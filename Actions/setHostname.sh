#!/bin/bash

properName="MacBook Air M1"
rightName="MacBook-Air-M1"
currentName=$( hostname | rev | cut -c6- | rev )

if [[ "$currentName" == "$rightName" ]];
then
    echo "Hostname is $rightName"
else
    scutil --set ComputerName "$properName"
    scutil --set LocalHostName "$rightName"
fi