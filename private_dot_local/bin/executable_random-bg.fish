#!/usr/bin/env fish

set wallpaper_dir "$HOME/Personal/wallpapers"

while true
    set img (fd -t f . "$wallpaper_dir" | shuf -n 1)
    if test -f "$img"
        swaymsg output "*" bg "$img" fill
    end
    sleep 20m
end
