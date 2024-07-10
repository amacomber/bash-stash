#!/bin/bash
sudo killall RingCentral
Sudo killall Glip
sudo rm -r /Applications/RingCentral.app/
sudo rm -r /Applications/Glip.app

#Make Temporary Install Directory
mkdir "/tmp/Installer/";
cd "/tmp/Installer/";

#Download PKG file.
curl -L -o /tmp/Installer/RingCentral.pkg "https://app.ringcentral.com/downloads/RingCentral.pkg";

#install the APP from PKG file
sudo installer -pkg /private/tmp/Installer/RingCentral.pkg -target /;

#Clean up installer files
sudo rm -rf "/tmp/Installer";

exit 0