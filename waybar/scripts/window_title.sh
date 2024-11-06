#!/bin/bash

# Get the current focused window details
window_info=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | {name: .name, app_id: .app_id, window: .window_properties.class}')

# Extract app_id and window name
app_id=$(echo "$window_info" | jq -r '.app_id')
window_name=$(echo "$window_info" | jq -r '.name')

# Check if app_id is null or "none" and use app_id as fallback'
if [ "$app_id" == "null" ] || [ "$app_id" == "none" ]; then
    app_id=$(echo "$window_info" | jq -r '.window')
fi

# Check if app_id is null or "none" and use app_id as fallback'
if [ "$app_id" == "null" ] || [ "$app_id" == "none" ]; then
    # get the workspace number instead
    formatted_title="󱤎󱤧󱤬󱤂"
else
    # Format the output
    formatted_title="󱤎 <b>$app_id</b> - $window_name"

    # Convert to lowercase
    formatted_title=$(echo "$formatted_title" | tr '[:upper:]' '[:lower:]')

    # Check length and truncate if necessary
    if [ ${#formatted_title} -gt 69 ]; then
        formatted_title="${formatted_title:0:63}..."
    fi
fi

# Print the final output
echo "$formatted_title"
