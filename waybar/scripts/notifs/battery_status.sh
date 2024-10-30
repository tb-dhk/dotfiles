#!/bin/bash
# Get battery status
battery_info=$(upower -i $(upower -e | grep battery) | awk '/state:/ {state=$2} /percentage:/ {percentage=$2} END {printf "battery %s (%s)\n", state, percentage}')

echo "$battery_info"
