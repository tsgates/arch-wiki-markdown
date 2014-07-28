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

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=r.20140728
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
        "mkd-syntax-conceal.patch"
        "${_pkgname}.vimrc"
        "${_pkgname}.colors.vim"
        "git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master"
        "git+https://github.com/plasticboy/vim-markdown.git#branch=master"
        "git+https://github.com/drmikehenry/vim-fixkey.git#branch=master")
sha512sums=('1aec792b9d5fcfcb35bdaa44985031c6bcf4ba03406b36c926f53ff0b71db3312eb1d49e68c2ed4eace2b19295d1a469a527a774734a0d6a3f3de6cb6ece9518'
            '0ce47316a04d09ddc2317a53a2661b8c1980842370cc0b122efcd2c6a788834a773d12acd277a2ecd47448bf92f2fda1ab54d446af838f630dd2a0628f5de0f7'
            'bf0c32b45ff35f34f767e6d665bc147d0a8d2186438b62b5a3643e5dda3f2d3bcfdd1aa94006d61ad8ab630250d1951fab4e38d682f0dc7bc628f0737740c9ab'
            'd093a4c04e7f2beeee836793daaa38fa766f4cd3b5ba74e929bfc70e4855eccf31a0c5c078f60848f5b8c2efa1a3df5e5d639a897272c89e6d4eaebfceb0ebd3'
            'SKIP'
            'SKIP'
            'SKIP')

[[ -f "${srcdir}/wiki-docs/date" ]] \
    && _date=$(cat "${srcdir}/wiki-docs/date") \
    || _date=$(date +%Y%m%d)

pkgver() {
    cd ${_startdir}
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$_date"
}

prepare() {
    pushd vim-markdown >/dev/null 2>&1
    patch -p1 < ../mkd-syntax-conceal.patch
    popd >/dev/null 2>&1

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
    echo -n "Converting Wiki... "
    install -d docs
    while read -r file; do
        NEWFILE="docs/$(sed 's|^.*/||;s|\.[^\.]*$||' <<< $file).md"
        pandoc -f html -t markdown_github --atx-headers -o "$NEWFILE" "$file"

        # Sanitize the output file a bit
        sed -i -re 's|\[(\s*[^]]*)\]\(\s*mailto:([^\)]*\))|\1 \(\2|g' "$NEWFILE" # convert [mail](mailto:a@b.c) -> mail (a@b.c)
        sed -i -re 's|\[\s*(https?:\|www\.)[^]]*\s*\]\(\s*(https?:\|www\.)([^)]*)\s*\)|\2\3|g' "$NEWFILE" # convert external links with [http://url](http://url)
        # sed -i -re 's|\[\s*([^]]*)\s*\]\(\s*(https?:\|www\.[^)]*)\s*\)|\1 (\2)|g' "$NEWFILE" # convert the remaining external links
        sed -i -re 's|\[([^]]*)\]\(\.\.\/[^\)]*\)|\1|g' "$NEWFILE" # strip internal links
    done < <(find wiki-docs/${_wiki_lang} -type f) \
        && echo "Done!" \
        || echo "Failed!"
}

package() {
    # Wiki files
    pushd docs >/dev/null 2>&1
        for doc in *; do
            install -Dm644 "$doc" "${pkgdir}/usr/share/doc/${_pkgname}/${doc}"
        done
    popd >/dev/null 2>&1

    # Vim files from vim-markdown
    install -Dm644 vim-markdown/syntax/mkd.vim "${pkgdir}/usr/share/${_pkgname}/syntax/mkd.vim"
    install -Dm644 vim-markdown/ftdetect/mkd.vim "${pkgdir}/usr/share/${_pkgname}/ftdetect/mkd.vim"
    install -Dm644 vim-markdown/ftplugin/mkd.vim "${pkgdir}/usr/share/${_pkgname}/ftplugin/mkd.vim"

    # Vim files from vim-fixkey
    install -Dm644 vim-fixkey/plugin/fixkey.vim "${pkgdir}/usr/share/${_pkgname}/plugin/fixkey.vim"

    # Package files
    install -Dm644 ${_pkgname}.colors.vim "${pkgdir}/usr/share/${_pkgname}/colors/${_pkgname}.vim"
    install -Dm644 ${_pkgname}.vimrc "${pkgdir}/usr/share/${_pkgname}/${_pkgname}.vimrc"
    install -Dm755 arch-wiki "${pkgdir}/usr/bin/arch-wiki"
    echo $pkgver > "${pkgdir}/usr/share/${_pkgname}/version"
}
