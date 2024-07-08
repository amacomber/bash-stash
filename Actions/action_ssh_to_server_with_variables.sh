#!/bin/bash

# DEFINITIONS #
currentuser=$(ls -l /dev/console | awk '{ print $3 }')
certloc="/Users/$currentuser/Library/AWS_Certs"
certname="boringhost.pem"
generatedcerts="/Users/$currentuser/Library/AWS_Certs/Generated/id_rsa"
servername="ec2-00-00-000-000.us-west-2.compute.amazonaws.com"

if test -f "$certloc"/"$certname"; then
    echo "'$certloc/$certname' exists"
  else
    cp -v "$generatedcerts" "$certloc"/"$certname"
    chmod 400 "$certloc"/"$certname"
fi

ssh -i "$certloc"/"$certname" "$currentuser"@"$servername"
