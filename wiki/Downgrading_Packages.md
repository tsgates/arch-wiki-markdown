Downgrading Packages
====================

Summary

Covers why and how to revert to older versions of packages.

Related

Arch Build System

pacman

This guide will show you how to downgrade a package to a previous
version. Downgrading a package is not normally recommended and is often
only necessary when a bug is introduced in the current package.

Before downgrading, consider why you are doing so. If it is because of a
bug, please help both Arch and upstream developers by spending a few
minutes reporting the bug on the Arch bug tracker or to the upstream
project itself. Because Arch is a rolling release distribution, you will
likely be continuously working with new packages and will experience a
bug from time to time.

Both we and the upstream developers would appreciate the effort. That
extra bit of information could save hours of testing and debugging and
may also help release more stable software.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Reason                                                             |
| -   2 The details                                                        |
| -   3 How to downgrade a package                                         |
|     -   3.1 Downgrading the kernel                                       |
|                                                                          |
| -   4 Finding your older version                                         |
|     -   4.1 Out-of-sync mirrors                                          |
|     -   4.2 ARM                                                          |
|     -   4.3 Recompile the package                                        |
|                                                                          |
| -   5 Change repositories                                                |
| -   6 FAQ                                                                |
|     -   6.1 Q: I can not downgrade a package, because of dependencies.   |
|     -   6.2 Q: How do I stop pacman from upgrading downgraded packages?  |
|     -   6.3 Q: I want to go back to how my system was yesterday.         |
+--------------------------------------------------------------------------+

Reason
------

The process of downgrading is that of uninstalling the current package
and installing a previous version. The previous version can be an
immediate version (the package version directly before it) or to a
number of versions prior.

The reasons for downgrading include (among others): that the current
version has a bug, does not yet contain the desired functionality, or
was done for experimental reasons. In any of these cases, the user has
chosen that it would be less problematic to revert to a previous version
than to wait for a new release.

Downgrading a package may mean that other packages may have to be
downgraded with it. For those that have installed a good amount of
experimental packages, and edited a good deal of configurations, it may
be preferable to re-install the system rather than trying to downgrade.

The details
-----------

However, the user must keep in mind the following points:

-   Consider the dependencies of each program. The required libraries
    often change with each version, and the functionality of associated
    files may be completely different from previous ones. The solution
    will require changing these to earlier versions as well.
-   Consider if the necessary files have been removed from the system
    and are even going to be available from any source. Arch Linux's
    rolling release system of repositories are automatically upgraded
    without saving any older versions. See more about this problem
    below.
-   Be careful with changes to configuration files and scripts. At this
    point in time, we will rely upon pacman to handle this for us, as
    long as we do not bypass any safeguards it contains.

The Arch Rollback Machine concept is being developed and awaiting useful
incorporation into pacman. Once that occurs, this will become automated.

How to downgrade a package
--------------------------

-   Q: I just ran pacman -Syu and package XYZ was upgraded to version N
    from version M. This package is causing problems on my computer, how
    can I downgrade from version N to the older version M?
-   A: You may be able to downgrade the package trivially by visiting
    /var/cache/pacman/pkg on your system and seeing if the older version
    of the package is stored there. (If you have not run pacman -Scc
    recently, it should be there). If the package is there, you can
    install that version using
    pacman -U /var/cache/pacman/pkg/pkgname-olderpkgver.pkg.tar.gz.

This process will remove the current package, will carefully calculate
all of the dependency changes, and will install the older version you
have chosen with the proper dependencies down the line.

Note:If you change a fundamental part of the OS, you may end up with the
need to take out literally dozens of packages and replace them with
their older versions. Or they may just be gone and you will have to put
them back in a manual, piece-meal fashion, while being careful that a
particular upgrade does not want to re-install the undesirable package
version you did not want in the first place.

There is also a package in the AUR called downgrade. This is a simple
Bash script which will look in your cache for older versions of
packages. It will also search the A.R.M. if there is no package in your
cache. You can then select a package to install. It basically just
automates the processes outlined here. Check downgrade --help for usage
information.

One more powerful tool is named downgrader, and it works with pacman's
log also, can downgrade packages from ARM, local cache, and work with
list of packages (if your system unstable after upgrade of some
packages, and you unsure about package name)

> Downgrading the kernel

If you are unable to boot after a kernel update, then you can downgrade
the kernel via a live cd. Use a fairly recent Arch Linux installation
medium. When it has booted, mount the partition with your system on
(e.g. /mnt) and if you have /boot or /var on separate partitions, mount
them there, as well (e.g. mount /dev/sdc3 /mnt/boot). Then mount dev,
proc, etc:

    # mount -t proc proc /mnt/proc
    # mount -t sysfs sys /mnt/sys
    # mount -o bind /dev /mnt/dev

And finally, chroot into the system chroot /mnt /bin/bash. Here you can
go to /var/cache/pacman/pkg and downgrade the packages. At least
downgrade linux, linux-headers and any kernel modules. For example:

    # pacman -U linux-3.5.6-1-x86_64.pkg.tar.xz linux-headers-3.5.6-1-x86_64.pkg.tar.xz virtualbox-host-modules-4.2.0-5-x86_64.pkg.tar.xz

Exit the chroot (with exit), reboot and you should be done.

If you have a more exotic setup (lvm, encryption, ...), see this post:
http://sch1zo.github.com/blog/2012/05/08/downgrading-a-bad-kernel-on-arch-with-luks-and-lvm/

Finding your older version
--------------------------

There are three ways to do this.

> Out-of-sync mirrors

If you can not find older versions on your system, check if one of the
mirrors is out of sync, and get it from there. Click here to see the
status of mirrors.

> ARM

The Arch Rollback Machine (ARM) contains archived snapshots of all the
repos going back to 1 November 2009. The site is in a state of flux as
of this date (21 November 2009), and now has lost the items back thru 1
October 2008, as previously reported.

If you are interested in ARM, it would be best to view the introductory
forum announcement and discussion, so as to stay abreast of the current
progress of the project. The introductory forum thread is here.

It is said that the goal was to construct the urls in such a way as to
facilitate easy wget+pacman scripting to "roll back" your system to a
particular date. The automation process is not yet explained. To just
manually search for a particular package, one can use the search page
which has been provided at ARM Search.

There is several tools available (via AUR) for automatically download
old packages from ARM: downgrade, armh and pkgman.

> Recompile the package

In worst-case scenario, if the package is not located anywhere else, you
will need to compile the older version yourself. To do this you will
need a PKGBUILD for the file; you could edit the existing PKGBUILD
provided by ABS to use older sources, or you can visit
https://www.archlinux.org/packages/ and search for the package you wish
to downgrade. Once you find it, click "View Changes" and select "log".
Locate the version you need and click on the path. Then just download
the files located in that directory and build it with makepkg.

For AUR packages, currently the only way to get the older PKGBUILDs is
at http://pkgbuild.com/git/aur-mirror.git/ or check the Unofficial User
Repositories for precompiled binaries (they are sometimes out of date).

Change repositories
-------------------

To change repository to ARM, remarks-out the old line and adds the
appropriate directory location in the format:

    [core]
    #Server=http://mirrors.gigenet.com/archlinux/core/os/i686
    Server=http://arm.konnichi.com/2009/11/01/core/os/i686

In this example, the date section is taking whatever packages are
available as of the date of November 1st, 2009. Please note that all
repositories are snapshots of the official repositories. You need only
change the mirror in /etc/pacman.d/mirrorlist, placing an ARM mirror at
the top. For example, http://arm.konnichi.com/2009/11/01/$repo/os/i686
to sync all official repositories listed in /etc/pacman.conf to the
chosen ARM mirror then update with:

    # pacman -Syy   #Refresh the sync databases.
    # pacman -Suu   #Downgrade all packages with a lower version in the repos.

This alone does not guarantee a seamless rollback as there are sometimes
package conflicts with regards to version numbers, etc. If you know the
repository it may be easier to visit the global mirror. For example,
http://arm.konnichi.com/core/os/i686 (note the omission of the date).

More information, please see pacman.

FAQ
---

Q: I can not downgrade a package, because of dependencies.

A: You can ignore dependencies when upgrading or removing, using the d
flag. But this might break your system further.

    # pacman -Ud /path/to/packagename-oldversion.pkg.tar.gz

Q: How do I stop pacman from upgrading downgraded packages?

A: Uncomment IgnorePkg from /etc/pacman.conf and add them in sequence.
For example:

    /etc/pacman.conf

    ...
    IgnorePkg = gimp libtorrent-rasterbar
    ...

This will instruct pacman to ignore any upgrades for selected packages
when performing a system update.

Q: I want to go back to how my system was yesterday.

A: It is easy if you have enabled periodic snapshots provided by LVM.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Downgrading_Packages&oldid=255536"

Category:

-   Package management
