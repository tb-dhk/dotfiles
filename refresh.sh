#!/bin/bash

# Define the path to the config directory
config_dir="$HOME/.config"

# Function to replace files and directories recursively
replace_files_and_directories() {
    local current_dir="$1"
    
    # Iterate over all items in the current directory
    for item in "$current_dir"/*; do
        # Skip the script itself
        if [ "$item" != "$0" ]; then
            local basename=$(basename "$item")
            local config_item="$config_dir/$basename"
            
            # Check if the item is a file or directory
            if [ -d "$item" ]; then
                # If it's a directory, recurse into it
                if [ -d "$config_item" ]; then
                    echo "Replacing directory $item with $config_item"
                    rm -rf "$item"  # Remove the existing directory
                    cp -r "$config_item" "$item"  # Copy the new directory
                else
                    echo "No corresponding config directory found for $item"
                fi
            elif [ -f "$item" ]; then
                # If it's a file, replace it
                if [ -f "$config_item" ]; then
                    echo "Replacing file $item with $config_item"
                    cp "$config_item" "$item"
                else
                    echo "No corresponding config file found for $item"
                fi
            fi
        fi
    done
}

# Call the function with the current directory
replace_files_and_directories "$(pwd)"

