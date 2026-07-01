#!/usr/bin/env bash

# change_wallpaper.sh
# Cycles through wallpapers in ~/.config/swww/wallpapers using swww.

WALLPAPER_DIR="$HOME/.config/swww/wallpapers"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Error: Wallpaper directory not found at $WALLPAPER_DIR"
    exit 1
fi

# Get a random wallpaper from the directory
RANDOM_WALL=$(find "$WALLPAPER_DIR" -type l -o -type f | shuf -n 1)

if [[ -z "$RANDOM_WALL" ]]; then
    echo "Error: No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Apply the wallpaper using swww
swww img "$RANDOM_WALL" --transition-type center --transition-step 100 --transition-fps 60
