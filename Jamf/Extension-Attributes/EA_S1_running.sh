#!/bin/bash

PROCESS=SentinelAgent
check=$(ps aux | grep -v grep | grep -ci $PROCESS)

if [ $check -gt 0 ]
        then
                result="Running"
        else
                result="Not Running"
fi

echo "<result>${result}</result>"