# A simple and easy LUKS helper
It's just a simple bash script to open and close [LUKS container](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup).

Usage
-----
1. Create a `seluks.config` file in the same directory as your container file. See the [example](https://github.com/dbaelz/seluks/blob/master/seluks.config.example) for the required variables.
2. Optional: Add the script to the `$PATH` variable
3. Execute it with the `validate`, `open` or `close` (abbreviation: `v`, `o`, `c`) parameter.

Example:
```
seluks.sh open
```

Current status
--------------
* Basic verification of the config file and the variables
* Rudimentary error handling
* Usage of some Linux tools without checks
* Only tested with Ubuntu 16.04

License
-------------
seluks is licensed under the [BSD License](https://github.com/dbaelz/seluks/blob/master/LICENSE).
