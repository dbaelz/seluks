# A simple and easy LUKS helper
It's just a simple bash script to open and close [LUKS container](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup).

Usage
-----
1. Create a `seluks.config` file in the same directory as your container file. See the example file for the configuration.
2. Execute the script with the _open_ or _close_ parameter.

Current status
--------------
* No verification of the config file and the variables
* No error handling
* Hardcoded usage of the _sudo_ command
* Usage of some Linux tools without checks
* Only tested with Ubuntu 16.04

License
-------------
seluks is licensed under the [BSD License](https://github.com/dbaelz/seluks/blob/master/LICENSE).
