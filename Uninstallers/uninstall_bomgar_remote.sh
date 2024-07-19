#!/bin/bash

# Define variables
cd /Applications;
BGD=$(ls -al | grep bomgar.scc | awk '{print $9}')

if [ -d /Applications/"$BGD"/"Remote Support Customer Client.app" ]; then
/Applications/"$BGD"/"Remote Support Customer Client.app"/Contents/MacOS/sdcust -uninstall silent
else
echo "Bomgar Remote Agent Not Installed"
fi