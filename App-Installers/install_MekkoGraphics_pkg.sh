#!/bin/bash

### Definitions ###
url="https://download.insightsoftware.com/mekko-graphics/mac/MekkoGraphics.pkg"
appName="MekkoGraphics"

### Create Installer folder for downloads in the /tmp directory ###
mkdir "/tmp/Installer/";
cd "/tmp/Installer/";
echo "Installer Directory created"

### Download PKG file ###
curl -L -o /tmp/Installer/$appName.pkg "$url";
echo "$appName Downloaded"

### Install the APP from PKG file ###
sudo -S installer -allowUntrusted -pkg /private/tmp/Installer/$appName.pkg -target /;
echo "$appName Installed"

### Remove Installer files ###
sudo rm -rf "/tmp/Installer";
echo "Cleaned up Installer files"

exit 0
