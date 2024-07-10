#!/bin/bash


export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:sbin:$PATH"
loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

DOMAIN=domain

RESULT=()

if [[ -f "/Users/$loggedInUser/Library/Accounts/Accounts4.sqlite" ]]; then
	INTERNET_ACCOUNTS=$(sqlite3 "/Users/$loggedInUser/Library/Accounts/Accounts4.sqlite" 'SELECT ZUSERNAME VARCHAR FROM ZACCOUNT' | tr '|' ' ' | awk NF | tr ' ' '|' | grep "@$DOMAIN.com")
	if [[ "$INTERNET_ACCOUNTS" != "" ]]; then
		RESULT+=("$INTERNET_ACCOUNTS")
	fi
else
	/bin/echo "<result>No DB</result>"
	exit 0
fi

if [[ "$RESULT" = "" ]]; then
    /bin/echo "<result>None</result>"
else
    /bin/echo "<result>$(printf '%s\n' ${RESULT[@]})</result>"
fi

exit 0