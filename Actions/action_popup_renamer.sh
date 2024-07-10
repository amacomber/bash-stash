#!/bin/sh

# Create base folder if it does not exist
[ ! -d "/Library/Alpacalypse" ] && mkdir "/Library/Alpacalypse"

# Extract custom icon from Self Service
xxd -p -s 260 "$(defaults read /Library/Preferences/com.jamfsoftware.jamf self_service_app_path)"/Icon$'\r'/..namedfork/rsrc | xxd -r -p > /Library/Alpacalypse/selfservice.icns

# Prompt for asset tag entry
computerName=$(osascript -e 'tell application "SystemUIServer"
set myComputerName to text returned of (display dialog "Insert Asset Tag (AXXXXX) and click Submit." default answer "" with title "Asset ID" buttons {"Submit"} with icon POSIX file "/Library/Alpacalypse/selfservice.icns")
end tell')

# Remove apostrophes and replace spaces with dashes
hoseName=${computerName//\'/}
hostName=${hostName// /-}

# Set local computer naming
/usr/sbin/scutil --set ComputerName "${computerName}"
/usr/sbin/scutil --set LocalHostName "${hostName}"
/usr/sbin/scutil --set HostName "${hostName}"

# Update Jamf with correct naming
/usr/local/bin/jamf setcomputername -name "${computerName}"

# Flush caches
/usr/bin/dscacheutil -flushcache

/bin/echo "Computer name has been set..."

exit 0