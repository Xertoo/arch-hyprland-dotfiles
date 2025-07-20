#!/bin/bash

MEM_INFO=$(free -m | awk 'NR==2{printf "%.1f", $3/1024}')
echo "{\"text\": \"${MEM_INFO}GB\", \"tooltip\": \"Memory Used: ${MEM_INFO}GB\"}"
