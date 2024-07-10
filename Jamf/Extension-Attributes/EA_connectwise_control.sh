#!/bin/bash

if [ -d  "/opt/connectwisecontrol-"* ]; then
    connect_wise=$(defaults read /opt/connectwisecontrol-*/Contents/Info.plist CFBundleVersion)
else
    connect_wise="Not Installed"
fi

echo "<result>${connect_wise}</result>"