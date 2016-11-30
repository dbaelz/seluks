#!/bin/bash

source seluks.config

if [ "$1" == "open" ]; then
	echo "Open container $container"
	loopDevice=`sudo losetup -f`

	if [ "`losetup -a | grep -c "$container"`" != "0" ]; then
	        echo "Container already in use!"
	        exit
	fi

	sudo /sbin/losetup $loopDevice $container
	sudo /sbin/cryptsetup luksOpen $loopDevice $mapper
	sudo /bin/mount -t $filesystem /dev/mapper/$mapper $mountpoint
elif [ "$1" == "close" ]; then
	echo "Close container $container"
	loopDevice=`sudo losetup -a | grep "$container" | sed "s/: .*//"`

	if [ "`sudo losetup -a | grep -c "$container"`" != "1" ]; then
		echo "Container not in use!"
		exit
	fi

	sudo /bin/umount $mountpoint
	sudo /sbin/cryptsetup luksClose $mapper
	sudo /sbin/losetup -d $loopDevice
else
	echo "The mode is required as parameter. Allowed values: 'open' or 'close'"
fi
