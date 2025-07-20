#!/bin/bash

STATE_FILE="/tmp/gamemode.state"
STATE="off"

if [ -f "$STATE_FILE" ]; then
  STATE=$(cat "$STATE_FILE")
fi

if [ "$STATE" = "off" ]; then
  # Włącz Game Mode
  hyprctl --batch "
    keyword general:border_size 1;
    keyword decoration:rounding 0;
    keyword decoration:drop_shadow no;
    keyword general:gaps_in 0;
    keyword general:gaps_out 0;
    keyword decoration:blur:enabled false;
    keyword animations:enabled false;
    keyword decoration:active_opacity 1.0;
    keyword decoration:inactive_opacity 1.0;
    keyword decoration:fullscreen_opacity 1.0
  "
  echo "on" > "$STATE_FILE"
else
  # Wyłącz Game Mode
  hyprctl --batch "
    keyword general:border_size 3;
    keyword decoration:rounding 10;
    keyword decoration:drop_shadow yes;
    keyword general:gaps_in 5;
    keyword general:gaps_out 10;
    keyword decoration:blur:enabled true;
    keyword animations:enabled true;
    keyword decoration:active_opacity 0.9;
    keyword decoration:inactive_opacity 0.8;
    keyword decoration:fullscreen_opacity 1.0
  "
  echo "off" > "$STATE_FILE"
fi
