#!/bin/bash

# Set DMG Download URL based on architecture
arch=$( uname -m )

# Check the architecture and print the appropriate message
if [ "$arch" = "arm64" ]; then
    echo "Apple"
    DownloadUrl=$( curl -s https://api.github.com/repos/zaproxy/zaproxy/releases/latest | grep "browser_download_url.*dmg" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' | tail -1 )
    echo "$DownloadUrl"
elif [ "$arch" = "x86_64" ]; then
    echo "Intel"
    DownloadUrl=$( curl -s https://api.github.com/repos/zaproxy/zaproxy/releases/latest | grep "browser_download_url.*dmg" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' | head -1 )
    echo "$DownloadUrl"
else
    echo "Unknown architecture: $arch"
    echo "This is a bad ending."
    exit 1 # Bad Ending
fi


DMG_PATH="/private/tmp/Installer/ZAProxy.dmg"
MOUNT_POINT="/Volumes/ZAP"
INSTALLER_DIR="/private/tmp/Installer"
APPLICATIONS_DIR="/Applications"
APP_NAME="ZAP.app"

# Create the Installer directory
mkdir -p "$INSTALLER_DIR"
[ -d "$INSTALLER_DIR" ] && echo "Installer Directory created"

# Download the DMG
curl -L -o "$DMG_PATH" "$DownloadUrl"
[ -f "$DMG_PATH" ] && echo "ZAProxy Downloaded"

# Mount the DMG
hdiutil attach "$DMG_PATH" -mountpoint "$MOUNT_POINT"

# Copy the app to the Applications folder
cp -R "$MOUNT_POINT/$APP_NAME" "$APPLICATIONS_DIR"
[ -f "/Volumes/ZAP.app" ] && echo "ZAProxy Installed"

# Unmount the DMG
hdiutil detach "$MOUNT_POINT"

# Remove the Installer directory
rm -rf "$INSTALLER_DIR"
[ ! -f "$INSTALLER_DIR" ] && echo "Cleaned up Installer files"

exit 0