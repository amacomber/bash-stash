#!/bin/bash

[ ! -d "~/Library/Preferences/com.test.loginwindow" ] && touch ~/Library/Preferences/com.test.loginwindow
[ ! -d "~/Library/Preferences/SystemConfiguration/com.test.PowerManagement" ] && touch ~/Library/Preferences/SystemConfiguration/com.test.PowerManagement
/usr/bin/defaults write ~/Library/Preferences/com.test.loginwindow DisableScreenLockImmediate -bool true

defaults write ~/Library/Preferences/SystemConfiguration/com.test.PowerManagement SystemPowerSettings -dict SleepDisabled -bool YES

defaults write ~/Library/Preferences/com.test.loginwindow SleepDisabled -bool true