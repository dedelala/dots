#!/bin/bash

hc() {
        herbstclient "$@"
}

a="operation catgirl"
b="sideways space minecraft"
c="the fucker"

read -r x < <(printf "$a\n$b\n$c" | rofi -dmenu)

case $x in
$a)
        hc chain , add play , use play
        cd "$HOME/play/mc" && ./minecraft_launcher.sh
        ;;
$b)
        ;;
$c)
        ;;
esac

