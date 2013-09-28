MinGW PKGBUILD Guidelines
=========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

This page expains how to write PKGBUILDs for software running on Windows
using GCC. There are two options to build software for Windows on Linux:

-   [www.MinGW.org]: provides 32-bit toolchains with limited DirectX
    support. Available from Arch's [community] repository by installing
    mingw32-gcc.
-   [mingw-w64.sourceforge.net]: provides 32 and 64-bit toolchains with
    secure crt, Vista+ API, DDK (ReactOS), and DirectX (WINE) support.
    For a full list of supported features and differences with the old
    MinGW.org, see here. Available in the AUR by installing
    mingw-w64-gcc

There are some differences between the packaging of both projects,
detailed below.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 MinGW.org                                                          |
|     -   1.1 Package Naming                                               |
|     -   1.2 Packaging                                                    |
|     -   1.3 Examples                                                     |
|         -   1.3.1 Plain Makefile                                         |
|         -   1.3.2 Autotools                                              |
|         -   1.3.3 CMake                                                  |
|                                                                          |
| -   2 MinGW-w64                                                          |
|     -   2.1 Package Naming                                               |
|     -   2.2 Packaging                                                    |
|     -   2.3 Examples                                                     |
|         -   2.3.1 Autotools                                              |
|         -   2.3.2 CMake                                                  |
+--------------------------------------------------------------------------+

MinGW.org
---------

> Package Naming

A package for mingw32 should be named mingw32-pkgname. If a static
variant of the package is being built, suffix the package name with
-static.

> Packaging

Packaging for cross platform packages can be fairly tricky as there are
many different build systems and low-level quirks. Take a note of the
following things though:

-   always add mingw32-runtime to depends
-   always add mingw32-gcc to makedepends
-   always add !strip and !buildflags to options 
-   always use the original pkgdesc and append (mingw32) to the end of
    pkgdesc
-   always use and follow the original pkgver of the official package
-   always add unset LDFLAGS CPPFLAGS in front of toolchain
    configure/Makefile generation sequences
-   always put all stuff under the /usr/i486-mingw32 prefix
-   always use any as the architecture
-   always build both shared and static binaries, unless they conflict
-   always remove Win32 executables (*.exe) if the intended package is a
    library
-   consider using !libtool in options if you get .la files in $pkgdir
-   consider removing unneeded documentation
    (rm -r $pkgdir/usr/i486-mingw32/share/{doc,info,man})
-   consider explicitly stripping symbols with i486-mingw32-strip in
    package()
    -   if the binary is a DLL, use i486-mingw32-strip -x -g *.dll
    -   if the binary is a static lib, use i486-mingw32-strip -g *.a

As mentioned above, the files should all be installed into
/usr/i486-mingw32. Specifically, all .dll files should be put into
/usr/i486-mingw32/bin as they are dynamic libraries needed at runtime.
Their corresponding .dll.a files should go into /usr/i486-mingw32/lib.
Please delete any unnecessary documentation and perhaps other files from
/usr/share. Cross-compilations packages are not meant for the user but
only for the compiler and as such you should try to make them as small
as possible.

Always try to match the pkgver in your mingw packages to the pkgver of
the corresponding regular packages in the official Arch Linux repos (not
the testing repos). This ensures that the cross-compiled software works
exactly the same way on mingw without any unexpected bugs. If packages
in Arch are out-of-date, there usually is a good reason and you should
still follow the Arch version instead of using the most recent upstream
release.

> Examples

The following examples will try to cover some of the most common
conventions and build systems.

Plain Makefile

    # Maintainer: yourname <yourmail>
    pkgname=mingw32-foo
    pkgver=1.0
    pkgrel=1
    pkgdesc="Foo bar (mingw32)"
    arch=('any')
    url="http://www.foo.bar"
    license=('GPL')
    makedepends=('mingw32-gcc')
    depends=('mingw32-runtime')
    options=('!strip' '!buildflags')
    source=("http://www.foo.bar/foobar.tar.gz")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24')

    build() {
      cd "${srcdir}/foobar"

      unset LDFLAGS

      sed "s|LOCAL = /usr/local|LOCAL = ${pkgdir}/usr/i486-mingw32|g" -i Makefile
      sed "s|CXX = gcc|CXX = i486-mingw32-gcc|g" -i Makefile
      sed "s|CXXFLAGS = |CXXFLAGS = -fPIC |g" -i Makefile

      # or with setconf instead of sed (add 'setconf' to makedepends)
      #setconf Makefile LOCAL "$pkgdir/usr/i486-mingw32"
      #setconf Makefile CXX i486-mingw32-gcc
      #setconf Makefile CXXFLAGS -fPIC

      make
    }

    package() {
      cd "${srcdir}/foobar"

      mkdir -p ${pkgdir}/usr/i486-mingw32/{lib,include}
      make install
      chmod 644 ${pkgdir}/usr/i486-mingw32/lib/libfoo.a
      i486-mingw32-ranlib ${pkgdir}/usr/i486-mingw32/lib/libfoo.a
    }

Autotools

    # Maintainer: yourname <yourmail>
    pkgname=mingw32-foo
    pkgver=1.0
    pkgrel=1
    pkgdesc="Foo bar (mingw32)"
    arch=('any')
    url="http://www.foo.bar"
    license=('GPL')
    makedepends=('mingw32-gcc')
    depends=('mingw32-runtime')
    options=('!strip' '!buildflags')
    source=("http://www.foo.bar/foobar.tar.gz")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24')

    build() {
      cd "${srcdir}/foobar"

      unset LDFLAGS

      ./configure --prefix=/usr/i486-mingw32 --host=i486-mingw32
      make
    }

    package() {
      cd "${srcdir}/foobar"

      make DESTDIR=${pkgdir} install
    }

CMake

    # Maintainer: yourname <yourmail>
    pkgname=mingw32-foo
    pkgver=1.0
    pkgrel=1
    pkgdesc="Foo bar (mingw32)"
    arch=('any')
    url="http://www.foo.bar"
    license=('GPL')
    makedepends=('mingw32-gcc' 'cmake')
    depends=('mingw32-runtime')
    options=('!strip' '!buildflags')
    source=("http://www.foo.bar/foobar.tar.gz"
            "cmake-toolchain.cmake")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24'
             'dd2b2db48187dff84050fe191d309d81')

    build() {
      cd "${srcdir}/foobar"
     
      unset LDFLAGS

      mkdir build && cd build
      cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr/i486-mingw32/ \
        -DCMAKE_TOOLCHAIN_FILE=${srcdir}/cmake-toolchain.cmake
      make
    }

    package() {
      cd "${srcdir}/foobar"

      cd build
      make DESTDIR=${pkgdir} install
    }

In this case, the toolchain is specified externally in
cmake-toolchain.cmake:

    cmake-toolchain.cmake

    # the name of the target operating system
    SET(CMAKE_SYSTEM_NAME Windows)

    # which compilers to use for C and C++
    SET(CMAKE_C_COMPILER i486-mingw32-gcc)
    SET(CMAKE_CXX_COMPILER i486-mingw32-g++)
    SET(CMAKE_RC_COMPILER i486-mingw32-windres)

    # here is the target environment located
    SET(CMAKE_FIND_ROOT_PATH /usr/i486-mingw32)

    # adjust the default behaviour of the FIND_XXX() commands:
    # search headers and libraries in the target environment, search 
    # programs in the host environment
    SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

MinGW-w64
---------

> Package Naming

A package for mingw-w64 should be named mingw-w64-pkgname. In the case
that a package is 32-bit only, prefix the package name with lib32-. If a
static variant of the package is being built, suffix the package name
with -static.

> Packaging

Packaging for cross platform packages can be fairly tricky as there are
many different build systems and low-level quirks. Take a note of the
following things though:

-   always add mingw-w64-crt to depends
-   always add mingw-w64-gcc to makedepends
-   always add !strip and !buildflags to options 
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
    library
-   consider using !libtool in options if you get .la files in $pkgdir
-   consider removing unneeded documentation
    (rm -r $pkgdir/usr/i686-w64-mingw32/share/{doc,info,man},
    rm -r $pkgdir/usr/x86_64-w64-mingw32/share/{doc,info,man})
-   consider explicitly stripping symbols with ${_arch}-strip in
    package()'s for-loop as demonstrated in the below PKGBUILD examples.
    -   if the binary is a DLL, use ${_arch}-strip -x -g *.dll
    -   if the binary is a static lib, use ${_arch}-strip -g *.a

As mentioned above, the files should all be installed into
/usr/i686-w64-mingw-w64 and /usr/x86_64-w64-mingw32. Specifically, all
.dll files should be put into /usr/*-w64-mingw-w64/bin as they are
dynamic libraries needed at runtime. Their corresponding .dll.a files
should go into /usr/*-w64-mingw-w64/lib. Please delete any unnecessary
documentation and perhaps other files from /usr/share.
Cross-compilations packages are not meant for the user but only for the
compiler and as such you should try to make them as small as possible.

Always try to match the pkgver in your mingw-w64 packages to the pkgver
of the corresponding regular packages in the official Arch Linux repos
(not the testing repos). This ensures that the cross-compiled software
works exactly the same way on Windows without any unexpected bugs. If
packages in Arch are out-of-date, there usually is a good reason and you
should still follow the Arch version instead of using the most recent
upstream release.

> Examples

The following examples will try to cover some of the most common
conventions and build systems.

Autotools

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
    options=('!strip' '!buildflags')
    source=("http://www.foo.bar/foobar.tar.gz")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24')

    _architectures="i686-w64-mingw32 x86_64-w64-mingw32"

    build() {
      unset LDFLAGS

      for _arch in ${_architectures}; do
        mkdir -p ${srcdir}/foo-build-${_arch}
        cd ${srcdir}/gcc-build-${_arch}  

        ${srcdir}/foo/configure --prefix=/usr/${_arch} --host=${_arch}
        make
      done
    }

    package() {
      for _arch in ${_targets}; do
        make DESTDIR=${pkgdir} install
      done
    }

CMake

    Toolchain-i686-mingw-w64-mingw32.cmake

    SET(CMAKE_SYSTEM_NAME Windows)

    # specify the cross compiler
    SET(CMAKE_C_COMPILER /usr/bin/i686-w64-mingw32-gcc)
    SET(CMAKE_CXX_COMPILER /usr/bin/i686-w64-mingw32-g++)

    # where is the target environment
    SET(CMAKE_FIND_ROOT_PATH /usr/i686-w64-mingw32)

    # search for programs in the build host directories
    SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    # for libraries and headers in the target directories
    SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

    # Make sure Qt can be detected by CMake
    SET(QT_BINARY_DIR /usr/i686-w64-mingw32/bin /usr/bin)

    # set the resource compiler (RHBZ #652435)
    SET(CMAKE_RC_COMPILER /usr/bin/i686-w64-mingw32-windres)

    # override boost library suffix which defaults to -mgw
    SET(Boost_COMPILER -gcc47)

    # These are needed for compiling lapack (RHBZ #753906)
    SET(CMAKE_Fortran_COMPILER /usr/bin/i686-w64-mingw32-gfortran)
    SET(CMAKE_AR:FILEPATH /usr/bin/i686-w64-mingw32-ar)
    SET(CMAKE_RANLIB:FILEPATH /usr/bin/i686-w64-mingw32-ranlib)

    Toolchain-x86_64-mingw-w64-mingw32.cmake

    SET(CMAKE_SYSTEM_NAME Windows)

    # specify the cross compiler
    SET(CMAKE_C_COMPILER /usr/bin/x86_64-w64-mingw32-gcc)
    SET(CMAKE_CXX_COMPILER /usr/bin/x86_64-w64-mingw32-g++)

    # where is the target environment
    SET(CMAKE_FIND_ROOT_PATH /usr/x86_64-w64-mingw32)

    # search for programs in the build host directories
    SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    # for libraries and headers in the target directories
    SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

    # Make sure Qt can be detected by CMake
    SET(QT_BINARY_DIR /usr/x86_64-w64-mingw32/bin /usr/bin)

    # set the resource compiler (RHBZ #652435)
    SET(CMAKE_RC_COMPILER /usr/bin/x86_64-w64-mingw32-windres)

    # override boost library suffix which defaults to -mgw
    SET(Boost_COMPILER -gcc47)

    # These are needed for compiling lapack (RHBZ #753906)
    SET(CMAKE_Fortran_COMPILER /usr/bin/x86_64-w64-mingw32-gfortran)
    SET(CMAKE_AR:FILEPATH /usr/bin/x86_64-w64-mingw32-ar)
    SET(CMAKE_RANLIB:FILEPATH /usr/bin/x86_64-w64-mingw32-ranlib)

    # Maintainer: yourname <yourmail>
    pkgname=mingw-w64-foo
    pkgver=1.0
    pkgrel=1
    pkgdesc="Foo bar (mingw-w64)"
    arch=('any')
    url="http://www.foo.bar"
    license=('GPL')
    makedepends=('mingw-w64-gcc' 'cmake')
    depends=('mingw-w64-crt')
    options=('!strip' '!buildflags')
    source=("http://www.foo.bar/foobar.tar.gz"
            "cmake-toolchain.cmake")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24'
             'dd2b2db48187dff84050fe191d309d81')

    _architectures="i686-w64-mingw32 x86_64-w64-mingw32"

    build() { 
      unset LDFLAGS

    for _arch in ${_architectures}; do
        mkdir build-${_arch} && pushd build-${_arch}
        PATH="/usr/${_arch}/bin:$PATH" cmake \
          -DCMAKE_VERBOSE_MAKEFILE=ON \
          -DCMAKE_INSTALL_PREFIX:PATH=/usr/${_arch} \
          -DCMAKE_INSTALL_LIBDIR:PATH=/usr/${_arch}/lib \
          -DINCLUDE_INSTALL_DIR:PATH=/usr/${_arch}/include \
          -DLIB_INSTALL_DIR:PATH=/usr/${_arch}/lib \
          -DSYSCONF_INSTALL_DIR:PATH=/usr/${_arch}/etc \
          -DSHARE_INSTALL_PREFIX:PATH=/usr/${_arch}/share \
          -DBUILD_SHARED_LIBS:BOOL=ON \
          -DCMAKE_TOOLCHAIN_FILE=${srcdir}/Toolchain-${_arch}.cmake \
          ..
        make
        popd
      done
    }

    package() {
      for _arch in ${_architectures}; do
        cd ${srcdir}/build-${_arch}
        make DESTDIR=${pkgdir} install
      done
    }

Retrieved from
"https://wiki.archlinux.org/index.php?title=MinGW_PKGBUILD_Guidelines&oldid=253674"

Category:

-   Package development
