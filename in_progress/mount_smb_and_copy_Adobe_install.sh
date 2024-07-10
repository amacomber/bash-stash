#!/bin/bash

# Variables
serverIP="10.0.0.1"
shareName="sharename"
roUN="username"
roPW="password"
wmp="WhateverMacPackage"
pkgName="/Applications/Installers/"$wmp"_Install.pkg"


# Check to see if the SMB share is currently mounted
# If YES then...
if [ -d "/Volumes/$shareName" ]; 
then
    echo "Connected to SMB share!"
    ### Adobe 2023 ###
    pkgLocation="/Volumes/"$shareName"/"$pkgName""

    #Create Cache Folder
    companyFolder="Company"
    cacheFolder="Installers"
    [ ! -d /Library/"$companyFolder" ] && mkdir /Library/"$companyFolder"
    [ ! -d /Library/"$companyFolder"/"$cacheFolder" ] && mkdir /Library/"$companyFolder"/"$cacheFolder"

    # Download File into Cache Folder
    [ -f /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg ] && rm -rf /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg;
    [ ! -f /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg ] && cp -rv "$pkgLocation" /Library/"$companyFolder"/"$cacheFolder";
    
    oldfileSHA=$(shasum -a 512 "$pkgLocation" | awk '{print $1;}')
    newfileSHA=$(shasum -a 512 /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg | awk '{print $1;}')
        if [ "$newfileSHA" == "$oldfileSHA" ]; 
        then
            echo "Installer copied successfully, SHA-512 match verified.";
        else
            echo "Installer did not copy successfully. Delete and try again";
        # Unmount SMB share
            umount -f "/Volumes/$shareName";
            rm -rf /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg;
            exit 1 ### SHA-CHECK FAILURE ###
        fi

    # Unmount SMB share
    umount -f "/Volumes/$shareName";
    exit 0
# If NO then...    
else
    echo "Attempting to connect to SMB share..."
    
    [ ! -d "/Volumes/$shareName" ] && mkdir "/Volumes/$shareName"
    
    mount_smbfs "//$roUN:$roPW@$serverIP/$shareName" /Volumes/$shareName
    if [ -d "/Volumes/$shareName" ]; 
    then
    echo "Connected to SMB share!"
    ### Adobe 2023 ###
    pkgLocation="/Volumes/"$shareName"/"$pkgName""

    #Create Cache Folder
    companyFolder="Company"
    cacheFolder="Installers"
    [ ! -d /Library/"$companyFolder" ] && mkdir /Library/"$companyFolder"
    [ ! -d /Library/"$companyFolder"/"$cacheFolder" ] && mkdir /Library/"$companyFolder"/"$cacheFolder"

    # Download File into Cache Folder
    [ -f /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg ] && rm -rf /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg;
    [ ! -f /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg ] && cp -rv "$pkgLocation" /Library/"$companyFolder"/"$cacheFolder";
    
    oldfileSHA=$(shasum -a 512 "$pkgLocation" | awk '{print $1;}')
    newfileSHA=$(shasum -a 512 /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg | awk '{print $1;}')
        if [ "$newfileSHA" != "$oldfileSHA" ]; 
        then
            echo "Installer copied successfully, SHA-512 match verified.";
        else
            echo "Installer did not copy successfully. Delete and try again";
        # Unmount SMB share
            umount -f "/Volumes/$shareName";
            rm -rf /Library/"$companyFolder"/"$cacheFolder"/"$wmp"_Install.pkg;
            exit 1 ### SHA-CHECK FAILURE ###
        fi

    # Unmount SMB share
    umount -f "/Volumes/$shareName";
    exit 0
    else
        echo "Unable to connect to SMB share."
        exit 2 ### UNABLE TO CONNECT TO SMB ###
    fi
# Finish up
fi