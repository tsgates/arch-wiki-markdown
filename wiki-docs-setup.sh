#!/usr/bin/env bash

WIKIDOCS="src/wiki-docs"

[[ -d "$WIKIDOCS" ]] && echo "The ${WIKIDOCS} directory already exists" && exit 1

[[ -d "tmp" ]] && rm -rf tmp
install -d tmp
curl $(pacman -Sp arch-wiki-docs) | tar -xJ -C tmp/ >/dev/null 2>&1
[[ -d src ]] || install -d src
mv tmp "$WIKIDOCS"
rm -rf tmp

(pacman -Si arch-wiki-docs | grep -e "^Version" | sed 's|^[^:]*: ||;s|-1$||') > "${WIKIDOCS}/date"
