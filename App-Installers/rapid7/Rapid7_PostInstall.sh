#!/bin/bash
chmod -R a+x /tmp/r7
cd /tmp/r7

chipArch=$(uname -p)
#Enter the client token
r7token='us:XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'

if [[ $chipArch == "arm" ]] ; then 
	echo "Apple Chipset"
    if [[ -d /opt/rapid7 ]] ; then
   
    ./agent_installer-arm64.sh reinstall_start --token "${r7token}"
    else 
	
	./agent_installer-arm64.sh install_start --token "${r7token}"
    fi
else
	echo "Intel Chipset"
    if [[ -d /opt/rapid7 ]] ; then
      ./agent_installer-x86_64.sh reinstall_start --token "${r7token}"
    else 
       ./agent_installer-x86_64.sh install_start --token "${r7token}"
    fi
fi