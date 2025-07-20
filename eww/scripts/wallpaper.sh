#!/bin/bash

CONFIG_DIR="$HOME/.config/eww"
LOG_FILE="$CONFIG_DIR/logs/wallpaper.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

echo "--- Script Start: $(date) ---" >> "$LOG_FILE"

# Check for jq
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it to use this script." >> "$LOG_FILE"
    exit 1
fi

if [ -z "$1" ]; then
  echo "Error: No wallpaper path provided." >> "$LOG_FILE"
  exit 1
fi

WALLPAPER="$1"
# Get the name of the currently focused monitor
MONITOR=$(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | .name')

echo "Selected wallpaper: $WALLPAPER" >> "$LOG_FILE"
echo "Detected focused monitor: $MONITOR" >> "$LOG_FILE"

if [ -z "$MONITOR" ]; then
    echo "Error: Could not determine focused monitor name." >> "$LOG_FILE"
    # Fallback to the first monitor if none is focused
    MONITOR=$(hyprctl -j monitors | jq -r '.[0].name')
    echo "Fallback: Using first detected monitor: $MONITOR" >> "$LOG_FILE"
fi

# IPC commands to hyprpaper
hyprctl hyprpaper unload all >> "$LOG_FILE" 2>&1
hyprctl hyprpaper preload "$WALLPAPER" >> "$LOG_FILE" 2>&1
hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER" >> "$LOG_FILE" 2>&1

echo "hyprpaper commands executed for monitor $MONITOR." >> "$LOG_FILE"
echo "--- Script End ---" >> "$LOG_FILE"
