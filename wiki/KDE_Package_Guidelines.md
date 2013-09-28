KDE Package Guidelines
======================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

The KDE packages on Arch Linux follow a certain schema.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Build dir                                                          |
| -   2 Install prefix                                                     |
| -   3 Build type                                                         |
| -   4 Force Qt4                                                          |
| -   5 Package naming                                                     |
|     -   5.1 KDE Config Module                                            |
|     -   5.2 Plasmoids                                                    |
|     -   5.3 Runners                                                      |
|     -   5.4 Service Menus                                                |
|     -   5.5 Themes                                                       |
|                                                                          |
| -   6 .install files                                                     |
+--------------------------------------------------------------------------+

Build dir
---------

A good way of building CMake packages is to make a build directory
outside the root of the project and run cmake from that dir. The
PKGBUILD should look this way:

    prepare() {
     mkdir build
    }
    build() {
     cd build
     cmake ../${pkgname}-${pkgver}
    }

Install prefix
--------------

Every packages must set the CMAKE_INSTALL_PREFIX variable, but also we
have to respect custom built versions of KDE, so please use:

    -DCMAKE_INSTALL_PREFIX=$(kde4-config --prefix)

When a package is moved to [extra] or [community] that line must be
changed to:

    -DCMAKE_INSTALL_PREFIX=/usr

Build type
----------

Please specify the build type; this makes it really simple to rebuild a
package with debug symbols by just using a sed rule.

    -DCMAKE_BUILD_TYPE=Release

Force Qt4
---------

On systems where both qt4 and qt5-base are installed, `qmake` refers to
the 5.x version, so force cmake to use Qt4 this way:

    export QT_SELECT=4

Package naming
--------------

> KDE Config Module

KDE Config Module packages should be named kcm-module.

> Plasmoids

Plasmoids packages should be named kdeplasma-applets-plasmoidname so
that they are recognizable as KDE-related packages; this also
distinguishes them from the official packages.

> Runners

Plasma runners packages should be named kdeplasma-runners-runnername so
that they are recognizable as KDE-related packages; this also
distinguishes them from the official packages.

> Service Menus

Service menus packages should be named kde-servicemenus-servicename so
that they are recognizable as KDE-related packages

> Themes

Plasma themes packages should be named kdeplasma-themes-themename so
that they are recognizable as KDE-related packages.

.install files
--------------

For many KDE packages, all .install files look almost exactly the same.
Some packages install icons in the hicolor icon theme; use the
xdg-icon-resource utility provided by the xdg-utils package, which is a
dependency of the qt4 package. So use this line:

    xdg-icon-resource forceupdate --theme hicolor &> /dev/null

Many packages install Freedesktop.org compatible .desktop files and
register MimeType entries in them. Running update-desktop-database in
post_install is recommended as that tool is provided by the
desktop-file-utils package which is a dependency of the qt4 package. So
use this line:

    update-desktop-database -q

Retrieved from
"https://wiki.archlinux.org/index.php?title=KDE_Package_Guidelines&oldid=256152"

Category:

-   Package development
