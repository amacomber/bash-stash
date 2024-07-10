#!/bin/sh

current_user=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ ! -f /Users/"$current_user"/Library/Containers/okta.ExtensionLauncher.Extension.Extension/Data/Library/Preferences/okta-safari-extension.plist ]; then 
    "<result>Not Available</result>"

else 
    okta_email=$(defaults read /Users/"$current_user"/Library/Containers/okta.ExtensionLauncher.Extension.Extension/Data/Library/Preferences/okta-safari-extension.plist ENDUSER_HOME | awk -F: '{gsub(/"/, "", $2); } /login/ {print $4}' |  awk -F '[",]' '{print $2}')
    "<result>$okta_email</result>"
fi