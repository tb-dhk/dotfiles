#!/bin/bash

while true; do
    for filename in ~/.config/hypr/wallpapers/*; do
        echo $filename
        swaybg -i "$filename" -m stretch &
        sleep 1 # optional delay between changes
    done
done
