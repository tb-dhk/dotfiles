#!/bin/bash

# Define source and destination directories
LOCAL_CONFIG="./.config/"
HOME_CONFIG="$HOME/.config/"

# Check if local config directory exists
if [ ! -d "$LOCAL_CONFIG" ] || [ ! -d "$HOME_CONFIG" ]; then
  exit 1
fi

# Sync files from home config to local config directory, only updating existing files
rsync -av --existing "$HOME_CONFIG" "$LOCAL_CONFIG"
