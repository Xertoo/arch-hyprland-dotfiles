#!/bin/sh

# VARS
CURRPATH="$(pwd)"
GREEN_BG='\033[41m'
RESET='\033[0m'

# DWM
cd "$CURRPATH/dwm"
doas make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED DWM${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/st"
doas make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED ST${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/slstatus"
doas make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED SLSTATUS${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/dmenu"
doas make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED DMENU${RESET}\n"
echo ""
echo ""

cd "$CURRPATH"
