#!/bin/bash

die() { echo "oh noes! $*" >&2; exit 1; }

cd "$(git rev-parse --show-toplevel)" || die "root"

dir=athena

gfind "$dir" -type d -printf "%P\0" \
| xargs -0 -I "{}" -- mkdir -pv "$HOME/{}" \
|| die "dirs"

gfind "$dir" -type f -printf "%P\0" \
| xargs -0 -I "{}" -- cp -pv "$dir/{}" "$HOME/{}" \
|| die "files"

