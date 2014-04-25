Snapshot Release
================

Contents
--------

-   1 Introduction
    -   1.1 Objective
    -   1.2 Rationale
-   2 New Branch
-   3 Pacman
    -   3.1 An example of pacman.conf
    -   3.2 Adding new functions to pacman
-   4 Arch Releases
-   5 Status
-   6 Related Projects

Introduction
------------

Arch Linux is no doubt a well maintained rolling release distribution
that combines both stability and bleeding edge. This approach is
therefore neither dynamic nor static state, instead, it is rather a
synthetic implementation of the basics of open-source philosophies. A
snapshot release captures thus the spirit of Arch linux and provides
some users the opportunity to use Arch linux in various environments and
settings.

> Objective

Snapshot release intends to follow the Arch way of implementing
minimalism and maintenance that can be suited for certain environments
and personal needs.

> Rationale

The rationale behind the snapshot release is to provide the Arch linux
community the benefits of a rolling release system.

New Branch
----------

There is no need of "stable" branch, but rather a "state" or "snapshot"
branch, containing core and extra packages.

Pacman
------

Pacman needs to be patched to handle snapshot release. Those who desires
to combine snapshot and rolling release should be able to attain a mixed
release system.

> An example of pacman.conf

    #
    # GENERAL OPTIONS
    #
    [options]

    # The default release is rolling. To enable snapshot release, add "Snapshot"
    # instead of "Rolling". There are two priority options for a snapshot release.
    # Priority 1 = Strict system (no rolling)
    # Priority 2 = Mixed system (core snapshot, extra rolling)
    #Release     = Rolling
    #Priority    = 1

    # The following paths are commented out with their default values listed.
    # If you wish to use different paths, uncomment and update the paths.
    #RootDir     = /
    #DBPath      = /var/lib/pacman/

> Adding new functions to pacman

There should be three functions that pacman should perform when
pacman.conf is set to Release = Snapshot:

    1.)
    If Release  = Snapshot (Default is Rolling)
     then use:
    Priority = 1 (options 1, 2: 1 = strict system; 2 = mixed system(core=snapshot, extra=rolling))

    2.)
    If Release = Snapshot
      Priority = 1
     then do not use:
    Rolling release repos in mirrorlist.

    3.)
    If Release = Snapshot
       Priority = 2
     then use:
    Both Rollling and Snapshot release repos in mirrorlist.

Arch Releases
-------------

Snapshot Releases should be coordinated with official Arch Releases.

Status
------

Archlinux is essentially an unstable rolling release system similar to
debian unstable branch, with no real intention of creating a stable
release. Many who have used debian unstable or archlinux consider these
distributions to be quite stable and meet the necessary requirements for
intermediate or advanced users. Archlinux is an excellent platform for
developers and for those who want to advance their linux skills.

Related Projects
----------------

See Arch Linux Stable.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Snapshot_Release&oldid=196033"

Category:

-   Arch development

-   This page was last modified on 23 April 2012, at 11:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
