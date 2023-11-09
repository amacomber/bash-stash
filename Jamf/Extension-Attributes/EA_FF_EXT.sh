#!/bin/sh


###################
### DEFINITIONS ###
###################

current_user=$(/usr/bin/stat -f%Su /dev/console)
	echo "Defined current user is $current_user"

if [ ! -e /Users/$current_user/Library/Application\ Support/Firefox/Profiles/ ]; then
  echo "Firefox is not installed on this computer."
  echo "<result>"Firefox not installed"</result>"

else

timestamp_check=$( ls -lt /Users/$current_user/Library/Application\ Support/Firefox/Profiles | grep "default" | rev | cut -d " " -f "1" | rev | head -n "1" )
	echo "Most recently used profile is $timestamp_check"

size_check=$( ls -lS /Users/$current_user/Library/Application\ Support/Firefox/Profiles | grep "default" | rev | cut -d " " -f "1" | rev | head -n "1" )
	echo "The largest profile is $size_check"

#####################
### PROFILE CHECK ###
#####################

if [[ $timestamp_check == $size_check ]]
	
then 
	profile_folder=$( ls -lS /Users/$current_user/Library/Application\ Support/Firefox/Profiles | grep "default" | rev | cut -d " " -f "1" | rev | head -n "1" )
	echo "defined profile folder name is $profile_folder"

else
	profile_folder=$( ls -lt /Users/$current_user/Library/Application\ Support/Firefox/Profiles | grep "default" | rev | cut -d " " -f "1" | rev | head -n "1"  )
	echo "defined profile folder name is $profile_folder"
	
fi

ext1="/Users/$current_user/Library/Application Support/Firefox/Profiles/$profile_folder/extensions.txt"
	echo "Extensions file 1 is defined as $ext1"

ext2="/Users/$current_user/Library/Application Support/Firefox/Profiles/$profile_folder/extensions2.txt"
	echo "Extensions file 2 is defined as $ext2"

json="/Users/$current_user/Library/Application Support/Firefox/Profiles/$profile_folder/extensions.json"
	echo "Json file location is defined as $json"


################################################
### CHECK FOR OLD TEXT FILES AND REMOVE THEM ###
################################################

if [ -f "$ext1" ]; then
    echo "$ext1 exists."
    echo "Removing $ext1"
    rm "$ext1"
    touch "$ext1"
    echo "Created Plain Text file from Firefox Extensions.json"

else
    touch "$ext1"
    echo "Created Plain Text file from Firefox Extensions.json"

fi

if [ -f "$ext2" ]; then
    echo "$ext2 exists."
    echo "Removing $ext2"
    rm "$ext2"
    touch "$ext2"
    echo "Created Plain Text file for parsing of Firefox Extensions.json"

else
    touch "$ext2"
    echo "Created Plain Text file for parsing of Firefox Extensions.json"

fi

###############################################
### TAKE FIREFOX JSON FILE AND READ TO TEXT ###
###############################################

cat "$json" > "$ext1"

####################################################
### REPLACE THE WORD NAME WITH A CARRIAGE RETURN ###
####################################################

sed 's/name/\n/g' "$ext1" > "$ext2"

###################################################
### EXTRACT EXTENSION NAMES AND ELIMINATE DUPES ###
###################################################

result=$( cat "$ext2" | cut -d \" -f 3 | tail -n +2 | sort -u )


######################
### DISPLAY RESULT ###
######################

echo "<result>$result</result>"

fi

