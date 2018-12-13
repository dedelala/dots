#!/bin/bash

die() { echo "yeah nah: $*" >&2; exit 1; }

cd "$(dirname "$0")" || die "root"

c="$HOME/.config"
mkdir -pv "$c/fontconfig"   || die "fc dir"
mkdir -pv "$c/kak/colors"   || die "kak dir"
mkdir -pv "$c/herbstluftwm" || die "herb dir"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

{
        # fc
        cp --preserve=mode -v fc/fonts.conf "$c/fontconfig" || die "fonts.conf"

        # herb
        cp --preserve=mode -v herb/* "$c/herbstluftwm" || die "herb"

        # kak
        kak/dedelala.kak.sh > "$t/dedelala.kak"                 || die "dedelala.kak.sh"
        cp --preserve=mode -v "$t/dedelala.kak" "$c/kak/colors" || die "dedelala.kak"
        cp --preserve=mode -v kak/kakrc "$c/kak"                || die "kakrc"

        # profile
        cp --preserve=mode -v profile "$HOME/.profile"

        # x
        for x in x/*; do
                cp --preserve=mode -v "$x" "$HOME/.$(basename "$x")" || die "$x"
        done

        # zsh
        cat zsh/init.zsh zsh/cdp.zsh zsh/rc.zsh > "$t/.zshrc" || die "cat zshrc"
        cp --preserve=mode -v "$t/.zshrc" "$HOME"             || die "zshrc"

} | column -t
