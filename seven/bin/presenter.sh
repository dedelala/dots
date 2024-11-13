#!/bin/bash

xrandr --output eDP1 --mode 1920x1080
xrandr --output DP1 --mode 1920x1080
xrandr --output DP2 --mode 1920x1080
herbstclient reload
xmodmap $HOME/.Xmodmap
