#!/bin/sh


	device=$(/usr/sbin/networksetup -listallhardwareports | grep -A 1 Wi-Fi | awk '/Device/{ print $2 }')
	result=$(/usr/sbin/networksetup -getairportnetwork $device | sed 's/Current Wi-Fi Network: //g')

# Ensure that AirPort was found
hasAirPort=$(echo "$result" | grep "Error")

# Report the result
if [ "$hasAirPort" == "" ]; then
	echo "<result>$result</result>"
else
	echo "<result>No AirPort Device Found.</result>"
fi