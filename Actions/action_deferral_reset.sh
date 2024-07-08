#!/bin/bash

workfolder="/Library/Company IT"
infofolder="$workfolder/Deferrals"
updatefilename="deferrals.plist"
updatefile="$infofolder/$updatefilename"
resetdeferral="0"
icon="/Library/Company IT/icon.png"


# Check that the info folder exists, create if missing and set appropriate permissions
		[ ! -f "$infofolder" ] && /bin/mkdir -p "$infofolder"
		/bin/chmod 755 "$infofolder"
		/usr/sbin/chown root:wheel "$infofolder"
        chflags hidden "$infofolder"
        echo "Deferrals folder created and hidden"

# Do we have a defer file. Initialize one if not.
[ ! -f "$updatefile" ] && /usr/bin/defaults write "$updatefile" deferral -int 0
echo "Deferral file present"

# Read deferral count
deferred=$( /usr/bin/defaults read "$updatefile" deferral )
echo "Current Deferrals: $deferred"

# Check deferral count. Reset if over. End if correct.
if [ "$deferred" -gt "$resetdeferral" ];
	then
    # Reset deferral counter
    echo "Resetting deferral count"
    /usr/bin/defaults write "$updatefile" deferral -int 0
		# Increment counter and store.
		# deferred=$(( deferred + 1 ))
		# /usr/bin/defaults write "$updatefile" deferral -int "$deferred"
	else
		exit 0

fi
        exit 0
