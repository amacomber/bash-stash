#!/bin/bash

InstallMacOS="/Applications/Install macOS Ventura.app"

[ ! -d "$InstallMacOS" ] && /usr/sbin/softwareupdate --fetch-full-installer --full-installer-version 13.5;

"$InstallMacOS"/Contents/Resources/startosinstall --agreetolicense &