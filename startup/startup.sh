# Get the terminal width
TERM_WIDTH=$(tput cols)

# Subtract 2 from the terminal width
ADJUSTED_WIDTH=$((TERM_WIDTH - 2))

# Run the Python script with the adjusted terminal width as an argument
python3 $HOME/.config/startup/startup.py $ADJUSTED_WIDTH | $HOME/.config/startup/colorize.sh
