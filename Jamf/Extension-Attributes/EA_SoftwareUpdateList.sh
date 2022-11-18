#!/bin/bash

# Define current updates waiting to be installed
updatespending="$(softwareupdate -la | grep "\*" | sed -n -e 's/^.*Label: //p')"
echo <result>"$updatespending"</result>

exit 0
