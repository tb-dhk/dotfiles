#!/bin/bash
if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then
    echo ' 󱤕󱤂 '
else
    VOL=" 󱤕$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%') "
    python3 ~/.config/waybar/scripts/nnp.py "$VOL"
fi
