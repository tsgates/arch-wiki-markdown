#!/usr/bin/env bash

source PKGBUILD

mkaurball
burp -c multimedia ${pkgname}-${pkgver}-${pkgrel}.src.tar.gz
