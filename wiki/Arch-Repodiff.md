Arch-Repodiff
=============

This is a utility for making diffs between different Arch same-named
repositories.

Installation
------------

Get PKGBUILD from arch-repodiff-svn, then make and install the package.

Fetch latest ABS tree
---------------------

Fetch latest ABS tree into ~/arch-abs:

    arch-repodiff-fetch ~/arch-abs

Make diff
---------

Make diff and put HTMLs into ~/arch-abs/current-diff,
~/arch-abs/extra-diff and ~/arch-abs/community-diff:

    arch-repodiff-diff ~/arch-abs ~/arch-abs/current-diff current http://example.com/css/main.css
    arch-repodiff-diff ~/arch-abs ~/arch-abs/extra-diff extra http://example.com/css/main.css
    arch-repodiff-diff ~/arch-abs ~/arch-abs/community-diff community http://example.com/css/main.css

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch-Repodiff&oldid=197581"

Category:

-   Package management

-   This page was last modified on 23 April 2012, at 15:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
