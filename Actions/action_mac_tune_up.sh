#!/bin/bash

LoggedInUser=$(stat -f%Su /dev/console)

# Clear User Caches
rm -rf /Users/$LoggedInUser/Library/Caches/*

# Clear User Saved Application States

rm -rf "/Users/$LoggedInUser/Library/Saved Application State/*"