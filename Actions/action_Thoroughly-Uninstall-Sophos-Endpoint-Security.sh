#!/bin/sh

folder="/Library/Company IT"
unin="SophosUninstaller"

# Remove all Sophos support files
rm -R /Library/Sophos\ Anti-Virus/
rm -R /Library/Application\ Support/Sophos/
rm -R /Library/Preferences/com.sophos.*
rm /Library/LaunchDaemons/com.sophos.*
rm /Library/LaunchAgents/com.sophos.*
rm -R /Library/Extensions/Sophos*
rm -R /Library/Caches/com.sophos.*

if [ -e /Applications/Remove\ Sophos\ Endpoint.app ]
then
    rm -R /Applications/Remove\ Sophos\ Endpoint.app
fi

xattr -r -d com.apple.quarantine "$folder/$unin/Remove Sophos Endpoint.app"

# Uninstall the Sophos Endpoint from the APP
cd "$folder/$unin/Remove Sophos Endpoint.app/Contents/MacOS/tools/"
./InstallationDeployer --force_remove
echo "Uninstalled Sophos Successfully"

# Remove Uninstaller files
rm -rf "$folder/$unin";
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
