# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
# Contributor: Kevin MacMartin <prurigro at gmail dot com>
#
[[ -z "$_wiki_downloadlive" ]] && _wiki_downloadlive=0 # set to 1 to rip directly from the live wiki.
[[ -z "$_wiki_norebuild" ]] && _wiki_norebuild=0 # set to 1 to prevent rebuilding the wiki docs if they already exist.
[[ -z "$_wiki_lang" ]] && _wiki_lang=en # Change to the language of your choice (list of available languages below).
#
# Available language strings for $_wiki_lang (when this was writing) are:
#   ar, bg, ca, cs, da, el, en, eo, es, fi, he, hr, hu, id, it,
#   ja, ko, lt, nb, nl, pl, pt, ru, sk, sr, th, uk, zh-CN, zh-TW

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=r84.20140729
pkgrel=1
pkgdesc="Search and read the Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('bash' 'vim')
makedepends=('pandoc-static')
source=("arch-wiki"
        "${_pkgname}.vimrc"
        "${_pkgname}.colors.vim"
        "git+https://github.com/prurigro/vim-markdown-concealed.git#branch=master"
        "git+https://github.com/drmikehenry/vim-fixkey.git#branch=master")
sha512sums=('1aec792b9d5fcfcb35bdaa44985031c6bcf4ba03406b36c926f53ff0b71db3312eb1d49e68c2ed4eace2b19295d1a469a527a774734a0d6a3f3de6cb6ece9518'
            '4e2291e35a2b3640645d30b863ff81a1173d022d0ad6dfcd0caca3f34aa7d6082fd2f5263ba2123a957829e0606eddb7b163de108e93f48173481d4c52c12220'
            'SKIP'
            'SKIP'
            'SKIP')

# Set final dependencies/sources depending on whether live or packaged docs are selected
if [[ "$_wiki_downloadlive" = 1 ]]; then
    makedepends+=('python-cssselect' 'python-lxml' 'python-simplemediawiki')
    source+=("git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master")
    sha512sums+=('d093a4c04e7f2beeee836793daaa38fa766f4cd3b5ba74e929bfc70e4855eccf31a0c5c078f60848f5b8c2efa1a3df5e5d639a897272c89e6d4eaebfceb0ebd3')
else
    makedepends+=('arch-wiki-docs')
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
            pandoc -f html -t markdown_github --atx-headers -o "$NEWFILE" "$file"

            # Sanitize the output file a bit
            sed -i -re 's|\[(\s*[^]]*)\]\(\s*mailto:([^\)]*\))|\1 \(\2|g' "$NEWFILE" # convert [mail](mailto:a@b.c) -> mail (a@b.c)
            sed -i -re 's|\[\s*(https?:\|www\.)[^]]*\s*\]\(\s*(https?:\|www\.)([^)]*)\s*\)|\2\3|g' "$NEWFILE" # convert external links with [http://url](http://url)
            sed -i -re 's|\(([^`\(\)]*`[^`\(\)]*\([^`\(\)]*[^`\(\)]*\)[^`\(\)]*`[^`\(\)]*)\)|\1|g' "$NEWFILE" # remove outer brackets from code-quotes surrounding brackets
            sed -i -re 's|\[([^]]*)\]\(\.\.\/[^\)]*\)|\1|g' "$NEWFILE" # strip internal links
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
