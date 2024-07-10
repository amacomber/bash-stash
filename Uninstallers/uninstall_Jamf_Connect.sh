#!/bin/bash

### Define Logged In User ###
LoggedInUser=$(stat -f%Su /dev/console)

### Reset the login window ###
/usr/local/bin/authchanger -reset

### Unload LaunchAgent ###
launchctl unload -w /Library/LaunchAgents/com.jamf.connect.plist
launchctl unload -w /Library/LaunchDaemons/com.jamf.connect.daemon.plist

### Remove LaunchAgent files ###
rm /Library/LaunchAgents/com.jamf.connect.plist
rm /Library/LaunchDaemons/com.jamf.connect.daemon.plist

### Kill Jamf Connect process and remove app ###
killall "Jamf Connect" && rm -rf "/Applications/Jamf Connect.app"

### Remove Jamf Connect files ###
rm /usr/local/bin/authchanger
rm /usr/local/lib/pam/pam_saml.so.2
rm -r /Library/Security/SecurityAgentPlugins/JamfConnectLogin.bundle

### Remove Jamf Connect plist ###
rm "/Library/Managed Preferences/com.jamf.connect.plist"
rm "/Library/Managed Preferences/com.jamf.connect.login.plist"
rm "/Library/Managed Preferences/$LoggedInUser/com.jamf.connect.plist"
rm "/Library/Managed Preferences/$LoggedInUser/com.jamf.connect.login.plist"

exit 0