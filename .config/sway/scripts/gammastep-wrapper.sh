#!/bin/bash

if pgrep -x "gammastep" > /dev/null
then
    echo "gammastep is already running"
else
    gammastep set -O 2500
fi

