SPArch
======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  Summary help replacing me
  ----------------------------------------------------------
  A guide to getting Arch Linux to run on a sparc machine.

Note:Currently there is no SPArch installation media so you must follow
steps along the lines of Install from Existing Linux. Note also that
there are not many repositories currently, and they do not have many
packages.

Contents
--------

-   1 Installing pacman on your host system
-   2 Setting up a chroot
-   3 Building a bootable base system
-   4 Sharing your packages with others
-   5 Packages needed for a base system (sparc64)

Installing pacman on your host system
-------------------------------------

First you need to get pacman:

    $ wget http://dcampbell.info/archlinux/core/os/sparc64/pacman-3.4.1-1-sparc64.pkg.tar.gz

If you do not mind littering your root, you can install pacman this way:

    # cd /
    # tar xzf /where/put/pacman-3.4.1-1-sparc64.pkg.tar.gz

Once you have pacman on your host system, you will need to edit
pacman.conf. Tell pacman to use one of the SPArch package repositories.

    # vim /etc/pacman.conf
    [core]
    Server = http://dcampbell.info/archlinux/$repo/os/$arch/
    [extra]
    Server = http://dcampbell.info/archlinux/$repo/os/$arch/

In order for pacman to work, you may also need to first install some
other packages. In Debian testing, I had to install xz-utils and
libarchive-dev. I then had to install libfetch and openssl from the
SPArch repository

    $ wget http://dcampbell.info/archlinux/core/os/sparc64/openssl-1.0.0.a-3-sparc64.pkg.tar.gz
    $ wget http://dcampbell.info/archlinux/core/os/sparc64/libfetch-2.33-1-sparc64.pkg.tar.gz
    $ cd /
    # tar xzf /path/to/openssl
    # tar xzf /path/to/libfetch

Setting up a chroot
-------------------

For this section follow the directions on Install_from_Existing_Linux.

Building a bootable base system
-------------------------------

Since packages are missing from the SPArch repository, you will have to
build some yourself to get a working system. To do this, you will want
to either install abs into your chroot or on your host (depending on
whether your chroot has enough to compile what you need) and then modify
makepkg.conf for building sparc packages.

    # vim /etc/makepkg.conf
    CARCH="sparc64"
    CHOST="sparc64-unknown-linux-gnu"
    CFLAGS="-O2 -pipe -mcpu=v9"
    CXXFLAGS="-O2 -pipe -mcpu=v9"

Note: If you want to create 64 bit binaries, you must use the -m64 flag.
Otherwise, on a v9 system you will get 32 bit v8+ binaries. Most of the
time you probably do not want 64 bit binaries: they will use more memory
and be slower unless processing large data.

If you plan to share the packages you build, please also set the
PACKAGER variable and make sure PKGEXT is '.pkg.tar.xz'

To update a PKGBUILD for building for sparc64:

    sed -i.old "s/arch=(/arch=('sparc64' /" PKGBUILD

Sharing your packages with others
---------------------------------

We need to figure out how to maintain the sparc repositories so that we
can spread out the work of keeping a working set packages available to
others. --DaveKong 01:47, 8 November 2010 (EST)

Packages needed for a base system (sparc64)
-------------------------------------------

base:

-   attr
-   bash
-   binutils
-   bzip2
-   coreutils
-   cryptsetup
-   dash
-   dcron
-   device-mapper
-   dhcpcd
-   diffutils
-   e2fsprogs
-   file
-   filesystem
-   findutils
-   gawk
-   gcc-libs
-   gen-init-cpio
-   gettext
-   glibc
-   grep
-   grub
-   gzip
-   initscripts
-   iputils
-   jfsutils
-   kernel26
-   less
-   libusb
-   licenses
-   logrotate
-   lzo2
-   mailx
-   man-db
-   man-pages
-   mdadm
-   net
-   pacman
-   pam
-   pciutils
-   pcmciautils
-   perl
-   ppp
-   procps
-   psmisc
-   reiserfsprogs
-   rp-pppoe
-   sed
-   shadow
-   sysfsutils
-   syslog-ng
-   sysvinit
-   tar
-   tcp_wrappers
-   texinfo
-   udev
-   usbutils
-   util-linux-ng
-   vi
-   wget
-   which
-   wpa_supplicant
-   xfsprogs

base-devel:

-   autoconf
-   automake
-   bison
-   fakeroot
-   flex
-   gcc
-   libtool
-   m4
-   make
-   patch
-   pkg-config

Retrieved from
"https://wiki.archlinux.org/index.php?title=SPArch&oldid=206906"

Category:

-   Arch development

-   This page was last modified on 13 June 2012, at 14:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
