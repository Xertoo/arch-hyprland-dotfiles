#!/bin/bash

STATE=$(cat /tmp/gamemode.state 2>/dev/null || echo "off")

if [[ "$STATE" == "on" ]]; then
  echo "on"
else
  echo "off"
fi