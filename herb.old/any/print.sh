#!/bin/bash

sleep 0.2

mkdir -p "$HOME/pics"

d=$(date '+%Y%m%d-%H%M')
w=$(herbstclient attr clients.focus.title \
        | tr 'A-Z' 'a-z' \
        | tr ' ' '-' \
        | tr '_' '-' \
        | tr -dc 'a-z0-9\-'
)
n=0
f=$(while true; do
        if ! [[ -r "$HOME/pics/$d-$w.$n.png" ]]; then
                echo "$d-$w.$n.png"
                break
        fi
        n=$((n+1))
done)

scrot -s "$f" || exit 1
t=$(file -b --mime-type "$f") || exit 1

xclip -selection clipboard -t "$t" < "$f"
mv "$f" "$HOME/pics/"

