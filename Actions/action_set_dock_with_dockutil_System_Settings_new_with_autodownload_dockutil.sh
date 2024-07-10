#!/bin/env bash

### Definitions
### Dockutil binary location
dockutil="/usr/local/bin/dockutil"
### Download URL
url=$( curl -s https://api.github.com/repos/kcrawford/dockutil/releases/latest | grep "browser_download_url.*pkg" | cut -d : -f 2,3 | tr -d '"' | awk '{$1=$1};1' )
#url="https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg"

### Current user definitions
LoggedInUser=$(stat -f %Su /dev/console)
LoggedInUserHome="/Users/$LoggedInUser"
UserPlist=$LoggedInUserHome/Library/Preferences/com.apple.dock.plist

### Check for a temp folder and make one if not found
[ ! -f "tmp/Installer" ] && /bin/mkdir -p "/tmp/Installer/"
cd "/tmp/Installer/"

### Download Latest DockUtils from GitHub
curl -L -o /tmp/Installer/dockutil.pkg "$url"

### Install DockUtil
installer -pkg /private/tmp/Installer/dockutil.pkg -target /

### Clean up the temp folder
[ -f "tmp/Installer" ] && rm -rf "/tmp/Installer"

### Disable show recents on Dock
sudo -u $(stat -f %Su /dev/console) -H defaults write com.apple.dock show-recents -bool FALSE



dockutil --remove all --no-restart $UserPlist
dockutil --add /System/Applications/Launchpad.app --no-restart $UserPlist
[ -d /System/Applications/System\ Preferences.app ] && dockutil --add /System/Applications/System\ Preferences.app --no-restart $UserPlist
[ -d /System/Applications/System\ Settings.app ] && dockutil --add /System/Applications/System\ Settings.app --no-restart $UserPlist
[ -d /Applications/Adobe\ Acrobat\ Reader.app ] && dockutil --add /Applications/Adobe\ Acrobat\ Reader.app --no-restart $UserPlist
[ -d /Applications/Microsoft\ Excel.app ] && dockutil --add /Applications/Microsoft\ Excel.app --no-restart $UserPlist
[ -d /Applications/OneDrive.app ] && dockutil --add /Applications/OneDrive.app --no-restart $UserPlist
[ -d /Applications/Microsoft\ OneNote.app ] && dockutil --add /Applications/Microsoft\ OneNote.app --no-restart $UserPlist
[ -d /Applications/Microsoft\ Outlook.app ] && dockutil --add /Applications/Microsoft\ Outlook.app --no-restart $UserPlist
[ -d /Applications/Microsoft\ PowerPoint.app ] && dockutil --add /Applications/Microsoft\ PowerPoint.app --no-restart $UserPlist
[ -d /Applications/Microsoft\ Teams.app ] && dockutil --add /Applications/Microsoft\ Teams.app --no-restart $UserPlist
[ -d /Applications/Microsoft\ Word.app ] && dockutil --add /Applications/Microsoft\ Word.app --no-restart $UserPlist
[ -d /Applications/Google\ Chrome.app ] && dockutil --add /Applications/Google\ Chrome.app --no-restart $UserPlist
[ -d /Applications/Safari.app ] && dockutil --add /Applications/Safari.app --no-restart $UserPlist
[ -d /Applications/Self\ Service.app ] && dockutil --add /Applications/Self\ Service.app $UserPlist

exit 0