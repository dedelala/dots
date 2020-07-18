#!/bin/bash

die() { echo "oh noes! $*" >&2; exit 1; }

cd "$(git rev-parse --show-toplevel)" || die "root"

c="$HOME/.config"
mkdir -pv "$c/fontconfig" "$c/kak/colors" "$c/herbstluftwm" "$c/kitty" || die "mkdirs"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

{
        # fc
        cp --preserve=mode -v fc/fonts.conf "$c/fontconfig" || die "fonts.conf"

        # herb
        cp --preserve=mode -v herb/"$HOSTNAME"/* "$c/herbstluftwm" || die "herb"

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
        cp --preserve=mode -v "zsh/rc.zsh" "$HOME/.zshrc" || die "zshrc"

} | column -t

fc-cache
herbstclient reload
xrdb -merge "$HOME/.Xresources"
xmodmap "$HOME/.Xmodmap"
