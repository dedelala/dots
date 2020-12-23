#!/bin/bash
# +hc $Mod-Shift-space

# +run gimp       /bin/gimp
# +run factorio   "$HOME/play/factorio/start.sh"
# +run ksp        "$HOME/play/ksp/KSP.x86_64"
# +run minecraft  "$HOME/play/minecraft-launcher/minecraft-launcher"
# +run starbound  "$HOME/play/starbound/start.sh"
# +run stardew    "$HOME/play/stardew/start.sh"

awk '/^# \+run /{print $3}' "$0" | rofi -dmenu -p "choose fighter" | while read -r v; do
        x=$(awk "/^# \+run $v /{print \$4}" "$0" | envsubst)
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

