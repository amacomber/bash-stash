#!/bin/bash

### Define Homebrew path, if any.
testbrew=$(which brew)

### Check for Homebrew
if [ "$testbrew" ]; 
then
### Homebrew exists. Check for xz
    homebrewxzversion=$(brew info xz | head -4 | tail -1)
    if [ "$homebrewxzversion" = "Not installed" ];
    then
    ### xz is not installed
	echo "<result>xz not installed</result>"
    else
    ### xz is installed. Get the version number from the path (same command but different paths on Intel and Apple Silicon)
	homebrewxzversion=$(brew info xz | head -4 | tail -1 | cut -d"/" -f6 | cut -d " " -f1)
    ### Report the version of xz
	echo "<result>$homebrewxzversion</result>"
    fi
else
### Report that Homebrew is not installed
    echo "<result>Homebrew not installed</result>"
fi

exit 0