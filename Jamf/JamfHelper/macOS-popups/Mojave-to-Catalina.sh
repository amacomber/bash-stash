#!/bin/bash

JAMFHELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
window="utility"
title="Company ITS Support"
icon="/Library/Company ITS Support/icon.png"
button1="OK"
button2="Upgrade"
description="Insecure macOS detected.
Clicking 'Upgrade' will take you to the App Store page for macOS Catalina.
You should plug-in power to your Mac while the upgrade occurs."


userChoice=$("$JAMFHELPER" -windowType "$window" -title "$title" -description "$description" -button1 "$button1" -button2 "$button2" -icon "$icon")
    if [ "$userChoice" == "2" ]; then
        open -a "Safari" "https://apps.apple.com/us/app/macos-catalina/id1466841314?mt=12&uo=4"
        exit 0 ### USER ACCESSED CATALINA ###
    else
        echo "Declined update."
        exit 1 ### USER DECLINED CATALINA ###
    fi
