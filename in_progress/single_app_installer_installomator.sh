#!/bin/bash

currentDate="$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
PROCESS="BetterTouchTool"
label="bettertouchtool"

currentDate="$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
echo "$currentDate - $PROCESS has STOPPED";
gitOwner="Installomator"
gitRepo="Installomator"

versionNum=$( curl -sL https://api.github.com/repos/Installomator/Installomator/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' | rev | cut -c2- | rev | cut -c2- )
echo "$gitRepo v$versionNum"

DownloadUrl=$( curl -s https://api.github.com/repos/Installomator/Installomator/releases/latest | grep "browser_download_url.*pkg" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' )
workingdir="/private/tmp/Installer"
pkgname="Installomator.pkg"

mkdir "$workingdir";
cd "$workingdir";
echo "$pwd"
echo "Installer Directory created"

curl -L -o "$workingdir"/"$pkgname" "$DownloadUrl"
echo "Installomator Downloaded"

# Install the Installomator APP from PKG file
installer -allowUntrusted -pkg "$workingdir"/"$pkgname" -target /;
echo "Installomator Installed"

# Remove Installer files
sudo rm -rf "$workingdir";
echo "Cleaned up Installer files"
killall "$PROCESS"
[ -d "/Applications/$PROCESS.app" ] && rm -rf "/Applications/$PROCESS.app";
zsh /usr/local/Installomator/Installomator.sh $label;
open -a "$PROCESS"

exit 0