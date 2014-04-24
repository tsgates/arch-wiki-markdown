Official repositories
=====================

Related articles

-   Mirrors
-   Arch User Repository
-   Unofficial user repositories
-   PKGBUILD
-   makepkg
-   pacman
-   Arch Build System

A software repository is a storage location from which software packages
are retrieved for installation.

Official repositories containing essential and popular software, readily
accessible via pacman.

They are maintained by package maintainers.

Contents
--------

-   1 Repositories
    -   1.1 core
    -   1.2 extra
    -   1.3 community
    -   1.4 multilib
    -   1.5 testing
        -   1.5.1 community-testing
        -   1.5.2 multilib-testing
-   2 Historical background
    -   2.1 official, unofficial, current & extra

Repositories
------------

> core

This repository can be found in .../core/os/ on your favorite mirror.

core contains packages for:

-   booting Arch Linux
-   connecting to the Internet
-   building packages
-   management and repair of supported file systems
-   the system setup process (e.g. openssh)

as well as dependencies of the above (not necessarily makedepends)

core has fairly strict quality requirements. Developers/users need to
signoff on updates before package updates are accepted. For packages
with low usage, a reasonable exposure is enough: informing people about
update, requesting signoffs, keeping in testing up to a week depending
on the severity of the change, lack of outstanding bug reports, along
with the implicit signoff of the package maintainer.

Note:To create a local repository with packages from core (or other
repositories) without an internet connection see Installing packages
from a CD/DVD or USB stick.

> extra

This repository can be found in .../extra/os/ on your favorite mirror.

extra contains all packages that do not fit in core. Example: Xorg,
window managers, web browsers, media players, tools for working with
languages such as Python and Ruby, and a lot more.

> community

This repository can be found in .../community/os/ on your favorite
mirror.

community contains packages from the Arch User Repository which gained
enough votes to be adopted by a Trusted User.

> multilib

This repository can be found in .../multilib/os/ on your favorite
mirror.

multilib contains 32 bit software and libraries that can be used to run
and build 32 bit applications on 64 bit installs (e.g. wine, skype,
etc).

For more information, see Multilib.

> testing

Warning:Be careful when enabling the testing repository. Your system may
break after performing an update. Only experienced users who know how to
deal with potential system breakage should use it.

This repository can be found in .../testing/os/ on your favorite mirror.

testing contains packages that are candidates for the core or extra
repositories.

New packages go into testing if:

-   They are expected to break something on update and need to be tested
    first.

-   They require other packages to be rebuilt. In this case, all
    packages that need to be rebuilt are put into testing first and when
    all rebuilds are done, they are moved back to the other
    repositories.

testing is the only repository that can have name collisions with any of
the other official repositories. If enabled, it has to be the first
repository listed in your /etc/pacman.conf file.

Note:testing is not for the "newest of the new" package versions. Part
of its purpose is to hold package updates that have the potential to
break the system, either by being part of the core set of packages, or
by being critical in other ways. As such, users of testing are strongly
encouraged to subscribe to the arch-dev-public mailing list, watch the
testing repository forum, and to report all bugs.

If you enable testing, you must also enable community-testing.

community-testing

This repository is like the testing repository, but for packages that
are candidates for the community repository.

If you enable it, you must also enable testing.

multilib-testing

This repository is like the testing repository, but for packages that
are candidates for the multilib repository.

If you enable it, you must also enable testing.

Historical background
---------------------

> official, unofficial, current & extra

Most of the repository splits are for historical reasons. Originally,
when Arch Linux was used by very few users, there was only one
repository known as official (now core). At the time, official basically
contained Judd Vinet's preferred applications. It was designed to
contain one of each "type" of program -- one DE, one major browser, etc.

There were users back then that did not like Judd's selection, so since
the Arch Build System is so easy to use, they created packages of their
own. These packages went into a repository called unofficial, and were
maintained by developers other than Judd. Eventually, the two
repositories were both considered equally supported by the developers,
so the names official and unofficial no longer reflected their true
purpose. They were subsequently renamed to current and extra sometime
near the release version 0.5.

Shortly after the 2007.8.1 release, current was renamed core in order to
prevent confusion over what exactly it contains. The repositories are
now more or less equal in the eyes of the developers and the community,
but core does have some differences. The main distinction is that
packages used for Installation CDs and release snapshots are taken only
from core. This repository still gives a complete Linux system, though
it may not be the Linux system you want.

Some time around 0.5/0.6, there were a lot of packages that the
developers did not want to maintain. Jason Chu set up the "Trusted User
Repositories", which were unofficial repositories in which trusted users
could place packages they had created. There was a staging repository
where packages could be promoted into the official repositories by one
of the Arch Linux developers, but other than this, the developers and
trusted users were more or less distinct.

This worked for a while, but not when trusted users got bored with their
repositories, and not when untrusted users wanted to share their own
packages. This led to the development of the AUR. The TUs were
conglomerated into a more closely knit group, and they now collectively
maintain the community repository. The Trusted Users are still a
separate group from the Arch Linux developers, and there is not a lot of
communication between them. However, popular packages are still promoted
from community to extra on occasion. The AUR also allows untrusted users
to submit PKGBUILDs.

After a kernel in core broke many user systems, the "core signoff
policy" was introduced. Since then, all package updates for core need to
go through a testing repository first, and only after multiple signoffs
from other developers are they allowed to move. Over time, it was
noticed that various core packages had low usage, and user signoffs or
even lack of bug reports became informally accepted as criteria to
accept such packages.

In late 2009/the beginning of 2010, with the advent of some new
filesystems and the desire to support them during installation, along
with the realization that core was never clearly defined (just
"important packages, handpicked by developers"), the repository received
a more accurate description.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Official_repositories&oldid=301082"

Categories:

-   Package management
-   About Arch

-   This page was last modified on 24 February 2014, at 11:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
