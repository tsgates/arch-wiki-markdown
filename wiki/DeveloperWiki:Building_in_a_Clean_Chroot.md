DeveloperWiki:Building in a Clean Chroot
========================================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Why                                                                |
| -   3 Convenience Way                                                    |
| -   4 Classic Way                                                        |
|     -   4.1 Setting Up A Chroot                                          |
|     -   4.2 Building in the Chroot                                       |
|                                                                          |
| -   5 Handling Major Rebuilds                                            |
| -   6 Alternate Rebuild Handling                                         |
|     -   6.1 Using a custom repo                                          |
|     -   6.2 Manual package installation                                  |
|     -   6.3 Installation after building                                  |
+--------------------------------------------------------------------------+

Introduction
============

This article is part of the DeveloperWiki.

Why
===

Building in a clean chroot prevents missing dependencies in packages,
whether due to unwanted linking or packages missing in the depends array
in the PKGBUILD. It also allows users to build a package for the stable
repositories (core, extra, community) while having packages from
[testing] installed.

Convenience Way
===============

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
===========

Setting Up A Chroot
-------------------

The devtools package provides tools for creating and building within
clean chroots. Install it if not done already:

    pacman -S devtools

To make a clean chroot, create a directory in which the chroot will
reside. For example, $HOME/chroot.

Now create the chroot:

    CHROOT=$HOME/chroot
    mkdir $CHROOT
    sudo mkarchroot $CHROOT/root base base-devel sudo

Note:One can also define the CHROOT variable in $HOME/.bashrc using the
export command if the location is to be repeatedly used.

Edit $CHROOT/root/etc/makepkg.conf to set the packager name and any
makeflags. Also adjust the mirror list in
$CHROOT/root/etc/pacman.d/mirrorlist and enable [testing] in
$CHROOT/root/etc/pacman.conf if desired.

Alternatively, provide a custompacman.conf and makepkg.conf with the
following:

    sudo mkarchroot -C <pacman.conf> -M <makepkg.conf> $CHROOT/root base base-devel sudo

It is recommended however users do not use custom pacman.conf and
makepkg.conf during the initial creation of clean chroot to ensure no
user-specific adjustments are made. Use with caution.

Building in the Chroot
----------------------

Firstly, make sure the chroot is up to date with:

    sudo mkarchroot -u $CHROOT/root

Then, to build a package in the chroot, run the following from the dir
containing the PKGBUILD:

    sudo makechrootpkg -c -r $CHROOT

A unionfs is used to maintain the clean chroot during building. All
installed dependencies or makedepends and other changes made during
building are done in $CHROOT/rw. Passing the -c flag to makechrootpkg
ensures that this directory is cleaned before building starts.

Handling Major Rebuilds
=======================

The cleanest way to handle a major rebuild is to create a new chroot and
build the first package (typically the package for which the rebuild is
meant). Then create a local repo inside the new chroot. To do this:

    sudo mkdir $CHROOT/root/repo
    sudo chmod 0777 $CHROOT/root/repo

The chmod statement allows for the coping of package files and for the
creation of the local repo as your user rather than root.

    cp <package> $CHROOT/root/repo
    cd $CHROOT/root/repo
    repo-add local.db.tar.gz <package>

Then add the local repo to $CHROOT/root/etc/pacman.conf

    [local]
    Server = file:///repo

As long as you add only self built packages to this repo, you can add

    SigLevel = TrustAll

and update the repo:

    sudo mkarchroot -u $CHROOT/root

With every additional package rebuilt, copy the package to the local
repo directory, add it to the repo database and update the chroot.

Alternate Rebuild Handling
==========================

The above directions will work fine, but they can dirty the "pristine"
chroot that makechrootpkg tries to keep in check (that is the point of
using unionfs - dirtying a separate 'rw' directory).

Using a custom repo
-------------------

Follow the steps above to setup a local repo inside the chroot.

Build packages using:

    sudo makechrootpkg -r $CHROOT -u

The -u will update the chroot before building (-Syu) but updates will be
installed to the rw layer, maintaining a clean chroot.

Manual package installation
---------------------------

Packages can be installed manually to the rw layer of the chroot by
using:

    sudo makechrootpkg -r $CHROOT -I package-1.0-1-i686.pkg.tar.gz

Installation after building
---------------------------

Tell makechrootpkg to simply install a package to the rw layer of the
chroot after building by passing the -i arg. Unrecognized args get
passed to makepkg, so this calls `makepkg` with the -i arg.

    sudo makechrootpkg -r $CHROOT -- -i

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Building_in_a_Clean_Chroot&oldid=245841"

Category:

-   DeveloperWiki
