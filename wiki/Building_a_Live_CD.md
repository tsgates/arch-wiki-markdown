Building a Live CD
==================

Having a bootable version of Arch Linux running totally off of a CD is
useful in many ways. It can be used to rescue your system, test new
machines and check if the hardware is Linux compatible, keep an updated
installer with the latest packages, make a demo CD to show your
projects, and much more.

This article will give an overview of some methods available for
creating your own Arch Linux-based live media. Please refer to the
respective article for detailed information.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Archiso                                                            |
| -   2 larch                                                              |
| -   3 poison-livecd-creator                                              |
| -   4 Linux-pf                                                           |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Archiso
-------

Archiso is the official tool used to build Arch Linux release images. It
strongly follows the KISS principle and is easy to use. If you want to
build your own updated Arch Linux live installation images, this tool
will get you to your goal quickly, as the Git repository contains the
exact profile used to generate these installation images. However, it
can also be used for completely customizing your live medium. It relies
on an Arch Linux host system.

archiso.

larch
-----

larch aims to provide a more desktop-based approach, and it does not
require an Arch Linux host system.

larch.

Note:As of version 2.6.39, the vanilla kernel no longer supports aufs,
making a custom kernel a necessity.

Note:There is an AUFS version of the arch kernel in AUR(linkplz), and
larch maintains an i686 build, you need not compile anything unless you
want 64 bit

poison-livecd-creator
---------------------

It is a very simple live CD creator. It uses just a Makefile to build
live CD images, and uses pacman to install base and additional packages
to the live CD. You can choose your packages and build them into a live
CD. Moreover, it uses GRUB to boot the live CD in order to add more
flexibility. This means that it is much easier to make a live USB stick
without formating it. For that, you just need to install GRUB into your
USB pen drive and copy the files in the ISO to your root directory in
the pen drive. It relies on an Arch Linux host system and pacman.

poison-livecd-creator.

Linux-pf
--------

It supports aufs among other things, making it an option for live CDs.

linux-pf.

Note:As of version 2.6.39, the vanilla kernel no longer supports aufs,
making a custom kernel a necessity.

See Also
--------

-   Linux Live Kit

Retrieved from
"https://wiki.archlinux.org/index.php?title=Building_a_Live_CD&oldid=248527"

Categories:

-   Arch development
-   Live Arch systems
