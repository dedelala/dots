#!/bin/bash
# +hc XF86AudioMute mute
# +hc XF86AudioRaiseVolume ++
# +hc XF86AudioLowerVolume --

case $1 in
"++")
        exec "$0" set Playback 3dB+
        ;;

"--")
        exec "$0" set Playback 3dB-
        ;;

"mute")
        exec "$0" set Playback toggle-mute
        ;;

"set")
        if [[ -r "$HOME/.asoundrc" ]]; then
                ctl=$(awk '/^# +ctl .+/{print $3; exit}' < "$HOME/.asoundrc")
        else
                ctl=$(amixer scontrols | awk -F"'" '{print $2; exit}')
        fi
        [[ -n $ctl ]] || exit 1
        shift
        amixer -q sset "$ctl" "$*"
        ;;

"select")
        card=$(awk -F' ?[][]:? ?' '/^ [0-9]/{print $1 " : " $3}' < /proc/asound/cards \
        | rofi -p "select card" -dmenu | cut -d" " -f1) || exit 1
        [[ -n $card ]] || exit 1

        cat <<! >"$HOME/.asoundrc"
pcm.!default {
        type hw
        card $card
}

ctl.!default {
        type hw
        card $card
}
!

        ctl=$(amixer scontrols | awk -F"'" '{print $2}' | rofi -p "select ctl" -dmenu)
        [[ -n $ctl ]] || exit 1
        echo "# +ctl $ctl" >> "$HOME/.asoundrc"
        ;;

"status")
        if [[ -r "$HOME/.asoundrc" ]]; then
                card=$(awk '/card [0-9]/{print $2; exit}' < "$HOME/.asoundrc")
                ctl=$(awk '/^# +ctl .+/{print $3; exit}' < "$HOME/.asoundrc")
        else
                card=0
                ctl=$(amixer scontrols | awk -F"'" '{print $2; exit}')
        fi
        [[ -n $card ]] || exit 1
        [[ -n $ctl ]] || exit 1
        echo \
        $(awk -F' ?[][]:? ?' '/^ '"$card"' /{print $2}' < /proc/asound/cards) \
        $(amixer sget "$ctl" | awk -F'[][]' '/Playback[ 0-9\[]+%/{print $6, $4; exit}')
        ;;
*)
        exit 2
        ;;
esac

