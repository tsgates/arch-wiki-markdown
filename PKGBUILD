pkgname=arch-wiki-markdown
pkgrel=1
pkgdesc="markdown arch wiki"
arch=('any')
author="Taesoo Kim"

build() {
}

package() {
  cd "$srcdir/$pkgname"
  install -d "$pkgdir/usr/share/doc/arch-wiki-markdown"
  install -m 0644 $srcdir/../wiki/* "$pkgdir/usr/share/doc/arch-wiki-markdown"
}

