#!/bin/bash

#Download URL to DMG the more static the better
DownloadUrl="https://release.vectorworks.net/nnapub/all/2023/SP6/711238/NNA/eng/installer1/Vectorworks2023-SP6-711238-SeriesBEG-installer1-osx.dmg"

# Locate DMG Download Link From URL

regex='^https.*.dmg$'
if [[ $DownloadUrl =~ $regex ]]; then
    echo "URL points to direct DMG download"
    validLink="True"
else
    echo "Searching headers for download links"
    urlHead=$(curl -s --head $DownloadUrl)

    locationSearch=$(echo "$urlHead" | grep https:)

    if [ -n "$locationSearch" ]; then

        locationRaw=$(echo "$locationSearch" | cut -d' ' -f2)

        locationFormatted="$(echo "${locationRaw}" | tr -d '[:space:]')"

        regex='^https.*'
        if [[ $locationFormatted =~ $regex ]]; then
            echo "Download link found"
            DownloadUrl=$(echo "$locationFormatted")
        else
            echo "No https location download link found in headers"
            exit 1
        fi

    else

        echo "No location download link found in headers"
        exit 1
    fi

fi

#Create Temp Folder
DATE=$(date '+%Y-%m-%d-%H-%M-%S')

TempFolder="Download-$DATE"

mkdir /tmp/$TempFolder

# Navigate to Temp Folder
cd /tmp/$TempFolder

# Download File into Temp Folder
curl -s -O "$DownloadUrl"

# Capture name of Download File
DownloadFile="$(ls)"

echo "Downloaded $DownloadFile to /tmp/$TempFolder"

# Verifies DMG File
regex='\.dmg$'
if [[ $DownloadFile =~ $regex ]]; then
    DMGFile="$(echo "$DownloadFile")"
    echo "DMG File Found: $DMGFile"
else
    echo "File: $DownloadFile is not a DMG"
    rm -r /tmp/$TempFolder
    echo "Deleted /tmp/$TempFolder"
    exit 1
fi

# Mount DMG File -nobrowse prevents the volume from popping up in Finder

hdiutilAttach=$(hdiutil attach /tmp/$TempFolder/$DMGFile -nobrowse)

echo "Used hdiutil to mount $DMGFile "

err=$?
if [ ${err} -ne 0 ]; then
    echo "Could not mount $DMGFile Error: ${err}"
    rm -r /tmp/$TempFolder
    echo "Deleted /tmp/$TempFolder"
    exit 1
fi

regex='\/Volumes\/.*'
if [[ $hdiutilAttach =~ $regex ]]; then
    DMGVolume="${BASH_REMATCH[@]}"
    echo "Located DMG Volume: $DMGVolume"
else
    echo "DMG Volume not found"
    rm -r /tmp/$TempFolder
    echo "Deleted /tmp/$TempFolder"
    exit 1
fi

# Identify the mount point for the DMG file
DMGMountPoint="$(hdiutil info | grep "$DMGVolume" | awk '{ print $1 }')"

echo "Located DMG Mount Point: $DMGMountPoint"

# Capture name of App file

cd "$DMGVolume"

AppName="$(ls | Grep .app)"

cd ~

echo "Located App: $AppName"

# Test to ensure App is not already installed

ExistingSearch=$(find "/Applications/" -name "$AppName" -depth 1)

if [ -n "$ExistingSearch" ]; then

    echo "$AppName already present in /Applications folder"
    hdiutil detach $DMGMountPoint
    echo "Used hdiutil to detach $DMGFile from $DMGMountPoint"
    rm -r /tmp/$TempFolder
    echo "Deleted /tmp/$TempFolder"
    exit 1

else

    echo "$AppName not present in /Applications folder"
fi

#Uncomment based on the type of install

#OPTION ONE - Download DMG and Copy to /Applications
#DMGAppCopyPath=$(find "$DMGVolume" -name "*.app" -depth 1)
#cp -pPR "$DMGAppCopyPath" /Applications/
#echo "Copied $DMGAppPath to /Applications"

#OPTION TWO - Download DMG and run Installer .pkg
#DMGPKGInstallPath=$(find "$DMGVolume" -name "*.pkg" -depth 1)
#sudo -S installer -allowUntrusted -pkg "$DMGPKGInstallPath" -target /;
#echo "Installed Package $DMGPKGInstallPath"

#OPTION THREE - Download DMG and run .app Installer
DMGAppInstallPath=$(find "$DMGVolume" -name "*.app" -depth 1)
Install="Vectorworks 2023 Installer"
sudo "$DMGAppInstallPath/Contents/MacOS/$Install" --mode unattended --unattendedmodeui none;
echo "Installed App $DMGAppInstallPath"

err=$?
if [ ${err} -ne 0 ]; then
    echo "Could not copy $DMGAppPath Error: ${err}"
    hdiutil detach $DMGMountPoint
    echo "Used hdiutil to detach $DMGFile from $DMGMountPoint"
    rm -r /tmp/$TempFolder
    echo "Deleted /tmp/$TempFolder"
    exit 1
fi

# Unmount the DMG file
hdiutil detach $DMGMountPoint

echo "Used hdiutil to detach $DMGFile from $DMGMountPoint"

err=$?
if [ ${err} -ne 0 ]; then
    abort "Could not detach DMG: $DMGMountPoint Error: ${err}"
fi

#Remove Installer files
rm -r /tmp/$TempFolder

echo "Deleted /tmp/$TempFolder"