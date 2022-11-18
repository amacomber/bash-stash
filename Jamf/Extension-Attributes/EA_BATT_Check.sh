#!/bin/sh
#Define Pending Updates
batteryPower="$( pmset -g batt 2>&1 | head -n 1 | cut -d" " -f4 | cut -c2- )"
echo "$batteryPower"

if [[ "${batteryPower}" == "Battery" ]]
then
    echo "<result>Powered from Battery</result>"
else
    echo "<result>Powered from Adapter</result>"
fi
