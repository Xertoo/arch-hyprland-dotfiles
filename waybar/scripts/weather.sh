#!/bin/bash

STATE_FILE="/tmp/waybar_weather_state"

# Default to krakow if no state saved
if [ ! -f "$STATE_FILE" ]; then
  echo "krakow" > "$STATE_FILE"
fi

CITY=$(cat "$STATE_FILE")

if [ "$CITY" = "krakow" ]; then
  LAT="50.06"
  LON="19.94"
  NAME="Kraków"
else
  LAT="50.18"
  LON="20.59"
  NAME="Trąbki"
fi

# Fetch weather data from YR.no API (compact forecast)
DATA=$(curl -s --max-time 5 -H "User-Agent: waybar-script" \
  "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$LAT&lon=$LON")

# Parse temperature (instantaneous air temperature in Celsius)
TEMP=$(echo "$DATA" | jq '.properties.timeseries[0].data.instant.details.air_temperature' 2>/dev/null)

if [[ -z "$TEMP" || "$TEMP" == "null" ]]; then
  echo "$NAME: N/A"
else
  echo "$NAME: ${TEMP}°C"
fi
