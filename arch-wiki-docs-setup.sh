#!/usr/bin/env bash

WIKIDOCS="src/wiki-docs"

[[ -d "$WIKIDOCS" ]] && echo "The ${WIKIDOCS} directory already exists" && exit 1
install -d "$WIKIDOCS"
curl $(pacman -Sp arch-wiki-docs) | tar -xJ -C "${WIKIDOCS}/" >/dev/null 2>&1
pacman -Si arch-wiki-docs | grep -e "^Version" | sed 's|^[^:]*: ||;s|-1$||' > "${WIKIDOCS}/date"
