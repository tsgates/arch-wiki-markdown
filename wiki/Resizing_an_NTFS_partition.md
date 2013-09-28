Resizing an NTFS partition
==========================

Note:Please ensure you have a backup before attempting this if your data
is important!

Most systems that are purchased already have Windows installed on it,
and some people would prefer not wipe it off completely when doing an
Arch Linux installation. For this reason, among others, it is useful to
resize the existing Windows partition to make room for a Linux partition
or two. This is often accomplished with a Live CD or bootable USB thumb
drive.

For Live CDs the typical procedure is to download a .iso file, burn it
to a CD, and then boot from it. InfraRecorder is a free (as in GPL3)
CD/DVD burning application for Windows which fits the bill nicely. If
you would rather use a bootable USB media instead, UNetbootin is a handy
cross platform tool also available for Windows. Another alternative
which may provide success where UNetbootin fails to create a bootable
media is the LinuxLive USB Creator.

There are a number of bootable CD/USB images avaliable. This list is not
exhaustive by any means, but is a good place to start:

-   System Rescue CD is a good tool to have, and works seamlessly in
    most cases. Once booted, run GParted and the rest should be fairly
    obvious.
-   GParted Live is a small bootable GNU/Linux distribution for x86
    based computers. It enables you to use all the features of the
    latest versions of the GParted application. Does not include
    additional packages System Rescue CD may incorporate, and disk
    encryption schemes may not be supported.
-   Arch Linux "Core Image" ISOs come with parted and ntfsprogs.
    Text-based and not very pretty, but functional.

Note that the important programs for resizing NTFS partitions include
ntfsprogs and a utility like (G)parted or fdisk, provided by the
util-linux package. Unless you are an "advanced" user it is advisable to
use a tool like GParted to perform any resize operations to minimize the
chance of data loss due to user error.

If you already have Arch Linux installed on your system and simply want
to resize an existing NTFS partition, you can use the parted and
ntfsprogs packages to do it. Optionally, you can use the GParted GUI
after installing the gparted package from the [extra] repository. The
AUR also contains a gparted-git package in case you require any
features/fixes that are not yet in the official release.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Resizing_an_NTFS_partition&oldid=240482"

Category:

-   File systems
