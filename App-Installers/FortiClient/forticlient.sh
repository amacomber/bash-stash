#!/bin/bash

# Check if FortiClient folder exists
[ -d "/Library/FortiClient/" ] && installer -pkg "/Library/FortiClient/Install.mpkg" -target "/";
echo "Installed FortiClient"

# Clean up temp files
[ -d "/Library/FortiClient/" ] && rm "/Library/FortiClient";
echo "Cleaned up installer files."


exit 0
