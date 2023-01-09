#!/bin/bash

# Set the path to the video file
video_file="/home/virgil/Videos/magic.mp4"

# Set the correct shortcut
correct_shortcut="coucou"

# Continuously monitor for touch events
while true; do
    read -s -p "Enter shortcut to cancel video: " shortcut
    
    # Check shortcut
    if [ "$shortcut" != "$correct_shortcut" ]; then
        # Incorrect shortcut, play video
        mpv $video_file
    else
        # Correct shortcut, exit
        exit 0
    fi
done
