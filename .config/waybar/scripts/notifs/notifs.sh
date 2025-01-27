#!/bin/bash

# Define the log file
LOG_FILE="$HOME/notifications.log"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    touch "" > "$LOG_FILE"
fi

# Extract the last notification's appname
last_appname=$(grep -oP "appname: '.*?'" "$LOG_FILE" | tail -n 1 | sed -E "s/.*appname: '(.*?)'.*/\1/" | tr '[:upper:]' '[:lower:]')

# Extract the last notification's summary
last_summary=$(grep -oP "summary: '.*?'" "$LOG_FILE" | tail -n 1 | sed -E "s/.*summary: '(.*?)'.*/\1/" | tr '[:upper:]' '[:lower:]')

# Extract the last notification's body
last_body=$(grep -oP "body: '.*?'" "$LOG_FILE" | tail -n 1 | sed -E "s/.*body: '(.*?)'.*/\1/" | tr '[:upper:]' '[:lower:]')

# Extract the last notification's urgency
last_urgency=$(grep -oP "urgency: .*" "$LOG_FILE" | tail -n 1 | sed -E "s/.*urgency: (.*?).*/\1/" | tr '[:upper:]' '[:lower:]')

# Check if we found a notification
if [ -z "$last_appname" ] && [ -z "$last_summary" ] && [ -z "$last_body" ]; then
    formatted_text="󱤌󱥝󱤧󱤬󱤂 "
else
  # Create the formatted text based on notification type
  if [ "$last_appname" == "notify-send" ]; then
      formatted_text="$last_summary: $last_body"
  else 
      formatted_text="$last_appname: $last_summary"
      if [ -n "$last_body" ]; then
          formatted_text+=" ($last_body)"
      fi
  fi

  # if above 50 characters, truncate to 47 and add "..."
  formatted_text=$(echo "$formatted_text" | cut -c1-47)

  if [ -z "$last_urgency" ]; then
      last_urgency="normal"
  fi

  formatted_text=" <span foreground=\\\"#cdd6f4\\\">󱤌‍󱥝</span> $formatted_text "
fi

# Output JSON format
json_output="{\"text\": \"$formatted_text\", \"class\": \"$last_urgency\"}"

# Print the JSON output
echo "$json_output"
