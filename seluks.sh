#!/bin/bash

workingDir=$(pwd)
configFile="$workingDir/seluks.config"

if [ ! -e $configFile ]
then
	printf "ERROR: $configFile not found\n"
	exit -1
else
	source $configFile
fi

if [ "$1" == "validate" ] || [ "$1" == "v" ]; then
	printf "INFO: Validate $configFile\n\n"

	noErrorCount=0
	[[ -z "$container" ]] && printf "ERROR: Missing variable 'container'\n" || ((noErrorCount++))
	[[ -z "$mapper" ]] && printf "ERROR: Missing variable 'mapper'\n" || ((noErrorCount++))
	[[ -z "$mountpoint" ]] && printf "ERROR: Missing variable 'mountpoint'\n" || ((noErrorCount++))
	[[ -z "$filesystem" ]] && printf "ERROR: Missing variable 'filesystem'\n" || ((noErrorCount++))
	[[ $noErrorCount -eq 4 ]] && printf "SUCCESS: No missing variables\n" || exit

	noErrorCount=0
	[[ ! -f $container ]] && printf "ERROR: Container $workingDir/$container doesn't exist\n" || ((noErrorCount++))
	[[ ! -d $mountpoint ]] && printf "ERROR: Mountpoint $mountpoint doesn't exist\n" || ((noErrorCount++))
	[[ $noErrorCount -eq 2 ]] && printf "SUCCESS: Container file and mountpoint exist\n" || exit

elif [ "$1" == "open" ] || [ "$1" == "o" ]; then
	printf "INFO: Open container $container\n\n"
	loopDevice=`sudo losetup -f`

	if [ "`losetup -a | grep -c "$container"`" != "0" ]; then
		printf "ERROR: Container $container already in use\n"
		exit -1
	fi

	if [ -b "/dev/mapper/$mapper" ]; then
		printf "ERROR: Mapper /dev/mapper/$mapper already in use\n"
		exit -1
	fi

	sudo /sbin/losetup $loopDevice $container
	sudo /sbin/cryptsetup luksOpen $loopDevice $mapper
	sudo /bin/mount -t $filesystem /dev/mapper/$mapper $mountpoint
	printf "\nSUCCESS: Opened container $container\n"

elif [ "$1" == "close" ] || [ "$1" == "c" ]; then
	printf "INFO: Close container $container\n\n"

	loopDevice=`sudo losetup -a | grep "$container" | sed "s/: .*//"`

	if [ "`sudo losetup -a | grep -c "$container"`" != "1" ]; then
		printf "ERROR: Container $container not in use\n"
		exit -1
	fi

	sudo /bin/umount $mountpoint
	sudo /sbin/cryptsetup luksClose $mapper
	sudo /sbin/losetup -d $loopDevice
	printf "\nSUCCESS: Closed container $container\n"

else
	printf "ERROR: Mode parameter is required.\n"
	printf "ERROR: Allowed values: 'validate', 'open' or 'close' or the abbreviation 'v, 'o' or 'c'.\n"
fi
