#!/bin/bash

admin=$(dscl . -read /Groups/admin GroupMembership | awk '{print $3}')
currentuser=$(ls -l /dev/console | awk '{ print $3 }')

if [[ "$sadmin" == "$currentuser" ]] && /usr/sbin/dseditgroup -o edit -d $currentuser -t user admin && echo "Converted to standard user."

exit 0
