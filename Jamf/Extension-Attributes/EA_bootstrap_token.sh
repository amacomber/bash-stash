#!/bin/zsh

### EA to determine status of Bootstrap Token ###

test=$( profiles status -type bootstraptoken | head -2 | tail -1 | rev | cut -d" " -f1 | rev )

echo "<result>$test</result>"