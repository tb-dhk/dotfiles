#!/bin/bash

# Define the output directory
OUTPUT_DIR="/home/$USER/Pictures"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')

# Parse options
COPY_TO_CLIPBOARD=false
MODE="fullscreen"

# Process command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --window) MODE="window";;
    --area) MODE="area";;
    --clipboard) COPY_TO_CLIPBOARD=true;;
    *) echo "Usage: $0 [--window | --area] [--clipboard]"; exit 1;;
  esac
  shift
done

# Take screenshot based on mode
case "$MODE" in
  window)
    FILE="$OUTPUT_DIR/$TIMESTAMP-window.png"
    grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | "\(.x),\(.y) \(.width)x\(.height)"')" "$FILE"
    ;;
  area)
    FILE="$OUTPUT_DIR/$TIMESTAMP-area.png"
    grim -g "$(slurp)" "$FILE"
    ;;
  fullscreen)
    FILE="$OUTPUT_DIR/$TIMESTAMP-fullscreen.png"
    grim "$FILE"
    ;;
esac

# Copy to clipboard if --clipboard is specified
if [ "$COPY_TO_CLIPBOARD" = true ]; then
  wl-copy < "$FILE"
fi

echo "Screenshot saved to $FILE"
