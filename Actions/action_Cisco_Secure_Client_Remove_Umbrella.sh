#!/usr/bin/env bash

### Remove the Umbrella components ###
rm -rf /opt/cisco/secureclient/bin/plugins/libacumbrellaapi.dylib;
rm -rf /opt/cisco/secureclient/bin/plugins/libacumbrellactrl.dylib;
rm -rf /opt/cisco/secureclient/bin/plugins/libacumbrellaplugin.dylib;

### Restart Cisco Secure Client ###
killall "Cisco Secure Client";
open -a "Cisco Secure Client";

exit 0