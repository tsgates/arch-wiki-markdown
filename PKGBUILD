# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
# Contributor: Kevin MacMartin <prurigro at gmail dot com>

# Change to the language of your choice.
_wiki_lang=en
# Available language strings at the time of this writing are:
# ar, bg, ca, cs, da, el, en, eo, es, fi, he, hr, hu, id, it,
# ja, ko, lt, nb, nl, pl, pt, ru, sk, sr, th, uk, zh-CN, zh-TW

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=r43.20140714
pkgrel=1
pkgdesc="Search and read Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('bash' 'vim')
makedepends=('nodejs' 'python-cssselect' 'python-lxml' 'python-simplemediawiki')

source=("git+https://github.com/prurigro/${_pkgname}#branch=cleanup-and-update" # When changes are pulled: s|prurigro|tsgates|;s|cleanup-and-update|master|
        "git+https://github.com/lahwaacz/arch-wiki-docs.git#branch=master")
sha512sums=('SKIP' 'SKIP')

pkgver() {
    cd $_pkgname
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(date +%Y%m%d)"
}

prepare() {
    if [[ ! -d "arch-wiki-docs" ]]; then
        echo "Downloading Wiki"
        python arch-wiki-docs/arch-wiki-docs.py --output-directory arch-wiki-docs --clean --safe-filenames
        echo "Done!"
    else
        echo "Download directory already exists, using that!"
    fi
}

build() {
    if [[ ! -d "wiki" ]]; then
        echo "Converting Wiki"
        install -d wiki
        while read -r file; do
            ./html2md.js "$file" > "wiki/$(sed 's|^.*/||;s|\.html$||' <<< $file).md"
        done < <(find ${_pkgname}/arch-wiki-docs/${_wiki_lang}/ -type f)
        echo "Done!"
    else
        echo "Wiki directory already exists, using that!"
    fi
}

package() {
    echo "Installing Wiki"
    install -d "${pkgdir}/usr/share/doc/${_pkgname}"
    cp --no-preserve=ownership wiki/* "${pkgdir}/usr/share/doc/${_pkgname}/"
    cd $_pkgname
    install -Dm755 arch-wiki "${pkgdir}/usr/bin/arch-wiki"
    install -Dm644 ${_pkgname}.vim "${pkgdir}/usr/share/${_pkgname}/colors/${_pkgname}.vim"
    echo $pkgver > "${pkgdir}/usr/share/${_pkgname}/version"
    echo "Done!"
}
