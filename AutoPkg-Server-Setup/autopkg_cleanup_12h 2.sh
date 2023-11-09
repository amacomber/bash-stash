#!/bin/sh

# Definitions
username=$(ls -l /dev/console | awk '{ print $3 }')

# Clear old Overrides
rm -R "/Users/$username/Library/AutoPkg/RecipeOverrides/"
mkdir "/Users/$username/Library/AutoPkg/RecipeOverrides"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
echo "Cleared old overrides."

chown -R $username "/Users/$username/Library/AutoPkg/RecipeOverrides/"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
exit 0
