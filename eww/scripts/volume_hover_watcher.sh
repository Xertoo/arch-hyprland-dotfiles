#!/bin/bash

# Poczekaj, aż myszka wejdzie do okna
while [[ "$(eww get volume_hover)" != "true" ]]; do
    sleep 0.1
done

# Monitoruj, czy myszka opuściła okno
while true; do
    sleep 0.2
    hover=$(eww get volume_hover)
    if [[ "$hover" == "false" ]]; then
        eww close volpopup
        exit
    fi
done
