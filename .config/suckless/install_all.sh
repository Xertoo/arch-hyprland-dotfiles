#!/bin/sh

# VARS
CURRPATH="$(pwd)"
GREEN_BG='\033[41m'
RESET='\033[0m'

# DWM
cd "$CURRPATH/dwm"
sudo make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED DWM${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/st"
sudo make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED ST${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/slstatus"
sudo make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED SLSTATUS${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/dmenu"
sudo make clean install
echo ""
echo ""
printf "${GREEN_BG}INSTALLED DMENU${RESET}\n"
echo ""
echo ""

cd "$CURRPATH"
