# Check if we are on tty1
# Set up environment variables for i3
# alias sx='startx && unalias sx'
if [[ "$(tty)" == "/dev/tty1" ]] then
    export XDG_CURRENT_DESKTOP=i3
    export PATH="$PATH:/home/abtuly/.dotnet/tools"
    startx
    # setxkbmap -layout "us,ara" -option 'grp:win_space_toggle'
    # xset r rate 300 35
fi
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

# Added by `rbenv init` on Mon Oct  6 03:10:58 PM +03 2025
eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"
