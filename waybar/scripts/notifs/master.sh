#!/bin/bash

# Path to the battery status script
BATTERY_SCRIPT="$HOME/.config/waybar/scripts/notifs/battery_status.sh"

# Initialize last known state and percentage to empty
last_state=$(echo "$battery_status" | grep -oP '(?<=battery ).*(?= \()' || echo "unknown")
last_percentage=$(echo "$battery_status" | grep -oP '(?<=\().*(?=%\))' || echo "0")

while true; do
    # Get current battery status and percentage, and handle if empty
    battery_status=$($BATTERY_SCRIPT 2>/dev/null)
    echo "battery_status: $battery_status"
    
    # Check if battery_status output is empty and skip this loop if so
    if [[ -z "$battery_status" ]]; then
        sleep 1
        continue
    fi

    # Extract current state and percentage safely, defaulting to unknown values if not found
    current_state=$(echo "$battery_status" | grep -oP '(?<=battery ).*(?= \()' || echo "unknown")
    current_percentage=$(echo "$battery_status" | grep -oP '(?<=\().*(?=%\))' || echo "0")
    echo "current_state: $current_state"    

    # Check for state changes and notify
    if [[ "$current_state" != "$last_state" ]]; then
        if [[ $current_state == "charging" ]]; then
          notify-send -u low "Battery" "charging ($current_percentage%)"
        elif [[ $current_state == "discharging" ]]; then
          notify-send -u normal "Battery" "discharging ($current_percentage%)"
        fi
    fi

    # Check for critical battery level warnings and notify
    if (( current_percentage <= 10 && current_percentage != last_percentage )); then
        notify-send -u critical "Battery" "Battery is at $current_percentage%!"
    elif (( current_percentage <= 20 && current_percentage != last_percentage )); then
        notify-send -u normal "Battery" "Battery is at $current_percentage%."
    fi

    # Update last known percentage
    last_state="$current_state"
    last_percentage="$current_percentage"

    # Wait 1 second before the next check
    sleep 1
done

