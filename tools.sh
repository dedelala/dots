#!/bin/bash

die() { echo "sad tools face: $*"; exit 1; }

cd "$(dirname "$0")" || die "root"

t="$HOME/tools"
mkdir -pv "$t"

case $1 in
install)
        for d in kakoune/src dmenu dwm st; do
                cd "$t/$d" || die "cd $d"
                sudo make install || die "install $d"
        done
        exit
        ;;
update)
        cd "$t/kakoune" || die "cd kak"
        git stash || die "stash kak"
        git pull || die "pull kak"
        git stash pop || die "pop kak"

        for d in dmenu dwm st; do
                cd "$t/$d" || die "cd $d"
                git pull || die "pull $d"
        done
        exit
        ;;
esac

docker pull dedelala/kakao:latest
docker pull dedelala/sucka:latest

if ! [[ -d "$t/kakoune" ]]; then
        git clone --depth 1 https://github.com/mawww/kakoune.git "$t/kakoune" \
        || die "get kak"

        d=$PWD
        cd "$t/kakoune" || die "cd kak"
        git apply - < "$d/kak/make-install.patch" || die "patch kak"
        cd "$d" || die "cd bak"

        docker run -t --rm -v "$t/kakoune:/src" -w /src/src \
          dedelala/kakao:latest make || die "build kak"
fi

for tool in dmenu dwm st; do
        if ! [[ -d "$t/$tool" ]]; then
                git clone --depth 1 "https://git.suckless.org/$tool" "$t/$tool" \
                || die "get $tool"
        fi
        cp -v "$tool/config.h" "$t/$tool"

        docker run -t --rm -v "$t/$tool:/src" -w /src \
          dedelala/sucka:latest make || die "build $tool"
done
