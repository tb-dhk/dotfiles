#!/bin/bash

# Temporary file to store the index of the current player
index_file="/tmp/current_player_index"

# Function to escape special characters for GTK markup
escape_markup() {
    echo "$1" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g; s/"/&quot;/g; s/'\''/&apos;/g'
}

# Sleep to allow state to stabilize
sleep 0.1

# Initialize variables
icon='󱤈'  # Default paused icon
color=""
metadata=""

# Get a list of active players
players=($(playerctl -l 2>/dev/null))

# Initialize the player index if it doesn't exist
if [ ! -f "$index_file" ]; then
    echo 0 > "$index_file"
fi

# Read the current index from the file
current_index=$(cat "$index_file")

# Set the player
if [ ${#players[@]} -gt 0 ]; then
    player="${players[$current_index / 10 % ${#players[@]}]}"
else
    player=""
fi

# Check the player's state and set metadata
if [ -z "$player" ]; then
    metadata="󱤕󱤧󱤬󱤂"  # No player active
else
  if playerctl -p "$player" status 2>/dev/null | grep -q 'Playing'; then
    icon='󱤕'
    color="green"
  elif playerctl -p "$player" status 2>/dev/null | grep -q 'Paused'; then
    icon='󱤈'
    color="orange"
  fi
  # Fetch artist and title separately, escape them, and bold the artist
  artist=$(playerctl -p "$player" metadata --format '{{ artist }}')
  title=$(playerctl -p "$player" metadata --format '{{ title }}')
  
  artist_escaped=$(escape_markup "$artist" | tr '[:upper:]' '[:lower:]')
  title_escaped=$(escape_markup "$title" | tr '[:upper:]' '[:lower:]')
  
  # Bold the artist using HTML tags
  metadata="${icon} <b>${artist_escaped}</b> - ${title_escaped}"
fi

# Limit the output to 50 characters and append "..." if necessary
formatted_output=$(echo "$metadata" | awk '{if (length > 40) print substr($0, 1, 37) "..."; else print $0}')

# Print the final output: color, icon, and formatted metadata
printf '{"text": " %s ", "class": "%s"}\n' "$formatted_output" "$color"
