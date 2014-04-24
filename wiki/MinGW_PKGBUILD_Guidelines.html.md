MinGW PKGBUILD Guidelines
=========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

This page expains how to write PKGBUILDs for software running on Windows
using GCC. There are two options to build software for Windows on Linux:

-   [mingw-w64.sourceforge.net]: provides 32 and 64-bit toolchains with
    secure crt, Vista+ API, DDK (ReactOS), and DirectX (WINE) support.
    For a full list of supported features and differences with the old
    MinGW.org, see here. Available from Arch's [community] repository by
    installing mingw-w64-gcc.
-   [www.MinGW.org]: provides 32-bit toolchains with limited DirectX
    support. It also suffers from long-standing breakage in the
    implementation of thread-local storage and the floating point
    library support. It has been removed from the official repositories
    and the AUR.

Contents
--------

-   1 Package naming
-   2 Packaging
-   3 Examples
    -   3.1 Autotools
    -   3.2 CMake

Package naming
--------------

A package for mingw-w64 should be named mingw-w64-pkgname. If a static
variant of the package is being built, suffix the package name with
-static (see below for the cases where this is necessary).

Packaging
---------

Packaging for cross platform packages can be fairly tricky as there are
many different build systems and low-level quirks. Take a note of the
following things though:

-   always add mingw-w64-crt to depends
-   always add mingw-w64-gcc to makedepends
-   always add !strip, staticlibs and !buildflags to options 
-   always use the original pkgdesc and append (mingw-w64) to the end of
    pkgdesc
-   always use and follow the original pkgver of the official package
-   always add unset LDFLAGS CPPFLAGS in front of toolchain
    configure/Makefile generation sequences
-   always build both 32-bit and 64-bit versions of libraries, unless of
    course the package can only target, or is meant to only target,
    32-bit or 64-bit, or if problems arise building one of the two.
-   always put all stuff under the /usr/i686-w64-mingw32 and
    /usr/x86_64-w64-mingw32 prefix
-   always use any as the architecture
-   always build both shared and static binaries, unless they conflict
-   always remove Win32 executables (*.exe) if the intended package is a
    library (rm "$pkgdir"/usr/${_arch}/bin/*.exe)
-   consider removing unneeded documentation
    (rm -r $pkgdir/usr/i686-w64-mingw32/share/{doc,info,man},
    rm -r $pkgdir/usr/x86_64-w64-mingw32/share/{doc,info,man})
-   consider using mingw-w64-pkg-config for building with configure
    scripts
-   consider using mingw-w64-cmake for building with CMake
-   consider explicitly stripping symbols with ${_arch}-strip in
    package()'s for-loop as demonstrated in the below PKGBUILD examples.
    -   consider using the `find` command to iterate over $pkgdir since
        not all DLLs, static libraries, or executables may reside in
        their appropriate locations.
        -   if the binary is a DLL, use
            ${_arch}-strip --strip-unneeded *.dll
        -   if the binary is a static lib, use ${_arch}-strip -g *.a
-   if a package is modular (requires certain build dependencies, but
    said dependencies are optional to the end user) add these to
    makedepends and optdepends. Be sure to subtract them from depends if
    updating an existing package. Example of this in use:
    mingw-w64-ruby, mingw-w64-allegro
-   if a package installs a $pkgdir/usr/${_arch}/bin/*-config script,
    symlink it to $pkgdir/usr/bin/${_arch}-*-config

As mentioned above, the files should all be installed into
/usr/i686-w64-mingw32 and /usr/x86_64-w64-mingw32. Specifically, all
DLLs should be put into /usr/*-w64-mingw32/bin as they are dynamic
libraries needed at runtime. Their corresponding .dll.a files should go
into /usr/*-w64-mingw32/lib. Please delete any unnecessary documentation
and perhaps other files from /usr/share. Cross-compilations packages are
not meant for the user but only for the compiler and binary
distribution, and as such you should try to make them as small as
possible.

Always try to match the pkgver in your mingw-w64 packages to the pkgver
of the corresponding regular packages in the official Arch Linux repos
(not the testing repos). This ensures that the cross-compiled software
works exactly the same way on Windows without any unexpected bugs. If
packages in Arch are out-of-date, there usually is a good reason and you
should still follow the Arch version instead of using the most recent
upstream release. If the corresponding native package is in the AUR, you
need not follow this version policy, as many AUR packages are often
orphaned or left unmaintained.

Examples
--------

The following examples will try to cover some of the most common
conventions and build systems.

> Autotools

    # Maintainer: yourname <yourmail>
    pkgname=mingw-w64-foo
    pkgver=1.0
    pkgrel=1
    pkgdesc="Foo bar (mingw-w64)"
    arch=('any')
    url="http://www.foo.bar"
    license=('GPL')
    makedepends=('mingw-w64-gcc')
    depends=('mingw-w64-crt')
    options=('!strip' '!buildflags' 'staticlibs')
    source=("http://www.foo.bar/foobar.tar.gz")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24')

    _architectures="i686-w64-mingw32 x86_64-w64-mingw32"

    build() {
      unset LDFLAGS
      cd "${srcdir}/foo-$pkgver/"
      for _arch in ${_architectures}; do
        mkdir -p build-${_arch} && pushd build-${_arch}
        ../configure \
          --prefix=/usr/${_arch} \
          --host=${_arch}
        make
        popd
      done
    }

    package() {
      for _arch in ${_architectures}; do
        cd "${srcdir}/foo-$pkgver/build-${_arch}"
        make DESTDIR="${pkgdir}" install
        find "$pkgdir" -name '*.exe' -o -name '*.bat' -o -name '*.def' -o -name '*.exp' -o -name '*.manifest' -exec rm {} \;
        find "$pkgdir" -name '*.dll' -exec ${_arch}-strip --strip-unneeded {} \;
        find "$pkgdir" -name '*.dll' -o -name '*.a' -exec ${_arch}-strip -g {} \;
      done
    }

> CMake

    # Maintainer: yourname <yourmail>
    pkgname=mingw-w64-foo
    pkgver=1.0
    pkgrel=1
    pkgdesc="Foo bar (mingw-w64)"
    arch=('any')
    url="http://www.foo.bar"
    license=('GPL')
    makedepends=('mingw-w64-cmake')
    depends=('mingw-w64-crt')
    options=('!strip' '!buildflags' 'staticlibs')
    source=("http://www.foo.bar/foobar.tar.gz")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24')

    _architectures="i686-w64-mingw32 x86_64-w64-mingw32"

    build() { 
      unset LDFLAGS
      cd "$srcdir/foo-$pkgver/"
      for _arch in ${_architectures}; do
        mkdir -p build-${_arch} && pushd build-${_arch}
        ${_arch}-cmake \
          -DCMAKE_BUILD_TYPE=Release \
          ..
        make
        popd
      done
    }

    package() {
      for _arch in ${_architectures}; do
        cd "${srcdir}/foo-$pkgver/build-${_arch}"
        make DESTDIR="${pkgdir}" install
        find "$pkgdir" -name '*.exe' -o -name '*.bat' -o -name '*.def' -o -name '*.exp' -o -name '*.manifest' -exec rm {} \;
        find "$pkgdir" -name '*.dll' -exec ${_arch}-strip --strip-unneeded {} \;
        find "$pkgdir" -name '*.dll' -o -name '*.a' -exec ${_arch}-strip -g {} \;
      done
    }

Retrieved from
"https://wiki.archlinux.org/index.php?title=MinGW_PKGBUILD_Guidelines&oldid=306192"

Category:

-   Package development

-   This page was last modified on 21 March 2014, at 02:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
