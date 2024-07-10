#!/bin/bash
#Script to connect to an SMB Share on macOS
serverIP="xxxx"
shareName="xxxx"
roUN="xxxx"
roPW="xxxx"

#Make sure the mount directory exists
if [ ! -d "/Volumes/jamf_staging" ]
then
    mkdir -p "/Volumes/jamf_staging"
fi

#Mount the SMB share
mount -t smbfs //$roUN:$roPW@$serverIP/$shareName /Volumes/$shareName

#Check if the mount succeeded
if [ "$?" -eq 0 ]
then
    echo "The SMB share has been successfully mounted!"
else
    echo "The mount failed!"
fi