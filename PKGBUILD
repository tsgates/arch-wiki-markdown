# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
# Contributor: Kevin MacMartin <prurigro at gmail dot com>

# Change to the language of your choice.
_wiki_lang=en
# Available language strings at the time of this writing are:
# ar, bg, ca, cs, da, el, en, eo, es, fi, he, hr, hu, id, it,
# ja, ko, lt, nb, nl, pl, pt, ru, sk, sr, th, uk, zh-CN, zh-TW

_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=9031de0
pkgrel=1
pkgdesc="Search and read Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('vim')
makedepends=('nodejs' 'wget')

source=("git+https://github.com/prurigro/${_pkgname}") # When changes are pulled, s|prurigro|tsgates|
sha512sums=('SKIP')

pkgver() {
    cd $_pkgname
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(pacman -Si arch-wiki-docs | grep -e "^Version" | sed 's|^.*: ||')"
}

build() {
    cd $_pkgname
    ./gen-wiki.sh "$_wiki_lang"
}

package() {
    cd $_pkgname
    install -Dm644 wiki/* "$pkgdir/usr/share/doc/${_pkgname}/"
    install -Dm755 arch-wiki "${pkgdir}/usr/bin/arch-wiki"
}
