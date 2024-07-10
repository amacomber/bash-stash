#!/bin/bash
/bin/echo "<result>$(/usr/sbin/systemsetup -gettimezone | /usr/bin/awk '{print $3}')</result>"