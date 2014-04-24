Ruby Gem Package Guidelines
===========================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Writing PKGBUILDs for software written in Ruby.

Contents
--------

-   1 Package naming
    -   1.1 Versioned packages
-   2 Examples
-   3 Notes
-   4 Gotchas
    -   4.1 Package contains reference to $pkgdir
-   5 Example PKGBUILD
-   6 Automation

Package naming
--------------

For libraries, use ruby-$gemname. For applications, use the program
name. In either case, the name should be entirely lowercase.

Always use ruby- prefix even if $gemname already starts with word ruby.
It is needed to avoid future name clashes in case if a gem with shorter
name appear. It also makes names more easily parseble by tools (think
about PKGBUILD generators/version or dependency checkers, etc...).
Examples: ruby-ruby-protocol-buffers.

Versioned packages

If you need to add a versioned package then use ruby-$gemname-$version,
e.g. ruby-builder-3.2.1. So rubygem dependency builder=3.2.1 will turn
into ruby-builder-3.2.1 Arch package.

In case if you need to resolve "approximately greater" dependency ~>
then package should use version without the last part, e.g. rubygem
dependency builder~>3.2.1 will turn into ruby-builder-3.2. An exception
for this rule is when "approximately greater" dependency matches the
latest version of the gem - in this case avoid introducing a new
versioned package and use just ruby-$gemname instead (the HEAD version).

Another problem with versioned packages is that it can conflict with
other versions, e.g. because the packages install the same files in
/usr/bin. One solution for this problem is that versioned packages
should not install such files - only HEAD version package can do this.

Examples
--------

For examples, please see ruby-rethinkdb ruby-json_pure ruby-hpricot.

Notes
-----

Add --verbose to gem arguments to receive additional information in case
of troubles.

Note:Usage of --no-user-install gem argument is mandatory since latest
Ruby versions (See FS#28681 for details).

Gotchas
-------

> Package contains reference to $pkgdir

Sometimes when you build the package you can see following warning
WARNING: Package contains reference to $pkgdir. Some packed files
contain absolute path of directory where you built the package. To find
these files run cd pkg && grep -R "$(pwd)" . Most likely the reason will
be hardcoded path in .../ext/Makefile.

Note:folder ext contains native extension code usually written in C.
During the package installation rubygems generates a Makefile using mkmf
library. Then make is called, it compiles a shared library and copies
one to lib gem directory.

After gem install is over the Makefile is not needed anymore. In fact
none of the files in ext is needed and it can be completely removed by
adding rm -rf "$pkgdir/$_gemdir/gems/$_gemname-$pkgver/ext" to package()
function.

Example PKGBUILD
----------------

An example PKGBUILD can be found at
/usr/share/pacman/PKGBUILD-rubygem.proto, which is in the abs package.

Automation
----------

The gem installation can be automated completely with the tool pacgem
which creates a temporary PKGBUILD, calls makepkg and namcap. The
resulting package is then installed with sudo pacman.

There is also gem2arch tools which aid in automating the process of
creating a ruby gem PKGBUILD. Make sure to manually check the PKGBUILD
after generation.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ruby_Gem_Package_Guidelines&oldid=296255"

Category:

-   Package development

-   This page was last modified on 5 February 2014, at 05:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
