Ruby Gem Package Guidelines
===========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Writing PKGBUILDs for software written in Ruby.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package Naming                                                     |
| -   2 Examples                                                           |
| -   3 Notes                                                              |
| -   4 Example PKGBUILD                                                   |
| -   5 Automation                                                         |
+--------------------------------------------------------------------------+

Package Naming
--------------

For libraries, use ruby-gemname. For applications, use the program name.
In either case, the name should be entirely lowercase

Examples
--------

For examples, please see github-gem ruby-json_pure ruby-hpricot.

Notes
-----

Add --verbose to gem arguments to receive additional information in case
of troubles.

Note:Usage of --no-user-install gem argument is mandatory since latest
Ruby versions (See FS#28681 for details).

Example PKGBUILD
----------------

An example PKGBUILD can be found at
/usr/share/pacman/PKGBUILD-rubygem.proto, which is in the abs package.

Automation
----------

The gem installation can be automated completely with the tool pacgem
which creates a temporary PKGBUILD, calls makepkg and namcap. The
resulting package is then installed with sudo pacman.

There are also multiple gem2arch tools which aid in automating the
process of creating a ruby gem PKGBUILD. Make sure to manually check the
PKGBUILD after generation. The original version is by Abhishek Dasgupta.
Search for other versions of this tool in AUR (Search for gem2arch).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ruby_Gem_Package_Guidelines&oldid=253484"

Category:

-   Package development
