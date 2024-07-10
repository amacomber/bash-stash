#!/bin/bash

if [ -f  "/Library/LaunchDaemons/snap-agent.plist" ]; then
	echo "<result>BlackPoint Installed</result>"
else
	echo "<result>BlackPoint Not Installed</result>"
fi

