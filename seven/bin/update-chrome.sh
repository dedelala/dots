#!/bin/bash

die() { printf "oh no she don't, %s" "$*"; exit 7; }

cd $HOME/void-packages || die "dir"

git pull || die "pull"

./xbps-src pkg google-chrome || die "pkg"

sudo xbps-install -y --repository=$HOME/void-packages/hostdir/binpkgs/nonfree google-chrome || die "install"
