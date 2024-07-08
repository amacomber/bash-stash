#!/bin/bash

# Enable System Firewall
sfw="/usr/libexec/ApplicationFirewall/socketfilterfw"

$sfw --setglobalstate on
$sfw --setloggingmode on

pkill -HUP socketfilterfw
