#!/bin/bash

TEST=$( defaults read /Library/Preferences/com.netflix.Escrow-Buddy.plist GenerateNewKey )

echo "<result>$TEST</result>"