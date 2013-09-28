Official Repositories
=====================

Summary

Software repositories contain software compiled and packaged by
developers and Trusted Users, readily accessible via pacman. This
article outlines the official repositories provided and supported by
Arch Linux developers.

Overview

Packages in Arch Linux are built using makepkg and a custom build script
for each package (known as a PKGBUILD). Once packaged, software can be
installed and managed with pacman. PKGBUILDs for software in the
official repositories are available from the ABS tree; thousands more
are available from the (unsupported) Arch User Repository.

Related

Mirrors

Arch User Repository

Unofficial User Repositories

A software repository is a storage location from which software packages
may be retrieved and installed on a computer. Arch Linux package
maintainers (developers and Trusted Users) maintain a number of official
repositories containing software packages for essential and popular
software, readily accessible via pacman. This article outlines these
officially supported repositories.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Historical background                                              |
| -   2 [core]                                                             |
| -   3 [extra]                                                            |
| -   4 [community]                                                        |
| -   5 [multilib]                                                         |
| -   6 [testing]                                                          |
| -   7 [community-testing]                                                |
| -   8 [multilib-testing]                                                 |
+--------------------------------------------------------------------------+

Historical background
---------------------

Most of the repository splits are for historical reasons. Originally,
when Arch Linux was used by very few users, there was only one
repository known as [official] (now [core]). At the time, [official]
basically contained Judd Vinet's preferred applications. It was designed
to contain one of each "type" of program -- one DE, one major browser,
etc.

There were users back then that did not like Judd's selection, so since
the Arch Build System is so easy to use, they created packages of their
own. These packages went into a repository called [unofficial], and were
maintained by developers other than Judd. Eventually, the two
repositories were both considered equally supported by the developers,
so the names [official] and [unofficial] no longer reflected their true
purpose. They were subsequently renamed to [current] and [extra]
sometime near the release version 0.5.

Shortly after the 2007.8.1 release, [current] was renamed [core] in
order to prevent confusion over what exactly it contains. The
repositories are now more or less equal in the eyes of the developers
and the community, but [core] does have some differences. The main
distinction is that packages used for Installation CDs and release
snapshots are taken only from [core]. This repository still gives a
complete Linux system, though it may not be the Linux system you want.

Now, sometime around 0.5 or 0.6, they found there were a lot of packages
that the developers did not want to maintain. One of the developers
(Xentac) set up the "Trusted User Repositories", which were unofficial
repositories in which trusted users could place packages they had
created. There was a [staging] repository where packages could be
promoted into the official repositories by one of the Arch Linux
developers, but other than this, the developers and trusted users were
more or less distinct.

This worked for a while, but not when trusted users got bored with their
repositories, and not when untrusted users wanted to share their own
packages. This led to the development of the AUR. The TUs were
conglomerated into a more closely knit group, and they now collectively
maintain the [community] repository. The Trusted Users are still a
separate group from the Arch Linux developers, and there is not a lot of
communication between them. However, popular packages are still promoted
from [community] to [extra] on occasion. The AUR also allows untrusted
users to submit PKGBUILDs.

After a kernel in [core] broke many user systems, the "core signoff
policy" was introduced. Since then, all package updates for [core] need
to go through a [testing] repository first, and only after multiple
signoffs from other developers are they allowed to move. Over time, it
was noticed that various [core] packages had low usage, and user
signoffs or even lack of bug reports became informally accepted as
criteria to accept such packages.

In late 2009/the beginning of 2010, with the advent of some new
filesystems and the desire to support them during installation, along
with the realization that [core] was never clearly defined (just
"important packages, handpicked by developers"), the repository received
a more accurate description (see below).

[core]
------

This repository can be found in .../core/os/ on your favorite mirror.

It has fairly strict quality requirements:

-   Developers and/or users need to signoff on updates before package
    updates are accepted.

-   For packages with low usage, a reasonable exposure (i.e. inform
    people about update, request signoffs, keep in testing up to a week
    depending on the severity of the change, lack of outstanding bug
    reports, along with the implicit signoff of the package maintainer)
    is enough.

It contains packages which:

-   are needed to boot any kind of supported Arch system.
-   may be needed to connect to the Internet.
-   are essential for package building.
-   can manage and check/repair supported filesystems.
-   virtually anyone will want or need early in the system setup process
    (e.g. openssh).
-   are dependencies (but not necessarily makedepends) of the above.

Note:This repository used to be included in the core installation media,
so you could build a fully working base system without Internet access.
This is no longer the case. Internet access is now required in order to
install a new system. See here if you would like to create a local
repository with packages from [core] or from any of the other
repositories.

[extra]
-------

This repository can be found in .../extra/os/ on your favorite mirror.

It contains all packages that do not fit in [core]. Example: Xorg,
window managers, web browsers, media players, tools for working with
languages such as Python and Ruby, and a lot more.

[community]
-----------

This repository can be found in .../community/os/ on your favorite
mirror.

It contains packages from the Arch User Repository which gained enough
votes to be adopted by a Trusted User.

[multilib]
----------

This repository can be found in .../multilib/os/ on your favorite
mirror.

It contains 32 bit software and libraries that can be used to run and
build 32 bit applications on 64 bit installs (e.g. wine, skype, etc).

For more information, see Multilib.

[testing]
---------

Warning:Be careful when enabling the [testing] repository. Your system
may break after performing an update. Only experienced users who know
how to deal with potential system breakage should use it.

This repository can be found in .../testing/os/ on your favorite mirror.

It's special because it contains packages that are candidates for the
[core] or [extra] repositories.

New packages go into [testing] if:

-   They are expected to break something on update and need to be tested
    first.

-   They require other packages to be rebuilt. In this case, all
    packages that need to be rebuilt are put into [testing] first and
    when all rebuilds are done, they are moved back to the other
    repositories.

This is the only repository that can have name collisions with any of
the other official repositories. If enabled, it has to be the first
repository listed in your /etc/pacman.conf file.

Note that it's not for the "newest of the new" package versions. Part of
its purpose is to hold package updates that have the potential to cause
system breakage, either by being part of the [core] set of packages, or
by being critical in other ways. As such, users of the [testing]
repository are strongly encouraged to subscribe to the arch-dev-public
mailing list, watch the [testing] Repository Forum, and to report all
bugs.

If you enable [testing], you must also enable [community-testing].

[community-testing]
-------------------

This repository is like the [testing] repository, but for packages that
are candidates for the [community] repository.

If you enable it, you must also enable [testing].

[multilib-testing]
------------------

This repository is like the [testing] repository, but for packages that
are candidates for the [multilib] repository.

If you enable it, you must also enable [testing].

Retrieved from
"https://wiki.archlinux.org/index.php?title=Official_Repositories&oldid=236723"

Categories:

-   Package management
-   About Arch
