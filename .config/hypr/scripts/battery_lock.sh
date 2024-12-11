#!/bin/bash

# Get the battery level
BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status) # Check if charging or discharging

# Lock the screen if the battery is low and discharging
if [[ "$STATUS" == "Discharging" && "$BATTERY_LEVEL" -le 10 ]]; then
    # Replace 'hyprctl dispatch dpms off' with your lock screen command
    loginctl lock-session
fi
