#!/usr/bin/env bash

cd $(dirname "$0")

[[ -n "$1" ]] && LANGUAGE="$1" || LANGUAGE="en"

DIR=$(pwd)
URL=$(pacman -Sp arch-wiki-docs)
TMP=${1:-$(mktemp -d)}
ZIP=${TMP}/arch-wiki-docs.tar.xz

(cd $DIR && {
    [[ -d "${DIR}/wiki" ]] && rm -rf "${DIR}/wiki" && install -d "${DIR}/wiki"
    [[ ! -d "$TMP" ]] && install -d "$TMP"
    [[ ! -e "$ZIP" ]] && wget $URL -O "$ZIP"
    tar Jxvf "$ZIP" -C "$TMP" >/dev/null 2>&1

    pacman -Si arch-wiki-docs | grep -e "^Version" | sed 's|^.*: ||' > wiki/version
    while read -r file; do
        MDFILE="${DIR}/wiki/$(sed 's|^.*/||;s|\.html$||' <<< $file).md"
        echo "Converting: ${file} -> ${MDFILE}"
        ./html2md.js "$file" > "$MDFILE"
    done < <(find ${TMP}/usr/share/doc/arch-wiki/html/${LANGUAGE}/ -type f)
    echo "Done!"

    [[ -d "$TMP" ]] && rm -rf "$TMP"
})
