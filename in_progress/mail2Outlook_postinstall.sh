#!/bin/zsh

echo "MailToOutlook: Starting"

GetLoggedInUser() {
	LOGGEDIN=$(/bin/echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/&&!/loginwindow/{print $3}')
	if [ "$LOGGEDIN" = "" ]; then
		echo "$USER"
	else
		echo "$LOGGEDIN"
	fi
}

SetHomeFolder() {
	HOME=$(dscl . read /Users/"$1" NFSHomeDirectory | cut -d ':' -f2 | cut -d ' ' -f2)
	if [ "$HOME" = "" ]; then
		if [ -d "/Users/$1" ]; then
			HOME="/Users/$1"
		else
			HOME=$(eval echo "~$1")
		fi
	fi
}

## Main
LoggedInUser=$(GetLoggedInUser)
SetHomeFolder "$LoggedInUser"
echo "MailToOutlook: Running as: $LoggedInUser; Home Folder: $HOME"

APPLICATION="/private/tmp/MailToOutlook"
echo "Application path is $APPLICATION"

if [ "$LoggedInUser" = "root" ] || [ "$LoggedInUser" = "" ]; then
	echo "MailToOutlook: No user logged in"
else
	/usr/bin/sudo -u $LoggedInUser "$APPLICATION"
fi

/bin/rm -rf "$APPLICATION"

echo "MailToOutlook: Finished"
exit 0