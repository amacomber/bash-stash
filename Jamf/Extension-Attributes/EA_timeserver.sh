#!/bin/sh

if [ -f /usr/sbin/systemsetup ];then    
     echo “$(sudo /usr/sbin/systemsetup -getnetworktimeserver | awk '{print $4}')"
else
     echo "Time Server Not Configured."
fi
exit 0