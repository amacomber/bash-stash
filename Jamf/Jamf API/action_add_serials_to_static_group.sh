#!/bin/bash

### Jamf adjustable variables
# $4 - jamfpro_user ----- Username for JSS user
# $5 - jamfpro_password	- Password for JSS user
# $6 - jamfpro_url ------ Enter your Jamf Pro URL "https://yourjamfproserver.jamfcloud.com"
# $7 - GroupID ---------- Enter the group ID number
# $8 - AddRemove -------- possible values are "add" or "remove"


## Grab the serial number of the device
serialNumber=( enter serials here separated by spaces )

# Explicitly set initial value for the api_token variable to null:
api_token=""

# Explicitly set initial value for the token_expiration variable to null:
token_expiration=""

## Check if the variables have been provided, set them if not.  
jamfpro_user="$4"
# Hard code user if desired
# jamfpro_user="your_api_user"

jamfpro_password="$5"
# Hard code password if desired
# jamfpro_password='jamfpro_password_here'	

jamfpro_url="$6"
# Hard code JamfPro URL if desired
# jamfpro_url="https://your_jamf_pro_server_url_including_port_if_used_in_url"

# Remove the trailing slash from the Jamf Pro URL if needed.
jamfpro_url=${jamfpro_url%%/}

GroupID="$7"
# Hard code Group ID if desired
# GroupID="Group_ID_Number"

AddRemove="$8"
# Hard code AddRemove here if you want - possible values are "add" or "remove"
# AddRemove="add"
# AddRemove="remove"

# Make sure AddRemove is lower case
AddRemove=$(echo $AddRemove | tr '[:upper:]' '[:lower:]')

GetJamfProAPIToken() {
    # This function uses Basic Authentication to get a new bearer token for API authentication.
    # Use user account's username and password credentials with Basic Authorization to request a bearer token.

    if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
        api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}/api/v1/auth/token" | python -c 'import sys, json; print json.load(sys.stdin)["token"]')
    else
        api_token=$(/usr/bin/curl -X POST --silent -u "${jamfpro_user}:${jamfpro_password}" "${jamfpro_url}/api/v1/auth/token" | plutil -extract token raw -)
    fi
}

APITokenValidCheck() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user. 
    # The API call will only return the HTTP status code.

    api_authentication_check=$(/usr/bin/curl --write-out %{http_code} --silent --output /dev/null "${jamfpro_url}/api/v1/auth" --request GET --header "Authorization: Bearer ${api_token}")
}

InvalidateToken() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user. 
    # The API call will only return the HTTP status code.

    APITokenValidCheck

    # If the api_authentication_check has a value of 200, that means that the current
    # bearer token is valid and can be used to authenticate an API call.

    if [[ ${api_authentication_check} == 200 ]]; then

        # If the current bearer token is valid, an API call is sent to invalidate the token.

        authToken=$(/usr/bin/curl "${jamfpro_url}/api/v1/auth/invalidate-token" --silent  --header "Authorization: Bearer ${api_token}" -X POST)
      
        # Explicitly set value for the api_token variable to null.
        api_token=""
    fi
}

GetJamfProAPIToken

apiURL="JSSResource/computergroups/id/${GroupID}"

for s in ${serialNumber[@]} ; do
	# Output the Instance
	echo "Serial: $s"
if [ "$AddRemove" == "add" ]; then
    apiData="<computer_group><computer_additions><computer><serial_number>$s</serial_number></computer></computer_additions></computer_group>"
else
    apiData="<computer_group><computer_deletions><computer><serial_number>$s</serial_number></computer></computer_deletions></computer_group>"
fi

echo "$api_token"

curl -s \
	--header "Authorization: Bearer ${api_token}" --header "Content-Type: text/xml" \
	--url "${jamfpro_url}/${apiURL}" \
	--data "${apiData}" \
    --request PUT > /dev/null


done
InvalidateToken


exit 0
