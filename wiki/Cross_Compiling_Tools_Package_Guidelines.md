Cross Compiling Tools Package Guidelines
========================================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Important note                                                     |
| -   2 Version compatibility                                              |
| -   3 Building a Cross Compiler                                          |
| -   4 Package naming                                                     |
| -   5 File Placement                                                     |
| -   6 Example                                                            |
| -   7 Hows and whys                                                      |
|     -   7.1 Q: Why not installing into /opt?                             |
|     -   7.2 Q: What is that out-of-path executables thing?               |
|                                                                          |
| -   8 Troubleshooting                                                    |
|     -   8.1 Q: What to do if compilation fails without clear message?    |
|     -   8.2 Q: What does this error [error message] means?               |
|     -   8.3 Q: Why do files get installed in wrong places?               |
|                                                                          |
| -   9 See also                                                           |
+--------------------------------------------------------------------------+

  

Tip:As alternative for creation of cross-compiler packages you could use
crosstool-ng and create you own toolchain in fully automated way.
crosstool-ng can be found on crosstool-ng

.

Important note
--------------

This page describes new way of doing things, inspired by follwing
packages in [community]:

-   mingw32-gcc and other packages from mingw32-* series
-   arm-elf-gcc-base and other packages from arm-elf-* series
-   arm-wince-cegcc-gcc and other packages from arm-wince-cegcc-* series

Version compatibility
---------------------

Warning:Using incompatible version of packages for toolchain compilation
leads to inevitable failures. By default consider all versions
incompatible.

Following strategies allows to select compatible vesions of gcc,
binutils, kernel and C library:

-   General rules:
    -   there is correlation between gcc and binutils releases, use
        simultaneously released versions;
    -   it is better to use latest kernel headers to compile libc but
        use --enable-kernel switch (specific to glibc, other C libraries
        may use different conventions) to enforce work on older kernels;

-   Official repositories: you may have to apply additional fixes and
    hacks, but versions used by Arch Linux (or it's
    architecture-specific forks) most probably can be made to work
    together;
-   Software documentation: all GNU software have README and NEWS files,
    documenting things like minimal required versions of dependencies;
-   Other distributions: they too do cross-compilation
    -   Gentoo crossdev lists some working combinations.

-   http://cross-lfs.org covers steps, necessary for building
    cross-compiler and mentions somewhat up-to-date versions of
    dependencies.

Building a Cross Compiler
-------------------------

The general approach to building a cross compiler is:

1.  binutils: Build a cross-binutils, which links and processes for the
    target architecture
2.  headers: Install a set of C library and kernel headers for the
    target architecture
    1.  use linux-api-headers as reference and pass
        ARCH=target-architecture to make
    2.  create libc headers package (process for Glibc is described
        here)

3.  gcc-stage-1: Build a basic (stage 1) gcc cross-compiler. This will
    be used to compile the C library. It will be unable to build almost
    anything else (because it can't link against the C library it
    doesn't have).
4.  libc: Build the cross-compiled C library (using the stage 1 cross
    compiler).
5.  gcc-stage-2: Build a full (stage 2) C cross-compiler

The source of the headers and libc will vary across platforms.

Tip:Exact procedure varies greatly, depending on your needs. For
example, if you want to create a "clone" of an Arch Linux system with
the same versions of kernel and glibc, you can skip building headers and
pass --with-build-sysroot=/ to configure.

Package naming
--------------

The package name shall not be prefixed with the word cross- (it was
previously proposed, but was not adopted in official packages, probably
due to additional length of names), and shall consist of the package
name, prefixed by GNU triplet without vendor field or with "unknown" in
vendor field; example: arm-linux-gnueabihf-gcc. If shorter naming
convention exists (e.g. mips-gcc), it may be used, but this is not
recommended.

File Placement
--------------

Latest versions of gcc and binutils use non-conflicting paths for
sysroot and libraries. Executables shall be placed into /usr/bin/, to
prevent conflicts here, prefix all of them with architecture name.

Typically, ./configure would have at least following parameters:

    _target=<your-target> # e.g. i686-pc-mingw32
    _sysroot=/usr/lib/${_target}
    ...
    ./configure \
        --prefix=${_sysroot} --sysroot=${_sysroot} \
        --bindir=/usr/bin

Example
-------

This is PKGBUILD for binutils for MinGW. Things worth noticing are:

-   specifying root directory of the cross-environment
-   usage of ${_pkgname}, ${_target} and ${_sysroot} variables to make
    the code more readable
-   removal of the duplicated/conflicting files

    # Maintainer: Allan McRae <allan@archlinux.org>

    # cross toolchain build order: binutils, headers, gcc (pass 1), w32api, mingwrt, gcc (pass 2)

    _target=i686-pc-mingw32
    _sysroot=/usr/lib/cross-${_target}

    pkgname=cross-${_target}-binutils
    _pkgname=binutils
    pkgver=2.19.1
    pkgrel=1
    pkgdesc="MinGW Windows binutils"
    arch=('i686' 'x86_64')
    url="http://www.gnu.org/software/binutils/"
    license=('GPL')
    depends=('glibc>=2.10.1' 'zlib')
    options=('!libtool' '!distcc' '!ccache')
    source=(http://ftp.gnu.org/gnu/${_pkgname}/${_pkgname}-${pkgver}.tar.bz2)
    md5sums=('09a8c5821a2dfdbb20665bc0bd680791')

    build() {
      cd ${srcdir}/${_pkgname}-${pkgver}
      mkdir binutils-build && cd binutils-build

      ../configure --prefix=${_sysroot} --bindir=/usr/bin \
        --with-sysroot=${_sysroot} \
        --build=$CHOST --host=$CHOST --target=${_target} \
        --with-gcc --with-gnu-as --with-gnu-ld \
        --enable-shared --without-included-gettext \
        --disable-nls --disable-debug --disable-win32-registry
      make
      make DESTDIR=${pkgdir}/ install
      
      # clean-up cross compiler root
      rm -r ${pkgdir}/${_sysroot}/{info,man}
    }

Note:During cross-toolchain building always execute configure and make
commands from dedicated directory (so-called out-of-tree compilation)
and remove whole src directory after slightest change in PKGBUILD.

Hows and whys
-------------

Q: Why not installing into /opt?

A: Two reasons:

1.  First, according to File Hierarchy Standard, these files just belong
    somewhere to /usr. Period.
2.  Second, installing into /opt is a last measure when there is no
    other option.

Q: What is that out-of-path executables thing?

A: This weird thing allows easier cross-compiling. Sometimes, project
Makefiles do not use CC & co. variables and instead use gcc directly. If
you just want to try to cross-compile such project, editing the Makefile
could be a very lengthy operation. However, changing the $PATH to use
"our" executables first is a very quick solution. You would then run
PATH=/usr/arch/bin/:$PATH make instead of make.

  

Troubleshooting
---------------

Q: What to do if compilation fails without clear message?

A: For error, occurred during running configure, read
$srcdir/pkgname-build/config.log. For error, occurred during
compilation, scroll console log up or search for word "error".

Q: What does this error [error message] means?

A: Most probably you made some of non-obvious errors:

-   Too many or too few configuration flags. Try to use already proven
    set of flags.
-   Dependencies are corrupted. For example misplaced or missing
    binutils files may result in cryptic error during gcc configuration.
-   You did not add export CFLAGS="" to your build() function (see bug
    25672 in GCC Bugzilla).
-   Some --prefix/--with-sysroot combination may require directories to
    be writable (non-obvious from clfs guides).
-   sysroot does nor yet has kernel/libc headers.
-   If google-fu does not help, immediately abandon current
    configuration and try more stable/proven one.

Q: Why do files get installed in wrong places?

A: Various methods of running generic make install line results in
different results. For example, some make targets may not provide
DESTDIR support and instead require install_root usage. The same for
tooldir, prefix and other similar arguments. Sometimes providing
parameters as arguments instead of environment variables, e.g

    ./configure CC=arm-elf-gcc

instead of

    CC=arm-elf-gcc ./configure

and vice versa may result in different outcomes (often caused by
recursive self-invocation of configure/make).

See also
--------

http://wiki.osdev.org/GCC_Cross-Compiler

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cross_Compiling_Tools_Package_Guidelines&oldid=249001"

Category:

-   Package development
