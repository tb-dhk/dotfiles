#!/bin/bash

if [ -z $(pgrep -x "gammastep") ]
then
    pkill gammastep
fi

gammastep set -O 3000
