#!/bin/bash

die() { echo "yeah nah: $*" >&2; exit 1; }

cd "$(dirname "$0")" || die "root"

c="$HOME/.config"
mkdir -pv "$c/kak/colors"   || die "kak dir"
mkdir -pv "$c/kak/autoload"   || die "kak dir"
mkdir -pv "$c/alacritty"        || die "alacritty dir"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

{
        # kak
        kak/dedelala.kak.sh > "$t/dedelala.kak"            || die "dedelala.kak.sh"
        install -vm 0644 "$t/dedelala.kak" "$c/kak/colors" || die "dedelala.kak"
        install -vm 0644 kak/kakrc "$c/kak"                || die "kakrc"
        install -vm 0644 kak/hcl.kak "$c/kak/autoload"     || die "hcl.kak"
        ln -fsv /usr/local/share/kak/autoload "$c/kak/autoload/global" \
            || die "link kak global autoload"

        # alacritty
        install -vm 0644 alacritty/alacritty.yml "$c/alacritty" || die "alacritty"

        # profile
        install -vm 0644 profile "$HOME/.profile" || die "profile"

        # tmux
        install -vm 0644 tmux/tmux.conf "$HOME/.tmux.conf" || die "tmux"

        # zsh
        install -vm 0644 zsh/rc.zsh "$HOME/.zshrc" || die "zshrc"

} | column -t
