#!/bin/bash

die() { echo "failed: $*" >&2; exit 1; }

cd "$(dirname "$0")" || die "dots root"

cat zsh/init.zsh zsh/cdp.zsh zsh/rc.zsh > "$HOME/.zshrc" || die "zsh"

mkdir -pv "$HOME/.config/kak/colors" || die "kak dirs"
kak/dedelala.kak.sh > "$HOME/.config/kak/colors/dedelala.kak" || die "kak colors"
cp -v kak/kakrc "$HOME/.config/kak" || die "kakrc"

for x in x/*; do
        cp -v "$x" "$HOME/.$(basename "$x")"
done
