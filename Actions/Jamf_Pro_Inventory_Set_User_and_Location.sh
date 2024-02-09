#!/bin/bash

### Set the domain in Parameter 5 ###

# Get the last user
lastUser=$(defaults read /Library/Preferences/com.apple.loginwindow lastUserName)
email=$(echo "$lastUser"\@"$5")
USER=$(stat -f %Su /dev/console)
realname=$(dscl /Search -read "/Users/$USER" RealName | sed '1d; s/^ //')

echo "Running recon for ${lastUser}..."
jamf recon -endUsername "${lastUser}"
jamf recon -email "${email}"
jamf recon -realname "${realname}"