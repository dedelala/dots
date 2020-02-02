#!/bin/bash

declare -A ctls=( [PCH]='Master' [earbuds]='Headset' )

if [[ -r "$HOME/.asoundrc" ]]; then
        s=$(awk '/card/{print $2; exit}' < "$HOME/.asoundrc")
fi
if [[ $s == "" ]]; then
        s=0
fi
if ! [[ -r "/proc/asound/card$s/id" ]]; then
        echo "oh noes, no noes" >&2
        exit 1
fi
sid=$(cat "/proc/asound/card$s/id")
sctl=${ctls[$sid]}
if [[ -z $sctl ]]; then
        echo "oh noes, no sctl" >&2
        exit 1
fi

case $1 in
+)
        amixer -q -c "$s" sset "$sctl" Playback 3dB+
        ;;
-)
        amixer -q -c "$s" sset "$sctl" Playback 3db-
        ;;
m)
        amixer -q -c "$s" sset "$sctl" Playback toggle-mute
        ;;
v)
        v=$(amixer -c "$s" sget "$sctl" \
        | awk -F'[][]' '/Playback[ 0-9\[]+%/{print $6, $4; exit}')
        echo "$sid $v"
        ;;
o)
        n=$(( s + 1 ))
        if ! [[ -r "/proc/asound/card$n/id" ]]; then
                n=0
        fi
        if [[ $n -eq $s ]]; then
                return 0
        fi
        nid=$(cat "/proc/asound/card$n/id")
        nctl=${ctls[$nid]}
        if [[ -z $nctl ]]; then
                echo "oh noes, no nctl" >&2
                return 1
        fi
        amixer -q -c "$s" sset "$sctl" mute
        amixer -q -c "$n" sset "$nctl" mute
        cat <<! >"$HOME/.asoundrc"
pcm.!default {
        type hw
        card $n
}

ctl.!default {
        type hw
        card $n
}
!
        amixer -q -c "$n" sset "$nctl" 50% unmute
        ;;
*)
        exit 2
        ;;
esac

