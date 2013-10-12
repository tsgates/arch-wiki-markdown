pkgname=arch-wiki-markdown
pkgver=20130505
pkgrel=1
pkgdesc="Search and read Arch Wiki offline in your terminal"
arch=('any')
url="https://github.com/tsgates/arch-wiki-markdown"
license=('MIT')
author="Taesoo Kim"
source=("git+https://github.com/tsgates/arch-wiki-markdown")
depends=('bash' 'vim')
sha1sums=('SKIP')

package() {
  install -d "$pkgdir/usr/share/doc/arch-wiki-markdown"
  install -m 0644 $srcdir/$pkgname/wiki/* "$pkgdir/usr/share/doc/arch-wiki-markdown"
  install -Dm 0755 $srcdir/$pkgname/arch-wiki "$pkgdir/usr/bin/arch-wiki"
}

