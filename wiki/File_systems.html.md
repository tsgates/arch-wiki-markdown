File systems
============

Related articles

-   Partitioning

From Wikipedia:

A file system (or filesystem) is a means to organize data expected to be
retained after a program terminates by providing procedures to store,
retrieve and update data, as well as manage the available space on the
device(s) which contain it. A file system organizes data in an efficient
manner and is tuned to the specific characteristics of the device.

Individual drive partitions can be setup using one of the many different
available filesystems. Each has its own advantages, disadvantages, and
unique idiosyncrasies. A brief overview of supported filesystems
follows; the links are to wikipedia pages that provide much more
information.

Before being formatted, a drive should be partitioned.

Contents
--------

-   1 Type of file systems
    -   1.1 Journaling
    -   1.2 Arch Linux support
-   2 Format a device
    -   2.1 Requirements
    -   2.2 Console tools
    -   2.3 GUI tools

Type of file systems
--------------------

-   Btrfs - Also known as "Better FS", is a new filesystem with powerful
    features similar to Sun/Oracle's excellent ZFS. These include
    snapshots, multi-disk striping and mirroring (software RAID without
    mdadm), checksums, incremental backup, and on-the-fly compression
    that can give a significant performance boost as well as save space.
    As of January 2011, Btrfs is considered unstable although it has
    been merged into the mainline kernel with an experimental status.
    Btrfs appears to be the future of GNU/Linux filesystems and is
    offered as a root filesystem option in all major distribution
    installers.
-   exFAT - Microsoft file system optimized for flash drives. Unlike
    NTFS, exFAT cannot pre-allocate disk space for a file by just
    marking arbitrary space on disk as 'allocated'. As in FAT, when
    creating a file of known length, exFAT must perform a complete
    physical write equal to the size of the file.
-   ext2 - Second Extended Filesystem is an established, mature
    GNU/Linux filesystem that is very stable. A drawback is that it does
    not have journaling support or barriers. Lack of journaling can
    result in data loss in the event of a power failure or system crash.
    It may also be not convenient for root (/) and /home partitions
    because file-system checks can take a long time. An ext2 filesystem
    can be converted to ext3.
-   ext3 - Third Extended Filesystem is essentially the ext2 system with
    journaling support and write barriers. It is backward compatible
    with ext2, well tested, and extremely stable.
-   ext4 - Fourth Extended Filesystem is a newer filesystem that is also
    compatible with ext2 and ext3. It provides support for volumes with
    sizes up to 1 exabyte (i.e. 1,048,576 terabytes) and files sizes up
    to 16 terabytes. It increases the 32,000 subdirectory limit in ext3
    to 64,000. It also offers online defragmentation capability.
-   F2FS - Flash-Friendly File System is a flash file system created by
    Kim Jaegeuk (Hangul: 김재극) at Samsung for the Linux operating
    system kernel. The motivation for F2FS was to build a file system
    that from the start takes into account the characteristics of NAND
    flash memory-based storage devices (such as solid-state disks, eMMC,
    and SD cards), which have been widely being used in computer systems
    ranging from mobile devices to servers.
-   JFS - IBM's Journaled File System was the first filesystem to offer
    journaling. It had many years of development in the IBM AIX®
    operating system before being ported to GNU/Linux. JFS makes the
    smallest demand on CPU resources of any GNU/Linux filesystem. It is
    very fast at formatting, mounting, and filesystem checks (fsck). JFS
    offers very good all-around performance especially in conjunction
    with the deadline I/O scheduler. It is not as widely supported as
    the ext series or ReiserFS, but still very mature and stable.
-   NILFS2 - New Implementation of a Log-structured File System was
    developed by NTT. It records all data in a continuous log-like
    format that is only appended to and never overwritten. It is
    designed to reduce seek times and minimize the type of data loss
    that occurs after a crash with conventional Linux filesystems.
-   NTFS - File system used by Windows. NTFS has several technical
    improvements over FAT and HPFS (High Performance File System), such
    as improved support for metadata, and the use of advanced data
    structures to improve performance, reliability, and disk space
    utilization, plus additional extensions, such as security access
    control lists (ACL) and file system journaling.
-   Reiser4 - Successor to the ReiserFS file system, developed from
    scratch by Namesys and sponsored by DARPA as well as Linspire, it
    uses B*-trees in conjunction with the dancing tree balancing
    approach, in which underpopulated nodes will not be merged until a
    flush to disk except under memory pressure or when a transaction
    completes. Such a system also allows Reiser4 to create files and
    directories without having to waste time and space through fixed
    blocks.
-   ReiserFS - Hans Reiser's high-performance journaling FS (v3) uses a
    very interesting method of data throughput based on an
    unconventional and creative algorithm. ReiserFS is touted as very
    fast, especially when dealing with many small files. ReiserFS is
    fast at formatting, yet comparatively slow at mounting. Quite mature
    and stable. ReiserFSv3 is not being actively developed at this time.
    Generally regarded as a good choice for /var.
-   Swap - Filesystem used for swap partitions.
-   VFAT - Virtual File Allocation Table is technically simple and
    supported by virtually all existing operating systems. This makes it
    a useful format for solid-state memory cards and a convenient way to
    share data between operating systems. VFAT supports long file names.
-   XFS - Early journaling filesystem originally developed by Silicon
    Graphics for the IRIX operating system and ported to GNU/Linux. It
    provides very fast throughput on large files and filesystems and is
    very fast at formatting and mounting. Comparative benchmark testing
    has shown it to be slower when dealing with many small files. XFS is
    very mature and offers online defragmentation capability.
-   ZFS - Combined file system and logical volume manager designed by
    Sun Microsystems. The features of ZFS include protection against
    data corruption, support for high storage capacities, integration of
    the concepts of filesystem and volume management, snapshots and
    copy-on-write clones, continuous integrity checking and automatic
    repair, RAID-Z and native NFSv4 ACLs.

> Journaling

All the above filesystems with the exception of ext2, FAT16/32, use
journaling. Journaling provides fault-resilience by logging changes
before they are committed to the filesystem. In the event of a system
crash or power failure, such file systems are faster to bring back
online and less likely to become corrupted. The logging takes place in a
dedicated area of the filesystem.

Not all journaling techniques are the same. Only ext3 and ext4 offer
data-mode journaling, which logs both data and meta-data. Data-mode
journaling comes with a speed penalty and is not enabled by default. The
other filesystems provide ordered-mode journaling, which only logs
meta-data. While all journaling will return a filesystem to a valid
state after a crash, data-mode journaling offers the greatest protection
against corruption and data loss. There is a compromise in system
performance, however, because data-mode journaling does two write
operations: first to the journal and then to the disk. The trade-off
between system speed and data safety should be considered when choosing
the filesystem type.

> Arch Linux support

-   btrfs-progs — Btrfs support.

http://btrfs.wiki.kernel.org/ || btrfs-progs

-   dosfstools — VFAT support.

http://www.daniel-baumann.ch/software/dosfstools/ || dosfstools

-   exfat-utils — exFAT support.

http://code.google.com/p/exfat/ || exfat-utils

-   f2fs-tools — F2FS support.

https://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git ||
f2fs-tools

-   fuse-exfat — exFAT mount support.

http://code.google.com/p/exfat/ || fuse-exfat

-   e2fsprogs — ext2, ext3, ext4 support.

http://e2fsprogs.sourceforge.net || e2fsprogs

-   jfsutils — JFS support.

http://jfs.sourceforge.net || jfsutils

-   nilfs-utils — NILFS support.

http://www.nilfs.org/ || nilfs-utils

-   ntfs-3g — NTFS support.

http://www.tuxera.com/community/ntfs-3g-download/ || ntfs-3g

-   reiser4progs — ReiserFSv4 support.

http://sourceforge.net/projects/reiser4/ || reiser4progs

-   reiserfsprogs — ReiserFSv3 support.

https://www.kernel.org/ || reiserfsprogs

-   util-linux — Swap support.

http://www.kernel.org/pub/linux/utils/util-linux/ || util-linux

-   xfsprogs — XFS support.

http://oss.sgi.com/projects/xfs/ || xfsprogs

-   zfs — ZFS support.

http://zfsonlinux.org/ || zfs

-   zfs-fuse — ZFS support via FUSE.

http://zfs-fuse.net/ || zfs-fuse

Note:The ZFS filesystem cannot be shrunk by disk utilities such as
GParted.

Format a device
---------------

Warning:Formatting a device removes everything on it, make sure to
backup everything you want to keep.

> Requirements

Before starting, you need to know which name Linux gave to your device.
Hard drives and USB sticks show up as /dev/sdx, where x is a lowercase
letter, while partitions show up as /dev/sdxY, where Y is a number.

If the device you want to format is mounted, it will show up in the
MOUNTPOINT column from:

    $ lsblk

If your device is not mounted:

    # mount /dev/sdxY /some/directory

And to unmount it, you can use umount on the directory you mounted the
disk on:

    # umount /some/directory

Note:Your device must be unmounted to format and create a new file
system.

Manipulate the partition table as you like. For that you can use fdisk
for MBR or gdisk for GPT or GUI tools. See partitioning for more
information.

Now you can create new file systems through console tools or graphic
interface tools.

> Console tools

To create a file system you just have to use mkfs which is just a
unified front-end for the different mkfs.fstype tools. E.g.:

    # mkfs -t ext4 /dev/partition

To create a swap file system, use mkswap:

    # mkswap /dev/partition

> GUI tools

There are several GUI tools for partition management:

-   Gparted — GTK+ Partition Magic clone, frontend to GNU Parted.

http://gparted.sourceforge.net || gparted

-   gnome-disk-utility — Disk management utility for GNOME.

http://www.gnome.org || gnome-disk-utility

-   KDE Partition Manager — KDE utility that allows you to manage disks,
    partitions, and file systems.

https://sourceforge.net/projects/partitionman/ || partitionmanager

Retrieved from
"https://wiki.archlinux.org/index.php?title=File_systems&oldid=297039"

Category:

-   File systems

-   This page was last modified on 12 February 2014, at 21:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
