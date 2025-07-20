#!/bin/bash

# Dependencies: curl, jq, bc

# Sparkline characters from low to high
SPARK_CHARS=(" " "▂" "▃" "▄" "▅" "▆" "▇" "█")

# CoinGecko IDs
COINS=(
    "fantom"
    "bitcoin"
    "ethereum"
    "solana"
    "binancecoin"
)

generate_sparkline() {
    local prices=($1)
    local min_price=$(printf "%s\n" "${prices[@]}" | sort -n | head -n1)
    local max_price=$(printf "%s\n" "${prices[@]}" | sort -n | tail -n1)
    local range=$(echo "$max_price - $min_price" | bc)
    
    local sparkline=""
    if (( $(echo "$range == 0" | bc -l) )); then
        for _ in "${prices[@]}"; do
            sparkline+="${SPARK_CHARS[0]}"
        done
        echo "$sparkline"
        return
    fi

    for price in "${prices[@]}"; do
        local normalized=$(echo "($price - $min_price) / $range" | bc -l)
        local index=$(echo "($normalized * 7) + 0.5" | bc -l | cut -d. -f1)
        sparkline+="${SPARK_CHARS[$index]}"
    done
    echo "$sparkline"
}

json_output="["
first_coin=true

for coin_id in "${COINS[@]}"; do
    # Fetch historical data for the last 30 days
    chart_data=$(curl -s "https://api.coingecko.com/api/v3/coins/${coin_id}/market_chart?vs_currency=usd&days=30&interval=daily")
    prices=($(echo "$chart_data" | jq -r '.prices[][1]'))
    
    # Fetch current data
    current_data=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=${coin_id}&vs_currencies=usd&include_24hr_change=true")
    
    if [ -z "$prices" ] || [ -z "$current_data" ]; then
        continue
    fi

    # Generate sparkline
    sparkline=$(generate_sparkline "${prices[*]}")

    # Extract details
    symbol=$(echo "$coin_id" | awk '{print toupper(substr($0,1,3))}')
    price=$(echo "$current_data" | jq -r ".\"${coin_id}\".usd")
    change=$(echo "$current_data" | jq -r ".\"${coin_id}\".usd_24h_change")
    
    # Format price
    formatted_price=$(printf "$%.2f" "$price")
    
    # Format change
    formatted_change=$(printf "%.2f" "$change")
    if (( $(echo "$change > 0" | bc -l) )); then
        change_class="positive"
        formatted_change="+${formatted_change}%"
    else
        change_class="negative"
        formatted_change="${formatted_change}%"
    fi

    if ! $first_coin; then
        json_output+=","
    fi

    json_output+=$(jq -n \
        --arg symbol "$symbol" \
        --arg price "$formatted_price" \
        --arg change "$formatted_change" \
        --arg change_class "$change_class" \
        --arg sparkline "$sparkline" \
        '{symbol: $symbol, price: $price, change: $change, change_class: $change_class, chart: $sparkline}')
    
    first_coin=false
done

json_output+="]"
echo "$json_output"
