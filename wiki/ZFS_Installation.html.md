ZFS Installation
================

Related articles

-   ZFS
-   Playing with ZFS
-   Installing Arch Linux on ZFS
-   ZFS on FUSE

This article provides several options for the installation of the
requisite ZFS software packages.

Contents
--------

-   1 Building from AUR
    -   1.1 A little script to build these automatically
-   2 Unofficial Repository
    -   2.1 Archiso Tracking Repository

Building from AUR
-----------------

The ZFS kernel module and related utils are available in the AUR; all
are required:

-   spl-utils
-   spl
-   zfs-utils
-   zfs

Note:The ZFS and SPL (Solaris Porting Layer is a Linux kernel module
which provides many of the Solaris kernel APIs) kernel modules are tied
to a specific kernel version. It would not be possible to apply any
kernel updates until updated packages are uploaded to AUR or the archzfs
repository.

Should you wish to update the core/linux package before the AUR/zfs and
AUR/spl packages' dependency lists are updated, a possible work-around
is to remove (uninstall) spl and zfs packages (the respective modules
and file system may stay in-use), update the core/linux package, build +
install zfs and spl packages - just do not forget to edit PKGBUILD and
correct the core/linux version number in "depends" section to match the
updated version). Finally, the system may be rebooted. [ This is only
for the situation, when ZFS is not used for root filesystem. ]

> A little script to build these automatically

The build order of the above is important due to nested dependencies.
One can automate the entire process, including downloading the packages
with the following shell script. The only requirements for it to work
are:

-   sudo - Note that your user needed sudo rights to
    /usr/bin/clean-chroot-manager for the script below to work.
-   rsync - Needed for moving over the build files.
-   cower - Needed to grab sources from the AUR.
-   clean-chroot-manager - Needed to build in a clean chroot and add
    packages to a local repo.

Be sure to add the local repo to /etc/pacman.conf like so:

    $ tail /etc/pacman.conf

    [chroot_local]
    SigLevel = Optional TrustAll
    Server = file:///path/to/localrepo/defined/below

    ~/bin/build_zfs

    #!/bin/bash
    #
    # ZFS Builder by graysky
    #

    # define the temp space for building here
    WORK='/scratch'

    # create this dir and chown it to your user
    # this is the local repo which will store your zfs packages
    REPO='/var/repo'

    # Add the following entry to /etc/pacman.conf for the local repo
    #[chroot_local]
    #SigLevel = Optional TrustAll
    #Server = file:///path/to/localrepo/defined/above

    for i in rsync cower clean-chroot-manager; do
      command -v $i >/dev/null 2>&1 || {
      echo "I require $i but it's not installed. Aborting." >&2
      exit 1; }
    done

    [[ -f ~/.config/clean-chroot-manager.conf ]] &&
      . ~/.config/clean-chroot-manager.conf || exit 1

    [[ ! -d "$REPO" ]] &&
      echo "Make the dir for your local repo and chown it: $REPO" && exit 1

    [[ ! -d "$WORK" ]] &&
      echo "Make a work directory: $WORK" && exit 1

    cd "$WORK"
    for i in spl-utils spl zfs-utils zfs; do
      [[ -d $i ]] && rm -rf $i
      cower -d $i
    done

    for i in spl-utils spl zfs-utils zfs; do
      cd "$WORK/$i"
      sudo ccm s
    done

    rsync -auvxP "$CHROOTPATH/root/repo/" "$REPO"

Unofficial Repository
---------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Does not conform 
                           with Help:Style#Package  
                           management instructions. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

For fast and effortless installation and updates, the "archzfs" signed
repository is available to add to your pacman.conf. The details of the
repositories are given here.

Once the key has been signed, it is now possible to update the package
database and install ZFS packages:

    # pacman -S archzfs

> Archiso Tracking Repository

ZFS can easily be used from within the archiso live environment by using
the special archiso tracking repository for ZFS. This repository makes
it easy to install Arch Linux on a root ZFS filesystem, or to mount ZFS
pools from within an archiso live environment using an up-to-date live
medium. The details for using this repository from a live environment
are given here

This repository and packages are also signed, so the key must be locally
signed following the steps listed in the previous section before use.
For a guide on how to install Arch Linux on to a root ZFS filesystem,
see Installing Arch Linux on ZFS.

When you have the above steps the process is as follows - do not use
pacman -Syyu as this will require a bunch of signatures and build
against a kernel that isn't running from the iso. Instead do:

    # pacman -Syy

    # pacman -S archzfs

If this succeeded then running zfs status should give some output other
than a kernel insmod error. You may then want to partition your drives
using gdisk or something along those lines. If you previously
partitioned your drives with zfs you're going to need to do a zfs
upgrade. Make sure you have a snapshot backed up or a backup image if
you have valuable data before doing this though.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ZFS_Installation&oldid=306110"

Category:

-   File systems

-   This page was last modified on 20 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
