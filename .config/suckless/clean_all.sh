#!/bin/sh

# VARS
CURRPATH="$(pwd)"
GREEN_BG='\033[41m'
RESET='\033[0m'

# DWM
cd "$CURRPATH/dwm"
sudo make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED DWM${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/st"
sudo make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED ST${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/slstatus"
sudo make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED SLSTATUS${RESET}\n"
echo ""
echo ""
cd ..

cd "$CURRPATH/dmenu"
sudo make clean
echo ""
echo ""
printf "${GREEN_BG}CLEANED DMENU${RESET}\n"
echo ""
echo ""

cd "$CURRPATH"
