#!/bin/bash

weathertext="$HOME/.config/hypr/scripts/weather/weathertext"

LAT="54.1593"
LON="18.5718"
URL="https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$LAT&lon=$LON"
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) eww-weather-script/1.0"

while true; do
    data=$(curl -s -H "User-Agent: $USER_AGENT" "$URL")
    
    if [ -n "$data" ]; then
        temp=$(echo "$data" | jq '.properties.timeseries[0].data.instant.details.air_temperature')
        symbol=$(echo "$data" | jq -r '.properties.timeseries[0].data.next_1_hours.summary.symbol_code')
        
        # Opcjonalnie skróć/ikonka
        short_symbol=$(echo "$symbol" | sed 's/_.*//')

        output="Trąbki: ${temp}°C, ${short_symbol}"
        
        echo "$output" | cut -c1-30 > "$weathertext"
    fi

    sleep 600 # co 10 minut
done
