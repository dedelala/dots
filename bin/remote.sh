#!/bin/bash

die() { echo "yeah nah: $*" >&2; exit 1; }

cd "$(dirname "$0")" || die "root"

remote=$1
[[ -n $remote ]] || die "usage: $0 <host>"
ssh "$remote" true || die "no can has connect to $remote"

c=".config"
ssh "$remote" mkdir -pv "$c/kak/colors"   || die "kak dir"

t=$(mktemp -d) || die "tmp"
trap 'rm -rf "$t"' EXIT

# kak
kak/dedelala.kak.sh > "$t/dedelala.kak"          || die "dedelala.kak.sh"
scp -p "$t/dedelala.kak" "$remote:$c/kak/colors" || die "dedelala.kak"
scp -p kak/kakrc "$remote:$c/kak"                || die "kakrc"

# zsh
cat zsh/init.zsh zsh/rc.zsh > "$t/.zshrc" || die "cat zshrc"
scp -p "$t/.zshrc" "$remote:"             || die "zshrc"

