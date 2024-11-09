#!/bin/bash

# Define source and destination directories
LOCAL_CONFIG="./.config/"
HOME_CONFIG="$HOME/.config/"

# Check if local and home config directories exist
if [ ! -d "$LOCAL_CONFIG" ] || [ ! -d "$HOME_CONFIG" ]; then
  echo "Error: One of the config directories does not exist."
  exit 1
fi

# Loop through each subdirectory in LOCAL_CONFIG only
for dir in "$LOCAL_CONFIG"*/; do
  # Get the name of the subdirectory
  subdir_name=$(basename "$dir")

  # Check if the same subdirectory exists in HOME_CONFIG
  if [ -d "$HOME_CONFIG$subdir_name" ]; then
    echo "Syncing $subdir_name..."

    # Run rsync to copy files from HOME_CONFIG subdirectory to LOCAL_CONFIG subdirectory
    rsync_output=$(rsync -av --itemize-changes "$HOME_CONFIG$subdir_name/" "$LOCAL_CONFIG$subdir_name/")

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
