#!/bin/sh

# Script to install Nessus Agent from DMG
# $4 is passed from Parameter section in Jamf

InstallerLocation="/Library/Application Support/JAMF/Waiting Room/$4"
echo "$InstallerLocation"

# Attach dmg
hdiutil attach "$InstallerLocation" -nobrowse
echo "Attached DMG"

# Installs Nessus
installer -pkg /Volumes/Nessus\ Agent\ Install/Install\ Nessus\ Agent.pkg -target /
echo "Installed Nessus"

# Configuring Nessus Agent
echo "Configuring Nessus Agent"
/Library/NessusAgent/run/sbin/nessuscli agent link --key=YOURKEYHERENOQUOTES --host=cloud.tenable.com --port=443 --groups="YOURGROUPSINQUOTES"
echo "Configured Nessus Agent"

# Unmount DMG
hdiutil detach /Volumes/Nessus\ Agent\ Install
echo "Unmounted DMG"

# Delete DMG
rm "$InstallerLocation"
echo "Deleted DMG"

exit 0
