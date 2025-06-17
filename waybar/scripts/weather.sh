#!/bin/bash

STATE_FILE="/tmp/waybar_weather_state"

if [ ! -f "$STATE_FILE" ]; then
  echo "krakow" > "$STATE_FILE"
fi

CITY=$(cat "$STATE_FILE")

if [ "$CITY" = "krakow" ]; then
  OUTPUT=$(curl -s --max-time 5 'wttr.in/Krakow?format=%t+%W')
  echo "Kraków: $OUTPUT"
else
  OUTPUT=$(curl -s --max-time 5 'wttr.in/Trabki?format=%t+%W')
  echo "Trąbki: $OUTPUT"
fi
