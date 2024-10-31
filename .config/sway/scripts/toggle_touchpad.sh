#!/bin/bash

# Get touchpad ID (You may need to change the name according to your touchpad device)
TOUCHPAD_ID=$(xinput list | grep -i touchpad | awk '{print $6}' | sed 's/id=//')

# Check if touchpad ID is found
if [ -z "$TOUCHPAD_ID" ]; then
  echo "Touchpad not found!"
  exit 1
fi

# Check for activity and toggle touchpad
while true; do
  # Check if any key is pressed
  if xinput --list-props "$TOUCHPAD_ID" | grep "Device Enabled (.*): 1" > /dev/null; then
    xinput disable "$TOUCHPAD_ID"
  else
    xinput enable "$TOUCHPAD_ID"
  fi
  sleep 1  # Adjust sleep time as needed
done
