#!/bin/bash

###################
### DEFINITIONS ###
###################

# Get Download link and SHA Checksum info from #
# https://mrmacintosh.com/macos-big-sur-full-installer-database-download-directly-from-apple/ #
# or #
# https://mrmacintosh.com/macos-12-monterey-full-installer-database-download-directly-from-apple/ #

# macOS Link #
OSDownload=$"http://paste/package/url/InstallAssistant.pkg"

# Checksum value #
SHAExpected=$"Paste checksum here"

# Temporary Working Directory #
Temp=$"/Library/Whatever/Temp"

# Define Package Name #
PKGInstall="$Temp/InstallAssistant.pkg"

#####################
### SCRIPT STARTS ###
#####################

echo "$SHAExpected"

	if [[ -f "$PKGInstall" ]]; then
	echo "$PKGInstall already exists."

	# Check Downloaded File Checksum #
	SHACheck="$( openssl dgst -sha256 "$Temp/InstallAssistant.pkg" | cut -d " " -f3 )"
	echo "$SHACheck" &&
	echo "$SHAExpected" &&

		if [[ $SHAExpected = "$SHACheck" ]]; then
			# SHA Check is a match #
			echo "SHA Match - Proceeding with Install"

			# Execute Package Install #
			installer -pkg "$Temp/InstallAssistant.pkg" -target / &&

			# Clean up temp files #
			rm -R "$Temp"
			exit 0	### Package Install Successful
		else
			# No it is not
			echo "SHA Mismatch - Existing Installer PKG will be deleted"

			# Clean up temp old Installer files #
			rm -R "/$Temp"

			# Make temp folder for downloads #
			mkdir "$Temp";
			cd "$Temp" || exit;

			# Download InstallAssistant.pkg from Apple's Servers #
			curl -L -o "$PKGInstall" "$OSDownload" &&

			# Check Downloaded File Checksum #
			SHACheck="$( openssl dgst -sha256 "$PKGInstall" | cut -d " " -f3 )"
			echo "$SHACheck" &&
			echo "$SHAExpected" &&

					if [[ $SHAExpected = "$SHACheck" ]]; then
					# SHA Check is a match #
					echo "SHA Match - Proceeding with Install"

					# Execute Package Install #
					installer -pkg "$Temp/InstallAssistant.pkg" -target / &&

					# Clean up temp files #
					rm -R "$Temp"
					exit 0	### Package Install Successful
				else
					# No it is not
					echo "SHA Mismatch - Aborting Install"

					# Clean up temp files #
					rm -R "$Temp"
					exit 1	### SHA Mismatch

fi
fi
else
	# Installer Package Not Found #
	echo "$PKGInstall does not exist"

	# Make temp folder for downloads #
	mkdir "$Temp";
	cd "$Temp" || exit;

	# Download InstallAssistant.pkg from Apple's Servers #
	curl -L -o "$PKGInstall" "$OSDownload" &&

	# Check Downloaded File Checksum #
	SHACheck="$( openssl dgst -sha256 "$PKGInstall" | cut -d " " -f3 )"
	echo "$SHACheck" &&
	echo "$SHAExpected" &&

			if [[ $SHAExpected = "$SHACheck" ]]; then
			# SHA Check is a match #
			echo "SHA Match - Proceeding with Install"

			# Execute Package Install #
			installer -pkg "$PKGInstall" -target / &&

			# Clean up temp files #
			rm -R "$Temp"
			exit 0	### Package Install Successful
		else
			# No it is not
			echo "SHA Mismatch - Aborting Install"

			# Clean up temp files #
			rm -R "$Temp"
			exit 1	### SHA Mismatch
fi
fi
