#!/bin/bash

#####################################################
### Check to see if the computer is Intel or ARM. ###
#####################################################
arch=$(/usr/bin/arch)

###############################
### Is Rosetta 2 installed? ###
###############################
if [ "$arch" == "arm64" ]; then
    arch -x86_64 /usr/bin/true 2> /dev/null
    if [ $? -eq 1 ];
        then result="missing"
    else result="installed"
    fi
else result="ineligible"
fi

#############################################################
### Should only return missing, installed, or ineligible. ###
#############################################################
echo "<result>$result</result>"