#!/bin/bash

# Shortcut to Jamf Helper binary
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Type of Window to display; Options available: utility, fullscreen, and hud
windowtype="utility"
# Window Title
title="Company ITS Support"
# Path to company icon (you will need to deploy this icon file in another policy).
icon="/Library/Company ITS Support/icon.png"
# Setup the heading title and alignment
heading="Important macOS Update -alignHeading center"
# Define the buttons
button1="Later"
button2="Install Now"
# Set your timeout to close the window; written in seconds.
timeout="600"
# Define your base folder
basefolder="/Library/Company ITS Support"
# Define your deferral folder
deferralfolder="$basefolder/macosdeferrals"
# Define your plist name
plistname="macosdeferrals.plist"
# Define full path to plist
deferralfile="$deferralfolder/$plistname"
# Define maximum deferrals
alloweddeferral="10"
# Read current deferral count
currentdeferral=$( /usr/bin/defaults read /Library/Company\ IT/Deferrals/deferrals.plist deferral )
# Contents of your message window
description="This Mac needs updates.
Deferrals Allowed: $alloweddeferral
Deferrals Used: $currentdeferral
Software Update will run once deferrals run out.
Computer will reboot on its own."
# Start Script

    userChoice=$("$jamfHelper" -windowType "$windowtype" -title "$title" -heading "$heading" -alignHeading center -description "$description" -button1 "$button1" -button2 "$button2" -icon "$icon" -timeout "$timeout")
    # If the user chooses button2 (Install now)
    if [ "$userChoice" == "2" ]; then
    # Store deferrals used, time of last update and then reset the deferral count
		/usr/bin/defaults write "$deferralfile" lastdeferral -int $( /usr/bin/defaults read "$deferralfile" deferral )
		/usr/bin/defaults write "$deferralfile" lastupdate -date "$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
		/usr/bin/defaults write "$deferralfile" deferral -int 0
    # Run Recon to update EA
    jamf recon
    # Run Software Update
    softwareupdate -iaR
    else
		# Check that the info folder exists, create if missing and set appropriate permissions
		[ ! -f "$deferralfolder" ] && /bin/mkdir -p "$deferralfolder"
    # Correct permissions
		/bin/chmod 755 "$deferralfolder"
    # Change ownership
		/usr/sbin/chown root:wheel "$deferralfolder"
    # Hide the folder for an extra layer of protection from the users
    chflags hidden "$deferralfolder"
    # Check for a deferral file and create one if it's missing
    [ ! -f "$deferralfile" ] && /usr/bin/defaults write "$deferralfile" deferral -int 0
    # Read the current deferral count
    deferred=$( /usr/bin/defaults read "$deferralfile" deferral )
    # Check the current deferral count against the allowed deferrals. If under let the user choose, if over start updates automatically
    if [ "$deferred" -lt "$alloweddeferral" ];
	   then
		     # Increment counter by 1
		     deferred=$(( deferred + 1 ))
		     /usr/bin/defaults write "$deferralfile" deferral -int "$deferred"
         # Run Recon to update EA
         jamf recon
	else
		# Store deferrals used, time of last update and then reset the deferral count
    /usr/bin/defaults write "$deferralfile" lastdeferral -int $( /usr/bin/defaults read "$deferralfile" deferral )
    /usr/bin/defaults write "$deferralfile" lastupdate -date "$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
    /usr/bin/defaults write "$deferralfile" deferral -int 0
    # Run Recon to update EA
    jamf recon
    # Run Software Update
		softwareupdate -iaR
    fi
        exit 0
    fi
      
