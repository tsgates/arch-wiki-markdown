Python Package Guidelines
=========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Writing PKGBUILDs for software written in Python.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package Naming                                                     |
| -   2 File Placement                                                     |
| -   3 Notes                                                              |
| -   4 Example                                                            |
+--------------------------------------------------------------------------+

Package Naming
--------------

For libraries, use python-modulename. For applications, use the program
name. In either case, the package name should be entirely lowercase.

Python 2 libraries should instead be named python2-modulename.

File Placement
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

An example PKGBUILD can be found at
/usr/share/pacman/PKGBUILD-python.proto, which is in the abs package.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Python_Package_Guidelines&oldid=220215"

Category:

-   Package development
