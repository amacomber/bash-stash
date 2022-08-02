#Make temp folder for downloads.
mkdir "/tmp/Installer/";
cd "/tmp/Installer/";

#Download dockutil from GitHub.
curl -L -o /tmp/Installer/dockutil.pkg "https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg";

#install dockutil
sudo installer -pkg  /private/tmp/Installer/dockutil.pkg -target /;

#tidy up
sudo rm -rf "/tmp/Installer";

#Define Current User
currentuser=$(ls -l /dev/console | awk '{ print $3 }')

#Remove All Icons
/usr/local/bin/dockutil --remove all /Users/$currentuser

#Set Icons
/usr/local/bin/dockutil --add "/System/Applications/Launchpad.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/Applications/Safari.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/Applications/Google Chrome.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/Applications/Microsoft Outlook.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/Applications/Microsoft Word.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/Applications/Microsoft Excel.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/Applications/Microsoft PowerPoint.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/System/Applications/App Store.app" /Users/$currentuser;
/usr/local/bin/dockutil --add "/System/Applications/System Preferences.app" /Users/$currentuser;

exit 0
