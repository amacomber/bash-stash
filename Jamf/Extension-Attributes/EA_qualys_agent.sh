#!/bin/bash

if [ -d  "/Applications/QualysCloudAgent.app" ]; then
	echo "<result>Qualys Installed</result>"
else
	echo "<result>Qualys Not Installed</result>"
fi