#!/bin/bash

CONFIG_DIR="$HOME/.config/eww"
LOG_FILE="$CONFIG_DIR/logs/generate.log"
WALLPAPER_DIR="$HOME/wallpapers"
SCRIPT_PATH="$CONFIG_DIR/scripts/wallpaper.sh"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

echo "--- Script Start: $(date) ---" > "$LOG_FILE"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory $WALLPAPER_DIR not found." >> "$LOG_FILE"
    exit 1
fi

WIDGETS="(box :class \"wallpaper-grid\" :orientation \"h\" :wrap true :spacing 20 :space-evenly false"

for wallpaper in "$WALLPAPER_DIR"/*; do
  if [ -f "$wallpaper" ]; then
    echo "Found wallpaper: $wallpaper" >> "$LOG_FILE"
    # Eww needs an absolute path for url()
    WIDGETS+="(button :class \"wallpaper-button\" :onclick \"${SCRIPT_PATH} '${wallpaper}' && eww close wallpaper_picker\" "
    WIDGETS+="  (box :style \"background-image: url('${wallpaper}');\" :class \"wallpaper-image\"))"
  fi
done

WIDGETS+=")"

echo "Generated widgets successfully." >> "$LOG_FILE"
echo "--- Script End ---" >> "$LOG_FILE"

echo "$WIDGETS"
