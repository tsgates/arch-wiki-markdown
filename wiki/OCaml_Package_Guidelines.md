OCaml Package Guidelines
========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Writing PKGBUILDs for sowtware written in OCaml.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package Naming                                                     |
| -   2 File placement                                                     |
|     -   2.1 Libraries                                                    |
|     -   2.2 OASIS                                                        |
|                                                                          |
| -   3 OCaml Bytecode and Levels                                          |
| -   4 Example PKGBUILD                                                   |
+--------------------------------------------------------------------------+

Package Naming
--------------

For libraries, use ocaml-modulename. For applications, use the program
name. In either case, the name should be entirely lowercase.

File placement
--------------

> Libraries

OCaml libraries should be installed under /usr/lib/ocaml. Installation
in /usr/lib/ocaml/site-lib is deprecated.

OCaml libraries should be installed using ocaml-findlib. ocaml-findlib
includes library metadata in the package that makes it easy to manage
libraries. It is a de-facto standard and a lot of OCaml software now
requires it.

ocaml-findlib extracts necessary data from a file named META that should
be included in the source archive. If this file is not included, one
should either be obtained from the corresponding Debian, Ubuntu, or
Fedora package, or created for the package by the maintainer. A request
to include the file should also be made to the upstream developers of
the package.

The OCAMLFIND_DESTDIR variable should be used when installing packages
with ocaml-findlib. See the example PKGBUILD below for details.

> OASIS

OCaml packages that install executables using OASIS ignore DESTDIR. This
is a known limitation of OASIS (issue #852). One way to enable
DESTDIR-like functionality is to run the configure script with the
--destdir argument, like so:

    build() {
        cd "${srcdir}/${srcname}-${pkgver}"
        ./configure --prefix /usr --destdir "$pkgdir"

        # build commands
    }

OCaml Bytecode and Levels
-------------------------

OCaml can run code on multiple "levels", the top level interprets OCaml
Code without compiling, the bytecode level creates machine independent
bytecode and the native level creates machine code binaries (just like
C/C++).

When building OCaml Packages you need to be aware if the build process
is compiling native machine code, bytecode, or as in many cases both.
This creates a number of situations which can cause problems with
package options and the right dependencies.

If bytecode is produced at all then the PKGBUILD must contain the
following to protect the bytecode:

    options=('!strip')

If the package does not contain bytecode and only distributes a binary,
then ocaml is not needed as a dependency, but it of course is required
as a makedepends since the ocaml package provides the OCaml compiler. If
the package contains both native code and bytecode then ocaml should be
a dependency and a makedepends.

OCaml code is rarely (if ever) distributed as bytecode only and will
almost always include native code: the only case where using any as the
arch is advisable is when only un-compiled source code is distributed,
usually with a library, though many libraries still distribute native
code.

The moral of the story here is to be aware of what it is you are
distributing, chances are your package contains both native machine code
and bytecode.

Example PKGBUILD
----------------

    # Contributor: Your Name <youremail@domain.com>

    pkgname=ocaml-<package name>
    pkgver=4.2
    pkgrel=1
    license=()
    arch=('i686' 'x86_64')
    pkgdesc="An OCaml Package"
    url=""
    depends=('ocaml')
    makedepends=('ocaml-findlib')
    source=()
    options=('!strip')
    md5sums=()

    OCAMLFIND_DESTDIR="${pkgdir}$(ocamlfind printconf destdir)"

    build() {
      cd "${srcdir}/${pkgname}-${pkgver}"
      mkdir -p "$OCAMLFIND_DESTDIR"
      ./configure --prefix=/usr
      make
    }

    package() {
      cd "${srcdir}/${pkgname}-${pkgver}"
      env DESTDIR="${pkgdir}" \
        OCAMLFIND_DESTDIR="$OCAMLFIND_DESTDIR" \
        make install
    }

Keep in mind that many OCaml Packages will often need extra parameters
passed to make and make install. Also remember to remove
the'!strip'option and change the architecture if the package does not
produce bytecode.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OCaml_Package_Guidelines&oldid=206946"

Category:

-   Package development
