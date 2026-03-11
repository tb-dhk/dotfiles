#!/bin/bash

# get battery percentage as integer
number=$(upower -i $(upower -e | grep BAT) | awk '/percentage/ {gsub("%","",$2); print $2}')

# get battery state
state=$(upower -i $(upower -e | grep BAT) | awk '/state/ {print $2}')

# determine color
if [[ "$state" == "charging" ]]; then
    color="green"
elif (( number < 10 )); then
    color="red"
elif (( number < 20 )); then
    color="yellow"
fi

# convert number to custom symbols
text="󱥵$(echo $number | xargs python3 ~/.config/waybar/scripts/nnp.py)"

# print in json format for waybar
printf '{"text": " %s ", "class": "%s"}\n' "$text" "$color"
