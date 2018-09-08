#!/bin/bash

die() { echo "failed: $*" >&2; exit 1; }

cd "$(dirname "$0")" || die "dots root"

cat zsh/init.zsh zsh/fn-*.zsh zsh/rc.zsh > "$HOME/.zshrc"

mkdir -p "$HOME/.config/kak/colors" || die "kak dirs"
./dedelala.kak.sh > "$HOME/.config/kak/colors/dedelala.kak" || die "kak colors"
cp kakrc "$HOME/.config/kak" || die "kakrc"
