#!/bin/bash

die() { echo "yeah nah: $*" >&2; exit 1; }

cd "$(dirname "$0")" || die "root"

c="$HOME/.config"
mkdir -pv "$c/kak/colors"   || die "kak dir"
mkdir -pv "$c/kitty"        || die "kitty dir"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

{
        # kak
        kak/dedelala.kak.sh > "$t/dedelala.kak"                 || die "dedelala.kak.sh"
        install -vm 0644 "$t/dedelala.kak" "$c/kak/colors" || die "dedelala.kak"
        install -vm 0644 kak/kakrc "$c/kak"                || die "kakrc"

        # kitty
        install -vm 0644 kitty/* "$c/kitty" || die "kitty"

        # profile
        install -vm 0644 profile "$HOME/.profile"

        # zsh
        cat zsh/init.zsh zsh/cdp.zsh zsh/rc.zsh > "$t/.zshrc" || die "cat zshrc"
        install -vm 0644 "$t/.zshrc" "$HOME"             || die "zshrc"

} | column -t
