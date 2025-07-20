#!/bin/bash

if eww windows | grep -q "power_menu_window"; then
    eww close power_menu_window
else
    eww open power_menu_window
fi
