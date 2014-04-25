DeveloperWiki:Adopting Packages
===============================

Introduction
============

This document outlines the process for Arch Linux package maintainers to
add new packages to the official repositories. This article is part of
the DeveloperWiki.

Quick Instructions
==================

TODO: Rewrite this section with steps for adding new packages to svn

The BIG Picture
===============

Generally speaking, new packages are submitted by Archlinux end users to
the AUR's [unsupported] collection on https://aur.archlinux.org/. From
there, one of the Trusted Users will take the package, test the PKGBUILD
locally, fix any errors and make sure it conforms to AL package
guidelines. When the TU has finished testing it, they will place the
package in the [community] repo at ftp://ftp.archlinux.org/community/

When the package has been placed in the [community] repo, AL users have
access to the package via pacman (assuming the user hasn't disabled the
[community] repo in /etc/pacman.conf). Once the package has lived
bug-free in the [community] repo for a while, an AL package maintainer
can elect to adopt the package and follow the procedure outlined above.

Trusted Users are selected users within the AL user community that show
sound Linux knowledge and the ability to produce solid PKGBUILDs. The
[community] repo is not officially supported by AL developers or package
maintainers. The TUs are fully responsible for the packages found within
it. It is not until a package is adopted into the official AL repos that
the AL team becomes responsible for the package.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Adopting_Packages&oldid=190952"

Category:

-   DeveloperWiki

-   This page was last modified on 24 March 2012, at 17:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
