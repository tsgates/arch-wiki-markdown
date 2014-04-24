Arch Rollback Machine
=====================

Related articles

-   Downgrading Packages

The Arch Rollback Machine (ARM for short) is a daily snapshot of
official Archlinux mirror. You can use it to find an old version of a
package or to change the way you upgrade your system.

Contents
--------

-   1 Location
-   2 Architecture
-   3 Time travel
-   4 Time relativity
-   5 Future
-   6 Sources
-   7 Past

Location
--------

The ARM is available at http://seblu.net/a/arm or
ftp://seblu.net/archlinux/arm

Architecture
------------

The ARM stores each day snapshot in a filesystem hierarchy like the
following. In addition there are 3 symlinks pointing to special
snapshots and one packages directory.

    ├── 2013
    │   ├── 08
    │   │   └── 31
    │   ├── 09
    │   │   ├── 01
    │   │   ├── 02
    │   │   ├── ...
    │   │   ├── 21
    │   │   └── 22
    │   └── 10
    │       ├── 01
    │       ├── 02
    │       ├── ...
    │
    ├── packages
    │   ├── a
    │   │   ├── awesome
    │   │   │   ├── awesome-3.5.0-1-i686.pkg.tar.xz
    │   │   │   ├── awesome-3.5.0-1-x86_64.pkg.tar.xz
    │   │   │   ├── awesome-3.5.1-1-i686.pkg.tar.xz
    │   │   │   ├── ...
    │   │   │ 
    │   │   ├── ...
    │   │   ├── awstats
    │   │   └── axel
    │   │   
    │   ├── b
    │   ├── ...
    │   └── z
    │
    ├── all
    │   ├── awesome-3.5.1-1-i686.pkg.tar.xz
    │   ├── ...
    │   ├── zsh-5.0.2-3-i686.pkg.tar.xz
    │   ├── zsh-5.0.2-4-i686.pkg.tar.xz
    │   └── ...
    │
    ├── last -> 2013/09/22
    ├── month -> 2013/09/01
    └── week -> 2013/09/16

-   The 20xx hierarchy contains daily snapshots of official mirror
    organized by date.
-   The packages hierarchy contains symlinks to all versions of each
    package. One directory by package.
-   The all hierarchy contains symlinks to all versions of each package
    in one flat directory. No listing.
-   The last symlink is updated every day and points to the last
    finished mirror snapshot.
-   The week symlink is updated every week and points to the monday of
    the current week.
-   The month symlink is updated every month and points to the first day
    of the current month.

Time travel
-----------

This feature allow you to get packages and databases at a given date.
You can use it to:

1.  download an old package;
2.  use pacman stuck on a particular day.

To have pacman be stuck on 11th September 2013, edit your
/etc/pacman.conf and use the following server directive:

    [core]
    SigLevel = PackageRequired
    Server=http://seblu.net/a/arm/2013/09/11/$repo/os/$arch

    [extra]
    SigLevel = PackageRequired
    Server=http://seblu.net/a/arm/2013/09/11/$repo/os/$arch

    [community]
    SigLevel = PackageRequired
    Server=http://seblu.net/a/arm/2013/09/11/$repo/os/$arch

or by replace your /etc/pacman.d/mirrorlist by the following content:

    ##                                                                              
    ## Arch Linux repository mirrorlist                                             
    ## Generated on 2042-01-01                                                      
    ##
    Server=http://seblu.net/a/arm/2013/09/11/$repo/os/$arch

Then update the database: # pacman -Syy

Note:It's not safe to mix ARM and up-to-date mirrror. In case of
download failure, you can fallback on a upstream package and you will
have packages not from the same epoch than the rest of the system.

Time relativity
---------------

The feature allow you to get Archlinux upgrades delayed in time. To
upgrade your computer on a weekly or a monthly basis, edit your
/etc/pacman.conf and use the following server directive:

    [core]
    SigLevel = PackageRequired
    Server=http://seblu.net/a/arm/month/$repo/os/$arch
    #Server=http://seblu.net/a/arm/week/$repo/os/$arch

    [extra]
    SigLevel = PackageRequired
    Server=http://seblu.net/a/arm/month/$repo/os/$arch
    #Server=http://seblu.net/a/arm/week/$repo/os/$arch

    [community]
    SigLevel = PackageRequired
    Server=http://seblu.net/a/arm/month/$repo/os/$arch
    #Server=http://seblu.net/a/arm/week/$repo/os/$arch

or by replace your /etc/pacman.d/mirrorlist by the following content:

    ##                                                                              
    ## Arch Linux repository mirrorlist                                             
    ## Generated on 2042-01-01                                                      
    ##
    Server=http://seblu.net/a/arm/month/$repo/os/$arch
    #Server=http://seblu.net/a/arm/week/$repo/os/$arch

Note:It's not safe to mix ARM and up-to-date mirrror. In case of
download failure, you can fallback on a upstream package and you will
have packages not from the same epoch than the rest of the system.

Future
------

This is a kind a TODO list for ARM.

-   Move to official infrastructure.
-   Automatic cleanup after a defined amount of time.

Sources
-------

Scripts used to create this are simple.

You can find them here: https://github.com/seblu/armtools

Past
----

The original ARM has been closed on 2013-08-18 [1].

The new one is hosted on seblu.net since 2013-08-31.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Rollback_Machine&oldid=294935"

Category:

-   Package management

-   This page was last modified on 29 January 2014, at 21:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
