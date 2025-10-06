#!/usr/bin/env bash

#select radom wallpaper
NEW_WP=$(ls /home/kyooto/Pictures/Wallpaper | shuf -n 1)

WALLPAPER="/home/kyooto/Pictures/Wallpaper/$NEW_WP"

HYPRPAPER_CONF="/home/kyooto/.config/hypr/hyprpaper.conf"

echo " "  > $HYPRPAPER_CONF

echo "preload = $WALLPAPER" >> $HYPRPAPER_CONF
echo "wallpaper = eDP-1,$WALLPAPER" >> $HYPRPAPER_CONF
echo "splash = false" >> $HYPRPAPER_CONF

killall hyprpaper
hyprpaper &
