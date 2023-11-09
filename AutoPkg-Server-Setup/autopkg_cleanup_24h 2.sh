#!/bin/sh

# Definitions
username=$(ls -l /dev/console | awk '{ print $3 }')

# Update local git folder
cp -R /Users/$username/Library/AutoPkg/RecipeRepos/recipeFolder/ /Users/$username/Documents/Github/AutoPkg_Server
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
echo "Updated local git folder."

chmod +X /Users/$username/Documents/Github/AutoPkg_Server/autopkg_cleanup_7_days.sh
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
echo "Updated permissions for 7 day script."

chmod +X /Users/$username/Documents/Github/AutoPkg_Server/autopkg_cleanup_24h.sh
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
echo "Updated permissions for 24 hour script."

chmod +X /Users/$username/Documents/Github/AutoPkg_Server/autopkg_cleanup_12h.sh
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
echo "Updated permissions for 12 hour script."

chmod +X /Users/$username/Documents/Github/AutoPkg_Server/autopkg_run_2h.sh
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "$DATE";
echo "Updated permissions for 2 hour script."


exit 0
