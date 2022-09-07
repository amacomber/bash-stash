# Definitions
# Dockutil binary location
dockutil="/usr/local/bin/dockutil"
# Log File location
logfile="/Library/Logs/dockutil.log"
# Go to "https://github.com/kcrawford/dockutil/releases" and grab the link to the latest release
url="https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg"

# Check for a temp folder and make one if not found
echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

[ ! -f "tmp/Installer" ] && /bin/mkdir -p "/tmp/Installer/" >> "$logfile" 2>&1;
echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
echo " " >> "$logfile" 2>&1;

cd "/tmp/Installer/" >> "$logfile" 2>&1;
echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
# Download Latest DockUtils from GitHub

curl -L -o /tmp/Installer/dockutil.pkg "$url" >> "$logfile" 2>&1;
echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

#install DockUtils
installer -pkg /private/tmp/Installer/dockutil.pkg -target / >> "$logfile" 2>&1;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

# Clean up the temp folder
[ -f "tmp/Installer" ] && rm -rf "/tmp/Installer" >> "$logfile" 2>&1;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

#Define Current User
currentuser=$(ls -l /dev/console | awk '{ print $3 }')
echo "$currentuser"  >> "$logfile" 2>&1

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

#Remove All Icons from the Dock
$dockutil --remove all /Users/$currentuser >> "$logfile" 2>&1

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

#Set Icons

# Add Launchpad.app to the Dock
$dockutil --add /System/Applications/Launchpad.app /Users/$currentuser >> "$logfile" 2>&1

# Add Safari.app to the Dock
$dockutil --add /Applications/Safari.app /Users/$currentuser >> "$logfile" 2>&1

# Add Atom.app to the Dock
#$dockutil --add "/Applications/Atom.app" /Users/$currentuser >> "$logfile" 2>&1

# Add App Store.app to the Dock
$dockutil --add "/System/Applications/App Store.app" /Users/$currentuser >> "$logfile" 2>&1

# Add System Preferences.app to the Dock
$dockutil --add "/System/Applications/System Preferences.app" /Users/$currentuser >> "$logfile" 2>&1

# Restart Dock 
echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
killall Dock;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
exit 0
