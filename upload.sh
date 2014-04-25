#!/bin/bash

source PKGBUILD

makepkg --source
burp -c multimedia arch-wiki-markdown-git-$pkgver-1.src.tar.gz