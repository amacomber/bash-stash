#!/bin/bash

### Parameter 4: CUPS Printer Name - No Spaces          ###
### Parameter 5: IP Address or FQDN                     ###
### Parameter 6: PPD Path (use lpinfo -m | grep model)  ###
### Parameter 7: macOS Printer Name - Spaces Allowed    ###

4="Kyocera_Taskalfa_5054ci"
5="192.168.1.103"
6="Library/Printers/PPDs/Contents/Resources/Kyocera TASKalfa 5054ci.PPD Kyocera TASKalfa 5054ci KPDL"
7="Kyocera Taskalfa 5054ci"





lpadmin -p "${4}" -E -v lpd://${5} -m "${6}" -o printer-is-shared=false -D "${7}" -o auth-info-required=negotiate