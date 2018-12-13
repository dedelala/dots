#!/bin/bash

while read -r p; do
        if ! go get -u "$p"; then
                echo ":( $p"
                exit 1
        fi
done <<!
github.com/stamblerre/gocode
github.com/zmb3/gogetdoc
golang.org/x/tools/cmd/goimports
!
