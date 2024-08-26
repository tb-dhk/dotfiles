#!/bin/bash

# Extract volume level from `amixer` output
volume=$(amixer -D pulse sget Master | grep 'Front Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%')

# Extract mute status from `amixer` output
mute=$(amixer -D pulse sget Master | grep 'Front Left:' | awk -F'[][]' '{ print $4 }')

# Define color codes for different volume ranges
color_low="#f38ba8"     # Red
color_medium_low="#f9e2af" # Yellow
color_medium_high="#a6e3a1" # Green
color_high="#74c7ec"    # Blue
color_full="#ffffff"    # White

# Set default color
color=$color_low

# Determine color based on volume percentage
if [ "$volume" -ge 80 ]; then
    color=$color_full
elif [ "$volume" -ge 60 ]; then
    color=$color_high
elif [ "$volume" -ge 40 ]; then
    color=$color_medium_high
elif [ "$volume" -ge 20 ]; then
    color=$color_medium_low
fi

# If muted, show a different color (optional)
if [ "$mute" = "off" ]; then
    echo "  Mute"
else
    echo "%{T3}%{F$color}  $volume% %{F-}"
fi

