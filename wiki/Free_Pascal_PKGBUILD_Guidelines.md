Free Pascal PKGBUILD Guidelines
===============================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

This page explains on how to write PKGBUILDs for software built with the
Free Pascal Compiler (FPC). There currently exists two options for
building software of Linux, as well as a handful of options for building
software on other targets using FPC cross compilers:

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Arch Linux                                                         |
| -   2 Cross compilers                                                    |
| -   3 Free Pascal                                                        |
|     -   3.1 Package naming                                               |
|     -   3.2 Helpful snippets                                             |
|     -   3.3 Packaging                                                    |
|         -   3.3.1 Cross compiling                                        |
+--------------------------------------------------------------------------+

Arch Linux

-   fpc is available in the official Arch community repository and
    provides a compiler targetting only your host CPU (i686 or x86_64).
-   fpc-multilib is available from the Arch User Repository which
    provides an x86_64 host compiler targetting both i686 and x86_64 CPU
    Linuxes. This will also provide the ppcross386 FPC compiler driver
    package.

Cross compilers

-   fpc-arm-linux-rtl for ARM-based Linux
-   fpc-arm-wince-rtl for MS Windows CE
-   fpc-i386-freebsd-rtl for 32-bit Intel FreeBSD
-   fpc-i386-win32-rtl for 32-bit MS Windows
-   fpc-powerpc-linux-rtl for 32-bit PowerPC-based Linux
-   fpc-sparc-linux-rtl for SPARC-based Linux
-   fpc-x86_64-win64-rtl for 64-bit MS Windows

Free Pascal
-----------

> Package naming

The project name alone is usually sufficient. However, in the case of
cross-compiling, the package should be prefixed with fpc32- when
targetting i686 Linux from multilib and named in the format of
fpc-cpu-system-pkgname when targetting non-Arch Linux systems.

> Helpful snippets

-   Determine FPC's version and the CPU and OS of the units to output:

    _unittgt=`fpc -iSP`-`fpc -iSO`
    _fpcvers=`fpc -iV`

> Packaging

Please adhere to the following when making an FPC-based package:

-   always add fpc to makedepends
-   always put all compiled units (*.compiled, *.o, *.ppu, *.res, *.rst)
    under /usr/lib/fpc/$_fpcvers/units/$arch-linux

Cross compiling

-   always add the corresponding cross compiler package mentioned above
    (fpc-cpu-system-rtl or fpc-multilib for multilib) to depends
-   always add !strip to options for non-Unix-based systems
-   always put all compiled units (*.compiled, *.o, *.ppu, *.res, *.rst)
    under /usr/lib/fpc/$_fpcvers/units/$_unittgt (or if multilib,
    /usr/lib/fpc/$_fpcvers/units/i386-linux)
-   always use any (x86_64 if multilib) as the architecture

Retrieved from
"https://wiki.archlinux.org/index.php?title=Free_Pascal_PKGBUILD_Guidelines&oldid=216875"

Category:

-   Package development
