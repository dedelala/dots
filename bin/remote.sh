#!/bin/bash

die() { echo "oh noes! $*" >&2; exit 1; }

cd "$(git rev-parse --show-toplevel)" || die "root"

r=$1
[[ -n $r ]] || die "host?"
h="$(ssh "$r" echo '$HOME')"
c="$h/.config"

ssh "$r" mkdir -pv "$c/kak/colors" || die "dirs"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

# kak
kak/dedelala.kak.sh > "$t/dedelala.kak"     || die "dedelala.kak.sh"
scp -p "$t/dedelala.kak" "$r:$c/kak/colors" || die "dedelala.kak"
scp -p kak/kakrc "$r:$c/kak"                || die "kakrc"

# profile
scp -p profile "$r:$h/.profile"

# zsh
cat zsh/init.zsh zsh/cdp.zsh zsh/rc.zsh > "$t/.zshrc" || die "cat zshrc"
scp -p "$t/.zshrc" "$r:$h"             || die "zshrc"

