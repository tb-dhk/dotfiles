#!/bin/bash

# Temporary file to store the index of the current player
index_file="/tmp/current_player_index"

# Get a list of active players
players=($(playerctl -l 2>/dev/null))

# Initialize the player index if it doesn't exist
if [ ! -f "$index_file" ]; then
    echo 0 > "$index_file"
fi

# Read the current index from the file
current_index=$(cat "$index_file")
player="${players[$current_index / 10 % ${#players[@]}]}"

# toggle player
playerctl -p "$player" play-pause

# After changing the state, sleep briefly to allow any updates
sleep 0.1
