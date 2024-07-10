#!/bin/bash

##########################################################################################################
### Create an Encrypted String ###########################################################################
### this will be needed to pass credentials securely https://github.com/brysontyrrell/EncryptedStrings ###
##########################################################################################################

##############################################################################################
### JSS Paramaters ###########################################################################
### $4 = Username Encrypted String ###########################################################
### $5 = Password Encrypted String ###########################################################
### $6 = macOS Version | Example: Monterey ###################################################
### $7 = Install macOS path | Example: Install macOS Monterey.app ############################
### $8 = Jamf Helper Window Type | 0 = Fullscreen (default) | 1 = utility (not fullscreen) ###
##############################################################################################

#################################
### String Encrypted Username ###
#################################
SALTUN=""
KUN=""
UN=$(echo "$4" | /usr/bin/openssl enc -aes256 -md md5 -d -a -A -S "$SALTUN" -k "$KUN")

#################################
### String Encrypted Password ###
#################################
SALTPW=""
KPW=""
PW=$(echo "$5" | /usr/bin/openssl enc -aes256 -md md5 -d -a -A -S "$SALTPW" -k "$KPW")

###################################
### Set Jamf helper window type ###
###################################
if [ $8 == 0 ]; then
	jamfHelperWindowType="fs"
elif [ $8 == 1 ]; then
	jamfHelperWindowType="utility"
else
	jamfHelperWindowType="utility"
fi

#########################################
### Heading to be used for jamfHelper ###
#########################################
heading="Please wait as we prepare this Mac for macOS $6..."

#######################################
### Title to be used for jamfHelper ###
#######################################
description="This process will take approximately 15-30 minutes.
Once completed, the Mac will reboot and begin the upgrade."

######################################
### Icon to be used for jamfHelper ###
######################################
icon=/Applications/"$7"/Contents/Resources/InstallAssistant.icns

#########################
### Launch jamfHelper ###
#########################
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType $jamfHelperWindowType -title "macOS Software Update" -icon "$icon" -heading "$heading" -description "$description" &

jamfHelperPID=$!

####################
### Start Update ###
####################
	
####################################################
### Try to use credentials passed from JSS first ###
####################################################
echo "$PW" | /Applications/"$7"/Contents/Resources/startosinstall --agreetolicense --forcequitapps --stdinpass --user $UN && exit 0 || kill $jamfHelperPID && echo "Credentials passed from the JSS could not be authenticated on this Mac." && osascript -e 'text returned of (display dialog "The macOS upgrade requires you to authenticate with your Mac login credentials." with title "macOS Software Update" buttons {"OK"} default button 1 giving up after 180)'

##########################
### Obtain credentials ###
##########################
userPW=$(osascript -e '
display dialog "Please enter your Mac login password." default answer "" with title "Software Update User Authentication" buttons {"Stop","Submit"} default button "Submit" with hidden answer giving up after 180
if button returned of result is "Submit" then
	set userPW to the (text returned of the result)
else
	set userPW to "Stop"
end if')

#####################################################
### Stop the script if the Stop button is pressed ###
#####################################################
if [ $userPW == "Stop" ]; then
	echo "The user pressed stop when asked for their credentials."
	exit 1
else
	###############################
	### Launch jamfHelper again ###
	###############################
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType $jamfHelperWindowType -title "macOS Software Update" -icon "$icon" -heading "$heading" -description "$description" &

	jamfHelperPID=$!
	
	########################################################################
	### Prompt user for credentials if the credentials passed don't work ###
	########################################################################
	echo "$userPW" | /Applications/"$7"/Contents/Resources/startosinstall --agreetolicense --forcequitapps --stdinpass --user $(stat -f %Su /dev/console) && exit 0 || kill $jamfHelperPID && echo "Something went wrong" && osascript -e 'text returned of (display dialog "Something went wrong. Please try again." with title "macOS Software Update" buttons {"OK"} default button 1 giving up after 180)' && exit 1
	exit 0
fi