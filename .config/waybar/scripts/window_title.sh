#!/bin/bash

# Get the active workspace info
workspace_info=$(hyprctl activewindow -j)

# Extract the last window ID and title
window_id=$(echo "$workspace_info" | jq -r '.title')
window_name=$(echo "$workspace_info" | jq -r '.initialTitle')

# Check if window_id is null or "none" and use workspace id as fallback
if [ "$window_id" == "null" ] || [ "$window_id" == "none" ]; then
    window_id=$(echo "$workspace_info" | jq -r '.id')
fi

# Format the output
if [ "$window_id" == "null" ] || [ "$window_id" == "none" ]; then
    # If no window is found, display the workspace ID
    formatted_title="󱤎󱤧󱤬󱤂"
else
    # If a window is found, format the output as <window_id> - <window_name>
    formatted_title="󱤎 <b>$window_id</b> - $window_name"

    # Convert to lowercase
    formatted_title=$(echo "$formatted_title" | tr '[:upper:]' '[:lower:]')

    # Check length and truncate if necessary
    if [ ${#formatted_title} -gt 69 ]; then
        formatted_title="${formatted_title:0:63}..."
    fi
fi

# Print the final output
echo "$formatted_title"
