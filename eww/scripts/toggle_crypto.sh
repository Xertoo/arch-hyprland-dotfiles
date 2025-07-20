#!/bin/bash

EWW_BIN="/usr/bin/eww"

if [[ -z $($EWW_BIN active-windows | grep 'crypto') ]]; then
    $EWW_BIN open crypto
else
    $EWW_BIN close crypto
fi
