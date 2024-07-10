#!/bin/bash

# Define variables
DMG_URL="https://files.jamfconnect.com/JamfConnect.dmg"
DOWNLOAD_DIR="/private/tmp/Installer"
DMG_NAME="JamfConnect.dmg"
MOUNT_POINT="/Volumes/JamfConnect"

# Process to create the download directory
if [ ! -d "$DOWNLOAD_DIR" ]; then
        mkdir -p "$DOWNLOAD_DIR"
        echo "Created directory $DOWNLOAD_DIR"
    else
        echo "Directory $DOWNLOAD_DIR already exists"
    fi


# Process to download the dmg file
curl -L "$DMG_URL" -o "${DOWNLOAD_DIR}/${DMG_NAME}"
    echo "Downloaded DMG to ${DOWNLOAD_DIR}/${DMG_NAME}"


# Process to mount the dmg file
# hdiutil attach "${DOWNLOAD_DIR}/${DMG_NAME}" -nobrowse -quiet -noverify -noautoopen
/usr/bin/hdiutil convert -quiet "${DOWNLOAD_DIR}/${DMG_NAME}" -format UDTO -o "${DOWNLOAD_DIR}"/jamfcon
/usr/bin/hdiutil attach -quiet -nobrowse -noverify -noautoopen -mountpoint "${MOUNT_POINT}" "${DOWNLOAD_DIR}"/jamfcon.cdr
    if [ $? -eq 0 ]; then
        echo "Mounted DMG at $MOUNT_POINT"
    else
        echo "Failed to mount DMG" >&2
        exit 1
    fi


# Process to install the pkg file
PKG_PATH=$(find "$MOUNT_POINT" -name "*.pkg" | tail -1)
    if [ -z "$PKG_PATH" ]; then
        echo "No pkg file found in $MOUNT_POINT" >&2
        exit 1
    fi

    sudo installer -pkg "$PKG_PATH" -target /
    if [ $? -eq 0 ]; then
        echo "Installed package $PKG_PATH"
    else
        echo "Failed to install package $PKG_PATH" >&2
        exit 1
    fi

# Process to clean up
hdiutil detach "$MOUNT_POINT" -quiet
    if [ $? -eq 0 ]; then
        echo "Unmounted $MOUNT_POINT"
    else
        echo "Failed to unmount $MOUNT_POINT" >&2
    fi

    rm -rf "$DOWNLOAD_DIR"
    echo "Removed directory $DOWNLOAD_DIR"

open -a "Jamf Connect.app"