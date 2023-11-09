#!/bin/sh

# Definitions
username=$(ls -l /dev/console | awk '{ print $3 }')

# Clear AutoPkg Caches
rm -R "/Users/$username/Library/AutoPkg/Cache/"
mkdir "/Users/$username/Library/AutoPkg/Cache"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
echo "Cleared cache folder."

chown -R $username "/Users/$username/Library/AutoPkg/Cache/"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
exit 0
