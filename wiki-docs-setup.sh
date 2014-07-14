#!/usr/bin/env bash

WIKIDOCS="src/wiki-docs"

[[ -d "$WIKIDOCS" ]] && echo "The ${WIKIDOCS} directory already exists" && exit 1
[[ -d "src" ]] || install -d src
curl $(pacman -Sp arch-wiki-docs) | tar -xJ -C src/ >/dev/null 2>&1
mv src/arch-wiki-docs "$WIKIDOCS"
pacman -Si arch-wiki-docs | grep -e "^Version" | sed 's|^[^:]*: ||;s|-1$||' > "${WIKIDOCS}/date"
