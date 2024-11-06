grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | "\(.x),\(.y) \(.width)x\(.height)"')" "/home/$USER/Pictures/$(date +'%Y-%m-%d_%H-%M-%S').png"
