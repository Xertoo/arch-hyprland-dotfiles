#!/bin/bash

STATE_FILE="/tmp/waybar_weather_state"

if [ ! -f "$STATE_FILE" ]; then
  echo "krakow" > "$STATE_FILE"
  exit
fi

CURRENT=$(cat "$STATE_FILE")

if [ "$CURRENT" = "krakow" ]; then
  echo "trabki" > "$STATE_FILE"
else
  echo "krakow" > "$STATE_FILE"
fi
