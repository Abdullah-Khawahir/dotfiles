# Check if we are on tty1
# Set up environment variables for i3
export XDG_CURRENT_DESKTOP=i3

export PATH="$PATH:/home/abtuly/.dotnet/tools"

setxkbmap -layout "us,ara" -option 'grp:win_space_toggle'
startx
xset r rate 300 35

# echo "Do you want to start i3? (y/N)"
# read option


# if [[ "$(tty)" == "/dev/tty1" ]] then
#   if [[ "$option" == "y" || -z "$option" ]]; then
#   fi
#
#   if [[ "$option" == "n"  ]]; then
#     # Set up environment variables for Sway
#     export QT_QPA_PLATFORM=wayland
#     export XDG_CURRENT_DESKTOP=sway
#     export XDG_SESSION_DESKTOP=sway
#     # Start Sway
#     echo "running sway"
#     sway
#   fi
# fi
