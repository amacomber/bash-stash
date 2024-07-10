#!/bin/bash

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Restart Required" -description "Please save all work and restart your computer." -icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarCustomizeIcon.icns -button1 "OK" && osascript -e 'tell app "loginwindow" to «event aevtrrst»'