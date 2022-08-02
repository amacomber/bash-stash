#!/bin/bash

# Check if FortiClient folder exists
[ -d "/Library/Company/FortiClient/" ] && installer -pkg /Library/Invitae\ IT/FortiClient/Install.mpkg -target "/";
echo "Installed FortiClient"

# Clean up temp files
[ -d "/Library/Company/FortiClient/" ] && rm F/Library/Invitae\ IT/FortiClient;
echo "Cleaned up installer files."


exit 0
