#!/bin/bash

# Define RGB color codes for a rainbow effect
RAINBOW_COLORS=(
    "243;139;168"  # Red
    "250;179;135"  # Orange
    "249;226;175"  # Yellow
    "166;227;161"  # Green
    "116;199;236"  # Indigo
    "137;180;250"  # Blue
    "180;190;254"  # Violet
)

# Function to get the next color
get_next_color() {
    local color_index=$((color_count % ${#RAINBOW_COLORS[@]}))
    printf "\033[38;2;%sm" "${RAINBOW_COLORS[$color_index]}"
    color_count=$((color_count + 1))
}

# Initialize color count
color_count=0

# Read input line by line
while IFS= read -r line; do
    get_next_color
    printf "%s\033[0m\n" "*$line*"  # Reset color after line
done

