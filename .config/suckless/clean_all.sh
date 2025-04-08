#!/bin/sh

# VARS
CURRPATH="$(pwd)"
GREEN_BG='\033[41m'
RESET='\033[0m'

# DWM
cd "$CURRPATH/dwm"
doas make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED DWM${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/st"
doas make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED ST${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/slstatus"
doas make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED SLSTATUS${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/dmenu"
doas make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED DMENU${RESET}\n"
echo ""
echo ""

cd "$CURRPATH"
