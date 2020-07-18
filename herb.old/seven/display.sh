#!/bin/bash

outs=$(xrandr | awk '/^\w.+ connected/{print $1}')

if [[ $(wc -l <<< "$outs") -eq 1 ]]; then
        rm -f "$HOME/.nodozzz"
        xrandr --auto
        exit
fi

rofi -p "select output" -dmenu <<< "$outs" | {
        read -r sel
        if [[ $sel == "eDP1" ]]; then
                rm -f "$HOME/.nodozzz"
        else
                touch "$HOME/.nodozzz"
        fi
        while read -r out; do
                if [[ "$out" == "$sel" ]]; then
                        xrandr --output "$out" --auto
                        continue
                fi
                xrandr --output "$out" --off
        done <<< "$outs"
}
