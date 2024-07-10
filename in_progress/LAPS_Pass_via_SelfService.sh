#!/bin/sh

basicToken='XXXXXXXXXXXXXXXXXXXXX'
instance="xxxxxxxxxx"
adminUser="xxxxxxxadmin"
serialNum=$(osascript -e '
display dialog "Please enter the Serial Number of the Mac." default answer "" with title "Retrieve Admin Password" buttons {"Stop","Submit"} default button "Submit" giving up after 180
if button returned of result is "Submit" then
	set serialNum to the (text returned of the result)
else
	set serialNum to "Stop"
end if')

#####################################################
### Stop the script if the Stop button is pressed ###
#####################################################
if [ $serialNum == "Stop" ]; then
	echo "The user pressed stop."
	exit 1
else
	###############################
	### Launch jamfHelper again ###
	###############################
    authToken=$( curl "https://$instance.jamfcloud.com/uapi/auth/tokens" --silent --request POST --header "Authorization: Basic $basicToken" | grep token | awk -F \" '{ print $4 }' )
    echo "$instance Auth Token created";
    [ -f "/Library/Alpacalypse/$instance/ComputerList.json" ] && rm -rf "/Library/Alpacalypse/$instance/ComputerList.json"
    [ ! -d "/Library/Alpacalypse" ] && mkdir "/Library/Alpacalypse";
    [ ! -d "/Library/Alpacalypse/$instance" ] && mkdir "/Library/Alpacalypse/$instance";

    ### Gather machine info via Jamf API with Serial Number
    computerID=$( curl -X GET "https://$instance.jamfcloud.com/JSSResource/computers/serialnumber/$serialNum" -H 'accept: application/xml' -H "Authorization: Bearer $authToken" | grep -e "<id>" | awk -F "<id>|</id>" '{print $2}' | head -1)
    echo "Computer ID is $computerID"

    ### Grab Computer info list
    
    managementID=$( curl "https://$instance.jamfcloud.com/api/v1/computers-inventory?section=GENERAL&page=0&page-size=1000&sort=general.name%3Aasc" -X GET -H "accept: application/json" -H "Authorization: Bearer $authToken" | grep "\"id\" : \"${computerID}\"" -A 36 | tail -1 | cut -c 25- | rev | cut -c 3- | rev );

    echo "Management ID is $managementID";

	adminPASS=$( curl https://$instance.jamfcloud.com/api/v2/local-admin-password/"$managementID"/account/"$adminUser"/password -X GET -H "Authorization: Bearer $authToken" -H "accept: text/json"  )
    # Shortcut to Jamf Helper binary
    jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    # Type of Window to display; Options available: utility, fullscreen, and hud
    windowtype="utility"
    # Window Title
    title="$adminUser Password"
    # Define the buttons
    button1="OK"
    #button2="Install Now"
    # Set your timeout to close the window; written in seconds.
    timeout="600"
    # Contents of your message window
    description="The password for $adminUser on $serialNum is:
    $adminPASS"

# expire the auth token
	/usr/bin/curl "https://$instance.jamfcloud.com/uapi/auth/invalidateToken" \
	--silent \
	--request POST \
	--header "Authorization: Bearer $authToken"
    "$jamfHelper" -windowType "$windowtype" -title "$title" -description "$description" -button1 "$button1" -timeout "$timeout";

    exit 0
fi


