#!/bin/bash
LD="/Library/LaunchDaemons/"
LA="/Library/LaunchAgents/"
serviceplistpath="com.manageengine.desktopcentral.dcagentservice.plist"
upgraderplistpath="com.manageengine.desktopcentral.dcagentupgrader.plist"
dcnotifyplistpath="com.manageengine.desktopcentral.dcnotifyservice.plist"
peruserplistpath="com.manageengine.desktopcentral.peruseragent.plist"
preloginpath="com.manageengine.desktopcentral.prelogin.plist"

launchctl remove "$serviceplistpath";
launchctl remove "$upgraderplistpath";
launchctl remove "$dcnotifyplistpath";
launchctl remove "$peruserplistpath";
launchctl remove "$preloginpath";

rm -rf "$LD""$serviceplistpath";
rm -rf "$LD""$upgraderplistpath";
rm -rf "$LD""$dcnotifyplistpath";
rm -rf "$LA""$peruserplistpath";
rm -rf "$LA""$preloginpath";

rm -rf "/Library/DesktopCentral_Agent";