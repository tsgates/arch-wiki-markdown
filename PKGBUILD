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
pkgver=r71.20140715
pkgrel=1
pkgdesc="Search and read the Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('bash' 'vim')
makedepends=('pandoc-static')
optdepends=('python-cssselect: required to rip docs directly from the wiki'
            'python-lxml: required to rip docs directly from the wiki'
            'python-simplemediawiki: required to rip docs directly from the wiki')
source=("git+https://github.com/prurigro/${_pkgname}#branch=cleanup-and-update"
        "git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master"
        "git+https://github.com/plasticboy/vim-markdown.git#branch=master"
        "mkd.vim")
sha512sums=('SKIP' 'SKIP' 'SKIP' 'da4065be79a39a7151a57744dcdd128b3a9a4fb8717dae3a060e9a665ca44de7c399d404067af221e49224aecff4aa12a3fb887af6f93a33455b0a8aee8ccd2a')

[[ -f "${srcdir}/wiki-docs/date" ]] \
    && _date=$(cat "${srcdir}/wiki-docs/date") \
    || _date=$(date +%Y%m%d)

pkgver() {
    cd ${_pkgname}
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$_date"
}

prepare() {
    if [[ ! -f "wiki-docs/date" ]]; then
        [[ "$_wiki_downloadlive" = 1 ]] \
            && ./${_pkgname}/download-wikidocs.sh --live \
            || ./${_pkgname}/download-wikidocs.sh
    else
        echo "Download directory exists (${_date}), using that"
    fi
}

build() {
    echo -n "Converting Wiki... "
    ./${_pkgname}/make-wikidocs.sh "$_wiki_lang" \
        && echo "Done!" \
        || echo "Failed!"
}

package() {
    # Wiki files
    install -d "${pkgdir}/usr/share/doc/${_pkgname}"
    cp --no-preserve=ownership wiki/* "${pkgdir}/usr/share/doc/${_pkgname}/"

    # Vim files from vim-markdown
    install -Dm644 vim-markdown/ftdetect/mkd.vim "${pkgdir}/usr/share/${_pkgname}/ftdetect/mkd.vim"
    install -Dm644 vim-markdown/ftplugin/mkd.vim "${pkgdir}/usr/share/${_pkgname}/ftplugin/mkd.vim"

    # Modified mkd.vim with concealing syntax
    install -Dm644 mkd.vim "${pkgdir}/usr/share/${_pkgname}/syntax/mkd.vim"

    # Package files
    cd $_pkgname
    install -Dm644 ${_pkgname}.colors.vim "${pkgdir}/usr/share/${_pkgname}/colors/${_pkgname}.vim"
    install -Dm644 ${_pkgname}.vimrc "${pkgdir}/usr/share/${_pkgname}/${_pkgname}.vimrc"
    install -Dm755 arch-wiki "${pkgdir}/usr/bin/arch-wiki"
    echo $pkgver > "${pkgdir}/usr/share/${_pkgname}/version"
}
