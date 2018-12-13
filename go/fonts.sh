#!/bin/bash

die() { echo "oh noes! $*"; exit 1; }

p=golang.org/x/image/font
go get -u -d "$p" || die "get fonts"
sudo cp "$GOPATH/src/$p/gofont/ttfs/"*.ttf /usr/share/fonts/TTF/ || die "install fonts"
sudo fc-cache

