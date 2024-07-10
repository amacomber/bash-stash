#!/bin/sh

loginwindow_check=$(security authorizationdb read system.login.console | grep 'loginwindow:login' 2>&1 > /dev/null; echo $?)

if [ $loginwindow_check == 0 ]; then
    echo "<result>macOS</result>"
else
    echo "<result>Jamf Connect</result>"
fi