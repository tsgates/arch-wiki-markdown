Ext4
====

Ext4 is the evolution of the most used Linux filesystem, Ext3. In many
ways, Ext4 is a deeper improvement over Ext3 than Ext3 was over Ext2.
Ext3 was mostly about adding journaling to Ext2, but Ext4 modifies
important data structures of the filesystem such as the ones destined to
store the file data. The result is a filesystem with an improved design,
better performance, reliability, and features.

Source: Ext4 - Linux Kernel Newbies

Contents
--------

-   1 Creating ext4 partitions from scratch
-   2 Migrating from ext3 to ext4
    -   2.1 Mounting ext3 partitions as ext4 without converting
        -   2.1.1 Rationale
        -   2.1.2 Procedure
    -   2.2 Converting ext3 partitions to ext4
        -   2.2.1 Rationale
        -   2.2.2 Procedure
        -   2.2.3 Migrating files to extents
-   3 Tips and tricks
    -   3.1 Remove reserved blocks
-   4 Troubleshooting
    -   4.1 Data corruption
    -   4.2 Barriers and Performance
        -   4.2.1 E4rat

Creating ext4 partitions from scratch
-------------------------------------

1.  Upgrade your system: pacman -Syu
2.  Format the partition: mkfs.ext4 /dev/sdxY (replace sdxY with the
    device to format (e.g. sda1))
3.  Mount the partition
4.  Add an entry to /etc/fstab, using the filesystem 'type' ext4
5.  Remember to set appropriate permissions using chmod if the drive is
    not writable

Tip:See the mkfs.ext4 man page for more options; edit /etc/mke2fs.conf
to view/configure default options.

Be aware that by default, mkfs.ext4 uses a rather low bytes-per-inode
ratio to calculate the fixed amount of inodes to be created.

Note:Especially for contemporary HDDs (750 GB+) this usually results in
a much too large inode number and thus many likely wasted GB. The ratio
can be set directly via the -i option; one of 6291456 resulted in 476928
inodes for a 2 TB partition. After three years, this author's root
partition uses about 415 thousand inodes.

Migrating from ext3 to ext4
---------------------------

There are two ways of migrating partitions from ext3 to ext4:

-   mounting ext3 partitions as ext4 without converting (compatibility)
-   converting ext3 partitions to ext4 (performance)

These two approaches are described below.

> Mounting ext3 partitions as ext4 without converting

Rationale

A compromise between fully converting to ext4 and simply remaining with
ext3 is to mount existing ext3 partitions as ext4.

> Pros:

-   Compatibility (the filesystem can continue to be mounted as ext3) –
    This allows users to still read the filesystem from other
    distributions/operating systems without ext4 support (e.g. Windows
    with ext3 drivers)
-   Improved performance (though not as much as a fully-converted ext4
    partition) – See Ext4 - Linux Kernel Newbies for details

> Cons:

-   Fewer features of ext4 are used (only those that do not change the
    disk format such as multiblock allocation and delayed allocation)

Note:Except for the relative novelty of ext4 (which can be seen as a
risk), there is no major drawback to this technique.

Procedure

1.  Edit /etc/fstab and change the 'type' from ext3 to ext4 for any
    partitions you would like to mount as ext4.
2.  Re-mount the affected partitions.
3.  Done.

> Converting ext3 partitions to ext4

Rationale

To experience the benefits of ext4, an irreversible conversion process
must be completed.

> Pros:

-   Improved performance and new features – See Ext4 - Linux Kernel
    Newbies for details

> Cons:

-   Read-only access from Windows can be provided by Ext2Explore, but
    there is currently no driver for writing data.
-   Irreversible (ext4 partitions cannot be 'downgraded' to ext3)

Procedure

These instructions were adapted from
http://ext4.wiki.kernel.org/index.php/Ext4_Howto and
https://bbs.archlinux.org/viewtopic.php?id=61602. They have been tested
and confirmed by this author as of January 16, 2009.

-   UPGRADE! Perform a sysupgrade to ensure all required packages are
    up-to-date: pacman -Syu
-   BACK-UP! Back-up all data on any ext3 partitions that are to be
    converted to ext4. Although ext4 is considered 'stable' for general
    use, it is still a relatively young and untested file system.
    Furthermore, this conversion process was only tested on a relatively
    simple setup; it is impossible to test each of the many possible
    configurations the user may be running.
-   Edit /etc/fstab and change the 'type' from ext3 to ext4 for any
    partitions that are to be converted to ext4.

Warning:ext4 is backwards-compatible with ext3 until extents and other
new fancy options are enabled. If the user has a partition that is
shared with another OS that cannot yet read ext4 partitions, it is
possible to mount said partition as ext4 in Arch and still be able to
use it as ext3 elsewhere at this point... Not so after the next step!
Note, however, that there are fewer benefits to using ext4 if the
partition is not fully converted.

-   The conversion process with e2fsprogs must be done when the drive is
    not mounted. If converting one's root (/) partition, the simplest
    way to achieve this is to boot from some other live medium.
    -   Boot the live medium (if necessary).
    -   For each partition to be converted to ext4:
        -   Ensure the partition is NOT mounted
        -   Run
            tune2fs -O extents,uninit_bg,dir_index /dev/the_partition
            (where /dev/the_partition is replaced by the path to the
            desired partition, such as /dev/sda1)
        -   Run fsck -fDp /dev/the_partition

Note:The user MUST fsck the filesystem, or it will be unreadable! This
fsck run is needed to return the filesystem to a consistent state. It
WILL find checksum errors in the group descriptors -- this is expected.
The '-f' parameter asks fsck to force checking even if the file system
seems clean. The '-p' parameter asks fsck to 'automatically repair'
(otherwise, the user will be asked for input for each error). You may
need to run fsck -f rather than fsck -fp.

-   Reboot Arch Linux!

Warning:If the user converted their root (/) partition, a kernel panic
may be encountered when attempting to boot. If this happens, simply
reboot using the 'fallback' initial ramdisk and re-create the 'default'
initial ramdisk: mkinitcpio -p linux

Migrating files to extents

Warning:Do NOT use the following method with Mercurial repository that
have been cloned locally, as doing so will corrupt the repository. It
might also corrupt other hard link in the filesystem.

Even though the filesystem is now converted to ext4, all files that have
been written before the conversion do not yet take advantage of the new
extents of ext4, which will improve large file performance and reduce
fragmentation and filesystem check time. In order to fully take
advantage of ext4, all files would have to be rewritten on disk. A
utility called e4defrag is being developed and will take care of this
task ; however, it is not yet ready for production.

Fortunately, it is possible to use the chattr program, which will cause
the kernel to rewrite the file using extents. It is possible to run this
command on all files and directories of one partition (e.g. if /home is
on a dedicated partition): (Must be run as root)

    find /home -xdev -type f -print0 | xargs -0 chattr +e
    find /home -xdev -type d -print0 | xargs -0 chattr +e

It is recommended to test this command on a small number of files first,
and check if everything is going all right. It may also be useful to
check the filesystem after conversion.

Using the lsattr command, it is possible to check that files are now
using extents. The letter 'e' should appear in the attribute list of the
listed files.

Tips and tricks
---------------

> Remove reserved blocks

By default 5% of a filesystem will be flagged as reserved for root user
to avoid fragmentation. For modern high-capacity disks, this is higher
than necessary if the partition is used as long-term archive (see this
email for more info). It is generally safe to reduce the percentage of
reserved blocks to free up disk space when the partition is either

-   Very large (for example >50 G)
-   Used as long-term archive

Use the tune2fs utility to do this. The command below would set the
percentage of reserved blocks on the partition /dev/sdXY to 1.0%:

    tune2fs -m 1.0 /dev/sdXY

If you need to find your drive's device name, issue the following
command:

    df -T | awk '{print $1,$2,$NF}' | grep "^/dev"

Troubleshooting
---------------

> Data corruption

Some early adopters of ext4 encountered data corruption after a hard
reboot. Please read Ext4 data loss; explanations and workarounds for
more information.

Since kernel 2.6.30, ext4 is considered "safe(r)." Several patches
improved the robustness of ext4 - albeit at a slight performance cost. A
new mount option (auto_da_alloc) can be used to disable this behavior.
For more information, please read Linux 2 6 30 - Filesystems performance
improvements.

For kernel versions earlier than 2.6.30, consider adding
rootflags=data=ordered to the kernel line in GRUB's menu.lst as a
preventative measure.

> Barriers and Performance

Since kernel 2.6.30, ext4 performance has decreased due to changes that
serve to improve data integrity [1].

Most file systems (XFS, ext3, ext4, reiserfs) send write barriers to
disk after fsync or during transaction commits. Write barriers enforce
proper ordering of writes, making volatile disk write caches safe to use
(at some performance penalty). If your disks are battery-backed in one
way or another, disabling barriers may safely improve performance.

Sending write barriers can be disabled using the barrier=0 mount option
(for ext3, ext4, and reiserfs), or using the nobarrier mount option (for
XFS) [2].

Warning:Disabling barriers when disks cannot guarantee caches are
properly written in case of power failure can lead to severe file system
corruption and data loss.

To turn barriers off add the option barrier=0 to the desired filesystem
in /etc/fstab. For example:

    # /dev/sda5    /    ext4    noatime,barrier=0    0    1

E4rat

E4rat is a preload application designed for the ext4 filesystem. It
monitors files opened during boot, optimizes their placement on the
partition to improve access time, and preloads them at the very
beginning of the boot process.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ext4&oldid=286425"

Category:

-   File systems

-   This page was last modified on 5 December 2013, at 21:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
