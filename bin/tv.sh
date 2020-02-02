#!/bin/bash

die() { echo "oh noes! $*" >&2; exit 1; }

cd "$(git rev-parse --show-toplevel)" || die "root"

r="kara.lala"
h="/home/x"
c="$h/.config"

ssh "$r" mkdir -pv "$c/fontconfig" "$c/kak/colors" "$c/herbstluftwm" || die "dirs"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

# fc
scp -p fc/fonts.conf "$r:$c/fontconfig" || die "fonts.conf"
ssh "$r" fc-cache || die "fc-cache"

# herb
scp -p herb/any/* "$r:$c/herbstluftwm" || die "herb"
scp -p herb/kara/* "$r:$c/herbstluftwm" || die "herb"

# kak
kak/dedelala.kak.sh > "$t/dedelala.kak"     || die "dedelala.kak.sh"
scp -p "$t/dedelala.kak" "$r:$c/kak/colors" || die "dedelala.kak"
scp -p kak/kakrc "$r:$c/kak"                || die "kakrc"

# profile
scp -p profile "$r:$h/.profile"

# x
for x in x/*; do
        scp -p "$x" "$r:$h/.$(basename "$x")" || die "$x"
done

# zsh
cat zsh/init.zsh zsh/cdp.zsh zsh/rc.zsh > "$t/.zshrc" || die "cat zshrc"
scp -p "$t/.zshrc" "$r:$h"             || die "zshrc"

