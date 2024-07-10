#!/bin/bash

if [ -f Library/Printers/PPDs/Contents/Resources/Kyocera TASKalfa 5054ci.PPD]
then
echo "<result>Found</result>"
else
echo "<result>Not Found</result>"
fi
