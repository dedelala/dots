#!/bin/bash

while read -r p; do
        go get -u "$p"
done <<!
github.com/stamblerre/gocode
github.com/zmb3/gogetdoc
golang.org/x/tools/cmd/goimports
!
