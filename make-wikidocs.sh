#!/usr/bin/env bash

# Converted Wiki (output folder)
WIKI="wiki"

# HTML Wiki (input folder)
WIKIDOCS="wiki-docs"

# Set the language to the default, then change it to the argument if valid
LANG="en"
[[ -n "$1" ]] && [[ -d "${WIKIDOCS}/${LANG}" ]] && LANG="$1"

[[ -d "$WIKI" ]] && rm -rf "$WIKI"
install -d "$WIKI"

# CONVERSION (PANDOC)
while read -r file; do
    NEWFILE="${WIKI}/$(sed 's|^.*/||;s|\.[^\.]*$||' <<< $file).md"
    pandoc -f html -t markdown_github --atx-headers -o "$NEWFILE" "$file"

    # Sanitize the output file a bit
    sed -i -re 's|\[(\s*[^]]*)\]\(\s*mailto:([^\)]*\))|\1 \(\2|g' "$NEWFILE" # convert [mail](mailto:a@b.c) -> mail (a@b.c)
    sed -i -re 's|\[\s*(https?:\|www\.)[^]]*\s*\]\(\s*(https?:\|www\.)([^)]*)\s*\)|\2\3|g' "$NEWFILE" # convert external links with [http://url](http://url)
    sed -i -re 's|\[\s*([^]]*)\s*\]\(\s*(https?:\|www\.[^)]*)\s*\)|\1 (\2)|g' "$NEWFILE" # convert the remaining external links
    sed -i -re 's|\[([^]]*)\]\(\.\.\/[^\)]*\)|\1|g' "$NEWFILE" # strip internal links
done < <(find ${WIKIDOCS}/${LANG} -type f)

# CONVERSION (html2md.js)
# cp ${_pkgname}/html2md.js .
# while read -r file; do
#     ./html2md.js "$file" > "${WIKI}/$(sed 's|^.*/||;s|\.[^\.]*$||' <<< $file).md"
# done < <(find ${WIKIDOCS}/${LANG} -type f)
# rm html2md.js
