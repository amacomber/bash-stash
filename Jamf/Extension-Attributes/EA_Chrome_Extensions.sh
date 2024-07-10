#!/bin/bash

# Script to retrieve extracted URLs from Chrome extensions in multiple directories

# Get the currently logged-in user
loggedInUser=$(stat -f "%Su" /dev/console)

# Specify the base directory for Chrome profiles
base_directory="/Users/$loggedInUser/Library/Application Support/Google/Chrome"

# Array to store extracted URLs
response_urls=()

# Check if the "Default" directory exists
if [ -d "$base_directory/Default" ]; then
  default_extensions_directory="$base_directory/Default/Extensions"

  # Find the directories in the Default extensions directory
  default_sub_directories=$(find "$default_extensions_directory" -type d -mindepth 1 -maxdepth 1 -exec basename {} \;)

  # Loop through each sub-directory in Default
  for directory in $default_sub_directories; do
    url="https://chrome.google.com/webstore/detail/$directory"

    # Make a request and retrieve the response URL
    response_url=$(curl -Ls -o /dev/null -w "%{url_effective}" "$url")

    # Exclude the response URL if it's the same as the input URL
    if [ "$response_url" == "$url" ]; then
      continue
    fi

    # Extract the desired part of the URL between 'detail/' and '/'
    extracted_url=$(echo "$response_url" | awk -F 'detail/' '{print $2}' | awk -F '/' '{print $1}')

    # Add the extracted URL to the array
    response_urls+=("$extracted_url")
  done
fi

# Loop through each profile directory using wildcard
for profile_folder in "$base_directory/Profile"*/; do
  extensions_directory="$profile_folder/Extensions"

  # Check if the extensions directory exists
  if [ ! -d "$extensions_directory" ]; then
    continue
  fi

  # Find the directories in the extensions directory
  sub_directories=$(find "$extensions_directory" -type d -mindepth 1 -maxdepth 1 -exec basename {} \;)

  # Loop through each sub-directory
  for directory in $sub_directories; do
    url="https://chrome.google.com/webstore/detail/$directory"

    # Make a request and retrieve the response URL
    response_url=$(curl -Ls -o /dev/null -w "%{url_effective}" "$url")

    # Exclude the response URL if it's the same as the input URL
    if [ "$response_url" == "$url" ]; then
      continue
    fi

    # Extract the desired part of the URL between 'detail/' and '/'
    extracted_url=$(echo "$response_url" | awk -F 'detail/' '{print $2}' | awk -F '/' '{print $1}')

    # Add the extracted URL to the array
    response_urls+=("$extracted_url")
  done
done

# Remove duplicates from the array
response_urls=($(printf "%s\n" "${response_urls[@]}" | sort -u))

# Output the result in the desired format for Jamf Pro
IFS=$'\n'
echo "<result>$(echo "${response_urls[*]}")</result>"