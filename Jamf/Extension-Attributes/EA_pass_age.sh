#!/bin/sh

# Get the current user
current_user=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }')

# Check if the current user is root
if [ "${current_user}" = "root" ]; then
  echo "Skipping script execution for root user."
  exit 0
fi

# Get the password last set time from the XML data and save it to a temporary file
account_policy_data=$(dscl . -read /Users/${current_user} accountPolicyData | sed '1d')
temp_file=$(mktemp)
echo "${account_policy_data}" > "${temp_file}"

# Use PlistBuddy to read the passwordLastSetTime
password_last_set_time=$(/usr/libexec/PlistBuddy -c "Print :passwordLastSetTime" "${temp_file}")

# Clean up the temporary file
rm "${temp_file}"

# Check if password_last_set_time is empty
if [ -z "${password_last_set_time}" ]; then
  echo "Error: Unable to retrieve password last set time for user ${current_user}."
  exit 1
fi

# Convert password_last_set_time to an integer (removing any fractional part)
password_last_set_time=${password_last_set_time%.*}

# Calculate the age of the password in days
current_date=$(date +%s)
password_age=$(( (current_date - password_last_set_time) / (60*60*24) ))

# Print the password age
echo "<result>${password_age} days</result>"
