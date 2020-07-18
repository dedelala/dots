#!/bin/bash

l="$HOME/.config/herbstluftwm/run.list"
awk '/./{print $1}' "$l" | rofi -dmenu -p mlem | while read -r v; do
        x=$(awk "/^$v /{print \$2}" "$l")
        x=$(eval echo "$x")
        if ! [[ -x $x ]]; then
                exit 1
        fi
        n=$(( $(herbstclient attr tags.count) - 1 ))
        herbstclient or \
                ,, and \
                        , use "$v" , spawn st "$x" \
                ,, and \
                        , add "$v" , keybind "Mod4-$n" use "$v" \
                        , use "$v" , spawn st "$x"
done

