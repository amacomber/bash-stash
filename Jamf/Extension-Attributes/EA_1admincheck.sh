#!/bin/bash

if groups adminName | grep -q -w admin; 
then 
echo "<result>Yes</result>"; 
else 
echo "<result>No</result>"; 
fi