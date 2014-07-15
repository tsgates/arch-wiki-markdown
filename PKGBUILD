# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
# Contributor: Kevin MacMartin <prurigro at gmail dot com>

# Change to the language of your choice.
#
# Available language strings at the time of this writing are:
#   ar, bg, ca, cs, da, el, en, eo, es, fi, he, hr, hu, id, it,
#   ja, ko, lt, nb, nl, pl, pt, ru, sk, sr, th, uk, zh-CN, zh-TW
#
_wiki_lang=en

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=r51.20140714
pkgrel=1
pkgdesc="Search and read Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('bash' 'vim')
makedepends=('nodejs' 'python-cssselect' 'python-lxml' 'python-simplemediawiki')

# If or when these changes are pulled: s|prurigro|tsgates|;s|cleanup-and-update|master|
source=("git+https://github.com/prurigro/${_pkgname}#branch=cleanup-and-update"
        "git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master"
        "git+https://github.com/plasticboy/vim-markdown.git#branch=master")
sha512sums=('SKIP' 'SKIP' 'SKIP')

[[ -f "${srcdir}/wiki-docs/date" ]] \
    && _date=$(cat "${pkgdir}/${_pkgname}/wiki-docs/date") \
    || _date=$(date +%Y%m%d)

pkgver() {
    cd ${_pkgname}
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$_date"
}

prepare() {
    if [[ ! -f "wiki-docs/date" ]]; then
        [[ -d "wiki-docs" ]] && rm -rf wiki-docs
        echo "Downloading Wiki"
        python arch-wiki-docs/arch-wiki-docs.py --output-directory wiki-docs --clean --safe-filenames
        echo $_date > wiki-docs/date
        echo "Done!"
    else
        echo "Download directory exists (${_date}), using that"
    fi
}

build() {
    echo "Converting Wiki"
    [[ -d "wiki" ]] && rm -rf wiki
    install -d wiki
    cp ${_pkgname}/html2md.js .
    while read -r file; do
        ./html2md.js "$file" > "wiki/$(sed 's|^.*/||;s|\.html$||' <<< $file).md"
    done < <(find wiki-docs/${_wiki_lang} -type f)
    rm html2md.js
    echo "Done!"
}

package() {
    echo "Installing Wiki"

    # Wiki files
    install -d "${pkgdir}/usr/share/doc/${_pkgname}"
    cp --no-preserve=ownership wiki/* "${pkgdir}/usr/share/doc/${_pkgname}/"

    # Vim files from vim-markdown
    install -Dm644 vim-markdown/ftdetect/mkd.vim "${pkgdir}/usr/share/${_pkgname}/ftdetect/mkd.vim"
    install -Dm644 vim-markdown/ftplugin/mkd.vim "${pkgdir}/usr/share/${_pkgname}/ftplugin/mkd.vim"
    install -Dm644 vim-markdown/syntax/mkd.vim "${pkgdir}/usr/share/${_pkgname}/syntax/mkd.vim"

    # Package files
    cd $_pkgname
    install -Dm644 ${_pkgname}.colorscheme.vim "${pkgdir}/usr/share/${_pkgname}/colors/${_pkgname}.vim"
    install -Dm644 ${_pkgname}.vimrc "${pkgdir}/usr/share/${_pkgname}/${_pkgname}.vimrc"
    install -Dm755 arch-wiki "${pkgdir}/usr/bin/arch-wiki"
    echo $pkgver > "${pkgdir}/usr/share/${_pkgname}/version"
    echo "Done!"
}
