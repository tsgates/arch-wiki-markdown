DeveloperWiki:Build machines
============================

Contents
--------

-   1 Introduction
-   2 Server Information
    -   2.1 Server address
    -   2.2 Server purpose
    -   2.3 Development tools
    -   2.4 Server admin
    -   2.5 Gaining access

Introduction
------------

This article is part of the DeveloperWiki.

Server Information
------------------

Server address

-   http://pkgbuild.com

Server purpose

-   PKGBUILD.com is an attempt to create a unified build environment for
    Arch Linux

Development tools

-   makechrootpkg - PKGBUILD.com uses a modified version of the standard
    makechrootpkg implementation that adds queueing and integrated
    architecture selection.
-   chrootupdate - Allows the update of all supported chroots by an
    otherwise unprivileged user.
-   chrootstatus - CLI version of the status indicator on the website.
-   unlock - Allows the removal of stale lockfiles by otherwise
    unprivileged users.
-   Users may set the makepkg.conf PACKAGER variable by creating a file
    called .packager in their home directory. Whatever is included on
    the first line of that file will replace the default packager
    (PKGBUILD.com Build Server).
-   Everything else falls under the standard devtools suite

Server admin

-   Ionut Biru (ioni/wonder)

Gaining access

If you need access to the build server, please send me an email at
ibiru@archlinux.org with [Build Server] in the subject line.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Build_machines&oldid=203485"

Category:

-   Arch development

-   This page was last modified on 2 June 2012, at 19:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
