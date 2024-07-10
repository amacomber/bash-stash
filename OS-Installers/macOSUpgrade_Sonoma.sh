#!/bin/bash

###################################################################################################################################################
### To create an Encrypted String #################################################################################################################
### Download to your Desktop https://github.com/brysontyrrell/EncryptedStrings/blob/master/EncryptedStrings_Bash.sh ###############################
### run command "cd ~/Desktop/ ####################################################################################################################
### run command ". ./EncryptedStrings_Bash.sh && GenerateEncryptedString stringYouWantToEncryptEnterHere" #########################################
### It should look something like this as an output: ##############################################################################################
###################################################################################################################################################

###############
### Example ###
###############

###################################################################################################################################################
### dnormandin@DNMBA Desktop % . ./EncryptedStrings_Bash.sh && GenerateEncryptedString stringYouWantToEncryptEnterHere ############################
### Encrypted String: U2FsdGVkX1+jZyNo2qSc8ksLZKnYxUPpm3vWIpXzsPo0nb3dI/1q7mGDxwrUCwL6C/yU1bjuhXjX1rrGWAL1mQ== ####################################
### Salt: a3672368daa49cf2 | Passphrase: c79edea1a1600c8a3d1f75c5 #################################################################################
###################################################################################################################################################

##############################################################################################
### JSS Paramaters ###########################################################################
### $4 = Username Encrypted String ###########################################################
### $5 = Password Encrypted String ###########################################################
### $6 = macOS Version | Example: Sonoma ####################################################
### $7 = Install macOS path | Example: Install macOS Sonoma.app #############################
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
if [ $8 -eq 0 ]; then
	jamfHelperWindowType="fs"
elif [ $8 -eq 1 ]; then
	jamfHelperWindowType="utility"
else
	jamfHelperWindowType="fs"
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
icon=/Applications/Install\ macOS\ Sonoma.app/Contents/Resources/InstallAssistant.icns

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
echo "$PW" | /Applications/Install\ macOS\ Sonoma.app/Contents/Resources/startosinstall --agreetolicense --forcequitapps --stdinpass --user $UN && exit 0 || kill $jamfHelperPID && echo "Credentials passed from the JSS could not be authenticated on this Mac." && osascript -e 'text returned of (display dialog "The macOS upgrade requires you to authenticate with your Mac login credentials." with title "macOS Software Update" buttons {"OK"} default button 1 giving up after 180)'

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
	##################################################################################################################
	### Pass Credentials from user to Admin user, so the user is not prompted for their credentials in the future. ###
	##################################################################################################################
	sudo sysadminctl -adminUser $(stat -f %Su /dev/console) -adminPassword "$userPW" -secureTokenOn $UN -password $PW
	
	###############################
	### Launch jamfHelper again ###
	###############################
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType $jamfHelperWindowType -title "macOS Software Update" -icon "$icon" -heading "$heading" -description "$description" &

	jamfHelperPID=$!
	
	########################################################################
	### Prompt user for credentials if the credentials passed don't work ###
	########################################################################
	echo "$userPW" | /Applications/Install\ macOS\ Sonoma.app/Contents/Resources/startosinstall --agreetolicense --forcequitapps --stdinpass --user $(stat -f %Su /dev/console) && exit 0 || kill $jamfHelperPID && echo "Something went wrong" && osascript -e 'text returned of (display dialog "Something went wrong. Please try again." with title "macOS Software Update" buttons {"OK"} default button 1 giving up after 180)' && exit 1
	exit 0
fi
