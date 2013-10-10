File Systems
============

> Summary

An overview of the types of file systems available.

> Related

Partitioning

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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Type of File Systems                                               |
|     -   1.1 Journaling                                                   |
|                                                                          |
| -   2 Format a device                                                    |
|     -   2.1 Pre-requirements                                             |
|     -   2.2 Step 1: delete old partitions, create new ones               |
|     -   2.3 Step 2: create the new file system                           |
|         -   2.3.1 In console                                             |
|                                                                          |
|     -   2.4 GUI tools                                                    |
+--------------------------------------------------------------------------+

Type of File Systems
--------------------

-   ext2 Second Extended Filesystem is an established, mature GNU/Linux
    filesystem that is very stable. A drawback is that it does not have
    journaling support (see below) or barriers. Lack of journaling can
    result in data loss in the event of a power failure or system crash.
    It may also be inconvenient for root (/) and /home partitions
    because file-system checks can take a long time. An ext2 filesystem
    can be converted to ext3.
-   ext3 Third Extended Filesystem is essentially the ext2 system with
    journaling support and write barriers. It is backward compatible
    with ext2, well tested, and extremely stable.
-   ext4 Fourth Extended Filesystem is a newer filesystem that is also
    compatible with ext2 and ext3. It provides support for volumes with
    sizes up to 1 exabyte (i.e. 1,048,576 terabytes) and files sizes up
    to 16 terabytes. It increases the 32,000 subdirectory limit in ext3
    to 64,000. It also offers online defragmentation capability.
-   ReiserFS (V3) Hans Reiser's high-performance journaling FS uses a
    very interesting method of data throughput based on an
    unconventional and creative algorithm. ReiserFS is touted as very
    fast, especially when dealing with many small files. ReiserFS is
    fast at formatting, yet comparatively slow at mounting. Quite mature
    and stable. ReiserFS (V3) is not being actively developed at this
    time. Generally regarded as a good choice for /var.
-   JFS IBM's Journaled File System was the first filesystem to offer
    journaling. It had many years of development in the IBM AIX®
    operating system before being ported to GNU/Linux. JFS makes the
    smallest demand on CPU resources of any GNU/Linux filesystem. It is
    very fast at formatting, mounting, and filesystem checks (fsck). JFS
    offers very good all-around performance especially in conjunction
    with the deadline I/O scheduler. It is not as widely supported as
    the ext series or ReiserFS, but still very mature and stable.
    Note:The JFS filesystem cannot be shrunk by disk utilities such as
    gparted.
-   XFS is another early journaling filesystem originally developed by
    Silicon Graphics for the IRIX operating system and ported to
    GNU/Linux. It provides very fast throughput on large files and
    filesystems and is very fast at formatting and mounting. Comparative
    benchmark testing has shown it to be slower when dealing with many
    small files. XFS is very mature and offers online defragmentation
    capability.
    Note:The XFS filesystem cannot be shrunk by disk utilities such as
    gparted.
-   VFAT or Virtual File Allocation Table is technically simple and
    supported by virtually all existing operating systems. This makes it
    a useful format for solid-state memory cards and a convenient way to
    share data between operating systems. VFAT supports long file names.
-   Btrfs Also known as "Better FS", Btrfs is a new filesystem with
    powerful features similar to Sun/Oracle's excellent ZFS. These
    include snapshots, multi-disk striping and mirroring (software RAID
    without mdadm), checksums, incremental backup, and on-the-fly
    compression that can give a significant performance boost as well as
    save space. As of January 2011, Btrfs is considered unstable
    although it has been merged into the mainline kernel with an
    experimental status. Btrfs appears to be the future of GNU/Linux
    filesystems and is offered as a root filesystem option in all major
    distribution installers.
-   NILFS2 New Implementation of a Log-structured File System was
    developed by NTT. It records all data in a continuous log-like
    format that is only appended to and never overwritten. It is
    designed to reduce seek times and minimize the type of data loss
    that occurs after a crash with conventional Linux filesystems.
-   Swap is the filesystem used for swap partitions.
-   NTFS - File system used by windows. Mountable with many utilities
    (e.g. NTFS-3G).

> Journaling

All the above filesystems with the exception of ext2 use journaling.
Journaling provides fault-resilience by logging changes before they are
committed to the filesystem. In the event of a system crash or power
failure, such file systems are faster to bring back online and less
likely to become corrupted. The logging takes place in a dedicated area
of the filesystem.

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

Format a device
---------------

Warning:formatting a device removes everything on it, make sure to
backup everything you want to keep.

> Pre-requirements

Before starting, you need to know which name Linux gave to your device.
Hard drives and USB sticks show up as /dev/sdx, where "x" is a lowercase
letter, while partitions show up as /dev/sdxY, where "Y" is a number.

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

> Step 1: delete old partitions, create new ones

For that you can use fdisk (for MBR) or gdisk (for GPT). See
partitioning for more information.

> Step 2: create the new file system

In console

To create a file system you just have to use mkfs:

    # mkfs -t ext4 /dev/<partition>

As mkfs is just a unified front-end for the different mkfs.fstype tools,
you need to install the packages providing these tools for each
filesystem you want to use:

-   btrfs-progs provides btrfs
-   e2fsprogs provides ext2, ext3 and ext4
-   jfsutils provides jfs
-   ntfsprogs provides ntfs
-   reiserfsprogs provides reiserfs
-   dosfstools provides vfat (also known as msdos)
-   xfsprogs provides xfs
-   nilfs-utils provides nilfs2

> GUI tools

There are several GUI tools for partition management:

-   GParted (GTK) is available in extra
-   gnome-disk-utility
-   KDE Partition Manager (KDE/Qt) is available in AUR

Retrieved from
"https://wiki.archlinux.org/index.php?title=File_Systems&oldid=249516"

Category:

-   File systems
