#!/bin/bash

# Vänta 3 sekunder så XFCE hinner rita upp skrivbordet helt
sleep 3

# Hämta namnen på alla inkopplade skärmar (t.ex. DP-1, HDMI-1, Virtual-1)
MONITORS=$(xrandr | grep " connected" | awk '{print $1}')

# Tvinga in bakgrundsbilden på varje skärm som hittades!
for MON in $MONITORS; do
    xfconf-query -c xfce4-desktop -p "/backdrop/screen0/monitor${MON}/workspace0/last-image" -n -t string -s "/usr/share/backgrounds/alinaarch.png"
    xfconf-query -c xfce4-desktop -p "/backdrop/screen0/monitor${MON}/workspace0/image-style" -n -t int -s 5
done
