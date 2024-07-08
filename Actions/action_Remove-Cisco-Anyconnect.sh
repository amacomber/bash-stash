#!/bin/sh

# Kill all AnyConnect processes
# killall "anyconnect"
# Unload LaunchDaemon
launchctl unload /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist
launchctl unload /Library/LaunchAgents/com.cisco.anyconnect.gui.plist
launchctl unload /Library/LaunchAgents/com.cisco.anyconnect.notification.plist

rm -rf /System/Library/StartupItems/CiscoVPN
rm -rf /Library/StartupItems/CiscoVPN
rm -rf /System/Library/Extensions/CiscoVPN.kext
rm -rf /Library/Extensions/CiscoVPN.kext
rm -rf /Library/Receipts/vpnclient-kext.pkg
rm -rf /Library/Receipts/vpnclient-startup.pkg
rm -rf /Cisco\ VPN\ Client.mpkg
rm -rf /com.nexUmoja.Shimo.plist
rm -rf /Profiles
rm -rf /Shimo.app
rm -rf /Library/Application\ Support/Shimo
rm -rf /Library/Frameworks/cisco-vpnclient.framework
rm -rf /Library/Extensions/tun.kext
rm -rf /Library/Extensions/tap.kext
rm -rf /private/opt/cisco-vpnclient
rm -rf /Applications/VPNClient.app
rm -rf /Applications/Shimo.app
rm -rf /private/etc/opt/cisco-vpnclient
rm -rf /Library/Receipts/vpnclient-api.pkg
rm -rf /Library/Receipts/vpnclient-bin.pkg
rm -rf /Library/Receipts/vpnclient-gui.pkg
rm -rf /Library/Receipts/vpnclient-profiles.pkg
rm -rf ~/Library/Preferences/com.nexUmoja.Shimo.plist
rm -rf ~/Library/Application\ Support/Shimo
rm -rf ~/Library/Preferences/com.cisco.VPNClient.plist
rm -rf ~/Library/Application\ Support/SyncServices/Local/TFSM/com.nexumoja.Shimo.Profiles
rm -rf ~/Library/Logs/Shimo*
rm -rf ~/Library/Application\ Support/Shimo
rm -rf ~/Library/Application\ Support/Growl/Tickets/Shimo.growlTicket
pkgutil --forget com.cisco.pkg.anyconnect.vpn

#Remove left over AnyConnect files
allAnyConnect=$( mdfind kind:app "anyconnect" | tail -1 )
compare=$( mdfind kind:app "anyconnect" | head -1 )

while [[ "$allAnyConnect" != "$compare" ]]; do
  echo "Removing $allAnyConnect"
  rm -rf "$allAnyConnect"
  echo "Removed Cisco AnyConnect files."

  # Re-define allAnyConnect
  allAnyConnect=$( mdfind kind:app "anyconnect" | tail -1 )
  echo "$allAnyConnect"
done

if [[ -d "$allAnyConnect" ]]; then
  rm -rf "$allAnyConnect"
  echo "Removing final Cisco AnyConnect files."
fi

echo "All Cisco AnyConnect Apps have been removed."

exit 0
