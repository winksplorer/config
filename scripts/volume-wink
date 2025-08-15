#!/bin/bash

IDFILE="/tmp/volume_notify_id"

if [ $# -eq 0 ]
then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
else
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
fi

VOL_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

if [ -f "$IDFILE" ]
then
    ID=$(cat "$IDFILE")
else
    ID=0
fi

NEW_ID=$(notify-send --print-id --replace-id="$ID" "$VOL_INFO")
echo "$NEW_ID" > "$IDFILE"

