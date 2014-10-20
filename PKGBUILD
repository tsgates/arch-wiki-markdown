# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
# Contributor: Kevin MacMartin <prurigro at gmail dot com>
#
[[ -z "$_wiki_downloadlive" ]] && _wiki_downloadlive=0 # set to 1 to rip directly from the live wiki.
[[ -z "$_wiki_norebuild" ]] && _wiki_norebuild=0 # set to 1 to prevent rebuilding the wiki docs if they already exist.
[[ -z "$_wiki_foldlines" ]] && _wiki_foldlines=0 # set to 1 to fold each line's to a text width of 78 chars.
[[ -z "$_wiki_lang" ]] && _wiki_lang=en # change to the language of your choice (list of available languages below).
#
# Available language strings for $_wiki_lang (when this was writing) are:
#   ar, bg, ca, cs, da, el, en, eo, es, fi, he, hr, hu, id, it,
#   ja, ko, lt, nb, nl, pl, pt, ru, sk, sr, th, uk, zh-CN, zh-TW

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=r106.20141020
pkgrel=1
pkgdesc="Search and read the Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('bash' 'vim')
if [[ "$_wiki_downloadlive" = 1 ]]; then
    makedepends=('python-lxml' 'python-simplemediawiki') \
    source=("arch-wiki"
            "${_pkgname}.vimrc"
            "${_pkgname}.colors.vim"
            "git+https://github.com/prurigro/vim-markdown-concealed.git#branch=master"
            "git+https://github.com/drmikehenry/vim-fixkey.git#branch=master"
            "git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master")
    sha512sums=('477508fa49a7078b8deb6b16b7aff31b43757829fc3cdec0ced504f7a3a99e54be7c377a24019cb896bac8c0fbc1a9b3d67c0b77e04938d95fe12514144e38c1'
                '7a71c5190e9694a1554d364bd0297601db421c0d44e173c74fe269c9ead6d52313f5faecbab5b66fefa50a726ef534a17b9c4d2012924bdb36a4ae4e9cd79bd5'
                'db1226157bc042c4b84ead57e4f2a4937e1b77ed61a465c8c9f9b17ec37ebe67965c74d4044158c01374718f03aabd8d1bb9e534708562406685565e6be1d9ca'
                'SKIP'
                'SKIP'
                'SKIP')
else
    makedepends=('arch-wiki-docs')
    source=("arch-wiki"
            "${_pkgname}.vimrc"
            "${_pkgname}.colors.vim"
            "git+https://github.com/prurigro/vim-markdown-concealed.git#branch=master"
            "git+https://github.com/drmikehenry/vim-fixkey.git#branch=master")
    sha512sums=('477508fa49a7078b8deb6b16b7aff31b43757829fc3cdec0ced504f7a3a99e54be7c377a24019cb896bac8c0fbc1a9b3d67c0b77e04938d95fe12514144e38c1'
                '7a71c5190e9694a1554d364bd0297601db421c0d44e173c74fe269c9ead6d52313f5faecbab5b66fefa50a726ef534a17b9c4d2012924bdb36a4ae4e9cd79bd5'
                'db1226157bc042c4b84ead57e4f2a4937e1b77ed61a465c8c9f9b17ec37ebe67965c74d4044158c01374718f03aabd8d1bb9e534708562406685565e6be1d9ca'
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
            sed -i '/^<table>$/,/^<\/table>$/d' "$NEWFILE" # remove leftover 'stub' tables
            sed -i '/^Category:$/q' "$NEWFILE" # remove everything after the line containing 'Category:'
            sed -i 's|</*span[^>]*>||g' "$NEWFILE" #remove the sed open tag
            [[ $(grep 'id="See_also"' "$NEWFILE") ]] \
                && sed -i '/^.*id="See_also".*$/q' "$NEWFILE"  # remove everything after the line with 'See_also'

            # Remove the last two lines of the file
            sed -i 'N;$!P;$!D;$d' "$NEWFILE"

            # Set line width to 78 characters
            if [ "$_wiki_foldlines" = 1 ]; then
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
