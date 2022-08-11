#!/bin/sh

# Define search terms and return first and last line of results.
lastresult=$( mdfind kind:app "Install macOS Monterey" | tail -1 )
maketempdirectory="/Applications/temporary/"
truemonterey="/Applications/Install macOS Monterey.app"
montereyappname="Install macOS Monterey.app"
montereytempfile="/Applications/temporary/Install macOS Monterey.app"
installersearch=$( mdfind kind:app "Install macOS" | tail -1 | grep -v '/Applications/temporary/' )
firstresult=$( mdfind kind:app "Install macOS" | head -1 | grep -v '/Applications/temporary/' )
# Log File location
logfile="/Library/Logs/removeMacOSinstallers.log"

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
# Kill macOS InstallAssistant if running
  killall "InstallAssistant" >> "$logfile" 2>&1

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
# Find and move existing Install macOS Monterey.app
if [ -d "$truemonterey" ]; then
  echo "$montereyappname located." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  [ ! -d "$maketempdirectory" ] && mkdir "$maketempdirectory"
  echo "Created temporary folder." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  [ ! -d "$montereytempfile" ] && mv -f "$truemonterey" "$montereytempfile";
  echo "$montereyappname moved temporarily" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
else
  echo "Install macOS Monterey.app not found. Moving on with the process." >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S');
  echo "$DATE" && echo " ";
fi



# While the first and last line of the search are different remove the file listed first.
while [[ "$installersearch" != "$firstresult" ]]; do
  echo "Removing $installersearch" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  rm -rf "$installersearch" >> "$logfile" 2>&1;
  echo "Removed macOS Installer files." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

# Re-Define the first and last lines of the search so this loop can continue until there is only one result.
  echo "Updating search results." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  installersearch=$( mdfind kind:app "Install macOS" | tail -1 | grep -v '/Applications/temporary/' )
  echo "$installersearch" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  firstresult=$( mdfind kind:app "Install macOS" | head -1 | grep -v '/Applications/temporary/' )
  echo "$firstresult" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
done

# Once the first and last result are the same do one more check in case there is 1 result.
# If there is 1 result run one more delete. If there is a 0 result then finish the job.
  echo "First and last result match. Moving to final stage." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

if [[ -d "$installersearch" ]]; then
  rm -rf "$installersearch" >> "$logfile" 2>&1;
  echo "Removing final macOS Installer files." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
fi

echo "All macOS Installer files have been removed." >> "$logfile" 2>&1;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

# Replace Monterey Installer
if [ -d "$montereytempfile" ]; then
  mv -f "$montereytempfile" "$truemonterey" >> "$logfile" 2>&1;
  [ -d "$truemonterey" ] && echo "Moved macOS Monterey Installer back." >> "$logfile" 2>&1;
  [ ! -d "$truemonterey" ] && echo "Move of macOS Monterey Installer failed." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  [ -d "$maketempdirectory" ] && rm -R "$maketempdirectory" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
else
  echo "No relocated installers found. Moving on with the process." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
fi

# Start next phase
echo "Software Update Percussive Reboot" >> "$logfile" 2>&1;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
launchctl kickstart -k system/com.apple.softwareupdated >> "$logfile" 2>&1;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
echo "Software Update Rebooted" >> "$logfile" 2>&1;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

if [ -d "$truemonterey" ]; then
  open -a "$truemonterey" >> "$logfile" 2>&1;
else
  echo "No macOS installers found. Moving on with the process." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  echo "Opening Software Update Preference Panel" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  open /System/Library/PreferencePanes/SoftwareUpdate.prefPane >> "$logfile" 2>&1;
fi

exit 0
