setxkbmap -option caps:swapescape &
nitrogen --restore &
slstatus &

xset r rate 200 50
xset s off
xset -dpms
xset s noblank

exec dwm
