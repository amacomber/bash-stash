#!/bin/bash

# Check if FortiClient folder exists
[ -d "/Applications/FortiClient.app" ] && /Applications/FortiClientUninstaller.app/Contents/Library/LaunchServices/com.fortinet.forticlient.uninstall_helper -v;
echo "Ran FortiClient Uninstaller."

[ -f "/Applications/FortiClient.app" ] && rm -rf "/Applications/FortiClient.app";
echo "Removed FortiClient App."

[ -f "/Applications/FortiClientUninstaller.app" ] && rm -rf "/Applications/FortiClientUninstaller.app";
echo "Removed FortiClient Uninstaller App."

sleep 1
[ -d "/Library/Application Support/Fortinet/" ] && rm -rf "/Library/Application Support/Fortinet/";
echo "Removing /Library/Application Support/Fortinet/ folder."

sleep 1
[ -f "/private/var/root/Library/Preferences/com.fortinet.FortiClientAgent.plist" ] && rm -rf "/private/var/root/Library/Preferences/com.fortinet.FortiClientAgent.plist";
echo "Removing root plist"

# Clean up temp files
[ -d "/Library/Company/FortiClient/" ] && rm -rf "/Library/Company/FortiClient";
echo "Cleaned up installer files."


exit 0
