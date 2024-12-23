#!/usr/bin/env bash

function get_current_language {
    case $(xset q | grep 'LED mask' | awk '{print $10}') in
        "00000002" ) echo 'EN';;
        "00001002" ) echo 'AR';;
        *) echo 'unknown';;
    esac
}

i3status | while IFS= read -r line; do
    current_language=$(get_current_language)
    echo "${line//KB_LAYOUT/$current_language}"
done
