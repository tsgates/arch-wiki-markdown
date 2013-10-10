#!/usr/bin/bash

DIR=$(dirname "$0")

(cd $DIR && {
    runhaskell filter.hs;
    pacman -Qi arch-wiki-docs > wiki/version
})
