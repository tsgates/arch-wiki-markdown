# Maintainer: Taesoo Kim <tsgatesv@gmail.com>
_pkgname=arch-wiki-markdown
pkgname=${_pkgname}-git
pkgver=9031de0
pkgrel=1
pkgdesc="Search and read Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/${_pkgname}"
license=('MIT')
depends=('vim')
source=("git+https://github.com/tsgates/${_pkgname}")
sha512sums=('SKIP')

pkgver() {
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
    install -d "${pkgdir}/usr/share/doc/${pkgname%-*}"
    install -Dm0644 ${_pkgname}/wiki/* "$pkgdir/usr/share/doc/${pkgname%-*}"
    install -Dm0755 ${_pkgname}/arch-wiki "$pkgdir/usr/bin/arch-wiki"
}
