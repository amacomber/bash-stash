#!/bin/bash

### Define variables ###
jss="xxxx"
URL="https://$jss.jamfcloud.com"
	
# API User with correct privs must be created in the instance    
# Create the authtoken with a basictoken from your API user
basicToken="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

### Generate Bearer Token ###
bearerToken=$(curl "$URL/uapi/auth/tokens" --silent --request POST --header "Authorization: Basic $basicToken" | grep token | awk -F \" '{ print $4 }');

# Shortcut to Jamf Helper binary
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Type of Window to display; Options available: utility, fullscreen, and hud
windowtype="utility"
# Window Title
title="Confirm Serial Number"
title2="Success!"
# Setup the heading title and alignment
heading="Heading"
# Define the buttons
button1="Cancel"
button2="Unmanage"
# Set your timeout to close the window; written in seconds.
timeout="180"


### Request Serial Number from user in dialog box
read -r -d '' applescriptCode <<'EOF'
   set dialogText to text returned of (display dialog "Which serial number would you like to unmanage?" default answer "")
   return dialogText
EOF

serialNumber=$(osascript -e "$applescriptCode");
thisComputer=$(system_profiler SPHardwareDataType | grep "Serial Number" | cut -d':' -f2 | sed 's/^ *//g')

if [ "$serialNumber" == "$thisComputer" ];
then
    ### Get UDID for the machine. We will use this to lookup the device in Jamf ###
    UDID=$(system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }')
    echo "$UDID"

    #####################################
    ### Get the computer ID from Jamf ###
    #####################################
    computerID=$(curl -X GET -H "Authorization: Bearer $bearerToken" "$URL/JSSResource/computers/udid/$UDID" -H "accept: application/xml" | grep -e "<id>" | awk -F "<id>|</id>" '{print $2}')
    echo "Computer ID $computerID"
    
    if [ -z "$computerID" ];
    then
        echo "Unable to locate the Computer ID in Jamf. This is the bad ending. Exit 99."
        description=""$serialNumber" not found in Jamf.

Please double-check the serial number and try again."
        userChoice=$("$jamfHelper" -windowType "$windowtype" -title "$title" -description "$description" -timeout "$timeout" -button1 "OK" -defaultButton 1)
        exit 99 ### Unable to locate the Computer ID in Jamf ###
    else
        ### Verify the information is correct
        lastUser=$(curl -X GET "$URL/JSSResource/computers/serialnumber/$serialNumber" -H "accept: application/xml" -H "Authorization: Bearer $bearerToken"  | awk -F "<realname>|</realname>" '{print $2}' | head -n 1 )
        macModel=$(curl -X GET "$URL/JSSResource/computers/udid/$UDID" -H "accept: application/xml" -H "Authorization: Bearer $bearerToken"  | grep -e "<model>" | awk -F "<model>|</model>" '{print $2}')
        echo "Device is $macModel"
        echo "Serial Number is $serialNumber"
        echo "Last User is $lastUser"
        
        # Contents of your message window
        description="Device is "$macModel"
Serial Number is "$serialNumber"
Last User is "$lastUser"

Are you sure you want to unmanage this device?"
        userChoice=$("$jamfHelper" -windowType "$windowtype" -title "$title" -description "$description" -button1 "$button1" -button2 "$button2" -defaultButton 1 -cancelButton 1 -timeout "$timeout")
        # If the user chooses button2 (Unmanage)
        if [ "$userChoice" == "2" ]; then
        curl -H "Authorization: Bearer $bearerToken" $URL/JSSResource/computers/id/$computerID -H "Content-Type: text/xml" -X PUT -d "<computer><general><remote_management><managed>false</managed></remote_management></general></computer>"
        echo "This is the best ending. Exit 0."
        description=""$serialNumber" 
has been successfully unmanaged."
        userChoice=$("$jamfHelper" -windowType "$windowtype" -title "$title2" -description "$description" -timeout "$timeout" -button1 "OK" -defaultButton 1)
        exit 0
        else
        echo "User canceled process. Exit 88."
        exit 88 ### User canceled process ###
        fi
    fi
else
    ### Gather machine info via Jamf API with Serial Number
    computerID=$(curl -X GET "$URL/JSSResource/computers/serialnumber/$serialNumber" -H 'accept: application/xml' -H "Authorization: Bearer $bearerToken" | grep -e "<id>" | awk -F "<id>|</id>" '{print $2}')
    echo "Computer ID $computerID"
    
    if [ -z "$computerID" ];
    then
        echo "Unable to locate the Computer ID in Jamf. This is the bad ending. Exit 99."
        description=""$serialNumber" not found in Jamf.

Please double-check the serial number and try again."
        userChoice=$("$jamfHelper" -windowType "$windowtype" -title "$title" -description "$description" -timeout "$timeout" -button1 "OK" -defaultButton 1)
        exit 99 ### Unable to locate the Computer ID in Jamf ###
    else
        ### Verify the information is correct
        lastUser=$(curl -X GET "$URL/JSSResource/computers/serialnumber/$serialNumber" -H "accept: application/xml" -H "Authorization: Bearer $bearerToken"  | awk -F "<realname>|</realname>" '{print $2}' | head -n 1 )
        macModel=$(curl -X GET "$URL/JSSResource/computers/serialnumber/$serialNumber" -H "accept: application/xml" -H "Authorization: Bearer $bearerToken"  | grep -e "<model>" | awk -F "<model>|</model>" '{print $2}')
        echo "Device is $macModel"
        echo "Serial Number is $serialNumber"
        echo "Last User is $lastUser"

        # Contents of your message window
        description="Device is "$macModel"
Serial Number is "$serialNumber"
Last User is "$lastUser"

Are you sure you want to unmanage this device?"
    userChoice=$("$jamfHelper" -windowType "$windowtype" -title "$title" -description "$description" -button1 "$button1" -button2 "$button2" -defaultButton 1 -cancelButton 1 -timeout "$timeout")
        # If the user chooses button2 (Unmanage)
        if [ "$userChoice" == "2" ]; 
        then
        curl -H "Authorization: Bearer $bearerToken" $URL/JSSResource/computers/id/$computerID -H "Content-Type: text/xml" -X PUT -d "<computer><general><remote_management><managed>false</managed></remote_management></general></computer>"
        echo "This is the best ending. Exit 0."
        description=""$serialNumber" 
has been successfully unmanaged."
        userChoice=$("$jamfHelper" -windowType "$windowtype" -title "$title2" -description "$description" -timeout "$timeout" -button1 "OK" -defaultButton 1)
        exit 0
        else
        echo "User canceled process. Exit 88."
        exit 88 ### User canceled process ###
        fi
    fi
fi
exit 0