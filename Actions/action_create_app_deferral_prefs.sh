#!/bin/bash

### List all instances
appname=( adobereaderdc androidstudio blender dropbox googlechrome googledrive gotomeeting firefox loom microsoftexcel microsoftword microsoftpowerpoint microsoftoutlook microsoftedge microsoftonedrive microsoftonenote microsoftteams microsoftvisualstudiocode slack zoom )

###### SCRIPT STARTS ######

for a in ${appname[@]} ; do
	# Output the App Name
	echo "$a"
	
    # Create the prefs
    defaults write /Library/Preferences/AllCovered/com.allcovered.installomator."$a".deferralcount.plist deferral -int 0
    done