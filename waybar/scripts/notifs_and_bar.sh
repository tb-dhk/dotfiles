#!/bin/bash

# Kill any running instances of dunst, waybar, and the master notification script
pkill dunst
pkill waybar
pkill -f "$HOME/.config/scripts/waybar/notifs/master.sh"

# Restart dunst with output logging
stdbuf -oL dunst -print >> "$HOME/notifications.log" &

# Restart waybar instances with specific configurations
waybar -c "$HOME/.config/waybar/top.json" &
waybar -c "$HOME/.config/waybar/bottom.json" &

# Start the master notification script
"$HOME/.config/scripts/waybar/notifs/master.sh" &
