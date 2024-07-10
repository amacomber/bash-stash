#!/bin/bash

cd /Library/Sentinel/sentinel-agent.bundle/Contents
version="$(cat Info.plist | grep string | awk -F '>|<' '{print $3}' | sed -n '7p')"

echo "<result>$version</result>"