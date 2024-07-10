#!/bin/bash

networksetup -listallnetworkservices | sed "1d" | while read output ; do networksetup -setv6off "$output";done
