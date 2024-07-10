#!/usr/bin/env bash

source_folder="/opt/cisco/anyconnect/profile"
destination_folder="/opt/cisco/secureclient/vpn/profile"

### Check if source folder exists ###
if [ ! -d "$source_folder" ]; then
  echo "$source_folder does not exist"
fi

### Check if destination folder exists, if not create it ###
if [ ! -d "$destination_folder" ]; then
  mkdir -p "$destination_folder"
fi

### Loop through .xml files in the source folder and copy them to the destination folder ###
for file in "$source_folder"/*.xml; do
  if [ -f "$file" ]; then
    cp "$file" "$destination_folder"
    echo "Copied $file to $destination_folder"
  fi
done

### Restart Cisco Secure Client ###
killall "Cisco Secure Client";
open -a "Cisco Secure Client";

exit 0