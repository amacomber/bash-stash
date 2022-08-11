#!/bin/sh

netset="networksetup -setv6off"

$netset USB\ 10/100/1000\ LAN
$netset Ethernet
$netset Wi-Fi

exit 0
