#!/bin/bash

# Set log file path
LOG_FILE="$HOME/notifications.log"

# Assign arguments to variables
APP_NAME="${1:-notify-send}"
SUMMARY="${2:-test}"
BODY="${3:-test}"
ICON="${4:-dialog-information}"
# make urgency lowercase
URGENCY=$(echo "${5:-normal}" | tr '[:upper:]' '[:lower:]')

echo $APP_NAME $SUMMARY $BODY $ICON $URGENCY

# Write to the log file in the specified format
echo "{" >> "$LOG_FILE"
echo "    appname: '$APP_NAME'," >> "$LOG_FILE"
echo "    summary: '$SUMMARY'," >> "$LOG_FILE"
echo "    body: '$BODY'," >> "$LOG_FILE"
echo "    icon: '$ICON'," >> "$LOG_FILE"
echo "    urgency: $URGENCY" >> "$LOG_FILE"
echo "}" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"  # Add a blank line between entries for readability

pkill -RTMIN+1 waybar
