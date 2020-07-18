#!/bin/bash

set_card() {
        read -r i _
        [[ -n $i ]] || return 1
        cat <<! >"$HOME/.asoundrc"
pcm.!default {
        type hw
        card $i
}

ctl.!default {
        type hw
        card $i
}
!
}

case $1 in
"set")
        ctl=$(cat "$HOME/.sound-ctl")
        [[ -n $ctl ]] || exit 1
        shift
        amixer -q sset "$ctl" "$*"
        ;;
"card")
        awk -F' ?[][]:? ?' '/^ [0-9]/{print $1 " : " $3}' < /proc/asound/cards \
        | rofi -p "select card" -dmenu | set_card || exit 1

        amixer scontrols | awk -F"'" '{print $2}' \
        | rofi -p "select ctl" -dmenu > "$HOME/.sound-ctl"
        ;;
"status")
        card=$(awk '/card [0-9]/{print $2; exit}' < "$HOME/.asoundrc")
        [[ -n $card ]] || exit 1

        ctl=$(cat "$HOME/.sound-ctl")
        [[ -n $ctl ]] || exit 1

        echo \
        $(awk -F' ?[][]:? ?' '/^ '"$card"' /{print $2}' < /proc/asound/cards) \
        $(amixer sget "$ctl" | awk -F'[][]' '/Playback[ 0-9\[]+%/{print $6, $4; exit}')
        ;;
*)
        exit 2
        ;;
esac

