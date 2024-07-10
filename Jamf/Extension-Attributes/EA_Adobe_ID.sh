#!/bin/sh


export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:sbin:$PATH"
loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')


if [[ -f "/Users/$loggedInUser/Library/Application Support/Adobe/PII/com.adobe.pii.prefs" ]]; then
	ADOBEID=$(cat "/Users/$loggedInUser/Library/Application Support/Adobe/PII/com.adobe.pii.prefs"  | grep adobeID | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
else
	/bin/echo "<result>N/A</result>"
	exit 0
fi

if [[ -z "$ADOBEID" ]]; then
    /bin/echo "<result>No ID</result>"
else
    /bin/echo "<result>$ADOBEID</result>"
fi

exit 0