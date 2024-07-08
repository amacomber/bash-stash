#!/bin/bash

#Within the Application Support folder, move the Carbonite folder to the Trash.
[ -d "/Library/Application Support/Carbonite" ] && rm -rf "/Library/Application Support/Carbonite"
echo "Carbonite folder not found or removed"

#Within the LaunchDaemons folder, move com.carbonite.installhelper.plist, com.carbonite.launchd.daemon.plist, com.carbonite.launchd.monitor.plist and com.carbonite.launchd.watcher.plist to the Trash.

[ -f "/Library/LaunchDaemons/com.carbonite.installhelper.plist" ] && rm -rf "/Library/LaunchDaemons/com.carbonite.installhelper.plist"
[ ! -f "/Library/LaunchDaemons/com.carbonite.installhelper.plist" ] && echo "LaunchDaemon com.carbonite.installhelper.plist not found or removed"
[ -f "/Library/LaunchDaemons/com.carbonite.launchd.daemon.plist" ] && rm -rf "/Library/LaunchDaemons/com.carbonite.launchd.daemon.plist"
[ ! -f "/Library/LaunchDaemons/com.carbonite.launchd.daemon.plist" ] && echo "LaunchDaemon com.carbonite.launchd.daemon.plist not found or removed"
[ -f "/Library/LaunchDaemons/com.carbonite.launchd.monitor.plist" ] && rm -rf "/Library/LaunchDaemons/com.carbonite.launchd.monitor.plist"
[ ! -f "/Library/LaunchDaemons/com.carbonite.launchd.monitor.plist" ] && echo "LaunchDaemon com.carbonite.launchd.monitor.plist not found or removed"
[ -f "/Library/LaunchDaemons/com.carbonite.launchd.watcher.plist" ] && rm -rf "/Library/LaunchDaemons/com.carbonite.launchd.watcher.plist"
[ ! -f "/Library/LaunchDaemons/com.carbonite.launchd.watcher.plist" ] && echo "LaunchDaemon com.carbonite.launchd.watcher.plist not found or removed"

#Go back to the Library folder and open the Preferences folder. Within the Preferences folder, move com.carbonite.carbonite.plist to the Trash.

[ -f "/Library/Preferences/com.carbonite.carbonite.plist" ] && rm -rf "/Library/Preferences/com.carbonite.carbonite.plist"
[ ! -f "/Library/Preferences/com.carbonite.carbonite.plist" ] && echo "Preferences com.carbonite.carbonite.plist not found or removed"

#Go back to the Library folder and open the PrivilegedHelperTools folder. Within the PrivilegedHelperTools folder, move com.carbonite.installhelper to the Trash.

[ -f "/Library/PrivilegedHelperTools/com.carbonite.installhelper" ] && rm -rf "/Library/PrivilegedHelperTools/com.carbonite.installhelper"
[ ! -f "/Library/PrivilegedHelperTools/com.carbonite.installhelper" ] && echo "Privileged Helper Tool com.carbonite.installhelper not found or removed"

#Within the User Caches folder, move the files starting with com.Carbonite to the Trash.

rm -rf ~/Library/Caches/com.Carbonite*
echo "User Caches not found or removed"

#Back in the ~/Library folder find and enter the Preferences folder. Move the files starting with com.Carbonite to the Trash.

rm -rf ~/Library/Preferences/com.Carbonite*
echo "User Preferences not found or removed"

#Back in the ~/Library folder find and enter the Saved Application State folder. Move the files starting with com.Carbonite to the Trash.

rm -rf ~/Library/Saved\ Application\ State/com.Carbonite*
echo "Saved Application State not found or removed"

#Navigate to the Applications folder and move Carbonite to the Trash.
[ -d "/Applications/Carbonite Endpoint.app" ] && rm -rf "/Applications/Carbonite Endpoint.app"
[ ! -d "/Applications/Carbonite Endpoint.app" ] && echo "Carbonite Endpoint.app not found or removed"

exit 0