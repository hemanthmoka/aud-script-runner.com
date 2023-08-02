#!/bin/bash

LOG_FILE="logfile.log"

# Clear log file
> "$LOG_FILE"

# Function to display log in Zenity window
display_log() {
  tail -f "$LOG_FILE" | zenity --text-info --title="Log" --width=400 --height=300
}

# Call the function in the background
display_log &

/Users/hemanth/Documents/Hemanth/Scripts/test/countdown >> "$LOG_FILE"
# Loop and append log messages to the file
#for i in {1..10}; do
#  echo "Log message $i" >> "$LOG_FILE"
#  sleep 1
#done

# Kill the background process after the loop completes
kill $!
