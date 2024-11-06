#!/bin/bash

# Define source and destination directories
LOCAL_CONFIG="./.config/"
HOME_CONFIG="$HOME/.config/"

# Check if local config directory exists
if [ ! -d "$LOCAL_CONFIG" ]; then
  echo "Local config directory $LOCAL_CONFIG does not exist."
  exit 1
fi

# Sync files from local config to home config directory
rsync -av "$LOCAL_CONFIG" "$HOME_CONFIG"

echo "Configuration files refreshed from $LOCAL_CONFIG to $HOME_CONFIG"
