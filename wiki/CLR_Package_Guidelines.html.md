CLR Package Guidelines
======================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

This document defines the standard for packaging Common Language Runtime
(.NET) projects under Arch Linux. Currently only Mono is capable of
providing a usable, efficient CLR runtime for multiple systems and this
standard will reflect its use. Be aware that a lot of CLR programs were
developed with Microsoft .NET in mind and, as such, may or may not run
under Mono because of .NET-exclusive factors such as P/Invoke calls and
Microsoft digital rights management (DRM) APIs and are thus will not
yield a usable package for Arch Linux. However, if combined with Wine as
of version 1.5.6 (?), your package may have a chance to run under it.
Please see the Wine PKGBUILD Guidelines for more information if such is
the case.

Contents
--------

-   1 Packaging gotchas
    -   1.1 Signed assemblies
-   2 Sample PKGBUILDs
    -   2.1 xbuild
        -   2.1.1 Unsigned DLL
    -   2.2 NAnt
    -   2.3 Prebuild

Packaging gotchas
-----------------

-   Always add mono to depends
-   Always set arch to any. Mono does not yet support compiling
    (running?) 64-bit assemblies.
-   Always add !strip to options
-   If the package is a library (DLL), consider installing it to Mono's
    global assembly cache (GAC) if it is to bo used as a dependency.
-   If the assembly is precompiled and comes with a program debug
    database file (Foo.dll.pdb), consider converting it as such:
    pdb2mdb Foo.dll
-   If the package is meant to be executed (EXE), be sure to install to
    /usr/bin a shell script to run it, similar to this one:

    #!/bin/sh
    mono foo.exe $@

> Signed assemblies

If the package is to be installed into the GAC, be sure it has a signed
key file. If not, you can generate one like this: sn -k 1024 Foo.snk.
Following that, the easiest way to embed the key file into the assembly
is to disassemble it like this: monodis Foo.dll --output=Foo.il.
Afterwards, reassemble it like so: ilasm /dll /key:Foo.snk Foo.il

Sample PKGBUILDs
----------------

The following examples will try to cover some of the most common
conventions and build systems.

> xbuild

Unsigned DLL

    # Maintainer: yourname <yourmail>
    pkgname=foo
    pkgver=1.0
    pkgrel=1
    pkgdesc="Fantabulous library for .Net"
    arch=('any')
    url="http://www.foo.bar"
    license=('GPL')
    depends=('mono')
    options=('!strip')
    source=("http://www.foo.bar/foobar.tar.gz")
    md5sums=('4736ac4f34fd9a41fa0197eac23bbc24')

    build() {
      cd "${srcdir}/foobar"

      xbuild Foo.sln

      # if the package is unsigned, do the following:
      cd "/bin/x86/Debug"
      monodis Foo.dll --output=Foo.il
      sn -k 1024 Foo.snk
      ilasm /dll /key:Foo.snk Foo.il
    }

    package() {
      cd "${srcdir}/foobar/bin/x86/Debug"

      install -Dm644 Foo.dll "$pkgdir/usr/lib/foobar/Foo.dll"
      install -Dm644 Foo.dll.mdb "$pkgdir/usr/lib/foobar/Foo.dll.mdb"
      
      # Register assembly into Mono's GAC
      gacutil -i Foo.dll -root "$pkgdir/usr/lib"
    }

> NAnt

> Prebuild

Retrieved from
"https://wiki.archlinux.org/index.php?title=CLR_Package_Guidelines&oldid=286718"

Category:

-   Package development

-   This page was last modified on 7 December 2013, at 00:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
