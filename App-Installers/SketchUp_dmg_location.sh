#!/bin/bash

### Check to see if the SketchUp 2022 folder is already present and if not then execute the script
if [ ! -d "/Applications/SketchUp 2022/" ]; then
downloadURL=$(curl -sL https://help.sketchup.com/en/downloading-sketchup | grep "https.*.dmg" | cut -d '"' -f 2)
echo "$downloadURL"
baseFolder="/tmp/Installer"

### Check for Installer directory and create if not there
[ ! -d "$baseFolder/" ] && mkdir "$baseFolder"

### Download the .dmg and store it in the Installer directory
curl -L -o "$baseFolder/sketch-up.dmg" "$downloadURL"

### Mount the dmg file
hdiutilAttach=$(hdiutil attach "$baseFolder/sketch-up.dmg" -nobrowse)
#"$hdiutilAttach"

### Copy the SketchUp folder to Applications
echo "Starting to copy files"
cp -rv "/Volumes/SketchUp 2022/SketchUp 2022" "/Applications";
echo "Done copying files"

### Check to see if SketchUp folder made it and announce
[ -d "/Applications/SketchUp 2022/" ] && echo "SketchUp 2022 installed into /Applications.";

### Clean up installer files
echo "Unmounting dmg and removing installer files";
hdiutil unmount "/Volumes/SketchUp 2022";
rm -rf "$baseFolder/";
[ ! -d "$baseFolder/" ] && echo "Deleted installer files"

exit 0
else

### This is what happens when the SketchUp 2022 folder is already found
echo "SketchUp 2022 is already installed."
exit 1 ### SketchUp Already Installed
fi
