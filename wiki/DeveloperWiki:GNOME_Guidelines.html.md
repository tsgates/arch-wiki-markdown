DeveloperWiki:GNOME Guidelines
==============================

Contents
--------

-   1 Introduction
-   2 Gnome profile initialization
-   3 GConf schemas:
-   4 Scrollkeeper documentation
-   5 .desktop files
-   6 GTK Icon cache
-   7 .install files

Introduction
============

The GNOME packages on Arch Linux follow a certain schema. The following
items are important considerations for packing GNOME software.

Gnome profile initialization
============================

There is no gnome profile initialization anymore. The old line below
should be stripped from any PKGBUILD:

    [ -z "$GNOMEDIR" ] && . /etc/profile.d/gnome.sh

GConf schemas:
==============

Many GNOME packages install GConf schemas. These schemas get installed
in the system GConf database, which has to be avoided.

Some packages provide a --disable-schemas-install switch for
./configure, which hardly ever works. Therefore, gconftool-2 has a
variable called GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL, whenever this is
set, gconftool-2 won't update any databases.

When creating packages that install schema files, use:

    make GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL=1 DESTDIR=$startdir/pkg install

for the package installation step in the PKGBUILD.

GConf schemas need to be installed and removed in the .install file
using pre_remove, pre_upgrade and post_upgrade and post_install. Use
gconf-merge-schemas to merge several schemas into one package specific
file, install or uninstall them with usr/sbin/gconfpkg --(un)install
$pkgname.

The usage of gconfpkg requres a dependency on gconf>=2.18.0.1-4 (or
gconfmm>=2.20.0).

Scrollkeeper documentation
==========================

Starting from GNOME 2.20 there's no need to handle scrollkeeper anymore,
as rarian reads OMF files directly. Scrollkeeper-update is a dummy these
days. The only required thing now is to makedepend on
gnome-doc-utils>=0.11.2.

.desktop files
==============

Many packages install Freedesktop.org compatible .desktop files and
register MimeType entries in them. Running "update-desktop-database -q"
in post_install() and post_remove() is recommended.

GTK Icon cache
==============

Quite some packages install icons in the hicolor icon theme. These
packages should depend on hicolor-icon-theme and should have
"gtk-update-icon-cache -q -t -f usr/share/icons/hicolor" in the
post_install, post_upgrade and post_remove function.

.install files
==============

For many gnome packages, all .install files look almost exactly the
same. The gedit package contains a very generic install file.

Basically, the only thing that has to be changed is the pkgname variable
on top of the .install file. As long as pacman doesn't supply us with
the pkgname variable, we need to supply it in the .install file. When
packages don't have gconf .schemas, hicolor icon files, or .desktop
files, remove the parts that handle those subjects.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:GNOME_Guidelines&oldid=161294"

Category:

-   DeveloperWiki

-   This page was last modified on 21 September 2011, at 18:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
