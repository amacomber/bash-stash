#!/bin/bash

# Define your variables
JAMF_URL="https://yourjamf.jamfcloud.com"
USERNAME="yourname"
PASSWORD="your password"
SERIALS=( ABCABC1234 ABCABC1235 ABCABC1236 )
PLIST_FILE="Desktop/com.client.jamf.info.plist"


[ ! -f "$PLIST_FILE" ] && touch "$PLIST_FILE"

defaults write "$PLIST_FILE" ABCABC1234 computername1
defaults write "$PLIST_FILE" ABCABC1235 computername2
defaults write "$PLIST_FILE" ABCABC1236 computername3

# Bearer token variables
bearerToken=""
tokenExpirationEpoch="0"

# Function to get a new Bearer token
getBearerToken() {
    response=$(curl -s -u "$USERNAME:$PASSWORD" "$JAMF_URL/api/v1/auth/token" -X POST)
    echo "$response"
    bearerToken=$(echo "$response" | grep -o '"[^"]*"' | head -2 | tail -1 | tr -d '"')
    echo "Bearer Token: $bearerToken"
    tokenExpiration=$(echo "$response" | grep -o '"[^"]*"' | tail -1 | tr -d '"')
    tokenExpirationEpoch=$(date -j -f "%Y-%m-%dT%T" "$tokenExpiration" +"%s")
}

# Function to check the token expiration
checkTokenExpiration() {
    nowEpochUTC=$(date -j -f "%Y-%m-%dT%T" "$(date -u +"%Y-%m-%dT%T")" +"%s")
    if [[ $tokenExpirationEpoch -gt $nowEpochUTC ]]; then
        echo "Token valid until the following epoch time: $tokenExpirationEpoch"
    else
        echo "No valid token available, getting new token"
        getBearerToken
    fi
}

# Function to invalidate the token
invalidateToken() {
    responseCode=$(curl -w "%{http_code}" -H "Authorization: Bearer ${bearerToken}" "$JAMF_URL/api/v1/auth/invalidate-token" -X POST -s -o /dev/null)
    if [[ ${responseCode} == 204 ]]; then
        echo "Token successfully invalidated"
        bearerToken=""
        tokenExpirationEpoch="0"
    elif [[ ${responseCode} == 401 ]]; then
        echo "Token already invalid"
    else
        echo "An unknown error occurred invalidating the token"
    fi
}

# Function to update device name in Jamf Pro
update_device_name() {
    local serial=$1
    local device_name=$2

    # Check token expiration before making the API call
    checkTokenExpiration
    
    # Get the Jamf Pro ID of the device by serial number
    jamf_id=$(curl -s -H "Authorization: Bearer ${bearerToken}" "$JAMF_URL/JSSResource/mobiledevices/serialnumber/$serial" \
        | xmllint --xpath '/mobile_device/general/id/text()' -)
    
    if [ -z "$jamf_id" ]; then
        echo "Error: Could not find device with serial $serial"
        return
    fi
    
    # Prepare the XML payload
    xml_data="<mobile_device><general><name>$device_name</name></general></mobile_device>"
    
    # Update the device name in Jamf Pro
    response=$(curl -su "$USERNAME:$PASSWORD" -H "Authorization: Bearer ${bearerToken}" -H "Content-Type: application/xml" \
        -X PUT \
        -d "$xml_data" \
        "$JAMF_URL/JSSResource/mobiledevices/id/$jamf_id")
    
    echo "Updated device: $serial to $device_name"
}

# Main loop to process each serial number
for serial in "${SERIALS[@]}"; do
    # Fetch the correct device name from the plist file
    device_name=$(defaults read "$PLIST_FILE" "$serial")
    
    if [ -z "$device_name" ]; then
        echo "Error: Could not find device name for serial $serial"
        continue
    fi
    
    # Update the device name in Jamf Pro
    update_device_name "$serial" "$device_name"
done

# Invalidate the token after all operations
invalidateToken

exit 0