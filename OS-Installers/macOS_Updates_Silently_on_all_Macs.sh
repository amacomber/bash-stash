#!/bin/bash


#########################################################################################
#
# DEFINITIONS
#
#########################################################################################

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
title="Company Name Enterprise IT"
button1="OK"
button2="Install Now"
heading="macOS Update"
workfolder="/Library/Company Name IT"
infofolder="$workfolder/Deferrals"
updatefilename="deferrals.plist"
updatefile="$infofolder/$updatefilename"
alloweddeferral="3"
currentdeferral=$( /usr/bin/defaults read /Library/Company Name\ IT/Deferrals/deferrals.plist deferral )
icon="/Library/Company Name IT/Company.png"
description="This Mac needs critical updates to the macOS currently installed.
You may defer $alloweddeferral times and you have already deferred $currentdeferral times.
Once you have used your deferrals the update will be installed automatically.

Depending on the speed of the internet connection, it may take 30-90 minutes to complete.

Warning! Update will take place in the background and a reboot will likely take place when done without any further warning.

Contact the Help Desk with any questions."

#########################################################################################
#
# FUNCTIONS
#
#########################################################################################

runAsUser() {
    if [ "$currentUser" != "loginwindow" ]; then
        launchctl asuser "$uid" sudo -u "$currentUser" "$@"
    else
        echo "no user logged in"
        exit 1
    fi
}


wrongUserPassword() {
userResponse=$(runAsUser osascript <<EOF
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
set theIcon to POSIX file "/Library/Company Name IT/Company.png" as alias
set appTitle to "macOS update"
set okTextButton to "OK"
set enterPassword to "Enter your password to start the update"
set passwordWrong to "Incorrect Password"
set errorPasswordText to passwordWrong & return & enterPassword
set theResponse to display dialog {errorPasswordText} default answer "" buttons {okTextButton} default button 1 with title {appTitle} with icon theIcon with hidden answer giving up after 600
set theTextReturned to the text returned of theResponse
if theResponse is gave up then
return "cancelled"
else if theTextReturned is "" then
return "nopassword"
else
return theTextReturned
end if
EOF
)
validatePassword "$userResponse"
}


noUserPassword() {
userResponse=$(runAsUser osascript <<EOF
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
set theIcon to POSIX file "/Library/Company Name IT/Company.png" as alias
set appTitle to "macOS update"
set okTextButton to "OK"
set enterPassword to "Enter your password to start the update"
set passwordEmpty to "The password is empty."
set errorPasswordText to passwordEmpty & return & enterPassword
set theResponse to display dialog {errorPasswordText} default answer "" buttons {okTextButton} default button 1 with title {appTitle} with icon theIcon with hidden answer giving up after 600
set theTextReturned to the text returned of theResponse
if theResponse is gave up then
return "cancelled"
else if theTextReturned is "" then
return "nopassword"
else
return theTextReturned
end if
EOF
)
validatePassword "$userResponse"
}


promptUserPassword() {
userResponse=$(runAsUser osascript <<EOF
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
set theIcon to POSIX file "/Library/Company Name IT/Company.png" as alias
set appTitle to "macOS update"
set okTextButton to "OK"
set changesText to "One or more Apple Updates are available." & return & "On Apple Silicon hardware you must enter your login/Okta password to continue."  & return & return &  "To continue with macOS update, enter login/Okta password for $currentUser"
set theResponse to display dialog {changesText} default answer "" buttons {okTextButton} default button 1 with title {appTitle} with icon theIcon with hidden answer giving up after 600
set theTextReturned to the text returned of theResponse
if theResponse is gave up then
return "cancelled"
else if theTextReturned is "" then
return "nopassword"
else
return theTextReturned
end if
EOF
)
}


verifyPassword() {
    dscl . authonly "$currentUser" "$userResponse" &> /dev/null; resultCode=$?
    if [ "$resultCode" -eq 0 ];then
        echo "Password Check: PASSED"
        # DO THE REST OF YOUR ACTIONS....
    else
        # Prompt for User Password
        echo "Password Check: WRONG PASSWORD"
        wrongUserPassword
    fi
}


validatePassword() {
    case "$userResponse" in
        "nopassword" ) echo "Password Check: NO PASSWORD" & noUserPassword ;;
        "cancelled" ) echo "Password Check: Time Out" ;;
        * ) verifyPassword  ;;
    esac
}

##########################################################################################
#
# SCRIPT CONTENTS
#
##########################################################################################


if [[ ${osvers} -lt 7 ]]; then
    userChoice=$("$jamfHelper" -windowType utility -title "$title" -description "$description" -button1 "$button1" -button2 "$button2" -icon "$icon")
    if [ "$userChoice" == "2" ]; then
        #this line will run second button

		# Store deferrals used, time of last update and then reset the deferral count
		/usr/bin/defaults write "$updatefile" lastdeferral -int $( /usr/bin/defaults read "$updatefile" deferral )
		/usr/bin/defaults write "$updatefile" lastupdate -date "$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
		/usr/bin/defaults write "$updatefile" deferral -int 0
        softwareupdate -iaR
    else
		# Check that the info folder exists, create if missing and set appropriate permissions
		[ ! -f "$infofolder" ] && /bin/mkdir -p "$infofolder"
		/bin/chmod 755 "$infofolder"
		/usr/sbin/chown root:wheel "$infofolder"
        chflags hidden "$infofolder"

# Do we have a defer file. Initialize one if not.
[ ! -f "$updatefile" ] && /usr/bin/defaults write "$updatefile" deferral -int 0

# Read deferral count
#commenting out because I defined $currentdeferral earlier in the script
#deferred=$( /usr/bin/defaults read "$updatefile" deferral )

# Check deferral count. Prompt user if under, otherwise force the issue.

if [ "$currentdeferral" -lt "$alloweddeferral" ];
	then
		# Increment counter and store.
		currentdeferral=$(( currentdeferral + 1 ))
		/usr/bin/defaults write "$updatefile" deferral -int "$currentdeferral"
	else
	# Store deferrals used, time of last update and then reset the deferral count
/usr/bin/defaults write "$updatefile" lastdeferral -int $( /usr/bin/defaults read "$updatefile" deferral )
/usr/bin/defaults write "$updatefile" lastupdate -date "$( /bin/date "+%Y-%m-%d %H:%M:%S" )"
/usr/bin/defaults write "$updatefile" deferral -int 0

if [[ $( /usr/bin/arch ) = arm64* ]];
    then
	    # Apple Silicon is yes, Intel is no
        echo "Apple Silicon detected"
        #Check for Company Logo
if [ -e  /Library/Company Name\ IT/Company.png ]; then
    echo "Logo exist"
else
    echo "Logo not found"
    # You will need to create a seperate policy that deploys your company logo with event trigger DeployLogo
    # jamf policy -event DeployLogo
fi

# Get the Username of the currently logged user
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
uid=$(id -u "$currentUser")
echo "Logged in user: $currentUser"

# Ask the logged user for the password
promptUserPassword "$currentUser"

# Check is password is correct
validatePassword "$userResponse"

# Automated Install of Update
if [ $userResponse = "cancelled" ]; then
    echo "Password entry was cancelled"
else
    echo "Running updates for Apple Silicon Mac"
    runAsUser expect -c "
        set timeout -1
        spawn sudo /usr/sbin/softwareupdate -iaR
        expect "Password:"
        send "$userResponse"
        expect "Password:"
        send "$userResponse"
        expect eof
        "
fi

else
	# Apple Silicon is no, Intel is yes
    echo "Intel Processor detected"
	softwareupdate -iaR

fi
        exit 0
    fi
fi

fi

exit 0
