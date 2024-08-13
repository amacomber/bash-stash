#!/bin/bash

# Define variables
url="https://yourjamf.jamfcloud.com"
username="username"
password="password"

#Variable declarations
bearerToken=""
tokenExpirationEpoch="0"

getBearerToken() {
	response=$(curl -s -u "$username":"$password" "$url"/api/v1/auth/token -X POST)
	bearerToken=$(echo "$response" | plutil -extract token raw -)
    echo $bearerToken
	tokenExpiration=$(echo "$response" | plutil -extract expires raw - | awk -F . '{print $1}')
	tokenExpirationEpoch=$(date -j -f "%Y-%m-%dT%T" "$tokenExpiration" +"%s")
}

checkTokenExpiration() {
    nowEpochUTC=$(date -j -f "%Y-%m-%dT%T" "$(date -u +"%Y-%m-%dT%T")" +"%s")
    if [[ tokenExpirationEpoch -gt nowEpochUTC ]]
    then
        echo "Token valid until the following epoch time: " "$tokenExpirationEpoch"
    else
        echo "No valid token available, getting new token"
        getBearerToken
    fi
}

invalidateToken() {
	responseCode=$(curl -w "%{http_code}" -H "Authorization: Bearer ${bearerToken}" $url/api/v1/auth/invalidate-token -X POST -s -o /dev/null)
	if [[ ${responseCode} == 204 ]]
	then
		echo "Token successfully invalidated"
		bearerToken=""
		tokenExpirationEpoch="0"
	elif [[ ${responseCode} == 401 ]]
	then
		echo "Token already invalid"
	else
		echo "An unknown error occurred invalidating the token"
	fi
}

# Create a directory to store user XML files
mkdir -p users_xml

# Function to gather all user IDs
gather_user_ids() {
  echo "Gathering USER IDS"
  checkTokenExpiration
  curl -s -H "Authorization: Bearer ${bearerToken}" "${url}/JSSResource/users" -o users.xml
  xmllint -o users.xml --format users.xml
  USER_IDS=$(sed -n 's:.*<id>\(.*\)</id>.*:\1:p' users.xml)
  echo "User IDs gathered: $USER_IDS"
}

# Function to download individual user XML files
download_user_xml() {
  local USER_ID=$1
  curl -s -H "Authorization: Bearer ${bearerToken}" "${url}/JSSResource/users/id/${USER_ID}" -o "users_xml/user_${USER_ID}.xml"
}

# Function to modify email addresses in the XML file
modify_email() {
  local USER_ID=$1
  #xmlstarlet ed -L -u "//user/email[. = '*@mischools.org']" -x "concat(substring-before(., '@'), '@stu.jpsk12.org')" "users_xml/user_${USER_ID}.xml"
  sed -i '' 's/@domaintochange.com/@newdomain.com/g' "users_xml/user_${USER_ID}.xml"
}

# Function to upload modified XML files back to Jamf Pro
upload_user_xml() {
  local USER_ID=$1
  curl -s -X PUT curl -s -H "Authorization: Bearer ${bearerToken}" -H "Content-Type: application/xml" --data-binary "@users_xml/user_${USER_ID}.xml" "${url}/JSSResource/users/id/${USER_ID}"
}

# Main script execution
gather_user_ids

for USER_ID in ${USER_IDS}; do
    if [ -f users_xml/.user_${USER_ID}_complete ]; then
    echo "UserID $USER_ID has already been fixed."
    else
	checkTokenExpiration
    download_user_xml ${USER_ID}
    modify_email ${USER_ID}
    upload_user_xml ${USER_ID}
    touch users_xml/.user_${USER_ID}_complete
    fi
done
checkTokenExpiration
invalidateToken
echo "Completed updating user emails."