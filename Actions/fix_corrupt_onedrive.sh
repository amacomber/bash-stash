#!/bin/bash

LoggedInUser=$(stat -f%Su /dev/console)

# Kill OneDrive process
killall OneDrive;

# Remove OneDrive.app
[ -d "/Applications/OneDrive.app" ] && rm -rf "/Applications/OneDrive.app"

# Remove corrupt OneDrive folder data
# Find OneDrive folders
onedrive1=$(ls "/Users/$LoggedInUser/Library/CloudStorage/" | grep OneDrive | head -1)
onedrive2=$(ls "/Users/$LoggedInUser/Library/CloudStorage/" | grep OneDrive | tail -1)
# While the first and last line of the search are different remove the file listed first.
while [[ "$onedrive1" != "$onedrive2" ]]; do
    echo "Removing $onedrive1";

    rm -rf "/Users/$LoggedInUser/Library/CloudStorage/$onedrive1/";
    echo "Removed OneDrive CloudStorage files.";

    # Re-Define the first and last lines of the search so this loop can continue until there is only one result.
    echo "Updating search results.";
    onedrive1=$(ls "/Users/$LoggedInUser/Library/CloudStorage/" | grep OneDrive | head -1)
    onedrive2=$(ls "/Users/$LoggedInUser/Library/CloudStorage/" | grep OneDrive | tail -1)
done
# Once the first and last result are the same do one more check in case there is 1 result.
# If there is 1 result run one more delete. If there is a 0 result then finish the job.
echo "First and last result match. Moving to final stage.";

if [ -d "/Users/$LoggedInUser/Library/CloudStorage/$onedrive1/" ]; 
then
    rm -rf "/Users/$LoggedInUser/Library/CloudStorage/$onedrive1/";
    echo "Removed all OneDrive CloudStorage files.";
fi
echo "All OneDrive CloudStorage files have been removed.";

# Reinstall OneDrive.app
echo "Reinstalling OneDrive"
jamf policy --event installOneDrive;

open -a "OneDrive.app"