#!/bin/bash

 driveList=$( ls -l /Volumes | cut -w -f9- )
 echo "$driveList"

 exit 0