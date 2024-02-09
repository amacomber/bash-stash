#!/bin/bash

gitOwner="Installomator"
gitRepo="Installomator"

versionNum=$( curl -sL https://api.github.com/repos/$gitOwner/$gitRepo/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' | rev | cut -c2- | rev | cut -c2- )

echo "$versionNum"

DownloadUrl=$( curl -s https://api.github.com/repos/$gitOwner/$gitRepo/releases/latest | grep "browser_download_url.*pkg" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' )
workingdir="/private/tmp/Installer"
pkgname="Installomator.pkg"

mkdir "$workingdir";
cd "$workingdir";
echo "$pwd"
echo "Installer Directory created"

curl -L -o "$workingdir"/"$pkgname" "$DownloadUrl"
echo "Installomator Downloaded"

#install the Installomator APP from PKG file
installer -allowUntrusted -pkg "$workingdir"/"$pkgname" -target /;
echo "Installomator Installed"

#Remove Installer files
sudo rm -rf "$workingdir";
echo "Cleaned up Installer files"

currentDate="$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
PROCESS="Plex Media Server"
#number=$(ps ax | grep -c -i "$PROCESS")

if pgrep "$PROCESS";
    then
        currentDate="$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
        echo "$currentDate  $PROCESS is RUNNING"
   else
        currentDate="$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
        echo "$currentDate  $PROCESS has STOPPED";
        [ -d "/Applications/Plex Media Server.app" ] && rm -rf "/Applications/Plex Media Server.app";
        zsh /usr/local/Installomator/Installomator.sh plexmediaserver;
	    open -a "Plex Media Server"
fi

exit 0