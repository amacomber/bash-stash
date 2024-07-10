#!/bin/bash

# Define the directory path
result="/Library/Application Support/MekkoGraphics/MekkoGraphics.app"

# Check if the directory exists
if [ -d "$result" ]; then
  echo "<result>Installed</result>"
else
  echo "<result>Not installed</result>"
fi