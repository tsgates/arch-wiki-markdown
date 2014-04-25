DeveloperWiki:PKGBUILD.com
==========================

Contents
--------

-   1 Directories that must be used
-   2 Creating chroots and building packages
-   3 i686
-   4 x86_64
-   5 Packager && Makeflags
-   6 Connecting to sigurd or gerolde from brynhild
-   7 Generating rebuilding list when soname is bumped

Directories that must be used
-----------------------------

All users should use only ~/packages for storing packages builds and
~/svn-packages. These directories are excluded from backups and all
other directories are automatically backed up.

Creating chroots and building packages
--------------------------------------

Devtools 0.9.10 has build helpers that can be used.

    /usr/bin/extra-i686-build
    /usr/bin/extra-x86_64-build
    /usr/bin/multilib-build
    /usr/bin/staging-i686-build
    /usr/bin/staging-x86_64-build
    /usr/bin/testing-i686-build
    /usr/bin/testing-x86_64-build

This can be used to _create_ and build packages. Chroots are created by
default in /var/tmp/archbuild. To build packages that depend on each
other you should use makechrootpkg directly.

    $ sudo extra-i686-build
    $ sudo testing-x86_64-build

i686
----

    $ setarch i686 sudo makechrootpkg -cr /var/lib/archbuild/extra-i686 -- -i

next package

    $ setarch i686 sudo makechrootpkg -r /var/lib/archbuild/extra-i686

x86_64
------

    $ sudo makechrootpkg -cr /var/lib/archbuild/extra-x86_64 -- -i

next package

    $ sudo makechrootpkg -r /var/lib/archbuild/extra-x86_64

Packager && Makeflags
---------------------

    Add ~/.makepkg.conf with PACKAGER information

    PACKAGER="Name <email>"
    MAKEFLAGS="-j5"

Connecting to sigurd or gerolde from brynhild
---------------------------------------------

On your local system add this:

    $ cat .ssh/config
      Host pkgbuild.com
        Hostname pkgbuild.com
        User youruser
        ForwardAgent yes

Generating rebuilding list when soname is bumped
------------------------------------------------

Available in repo-tools.git
(https://projects.archlinux.de/repo-tools.git/) and available on
brynhild:

    $ sogrep <repo> <soname>
    $ sogrep extra x264.so.107

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:PKGBUILD.com&oldid=209663"

Category:

-   Arch development

-   This page was last modified on 16 June 2012, at 18:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
