DeveloperWiki:dbscripts
=======================

Contents
--------

-   1 Usage
    -   1.1 Add or update packages
    -   1.2 Remove packages
    -   1.3 Move packages
        -   1.3.1 Moving packages from [testing] to [core] and [extra]
    -   1.4 Cleanup old packages
-   2 Development

Usage
-----

> Add or update packages

Run db-update to release all packages that are found in your ~/staging
directory. Packages for different repositories and architectures will be
updated at once. A simple integrity check is run before any repository
is touched.

> Remove packages

Use db-remove with the following parameters to remove a package from a
given repository:

    db-remove <pkgname|pkgbase> <repo> <arch>

Note that pkgname is the name defined in the PKGBUILD and not the actual
filename. For split packages, you need to use pkgbase to remove all
split packages at once. (It's not possible to remove just a single one.)

Example:

    db-remove lilo core i686

> Move packages

db-move uses the following syntax to move packages between repositories:

    db-move <repo-from> <repo-to> <pkgname|pkgbase> ...

You may move more than one package by simply appending them to the
command. Use the pkgbase for split packages. All packages of all
architectures are moved in one step.

Example:

    db-move testing extra php lighttpd apache

Moving packages from [testing] to [core] and [extra]

As moving several packages from [testing] to the repo they belong to is
a common use case; especially after rebuilds. Use testing2x to move
these packages to the correct repository. Of course, this will only work
if previous version of those packages are already in [core] or [extra]

Example:

    testing2x lilo php lighttpd apache zlib

This will move lilo and zlib to [core] and the other packages to
[extra]. You should prefer db-move if you are sure that all packages to
be moved have the same target repository.

> Cleanup old packages

Old versions of packages are not removed by the scripts mentioned above.
This cleanup is done regularly by a cron job called ftpdir-cleanup.

Development
-----------

-   source: https://projects.archlinux.org/dbscripts.git/
-   test suite: runTest in test directory

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:dbscripts&oldid=238781"

Category:

-   DeveloperWiki

-   This page was last modified on 6 December 2012, at 00:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
