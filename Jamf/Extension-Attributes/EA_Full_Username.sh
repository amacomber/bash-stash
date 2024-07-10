#!/bin/bash


USER=$(stat -f %Su /dev/console)
lastUser=$(dscl /Search -read "/Users/$USER" RealName | sed '1d; s/^ //')

if [ $lastUser == "" ]; then
	echo "<result>No logins</result>"
else
	echo "<result>$lastUser</result>"
fi