#!/bin/bash

currentUser=$(stat -f "%Su" /dev/console)
echo "$currentUser"

if [ -d "/Library/Internet Plug-Ins/WPFe.plugin" ];
	then
	echo "found /Library/Internet Plug-Ins/WPFe.plugin"
	rm -rf "/Library/Internet Plug-Ins/WPFe.plugin"
	else
	echo "did not find /Library/Internet Plug-Ins/WPFe.plugin"
fi

if [ -d "/Library/Internet Plug-Ins/Silverlight.plugin" ];
	then
	echo "found /Library/Internet Plug-Ins/Silverlight.plugin"
	rm -rf "/Library/Internet Plug-Ins/Silverlight.plugin"
	else
	echo "did not find /Library/Internet Plug-Ins/Silverlight.plugin"
fi

if [ -d "/Users/$currentUser/Library/Application Support/Microsoft/Silverlight" ];
	then
	echo "found /Users/$currentUser/Library/Application Support/Microsoft/Silverlight"
	rm -rf "/Users/$currentUser/Library/Application Support/Microsoft/Silverlight"
	else
	echo "did not find /Users/$currentUser/Library/Application Support/Microsoft/Silverlight"
fi

if [ -f "/Library/Receipts/Silverlight.pkg" ];
	then
	echo "found /Library/Receipts/Silverlight.pkg"
	rm -rf "/Library/Receipts/Silverlight.pkg"
	else
	echo "did not find /Library/Receipts/Silverlight.pkg"
fi
if [ -f "/Library/Receipts/Silverlight_W2_MIX.pkg" ];
	then
	echo "found /Library/Receipts/Silverlight_W2_MIX.pkg"
	rm -rf "/Library/Receipts/Silverlight_W2_MIX.pkg"
	else
	echo "did not find /Library/Receipts/Silverlight_W2_MIX.pkg"
fi
if [ -f "/Library/Receipts/WPFe.pkg" ];
	then
	echo "found /Library/Receipts/WPFe.pkg"
	rm -rf "/Library/Receipts/WPFe.pkg"
	else
	echo "did not find /Library/Receipts/WPFe.pkg"
fi