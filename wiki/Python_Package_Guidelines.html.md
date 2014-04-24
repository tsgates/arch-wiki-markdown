Python Package Guidelines
=========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Writing PKGBUILDs for software written in Python.

Contents
--------

-   1 Package naming
-   2 File placement
-   3 Notes
-   4 Example

Package naming
--------------

For libraries, use python-modulename. For applications, use the program
name. In either case, the package name should be entirely lowercase.

Python 2 libraries should instead be named python2-modulename.

File placement
--------------

Most Python packages are installed with the distutils system using
setup.py, which installs files under
/usr/lib/python<python version>/site-packages/pkgname directory.

Notes
-----

The --optimize=1 parameter compiles .pyo files so they can be tracked by
pacman.

In most cases, you should put any in the arch array since most Python
packages are architecture independent.

Please do not install a directory named just tests, as it easily
conflicts with other Python packages (for example,
/usr/lib/python2.7/site-packages/tests/).

Example
-------

An example PKGBUILD can be found here or at
/usr/share/pacman/PKGBUILD-python.proto, which is in the abs package.
Also you may want to check out PKGBUILD Templates page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Python_Package_Guidelines&oldid=291435"

Category:

-   Package development

-   This page was last modified on 3 January 2014, at 10:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
