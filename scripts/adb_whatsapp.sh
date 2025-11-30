#!/usr/bin/env bash

NUM=$(xclip -o -r -selection clipboard | sed 's/ //g' | sed 's/^0/966/' | xargs -0)

MSG=$(cat ~/.WhatsAppMSG)

ENCODED=$(echo "$MSG" | jq -R -s -r @uri)

CMD="adb shell am start -a android.intent.action.VIEW -d \"https://wa.me/$NUM?text=$ENCODED\""

echo "$CMD"
eval "$CMD"
