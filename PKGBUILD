# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
# Contributor: Kevin MacMartin <prurigro at gmail dot com>
#
[[ -z "$_wiki_downloadlive" ]] && _wiki_downloadlive=0 # set to 1 to rip directly from the live wiki.
[[ -z "$_wiki_norebuild" ]] && _wiki_norebuild=0 # set to 1 to prevent rebuilding the wiki docs if they already exist.
[[ -z "$_wiki_nofold" ]] && _wiki_nofold=0 # set to 1 to disable setting the text width to 78 chars.
[[ -z "$_wiki_lang" ]] && _wiki_lang=en # change to the language of your choice (list of available languages below).
#
# Available language strings for $_wiki_lang (when this was writing) are:
#   ar, bg, ca, cs, da, el, en, eo, es, fi, he, hr, hu, id, it,
#   ja, ko, lt, nb, nl, pl, pt, ru, sk, sr, th, uk, zh-CN, zh-TW

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=r93.20140731
pkgrel=1
pkgdesc="Search and read the Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('bash' 'vim')
if [[ "$_wiki_downloadlive" = 1 ]]; then
    makedepends=('pandoc-static' 'python-cssselect' 'python-lxml' 'python-simplemediawiki') \
    source=("arch-wiki"
            "${_pkgname}.vimrc"
            "${_pkgname}.colors.vim"
            "git+https://github.com/prurigro/vim-markdown-concealed.git#branch=master"
            "git+https://github.com/drmikehenry/vim-fixkey.git#branch=master"
            "git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master")
    sha512sums=('477508fa49a7078b8deb6b16b7aff31b43757829fc3cdec0ced504f7a3a99e54be7c377a24019cb896bac8c0fbc1a9b3d67c0b77e04938d95fe12514144e38c1'
                'd1a661df5fa3f2e0904da21c1ede02db4ce1f22e8f3ccb862ba4d0610a2951b65fc4f60dd75e732f8f4f19d0628004fb85d2c1bbdd38dcc449dcc6eb3f955974'
                'a4b62321c1d538ac33cbfd742fd8945f5a2118b4561faf19eaed7c5d9d0a6d696f758f339237b2eacde9327c2830b59e584cd60432adae9a89d7b95cb02bc327'
                'SKIP'
                'SKIP'
                'SKIP')
else
    makedepends=('pandoc-static' 'arch-wiki-docs')
    source=("arch-wiki"
            "${_pkgname}.vimrc"
            "${_pkgname}.colors.vim"
            "git+https://github.com/prurigro/vim-markdown-concealed.git#branch=master"
            "git+https://github.com/drmikehenry/vim-fixkey.git#branch=master")
    sha512sums=('477508fa49a7078b8deb6b16b7aff31b43757829fc3cdec0ced504f7a3a99e54be7c377a24019cb896bac8c0fbc1a9b3d67c0b77e04938d95fe12514144e38c1'
                'd1a661df5fa3f2e0904da21c1ede02db4ce1f22e8f3ccb862ba4d0610a2951b65fc4f60dd75e732f8f4f19d0628004fb85d2c1bbdd38dcc449dcc6eb3f955974'
                '95380722a4011e3487e048c3a66baeff1c39bc35adff0b9ef9763e57d19df6c97f9eb62ada72d46fab192c21d4260c07b93dcb9142b2ec397e1eb5a3f38b3f84'
                'SKIP'
                'SKIP')
fi

[[ -f "${srcdir}/wiki-docs/date" ]] \
    && _date=$(cat "${srcdir}/wiki-docs/date") \
    || _date=$(date +%Y%m%d)

pkgver() {
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$_date"
}

prepare() {
    if [[ ! -f "wiki-docs/date" ]]; then
        [[ -d "wiki-docs" ]] && rm -rf "wiki-docs"
        if [[ "$_wiki_downloadlive" = 1 ]]; then
            python arch-wiki-docs/arch-wiki-docs.py --output-directory "wiki-docs" --clean --safe-filenames
            echo $_date > "wiki-docs/$(date +%Y%m%d)"
        else
            install -d "wiki-docs"
            (pacman -Si arch-wiki-docs | grep -e "^Version" | sed 's|^[^:]*: ||;s|-1$||') > "wiki-docs/date"
            cp -R /usr/share/doc/arch-wiki/html/* "wiki-docs/"
        fi
    else
        echo "Download directory exists (${_date}), using that"
    fi
}

build() {
    if [ ! "$_wiki_norebuild" = 1 ] || [ ! -d "docs" ]; then
        echo -n "Converting Wiki... "
        [[ -d "docs" ]] && rm -rf docs
        install -d docs
        while read -r file; do
            NEWFILE="docs/$(sed 's|^.*/||;s|\.[^\.]*$||' <<< $file).md"
            pandoc -f html -t markdown_strict --atx-headers --normalize --smart --no-wrap -o "$NEWFILE" "$file"

            # Sanitize the output file a bit
            sed -i -re 's|^(\s*)\ \ \ \ ([-\*\+])|\1\ \ \2|g;s|^(\s*[-\*\+]\ )\ \ \ *|\1|g' "$NEWFILE" # fix spacing on lists
            sed -i -re 's|\[([^]]*)]\(#[^\)]*\)|\1|g' "$NEWFILE" # strip anchor links
            sed -i -re 's|\[(\s*[^]]*)\]\(\s*mailto:([^\)]*\))|\1 \(\2|g' "$NEWFILE" # convert [mail](mailto:a@b.c) -> mail (a@b.c)
            sed -i -re 's|\[\s*(https?:\|www\.)[^]]*\s*\]\(\s*(https?:\|www\.)([^)]*)\s*\)|\2\3|g' "$NEWFILE" # convert external links with [http://url](http://url)
            sed -i -re 's|\(([^`\(\)]*`[^`\(\)]*\([^`\(\)]*[^`\(\)]*\)[^`\(\)]*`[^`\(\)]*)\)|\1|g' "$NEWFILE" # remove outer brackets from code-quotes surrounding brackets
            sed -i -re 's|\[([^]]*)\]\(\.\.\/[^\)]*\)|\1|g' "$NEWFILE" # strip internal links
            sed -i -re 's|(\[[^]]*\]\([^)\ ]*)\ [^)]*\)|\1\)|g' "$NEWFILE" # remove titles from remaining links
            sed -i -re 's|^(\s*[-\*\+]\ )[0-9\.]*\.([0-9]*\ )|\1\2|g;s|^(\s*)[-\*\+]\ ([0-9]*)\ |\1\2\.\ |g' "$NEWFILE" # convert unordered lists with numbers to numbered lists
            sed -i '/<script type="text\/javascript"/,/<\/script>/d' "$NEWFILE" # remove the "article considered for removal" tables
            sed -i '/^Category:$/q' "$NEWFILE" # remove everything after the line containing 'Category:'
            sed -i 'N;$!P;$!D;$d' "$NEWFILE" # remove the last two lines of the file

            # Set line width to 78 characters
            if [ ! "$_wiki_nofold" = 1 ]; then
                # replace spaces in link titles with underscores to prevent them from being folded
                while [[ $(grep -E "\[[^]]*\ [^]]*\]" "$NEWFILE") ]]; do
                    sed -i -re 's|([^]]*)\ ([^]]*\]\([^)]*\))|\1_\2|g' "$NEWFILE"
                done

                # fold the text at 78 characters
                fold -w 78 -s "$NEWFILE" > "${NEWFILE}.tmp"
                mv "${NEWFILE}.tmp" "$NEWFILE"

                # remove trailing whitespace
                sed -i 's/[ \t]*$//' "$NEWFILE"
            fi
        done < <(find wiki-docs/${_wiki_lang} -type f) \
            && echo "Done!" \
            || echo "Failed!"
    fi
}

package() {
    # Wiki files
    pushd docs >/dev/null 2>&1
        for doc in *; do
            install -Dm644 "$doc" "${pkgdir}/usr/share/doc/${_pkgname}/${doc}"
        done
    popd >/dev/null 2>&1

    # Vim files from vim-markdown-concealed
    install -Dm644 vim-markdown-concealed/syntax/mkdc.vim "${pkgdir}/usr/share/${_pkgname}/syntax/mkdc.vim"
    install -Dm644 vim-markdown-concealed/ftdetect/mkdc.vim "${pkgdir}/usr/share/${_pkgname}/ftdetect/mkdc.vim"
    install -Dm644 vim-markdown-concealed/ftplugin/mkdc.vim "${pkgdir}/usr/share/${_pkgname}/ftplugin/mkdc.vim"

    # Vim files from vim-fixkey
    install -Dm644 vim-fixkey/plugin/fixkey.vim "${pkgdir}/usr/share/${_pkgname}/plugin/fixkey.vim"

    # Package files
    install -Dm644 ${_pkgname}.colors.vim "${pkgdir}/usr/share/${_pkgname}/colors/${_pkgname}.vim"
    install -Dm644 ${_pkgname}.vimrc "${pkgdir}/usr/share/${_pkgname}/${_pkgname}.vimrc"
    install -Dm755 arch-wiki "${pkgdir}/usr/bin/arch-wiki"
    echo $pkgver > "${pkgdir}/usr/share/${_pkgname}/version"
}
