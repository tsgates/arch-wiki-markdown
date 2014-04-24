Dynamic Kernel Module Support
=============================

Dynamic Kernel Module Support allows one to compile and install kernel
modules without recompiling the entire kernel.

Contents
--------

-   1 Installation
-   2 Enabling on boot
-   3 Usage
-   4 Submitting my first DKMS package
    -   4.1 Package name
    -   4.2 Dependencies
    -   4.3 Sources location
    -   4.4 Patching
    -   4.5 Loading/reloading modules automatically in .install?
    -   4.6 Namcap output
    -   4.7 Example files
        -   4.7.1 PKGBUILD
        -   4.7.2 dkms.conf
        -   4.7.3 .install
-   5 Disadvantages
    -   5.1 DKMS breaks the Pacman database
-   6 See Also

Installation
------------

Install dkms from the official repositories.

After installation, you still need package(s) that take advantage of it.
Some of these packages include:

-   Catalyst version: catalyst-dkms
-   Nvidia version: nvidia-dkms
-   VMware modules version: vmware-modules-dkms

Enabling on boot
----------------

To have modules automatically rebuilt after each kernel upgrade, enable
the dkms service:

    # systemctl enable dkms.service

If a userspace component (such as Nvidia or Catalyst X driver) is
started before the DKMS module is rebuilt, you often need to reboot (or
restart the component).

Usage
-----

To rebuild all DKMS modules for a kernel (e.g. after an upgrade), use:

    # dkms autoinstall -k 3.13.6-1-ARCH

Building a specific module is also possible (e.g. for current kernel):

    # dkms install -m nvidia -v 334.21 -k $(uname -r)

or simply:

    # dkms install nvidia/334.21 -k $(uname -r)

To build a module for all kernels, use:

    # dkms install nvidia/334.21 --all

Tip:Tab completion for module and kernel versions is available.

Submitting my first DKMS package
--------------------------------

Here are some guidelines to follow for creating and submitting your
first DKMS package to the AUR.

> Package name

DKMS packages are named by appending "-dkms" to their names. Those
beginning with "dkms-" should be renamed to follow this format.

A variable for $pkgname minus the "-dkms" suffix ($_pkgname or
$_pkgbase) is usually helpful in keeping the package in sync with the
non-DKMS version.

> Dependencies

Dependencies can be taken straight from the non-DKMS version. dkms
should then be added and linux-headers removed (dkms already lists it as
optional).

> Sources location

Sources should go into /usr/src/PACKAGE_NAME-PACKAGE_VERSION/, which is
the default path for DKMS commands. PACKAGE_NAME and PACKAGE_VERSION are
both set in dkms.conf.

-   PACKAGE_NAME - the actual project name (usually $_pkgname or
    $_pkgbase).

-   PACKAGE_VERSION - by convention this should also be the $pkgver.

> Patching

The sources can be patched either directly in the PKGBUILD or through
dkms.conf.

For simplicity it can be preferable to keep the DKMS PKGBUILD as close
to the non-DKMS version as possible and apply patches in the PKGBUILD.

> Loading/reloading modules automatically in .install?

Loading and unloading modules should be left to the user.

Consider a case where a module crashes when loaded. That could end up
halting the entire system, which is pretty severe.

> Namcap output

We have written this great utility called Namcap, which attempts to
check for common mistakes and non-standard decisions in your packages.
It's a good practice to have it run at least once on any package,
however, it isn't perfect and has not been updated for DKMS specific
guidelines.

For example, DKMS uses /usr/src/ by default, but Namcap believes this to
be a non-standard directory, even though its reference states /usr/src
as optional (Filesystem Hierarchy Standard (FHS)).

> Example files

Here's an example package that edits dkms.conf according to the package
name and version.

PKGBUILD

    PKGBUILD

    # Maintainer: foo <foo(at)gmail(dot)com>
    # Contributor: bar <bar(at)gmai(dot)com>

    _pkgbase=amazing
    pkgname=amazing-dkms
    pkgver=1
    pkgrel=1
    pkgdesc="The Amazing kernel modules (DKMS)"
    arch=('i686' 'x86_64')
    url="https://www.amazing.com/"
    license=('GPL2')
    depends=('dkms')
    conflicts=("${_pkgbase}")
    install=${pkgname}.install
    source=("${url}/files/tarball.tar.gz"
            'dkms.conf'
            'linux-3.14.patch')
    md5sums=(use 'updpkgsums')

    build() {
      cd ${_pkgbase}-${pkgver}

      # Patch
      patch -p1 -i "${srcdir}"/linux-3.14.patch

      # Build
      msg2 "Starting ./configure..."
      ./configure

      msg2 "Starting make..."
      make
    }

    package() {
      # Install
      make DESTDIR="${pkgdir}" install

      # Copy dkms.conf
      install -Dm644 dkms.conf "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/dkms.conf

      # Set name and version
      sed -e "s/@_PKGBASE@/${_pkgbase}/" \
          -e "s/@PKGVER@/${pkgver}/" \
          -i "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/dkms.conf

      # Copy sources (including Makefile)
      cp -r ${_pkgbase}/* "${pkgdir}"/usr/src/${_pkgbase}-${pkgver}/
    }

dkms.conf

    dkms.conf

    PACKAGE_NAME="@_PKGBASE@"
    PACKAGE_VERSION="@PKGVER@"
    MAKE[0]="make --uname_r=$kernelver"
    CLEAN="make clean"
    BUILT_MODULE_NAME[0]="@_PKGBASE@"
    DEST_MODULE_LOCATION[0]="/kernel/drivers/misc"
    AUTOINSTALL="yes"

.install

Instead of depmod we can now use dkms install (depends on dkms build,
which depends on dkms add):

    amazing-dkms.install

    # old version (without -$pkgrel): ${1%%-*}
    # new version (without -$pkgrel): ${2%%-*}

    post_install() {
        dkms install amazing/${1%%-*}
    }

    pre_upgrade() {
        pre_remove ${2%%-*}
    }

    post_upgrade() {
        post_install ${1%%-*}
    }

    pre_remove() {
        dkms remove amazing/${1%%-*} --all
    }

Tip:To keep DKMS packages closer to their non-DKMS counterparts: avoid
cluttering up package files with DKMS-specific stuff (e.g. version
numbers that need updating).

Disadvantages
-------------

> DKMS breaks the Pacman database

The problem is that the resulting modules don't belong to the package
anymore, so Pacman can't track them.

Support could be added through hooks (see: FS#2985).

See Also
--------

-   Ubuntu's man page
-   Linux Journal: Exploring Dynamic Kernel Module Support

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dynamic_Kernel_Module_Support&oldid=306186"

Category:

-   Kernel

-   This page was last modified on 20 March 2014, at 21:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
