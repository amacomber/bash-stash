#!/bin/sh

# Define search terms and return first and last line of results.
lastresult=$( mdfind kind:app "1Password Installer" | tail -1 )
installersearch=$( mdfind kind:app "1Password Installer" | tail -1 | grep -v '/Applications/temporary/' )
firstresult=$( mdfind kind:app "1Password Installer" | head -1 | grep -v '/Applications/temporary/' )
# Log File location
logfile="/Library/Logs/remove1Passwordinstallers.log"

# While the first and last line of the search are different remove the file listed first.
while [[ "$installersearch" != "$firstresult" ]]; do
  echo "Removing $installersearch" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  rm -rf "$installersearch" >> "$logfile" 2>&1;
  echo "Removed 1Password Installer files." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

# Re-Define the first and last lines of the search so this loop can continue until there is only one result.
  echo "Updating search results." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  installersearch=$( mdfind kind:app "1Password Installer" | tail -1 | grep -v '/Applications/temporary/' )
  echo "$installersearch" >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
  firstresult=$( mdfind kind:app "1Password Installer" | head -1 | grep -v '/Applications/temporary/' )
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
  echo "Removing final 1Password Installer files." >> "$logfile" 2>&1;

  echo " " >> "$logfile" 2>&1;
  DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;
fi

echo "All 1Password Installer files have been removed." >> "$logfile" 2>&1;

echo " " >> "$logfile" 2>&1;
DATE=$(date '+%Y-%m-%d %H:%M:%S') && echo "$DATE" >> "$logfile" 2>&1;

exit 0
