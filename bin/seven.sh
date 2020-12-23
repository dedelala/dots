#!/bin/bash

die() { echo "oh noes! $*" >&2; exit 1; }

cd "$(git rev-parse --show-toplevel)" || die "root"

dir=seven

find "$dir" -type d -printf "%P\0" \
| xargs -0 -I "{}" -- mkdir -pv "$HOME/{}" \
|| die "dirs"

find "$dir" -type f -printf "%P\0" \
| xargs -0 -I "{}" -- cp --preserve=mode -v "$dir/{}" "$HOME/{}" \
|| die "files"

fc-cache                        || die "fc-cache"
herbstclient reload             || die "hc reload"
xrdb -merge "$HOME/.Xresources" || die "xrdb"
xmodmap "$HOME/.Xmodmap"        || die "xmodmap"
