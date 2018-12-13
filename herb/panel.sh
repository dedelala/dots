#!/bin/sh

herbstclient pad 0 50 || exit 1

hermes -l -s '  ' -p bar bar | lemonbar \
        -B '#00000000' \
        -f "Go Regular:size=12" \
        -f "Font Awesome 5 Free:style=Regular:size=16" \
        -f "Font Awesome 5 Free:style=Solid:size=16" \
        -f "Font Awesome 5 Brands:size=16"
