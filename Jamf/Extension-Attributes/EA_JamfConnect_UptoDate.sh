#!/bin/bash

getJSONValue() {
	# $1: JSON string OR file path to parse (tested to work with up to 1GB string and 2GB file).
	# $2: JSON key path to look up (using dot or bracket notation).
	printf '%s' "$1" | /usr/bin/osascript -l 'JavaScript' \
		-e "let json = $.NSString.alloc.initWithDataEncoding($.NSFileHandle.fileHandleWithStandardInput.readDataToEndOfFile$(/usr/bin/uname -r | /usr/bin/awk -F '.' '($1 > 18) { print "AndReturnError(ObjC.wrap())" }'), $.NSUTF8StringEncoding)" \
		-e 'if ($.NSFileManager.defaultManager.fileExistsAtPath(json)) json = $.NSString.stringWithContentsOfFileEncodingError(json, $.NSUTF8StringEncoding, ObjC.wrap())' \
		-e "const value = JSON.parse(json.js)$([ -n "${2%%[.[]*}" ] && echo '.')$2" \
		-e 'if (typeof value === "object") { JSON.stringify(value, null, 4) } else { value }'
}
jamfConnectLocation="/Applications/Jamf Connect.app"

appNewVersion=$(getJSONValue "$(curl -s "https://learn-be.jamf.com/api/bundlelist?name_filter.field=name&name_filter.value=jamf-connect-documentation-current")" ".bundle_list[0].title" | awk -F ' ' '{print $NF}')
jamfConnectVersion=$(defaults read "$jamfConnectLocation"/Contents/Info.plist "CFBundleShortVersionString")

echo "Latest version: v$appNewVersion"
echo "Current version: v$jamfConnectVersion"

if [ "$appNewVersion" == "$jamfConnectVersion" ]; then
echo "<result>Jamf Connect up to date</result>"
else
echo "<result>Jamf Connect needs an update to v$appNewVersion</result>"
fi
