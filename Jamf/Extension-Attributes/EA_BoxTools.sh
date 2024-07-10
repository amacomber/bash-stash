#!/bin/bash

# Define Current User
currentuser=$(ls -l /dev/console | awk '{ print $3 }')
mainbox="/Library/Application\ Support/Box/Box\ Edit/Box\ Edit.app/Contents/Info.plist"
userbox="/Users/$currentuser/Library/Application\ Support/Box/Box\ Edit/Box\ Edit.app/Contents/Info.plist"

# Check to see if Box Edit.app exists
if [ -e $mainbox ]
then 
  echo "<result>True</result>"
else
	if [ -e $userbox ]
    then
    echo "<result>True</result>"
    fi
  echo "<result>False</result>"
fi