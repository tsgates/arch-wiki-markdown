# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
# Contributor: Kevin MacMartin <prurigro at gmail dot com>

# Change to the language of your choice.
#
# Available language strings at the time of this writing are:
#   ar, bg, ca, cs, da, el, en, eo, es, fi, he, hr, hu, id, it,
#   ja, ko, lt, nb, nl, pl, pt, ru, sk, sr, th, uk, zh-CN, zh-TW
#
_wiki_lang=en
_wiki_downloadlive=0 # set to 1 and download the optdepends to rip the live wiki
_wiki_norebuild=0 # set to 1 to prevent rebuilding if converted wiki docs exist

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=r83.20140729
pkgrel=1
pkgdesc="Search and read the Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('bash' 'vim')
makedepends=('pandoc-static')

if [[ "$_wiki_downloadlive" = 1 ]]; then
    makedepends+=('python-cssselect' 'python-lxml' 'python-simplemediawiki')
else
    makedepends+=('arch-wiki-docs')
fi

source=("arch-wiki"
        "${_pkgname}.vimrc"
        "${_pkgname}.colors.vim"
        "git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master"
        "git+https://github.com/prurigro/vim-markdown-concealed.git#branch=master"
        "git+https://github.com/drmikehenry/vim-fixkey.git#branch=master")
sha512sums=('1aec792b9d5fcfcb35bdaa44985031c6bcf4ba03406b36c926f53ff0b71db3312eb1d49e68c2ed4eace2b19295d1a469a527a774734a0d6a3f3de6cb6ece9518'
            'b42d3705d73127d60e8e63eec8378a5872d9afe256e660d60febaca760b66347a24f9f8d96497a32076a128240de59f0a8404dd74a22ec49ce062a518dc671d1'
            'd093a4c04e7f2beeee836793daaa38fa766f4cd3b5ba74e929bfc70e4855eccf31a0c5c078f60848f5b8c2efa1a3df5e5d639a897272c89e6d4eaebfceb0ebd3'
            'SKIP'
            'SKIP'
            'SKIP')

[[ -f "${srcdir}/wiki-docs/date" ]] \
    && _date=$(cat "${srcdir}/wiki-docs/date") \
    || _date=$(date +%Y%m%d)

pkgver() {
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$_date"
}

prepare() {
    if [[ ! -f "wiki-docs/date" ]]; then
        if [[ "$_wiki_downloadlive" = 1 ]]; then
            [[ -d "wiki-docs" ]] && rm -rf "wiki-docs"
            python arch-wiki-docs/arch-wiki-docs.py --output-directory "wiki-docs" --clean --safe-filenames
            echo $_date > "wiki-docs/$(date +%Y%m%d)"
        else
            [[ -d "wiki-docs" ]] && echo "The 'wiki-docs' directory already exists" && return 1
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
