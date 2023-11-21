#!/bin/bash

nodeV=$(node -v)

if [ -z "$nodeV" ];
then
    echo "<result>Not Installed</result>"
else
    echo "<restult>$nodeV</result>"
fi