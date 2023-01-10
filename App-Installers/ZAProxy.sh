#!/bin/bash

#DMG Download URL
DownloadUrl=$( curl -s https://api.github.com/repos/zaproxy/zaproxy/releases/latest | grep "browser_download_url.*dmg" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' )

workingdir="/private/tmp/Installer"
pkgname="ZAProxy.pkg"

mkdir "$workingdir";
cd "$workingdir";
echo "$pwd"
echo "Installer Directory created"

curl -L -o "$workingdir"/"$pkgname" "$DownloadUrl"
echo "ZAProxy Downloaded"

#install the ZAProxy APP from PKG file
installer -allowUntrusted -pkg "$workingdir"/"$pkgname" -target /;
echo "ZAProxy Installed"

#Remove Installer files
sudo rm -rf "$workingdir";
echo "Cleaned up Installer files"

exit 0