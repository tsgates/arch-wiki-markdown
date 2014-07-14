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
    cd arch-wiki-docs
    echo "Downloading Wiki"
    [[ -d "${srcdir}/${_pkgname}/arch-wiki-docs" ]] && rm -rf "${srcdir}/${_pkgname}/arch-wiki-docs"
    python arch-wiki-docs.py --output-directory "${srcdir}/${_pkgname}/arch-wiki-docs" --clean --safe-filenames
}

build() {
    cd $_pkgname
    echo "Converting Wiki"
    [[ -d "wiki" ]] && rm -rf wiki
    install -d wiki
    echo $pkgver > wiki/version
    while read -r file; do
        MDFILE="wiki/$(sed 's|^.*/||;s|\.html$||' <<< $file).md"
        echo "Converting: ${file} -> ${MDFILE}"
        ./html2md.js "$file" > "$MDFILE"
    done < <(find arch-wiki-docs/${_wiki_lang}/ -type f)
    echo "Done!"
}

package() {
    cd $_pkgname
    echo "Installing Wiki"
    install -Dm755 arch-wiki "${pkgdir}/usr/bin/arch-wiki"
    install -d "${pkgdir}/usr/share/doc/${_pkgname}/"
    cp --no-preserve=ownership wiki/* "${pkgdir}/usr/share/doc/${_pkgname}/"
}
