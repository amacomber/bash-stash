#!/bin/bash

currentuser=$(ls -l /dev/console | awk '{ print $3 }')
admin=$(dscl . -read /Groups/admin GroupMembership | grep -o "$currentuser")

if [[ "$sadmin" == "$currentuser" ]] && /usr/sbin/dseditgroup -o edit -d $currentuser -t user admin && echo "Converted to standard user."

exit 0
