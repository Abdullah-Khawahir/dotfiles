#!/bin/bash
layout=$(swaymsg -t get_inputs | jq -r '.[] | select(.type == "keyboard") | .xkb_active_layout_name' | head -n 1)
echo $layout 
