DeveloperWiki:Building in a Clean Chroot
========================================

Contents
--------

-   1 Introduction
-   2 Why
-   3 Convenience Way
-   4 Classic Way
    -   4.1 Setting Up A Chroot
        -   4.1.1 Custom pacman.conf
    -   4.2 Building in the Chroot
    -   4.3 Manual package installation
    -   4.4 Installation after building
-   5 Handling Major Rebuilds

Introduction
------------

This article is part of the DeveloperWiki.

Why
---

Building in a clean chroot prevents missing dependencies in packages,
whether due to unwanted linking or packages missing in the depends array
in the PKGBUILD. It also allows users to build a package for the stable
repositories (core, extra, community) while having packages from
[testing] installed.

Convenience Way
---------------

To quickly build a package in a chroot without any further tinkering,
one can use the helper scripts from the devtools package.

These helper scripts should be called in the same directory where the
PKGBUILD is, just like with makepkg. For instance, extra-i686-build
automatically sets up chroot in /var/lib/archbuild, updates it, and
builds a package for the extra repository. For multilib builds there is
just multilib-build without an architecture.

Tip:Consult the table below for information on which script to use when
building for a specific repository and architecture.

Note:[core] is omitted because those packages are required to go through
[testing] first before landing in [core].

  Target repository             Architecture   Build script to use
  ----------------------------- -------------- ------------------------
  extra / community             i686           extra-i686-build
  extra / community             x86_64         extra-x86_64-build
  testing / community-testing   i686           testing-i686-build
  testing / community-testing   x86_64         testing-x86_64-build
  staging / community-staging   i686           staging-i686-build
  staging / community-staging   x86_64         staging-x86_64-build
  multilib                      x86_64         multilib-build
  multilib-testing              x86_64         multilib-testing-build
  multilib-staging              x86_64         multilib-staging-build

Classic Way
-----------

> Setting Up A Chroot

The devtools package provides tools for creating and building within
clean chroots. Install it if not done already:

    # pacman -S devtools

To make a clean chroot, create a directory in which the chroot will
reside. For example, $HOME/chroot.

    $ mkdir ~/chroot

Define the CHROOT variable:

    # CHROOT=$HOME/chroot

Now create the chroot (the sub directory root is required because the
$CHROOT directory will get other sub directories for clean working
copies):

    # mkarchroot $CHROOT/root base-devel

Note:One can also define the CHROOT variable in $HOME/.bashrc using the
export command if the location is to be repeatedly used.

Edit ~/.makepkg.conf to set the packager name and any makeflags. Also
adjust the mirrorlist in $CHROOT/root/etc/pacman.d/mirrorlist and enable
the testing repository in $CHROOT/root/etc/pacman.conf, if desired.

Custom pacman.conf

Alternatively, provide a custom pacman.conf and makepkg.conf with the
following:

    # mkarchroot -C <pacman.conf> -M <makepkg.conf> $CHROOT/root base-devel

Warning: Using a custom pacman.conf or makepkg.conf during the initial
creation of clean chroot can result in unintended custom adjustments to
the chroot environment. Use with caution.

> Building in the Chroot

Firstly, make sure the chroot is up to date with:

    # arch-nspawn $CHROOT/root pacman -Syu

Then, to build a package in the chroot, run the following from the dir
containing the PKGBUILD:

    # makechrootpkg -c -r $CHROOT

Passing the -c flag to makechrootpkg ensures that the working chroot
(named $CHROOT/$USERNAME) is cleaned before building starts.

> Manual package installation

Packages can be installed manually to the working chroot by using:

    # makechrootpkg -r $CHROOT -I package-1.0-1-i686.pkg.tar.xz

If done from a directory that contains a PKGBUILD, the package will then
be built. Avoid being in such a directory if you want to just install
the package.

> Installation after building

Tell makechrootpkg to simply install a package to the rw layer of the
chroot after building by passing the -i arg. Unrecognized args get
passed to makepkg, so this calls `makepkg` with the -i arg.

    # makechrootpkg -r $CHROOT -- -i

Handling Major Rebuilds
-----------------------

The cleanest way to handle a major rebuild is to use the [staging]
repositories. Build the first package against [extra] and push it to
[staging]. Then rebuild all following packages against [staging] and
push them there.

If you can't use [staging], you can build against custom packages using
a command like this:

    # extra-x86_64-build -- -I ~/packages/foobar/foobar-2-1-any.pkg.tar.xz

You can specify more than one package to be installed using multiple -I
arguments.

A simpler, but dirtier way to handle a major rebuild is to install all
built packages in the chroot, never cleaning it. Build the first package
using:

    # extra-x86_64-build

And build all following packages using:

    # makechrootpkg -n -r /var/lib/archbuild/extra-x86_64

Running namcap (the -n argument) implies installing the package in the
chroot. *-build also does this by default.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Building_in_a_Clean_Chroot&oldid=286773"

Category:

-   DeveloperWiki

-   This page was last modified on 7 December 2013, at 03:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
