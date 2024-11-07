#!/bin/bash

# Define source and destination directories
LOCAL_CONFIG="./.config/"
HOME_CONFIG="$HOME/.config/"

# Check if local and home config directories exist
if [ ! -d "$LOCAL_CONFIG" ] || [ ! -d "$HOME_CONFIG" ]; then
  exit 1
fi

# Loop through each subdirectory in $HOME_CONFIG
for dir in "$HOME_CONFIG"*/; do
  # Get the name of the subdirectory
  subdir_name=$(basename "$dir")

  # Check if the same subdirectory exists in $LOCAL_CONFIG
  if [ -d "$LOCAL_CONFIG$subdir_name" ]; then
    echo "Syncing $subdir_name..."

    # Run rsync with --existing and --itemize-changes, capturing the output
    rsync_output=$(rsync -av --existing --itemize-changes "$HOME_CONFIG$subdir_name/" "$LOCAL_CONFIG$subdir_name/")

    # Process rsync output to show added and edited files
    echo "$rsync_output" | while IFS= read -r line; do
      # Added files are marked with ">"
      if [[ "$line" == *">f++++++++"* ]]; then
        echo "Added: ${line#* }"
      # Edited files are marked with ".f"
      elif [[ "$line" == *".f"* ]]; then
        echo "Edited: ${line#* }"
      fi
    done
  fi
done

echo "Sync complete."
