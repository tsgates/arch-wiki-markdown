Installing Arch Using Old Installation Media
============================================

Summary

This article give additional steps to the official installation guide,
to allow installing Arch using an old media cd using the Arch Install
Scripts instead of AIF.

Related

Installation Guide: You should still follow the official guide steps.

Note:This guide is only for installation media version 2011.08.19 and
older. For more recent versions, just follow the regular Installation
Guide

In the past, it didn't really matter what version of the installation
media was used to install arch, as long remote repos were used, the
result was an updated arch installation.

That is still true, but several changes have occurred in arch, including
pacman4 and the systemd adoption, that may do difficult the installation
using the media iso 2011.08.19 and older.

The goal of this article is to provide few additional steps to the
Installation Guide, in order to allow you to use an old installation
media to install arch, using the new Arch Install Scripts instead of
AIF.

This is useful in situations like this:

-   Some VPS providers only provide iso files of old media versions.
-   Installation on older computers. While the 2011.08.19 i686 iso was
    able to boot with only 64M RAM and install arch (activating swap),
    more recent versions can't.
-   Maybe an old media cd is the only media you have at hand to install
    arch at any given moment.

Again, this are only additional steps. You should still follow the
Installation Guide.

This steps have been tested using 2010.05 and 2011.08.19 installation
media cds.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Install the Arch Install Scripts                                   |
| -   2 Install haveged                                                    |
| -   3 Edit the fstab file                                                |
| -   4 Fixing Pacman                                                      |
+--------------------------------------------------------------------------+

Install the Arch Install Scripts
--------------------------------

-   Follow the guide until you get internet access.

-   Install arch-install-scripts from the official repositories, making
    sure you update the database; do it like this:

    # pacman -Sy arch-install-scripts

Note:Say no to the question about updating pacman.

-   If you are using a media older than 2011.08.19, edit both
    /usr/bin/pacstrap and /usr/bin/arch-chroot. Look for a line like
    this:

    mount -t devtmpfs udev "$1/dev" -o mode=0755,nosuid &&

And change it to this:

    mount /dev "$1/dev" -o bind,mode=0755,nosuid &&

on both files.

Again, that is not necessary for 2011.08.19 media.

Install haveged
---------------

-   Continue the steps, and after you have done
    pacstrap /mnt base base-devel, do:

    # pacstrap /mnt haveged

Edit the fstab file
-------------------

-   Omit using genfstab. That script does not work on older media.
    You'll need to edit the /mnt/etc/fstab file by hand.

You can use the content of /etc/mtab as reference.

Fixing Pacman
-------------

Once you are inside the arch-choot /mnt:

-   If you are using an installation media older than 2011.08.19, you'll
    need to update pacman's database. Do it like this:

    # pacman-db-upgrade

That is not necessary for 2011.08.19 media.

-   This steps will fix the arch signatures keyring:

    # /usr/sbin/haveged -w 1024 -v 1
    # pacman-key --init
    # pacman -U /var/cache/pacman/pkg/archlinux-keyring*

-   Do the rest of the steps normally.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Using_Old_Installation_Media&oldid=244521"

Category:

-   Getting and installing Arch
