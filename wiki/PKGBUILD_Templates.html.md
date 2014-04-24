PKGBUILD Templates
==================

Basic PKGBUILD
--------------

You can find prototype package build and .install files in
/usr/share/pacman.

    # Maintainer: Your Name <youremail@domain.com>
    pkgname=NAME
    pkgver=VERSION
    pkgrel=1
    pkgdesc=""
    arch=()
    url=""
    license=('GPL')
    groups=()
    depends=()
    makedepends=()
    optdepends=()
    provides=()
    conflicts=()
    replaces=()
    backup=()
    options=()
    install=
    changelog=
    source=(http://server/$pkgname-$pkgver.tar.gz)
    noextract=()
    md5sums=() #autofill with 'updpkgsums'

    build() {
      cd "$srcdir/$pkgname-$pkgver"

      ./configure --prefix=/usr
      make
    }

    package() {
      cd "$srcdir/$pkgname-$pkgver"

      make DESTDIR="$pkgdir/" install
    }

> Basic PKGBUILD with Links and Comments

    # Maintainer: Your Name <your email>

    # Name of the Software your PKGBUILD will install - should be unique. See PKGBUILD#pkgname
    pkgname=derp

    # The version number for the software
    pkgver=6.6.6

    # The release number for the arch package, as fixes are added to the PKGBUILD, the release number will increase
    pkgrel=9001

    # The description of the package, should be about 80 characters long (one line)
    pkgdesc="Derp is an example package for this PKGBUILD file."

    # The type of processor this software can build and work on. See PKGBUILD#arch
    arch=('i686' 'x86_64')

    # The official website for the software your PKGBUILD will install
    url="https://archlinux.org"

    # The License that the software is released under. See PKGBUILD#license
    license=('GPL3')

    # The group a package belongs in. An example would be kdebase (install all the KDE  packages)
    groups=allyourdatabasearebelongtous

    # Packages that your software needs to run. If the dependancy requires a minimum version number use the >= operator
    depends=('herp' 'fuuuuu>=2.0')

    # Packages that must be installed to build the software, but at not necessary to run it
    makedepends=('pony' 'wings' 'horns' 'supercompany2600')

    # Optional packages that extend the software's functionality
    optdepends=('derp-hoofbar: a browser plugin')

    # List of Package names that this PKGBUILD provides. Put modified packages that will be installed here.
    provides=('lol-git')

    # Packages that cannot be installed at the same time as this package
    conflicts=('pegasi')

    # Obsolete Packages that this Package replaces
    replaces=('dinky')

    # User files that should be saved. They are kept as Pacnew and Pacsave Files
    backup=('etc/derp.conf')

    # Change the default behavior of makepkg see PKGBUILD#options
    options=

    install='foo.install'

    # Source for the package, you can specify a folder (for git or download name to overriding the default
    # name saved useful if the upstream use tarballs named 'pinkieþæý' for example
    source=("${pkgname}.tar.gz::http://server.tl;dr/${pkgname}-${pkgver}.tar.gz"
            "derp.desktop")
    md5sums=('a0b2c3d4e5f6g7h8i9'
             'j10k11l12m13n14o15')

For more details, see PKGBUILD.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PKGBUILD_Templates&oldid=304591"

Category:

-   Package development

-   This page was last modified on 15 March 2014, at 10:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
