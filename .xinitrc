#!/bin/sh
unset XCURSOR_THEME
xsetroot -solid "#131212"

xrandr --newmode "1440x1080_120.00"  277.68  1440 1560 1720 2000  1080 1081 1084 1157  -HSync +Vsync
xrandr --addmode HDMI1 "1440x1080_120.00"
xrandr --output eDP1 --mode 1600x900 --pos 1920x493 --rotate normal --output HDMI1 --mode "1440x1080_120.00" --primary --rate 120 --pos 0x0 --rotate normal

polybar &

exec sxwm
