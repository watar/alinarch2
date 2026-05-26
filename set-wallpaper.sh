#!/bin/bash
# ==============================================================================
# Script:      set-wallpaper.sh
# Description: Automatically detects connected monitors and sets the Alina wallpaper.
# Author:      Ralf R. (ralf.rangedahl@alina.se)
# Version:     2.0.4
# Date:        2026-05-25
# ==============================================================================

source /usr/local/bin/alina-env.sh

# NOTE: This script usually runs silently in the background at startup via XFCE,
# but includes visual outputs in case it is executed manually from a terminal.
alina_header "WALLPAPER SETUP"

echo -e "${YELLOW}Waiting for XFCE desktop to initialize (3 seconds)...${NC}"
# Wait 3 seconds so XFCE has time to fully draw the desktop before applying
sleep 3

# Get the names of all connected screens (e.g., DP-1, HDMI-1, Virtual-1)
MONITORS=$(xrandr | grep " connected" | awk '{print $1}')

if [[ -z "$MONITORS" ]]; then
    echo -e "${RED}No connected monitors detected!${NC}"
    exit 1
fi

echo -e "\n${WHITE}Detected monitors:${NC}"
echo "$MONITORS" | while read -r mon; do echo -e "  - ${CYAN}$mon${NC}"; done

echo -e "\n${YELLOW}Applying Alina wallpaper to all screens...${NC}"

# Force the background image on every monitor found!
for MON in $MONITORS; do
    xfconf-query -c xfce4-desktop -p "/backdrop/screen0/monitor${MON}/workspace0/last-image" -n -t string -s "/usr/share/backgrounds/alinaarch.png"
    xfconf-query -c xfce4-desktop -p "/backdrop/screen0/monitor${MON}/workspace0/image-style" -n -t int -s 5
done

echo -e "${GREEN}Wallpaper applied successfully!${NC}"
# Pause briefly so the user sees the success message if run manually from a terminal
sleep 1
# EOF