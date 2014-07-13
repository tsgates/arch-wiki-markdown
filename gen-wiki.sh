#!/usr/bin/env bash

DIR=$(dirname "$0")
URL=$(pacman -Sp arch-wiki-docs)
OUT=${1:-$(mktemp -d)}
ZIP=${OUT}/arch-wiki-docs.tar.xz

(cd $DIR && {
    if [[ ! -e $ZIP ]]; then
        wget $URL -O $ZIP
        mkdir ${OUT}/pkg
        uz -X ${OUT}/pkg $ZIP
    fi
    ghc filter.hs +RTS -N4
    ./filter ${OUT}/pkg
    pacman -Si arch-wiki-docs > wiki/version
})
