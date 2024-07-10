#!/bin/bash

# Define Logged In User
LoggedInUser=$(stat -f%Su /dev/console)

# Reset macOS Sonoma Wi-Fi system

# Clear Wi-Fi prefs in SystemConfiguration folder
rm -rf /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist
rm -rf /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist.backup
rm -rf /Library/Preferences/SystemConfiguration/com.apple.network.eapolclient.configuration.plist
rm -rf /Library/Preferences/SystemConfiguration/com.apple.wifi.message-tracer.plist
rm -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces-pre-upgrade-new-target.plist
rm -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces-pre-upgrade-source.plist
rm -rf /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist

# Clear User Caches
rm -rf "/Users/$LoggedInUser/Library/Caches/"*