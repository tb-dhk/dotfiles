#!/bin/bash

if pgrep -x "gammastep" > /dev/null
then
    pkill gammastep
    echo "gammastep is already running"
fi

gammastep set -O 2500

