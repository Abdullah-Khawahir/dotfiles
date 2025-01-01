#!/usr/bin/env bash

function get_current_language {
    local caps=''
    local lang=''
    local num=''

    case $(xset q | grep 'LED mask' | awk '{print $10}' | awk -F '' '{ print $5 }') in
        "1" ) lang='AR';;
        "0" ) lang='EN';;
        *) lang='unknown';;
    esac

    case $(xset q | grep 'Caps Lock' | awk '{print $4}') in
        'on' ) caps='CAP|';;
        'off' ) caps='';;
        *) caps='c?';;
    esac

    case $(xset q | grep 'Num Lock' | awk '{print $8}') in
        'on' ) num='num|';;
        'off' ) num='';;
        *) num='n?';;
    esac

    echo "$caps$num$lang"
}

i3status | while :
do
    read line
    current_language=$(get_current_language)
    echo "${line//KB_LAYOUT/$current_language}"
done
# i3status | while IFS= read -r line; do
#     current_language=$(get_current_language)
#     echo "${line//KB_LAYOUT/$current_language}"
# done
