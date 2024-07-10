#!/bin/bash
  
totalLocalUsers=0


for i in $(dscl /Local/Default list Users UniqueID | awk '$2 >500 {print $1}'); do
    totalLocalUsers=$(($totalLocalUsers + 1 ))
done

echo “$totalLocalUsers"