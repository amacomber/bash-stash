#!/bin/sh

##Get the wireless port ID
WirelessPort=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

##Collect new preferred wireless network inventory and send back to the JSS
PreferredNetworks=$(networksetup -listpreferredwirelessnetworks "$WirelessPort" | sed 's/^   //g')

echo "<result>$PreferredNetworks</result>"