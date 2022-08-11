#!/bin/bash

arch=$(/usr/bin/arch)
if [ "$arch" == "arm64" ]; then
	echo "Apple Silicon Detected; installing Rosetta 2"
  softwareupdate --install-rosetta --agree-to-license
	else
		echo "Intel Macs don't require Rosetta 2."
	fi
exit 0
