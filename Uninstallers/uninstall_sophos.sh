#!/bin/sh

# Remove all Sophos support files
rm -r /Library/Sophos\ Anti-Virus/
rm -r /Library/Application\ Support/Sophos/
rm -r /Library/Preferences/com.sophos.*
rm -r /Library/LaunchDaemons/com.sophos.*
rm -r /Library/LaunchAgents/com.sophos.*
rm -r /Library/Extensions/Sophos*
rm -r /Library/Caches/com.sophos.*

xattr -r -d com.apple.quarantine "/Applications/Remove Sophos Endpoint.app"

# Uninstall the Sophos Endpoint from the APP
cd "/Applications/Remove Sophos Endpoint.app/Contents/MacOS/tools/"
./InstallationDeployer --force_remove
echo "Uninstalled Sophos Successfully"

# Remove any leftover sophos apps 
allSophos=$( mdfind kind:app "sophos" | tail -1 )
compare=$( mdfind kind:app "sophos" | head -1 )

while [[ "$allSophos" != "$compare" ]]; do
  echo "Removing $allSophos"
  rm -rf "$allSophos"
  sleep 1
  echo "Removed Sophos files."
  allSophos=$( mdfind kind:app "sophos" | tail -1 )
  echo "$allSophos"
done

if [[ -d "$allSophos" ]]; then
  rm -rf "$allSophos"
  echo "Removing final Sophos files."
fi

echo "All Sophos Apps have been removed."
echo "Cleaned up Uninstaller files"
exit 0