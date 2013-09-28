DeveloperWiki:Objectives
========================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Current Suggestions                                                |
|     -   2.1 AndyRTR                                                      |
|     -   2.2 Paul Mattal                                                  |
|     -   2.3 Alexander Baldeck                                            |
+--------------------------------------------------------------------------+

Introduction
============

This page is for a set of objectives to help us acheive our
DeveloperWiki:Goals. These should not be focused on too much, until we
complete some general goals for the distro. This article is part of the
DeveloperWiki.

Objectives change over time, the Goals are a set of mostly static
targets we all agree on. Objectives are tasks destined to assist fulfill
and ensure we reach those targets, Goals.

If possible, once the goals are complete, link in the objectives to a
goal. If an objective doesn't help any goal, we should consider why we
need to do that in the first place.

Current Suggestions
===================

AndyRTR
-------

-   a massive cleanup of current+extra repo we need.
-   provide only a much smaller number of binary packages (only ~500)
    from the core developer team trying to keep them always at the last
    stable release very soon after the release (toolchain, compiler,
    basic important libs, Xorg).
-   provide several binary "trees" on top of that. where we won't have
    the manpower for binaries i can also imagine more source based stuff
    provided like AUR. old devs + TUs should work together in devisions.
    they could be sorted like kde, gnome, xfce, server-daemons, games,
    artwork ....
-   drop the divided development for our two architectures and let's do
    more things together.
-   we should have at least one dev working on every "bleeding edge
    front": new important architectures(will there ever be something
    beyond x86_64? PS3? ArchBSD?; 3D-eyecandy, virtualization, livecd)
-   can we solve our lack of infrastructure and manpower alone only with
    our community? think about how powerful a new pacman based
    distribution made of several other distros could be...

Paul Mattal
-----------

-   a complete package triage on current and extra, determining a list
    of unused packages and removing them or demoting them to the AUR
-   repoman

Alexander Baldeck
-----------------

Instead of changing the way the distro works too much, we should rather
try to keep it as it is as much as possible:

-   users like the fact that we provide binary packages
-   users like that we have a big amount of packages in binary form
-   users like that we might have those we don't provide as a package in
    the AUR
-   users like that they don't need to mess with repo lists in all cases

My objectives would be:

-   keep the repos as they are as much as possible
-   make ArchStats work in a way that it is not lying and doesn't
    produce as much garbage data
-   drop packages that are listed as not used in ArchStats and move them
    to the AUR
-   find a new way of organizing ourselves which includes:
    -   there must be a easier and more standardized way of finding new
        maintainers
    -   package divisions
    -   ...

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Objectives&oldid=161304"

Category:

-   DeveloperWiki
