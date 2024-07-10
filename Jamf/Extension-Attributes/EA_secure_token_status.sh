#!/bin/bash

status=$( for user in $(dscl . list /Users UniqueID | awk '$2 >= 500 {print $1}'); do
	sysadminctl -secureTokenStatus "$user" 2>&1 | awk -F'] ' '{print $2}' 
	done
	)

echo "<result>$status</result>"