#!/bin/bash

# Get the currently running Steam game name
game_name=$(pgrep -a -f steam | grep '\\home' | awk -F'\\\\' '{print $(NF-1)}' | head -n 1 | tr '[:upper:]' '[:lower:]')

# Check if a game is found and format output
if [ -n "$game_name" ]; then
    echo " 󱤻 $game_name "
else
    echo ""
fi
