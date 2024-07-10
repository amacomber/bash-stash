#!/bin/sh
# Check OS level
sw_vers_Full=$(/usr/bin/sw_vers -productVersion)
if [[ "$sw_vers_Full" < "10.13" ]] ; then
	exit 0
fi
# Gather list of User Approved Kernel Extensions.
list=$( /usr/bin/sqlite3 -csv /var/db/SystemPolicyConfiguration/KextPolicy "select team_id,bundle_id from kext_policy" )
/bin/echo "<result>${list}</result>"
exit 0