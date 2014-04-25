AUR Metadata
============

Related articles

-   Arch User Repository
-   PKGBUILD
-   makepkg
-   pacman

In order to display information in the AUR web interface, the AUR's
back-end code attempts to parse PKGBUILD files and salvage package name,
version, and other information from it. PKGBUILDs are Bash scripts, and
correctly parsing Bash scripts without executing them is a huge
challenge, which is why makepkg is a Bash script itself: it includes the
PKGBUILD of the package being built via the source directive. AUR
metadata files were created to get rid of some hacks, used by AUR
package maintainers to work around incorrect parsing in the web
interface. See also FS#25210, FS#15043, and FS#16394.

Contents
--------

-   1 How it works
-   2 What does not work
-   3 pkgbuild_reflection and mkaurball
-   4 See also

How it works
------------

By adding a metadata file called ".AURINFO" to source tarballs to
overwrite specific PKGBUILD fields. .AURINFO files are parsed
line-by-line. The syntax for each line is key = value, where key is any
of the following field names:

-   pkgname
-   pkgver
-   pkgdesc
-   url
-   license
-   depends

Multiple depends lines can be specified to add multiple dependencies.
This format closely matches the .PKGINFO format that is used for binary
packages in pacman/libalpm. It can be extended by field name prefixes or
sections to support split packages later.

What does not work
------------------

-   Split packages
-   Multiple architectures (x86_64 dependencies tend to be more
    numerous, so just put them)

pkgbuild_reflection and mkaurball
---------------------------------

pkgbuild-introspection is a set of tools for generating .AURINFO files.
One of the provided tools is mkaurball, which is a script that runs
makepkg --source, generates an .AURINFO file, and inserts it into the
resulting source package.

Tip:mkaurball is a wrapper for makepkg --source. When creating source
packages for inclusion in the AUR, use mkaurball instead of running
makepkg --source directly.

Install the package pkgbuild-introspection-git from the Arch User
Repository.

See also
--------

-   https://mailman.archlinux.org/pipermail/aur-general/2014-January/026720.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=AUR_Metadata&oldid=293724"

Category:

-   Package development

-   This page was last modified on 20 January 2014, at 16:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
