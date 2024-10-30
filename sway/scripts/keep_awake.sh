#!/bin/bash

while true; do
    # Check if a video is playing using playerctl (works for many media players)
    if playerctl status | grep -q 'Playing'; then
        xset -dpms
        xset s off
    else
        xset +dpms
        xset s on
    fi
    sleep 30
done
