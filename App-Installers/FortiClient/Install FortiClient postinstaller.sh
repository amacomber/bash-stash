#!/bin/bash

# Check if FortiClient folder exists
[ -d "/Library/Company/FortiClient/" ] && installer -pkg /Library/Company/FortiClient/Install.mpkg -target "/";
echo "Installed FortiClient"

# Clean up temp files
[ -d "/Library/Company/FortiClient/" ] && rm /Library/Company/FortiClient;
echo "Cleaned up installer files."


exit 0
