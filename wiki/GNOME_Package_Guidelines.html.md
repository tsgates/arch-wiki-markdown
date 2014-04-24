GNOME Package Guidelines
========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

The GNOME packages on Arch Linux follow a certain schema.

Contents
--------

-   1 GNOME profile initialization
-   2 GConf schemas
-   3 GSettings schemas
-   4 Scrollkeeper documentation
-   5 .desktop files
-   6 GTK icon cache
-   7 .install files
-   8 Example

GNOME profile initialization
----------------------------

There is no GNOME profile initialization anymore. The old line below
should be stripped from any PKGBUILD:

    [ -z "$GNOMEDIR" ] && . /etc/profile.d/gnome.sh

GConf schemas
-------------

Many GNOME packages install GConf schemas. These schemas get installed
in the system GConf database, which has to be avoided. Some packages
provide a --disable-schemas-install switch for ./configure, which hardly
ever works. Therefore, gconftool-2 has a variable called
GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL, whenever this is set, gconftool-2
will not update any databases.

When creating packages that install schema files, use

    make GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL=1 DESTDIR=${pkgdir} install

for the package installation step in the PKGBUILD.

GConf schemas need to be installed and removed in the .install file
using pre_remove, pre_upgrade and post_upgrade and post_install. Use
gconf-merge-schemas to merge several schemas into one package specific
file, install or uninstall them with
usr/sbin/gconfpkg --(un)install $pkgname The usage of gconfpkg requres a
dependency on gconf>=2.18.0.1-4 (or gconfmm>=2.20.0).

GSettings schemas
-----------------

The GConf schemas will be replaced by GSettings schemas in the near
future, but some applications (e.g. Empathy) already using it. GSettings
uses dconf as backend, so all packages that contain GSettings schemas
require dconf as dependency. When a new GSettings schema installed on
the system, the GSettings database should be recompiled, but not when
packaging. To avoid recompiling GSettings database on packaging, use the
--disable-schemas-compile switch for ./configure. To recompile it on
install, add the following line to the .install file using post_install,
post_upgrade and post_remove:

    glib-compile-schemas usr/share/glib-2.0/schemas

Scrollkeeper documentation
--------------------------

Starting from GNOME 2.20 there is no need to handle scrollkeeper
anymore, as rarian reads OMF files directly. Scrollkeeper-update is a
dummy these days. The only required thing now is to makedepend on
gnome-doc-utils>=0.11.2.

.desktop files
--------------

Many packages install Freedesktop.org compatible .desktop files and
register MimeType entries in them. Running update-desktop-database -q in
post_install and post_remove is recommended (package should depend on
desktop-file-utils in this case).

GTK icon cache
--------------

Quite some packages install icons in the hicolor icon theme. These
packages should depend on hicolor-icon-theme and should have
gtk-update-icon-cache -q -t -f usr/share/icons/hicolor (WITHOUT leading
slash) in the post_install, post_upgrade and post_remove function.

.install files
--------------

For many GNOME packages, all .install files look almost exactly the
same. The gedit package contains a very generic install file:
https://projects.archlinux.org/svntogit/packages.git/tree/gedit/repos/extra-x86_64/gedit.install

Basically, the only thing that has to be changed is the pkgname variable
on top of the .install file. As long as pacman does not supply us with
the pkgname variable, we need to supply it in the .install file. When
packages do not have gconf schemas, hicolor icon files, or .desktop
files, remove the parts that handle those subjects.

Example
-------

For an example of above rules, take a look at the gedit PKGBUILD and the
.install file supplied above:
https://projects.archlinux.org/svntogit/packages.git/tree/gedit/repos/extra-x86_64/

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNOME_Package_Guidelines&oldid=259122"

Category:

-   Package development

-   This page was last modified on 27 May 2013, at 15:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
