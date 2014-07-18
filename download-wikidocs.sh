#!/usr/bin/env bash

WIKIDOCS="wiki-docs"

if [[ "$1" = "--live" ]]; then
    # Delete $WIKIDOCS folder if it exists
    [[ -d "$WIKIDOCS" ]] && rm -rf "$WIKIDOCS"

    # Download the wiki-docs to $WIKIDOCS
    echo "Downloading Wiki"
    python arch-wiki-docs/arch-wiki-docs.py --output-directory "$WIKIDOCS" --clean --safe-filenames \
        && echo "Done!"

    # Add a timestamp marking when the rip was made
    echo $_date > "${WIKIDOCS}/$(date +%Y%m%d)"
else
    [[ -d "$WIKIDOCS" ]] && echo "The ${WIKIDOCS} directory already exists" && exit 1
    install -d "$WIKIDOCS"

    (pacman -Si arch-wiki-docs | grep -e "^Version" | sed 's|^[^:]*: ||;s|-1$||') > "${WIKIDOCS}/date"

    TMPDIR="$(mktemp -d)"

    curl $(pacman -Sp arch-wiki-docs) | tar -xJ -C ${TMPDIR}/ >/dev/null 2>&1
    mv ${TMPDIR}/usr/share/doc/arch-wiki/html/* "${WIKIDOCS}/"
    rm -rf $TMPDIR
fi
