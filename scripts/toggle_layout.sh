#!/bin/bash

# Get the current keyboard layout
current_layout=$(setxkbmap -query | grep layout | awk '{print $2}')

# Toggle between Arabic and English
if [ "$current_layout" == "us" ]; then
    setxkbmap -layout ar
else
    setxkbmap -layout us
fi
