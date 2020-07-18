#!/bin/bash

step=500
min=100

b=$(cat /sys/class/backlight/intel_backlight/brightness)

case $1 in
+)
        m=$(cat /sys/class/backlight/intel_backlight/max_brightness)
        x=$(( b + step ))
        if [[ $x -gt $m ]]; then
                x=$m
        fi
;;
-)
        x=$(( b - step ))
        if [[ $x -lt min ]]; then
                x=$min
        fi
;;
*)
        exit 2
esac

xrandr --output eDP1 --set BACKLIGHT "$x"
