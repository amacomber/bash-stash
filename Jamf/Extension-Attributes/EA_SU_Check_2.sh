#!/bin/bash
#Define Pending Updates
suPending="$(softwareupdate -la | grep "\*")"
#echo "$suPending"

if [ -z "${suPending##No new*}" ];
then
    echo "<result>No Updates Available</result>"
else
    echo "<result>Updates Available</result>"
fi
