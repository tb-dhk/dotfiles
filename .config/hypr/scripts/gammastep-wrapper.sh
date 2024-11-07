#!/bin/bash

if pgrep -x "gammastep" > /dev/null
then
    pkill gammastep
fi

gammastep set -O 3000
