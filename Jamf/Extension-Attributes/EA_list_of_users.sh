#!/bin/bash

# List Users
result=$(/usr/bin/dscl . list /Users UniqueID | /usr/bin/awk '$2 > 500 { print $1 }')
echo "<result>"$result"</result>"

exit 0