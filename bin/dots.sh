#!/bin/bash

die() { echo "oh noes! $*" >&2; exit 1; }

cd "$(git rev-parse --show-toplevel)" || die "root"

c="$HOME/.config"
mkdir -pv "$c/fontconfig"   || die "fc dir"
mkdir -pv "$c/kak/colors"   || die "kak dir"
mkdir -pv "$c/herbstluftwm" || die "herb dir"
mkdir -pv "$c/kitty"        || die "kitty dir"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

{
        # fc
        cp --preserve=mode -v fc/fonts.conf "$c/fontconfig" || die "fonts.conf"
        fc-cache || die "fc-cache"

        # herb
        cp --preserve=mode -v herb/any/* "$c/herbstluftwm"     || die "herb"
        cp --preserve=mode -v herb/"$HOSTNAME"/* "$c/herbstluftwm" || die "herb"

        # kak
        kak/dedelala.kak.sh > "$t/dedelala.kak"                 || die "dedelala.kak.sh"
        cp --preserve=mode -v "$t/dedelala.kak" "$c/kak/colors" || die "dedelala.kak"
        cp --preserve=mode -v kak/kakrc "$c/kak"                || die "kakrc"

        # kitty
        cp --preserve=mode -v kitty/* "$c/kitty" || die "kitty"

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

herbstclient reload
xrdb -merge "$HOME/.Xresources"
xmodmap "$HOME/.Xmodmap"
