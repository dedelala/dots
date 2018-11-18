#!/bin/bash

die() { echo "yeah nah: $*" >&2; exit 1; }

cd "$(dirname "$0")" || die "root"

f=$(mktemp) || die "tmp"
trap 'rm -rf "$f"' EXIT

{
        # kak
        mkdir -pv "$HOME/.config/kak/colors"                || die "kak dir"
        kak/dedelala.kak.sh > "$f"                          || die "dedelala.kak.sh"
        cp -v "$f" "$HOME/.config/kak/colors/dedelala.kak"  || die "dedelala.kak"
        cp -v kak/kakrc "$HOME/.config/kak"                 || die "kakrc"

        # x
        for x in x/*; do
                cp -v "$x" "$HOME/.$(basename "$x")" || die "$x"
        done

        # zsh
        cat zsh/init.zsh zsh/cdp.zsh zsh/rc.zsh > "$f" || die "zshrc"
        cp -v "$f" "$HOME/.zshrc"

} | column -t
