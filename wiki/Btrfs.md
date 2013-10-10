Btrfs
=====

> Summary

Provides an overview and setup of Btrfs on Arch Linux.

> Related

Installing on Btrfs root

Btrfs is an abbreviation for B-tree File System and is also known as
"Butter FS" or "Better FS". Btrfs is a copy-on-write (COW) file system
written from the ground up for Linux. It is aimed at implementing
advanced features while focusing on fault tolerance, repair and easy
administration. Jointly developed by Oracle, Red Hat, Fujitsu, Intel,
SUSE and many others, Btrfs is licensed under the GPL and open for
contribution from anyone.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 File system creation                                               |
|     -   2.1 Creating a new file system                                   |
|     -   2.2 Convert from Ext3/4                                          |
|                                                                          |
| -   3 Limitations                                                        |
|     -   3.1 Encryption                                                   |
|     -   3.2 Swap file                                                    |
|     -   3.3 GRUB2 and core.img                                           |
|                                                                          |
| -   4 Features                                                           |
|     -   4.1 Copy-On-Write (CoW)                                          |
|     -   4.2 Multi-device filesystem and RAID feature                     |
|         -   4.2.1 Multi-device filesystem                                |
|         -   4.2.2 RAID features                                          |
|                                                                          |
|     -   4.3 Sub-volumes                                                  |
|     -   4.4 Snapshots                                                    |
|     -   4.5 Defragmentation                                              |
|     -   4.6 Compression                                                  |
|                                                                          |
| -   5 Resources                                                          |
+--------------------------------------------------------------------------+

Installation
------------

As of the beginning of the year 2013 Btrfs is included in the default
kernel and its' tools (btrfs-progs) are part of the default
installation. GRUB 2, mkinitcpio, and Syslinux have support for Btrfs
and require no additional configuration.

File system creation
--------------------

A Btrfs file system can either be newly created or have one converted.

> Creating a new file system

To format do a partition do:

    # mkfs.btrfs /dev/<partition>

Multiple devices can be entered to create a RAID. Supported RAID levels
include RAID 0, RAID 1 and RAID 10. By default the metadata is mirrored
and data is striped.

    # mkfs.btrfs [options] /dev/<part1> /dev/<part2>

> Convert from Ext3/4

Boot from an install CD, then convert by doing:

    # btrfs-convert /dev/<partition>

Mount the partion and test the conversion by checking the files. Be sure
to change the /etc/fstab to reflect the change (type to btrfs and
fs_passno [the last field] to 0 as Btrfs does not do a file system check
on boot). chroot into the system and rebuild the GRUB menu list (see
Install from Existing Linux and GRUB articles).

To complete, delete the saved image, delete the sub-volume that image is
on, then balance the drive to reclaim the space.

    # rm /ext2_saved/*
    # btrfs subvolume delete /ext2_saved

Limitations
-----------

A few limitations should be known before trying.

> Encryption

Btrfs has no built-in encryption support (this may come in future), but
you can encrypt the partition before running mkfs.btrfs. See Dm-crypt
with LUKS.

(If you've already created a btrfs file system, you can also use
something like EncFS or TrueCrypt, though perhaps without some of btrfs'
features.)

> Swap file

Btrfs does not support swap files. This is due to swap files requiring a
function that Btrfs doesn't have for possibility of corruptions.link A
swap file can be mounted on a loop device with poorer performance but
will not be able to hibernate. A systemd service file is available
systemd-loop-swapfile.

> GRUB2 and core.img

Grub 2 can boot Btrfs partitions however the module is larger than e.g.
ext4 and the core.img file made by grub-install may not fit between the
MBR and the first partition. This can be solved by using GPT or by
putting an extra 1 or 2 MB of free space before the first partition.

Features
--------

Various features are available and can be adjusted.

> Copy-On-Write (CoW)

CoW comes with some advantages, but can negatively affect performance
with large files that have small random writes. It is recommended to
disable CoW for database files and virtual machine images. You can
disable CoW for the entire block device by mounting it with "nodatacow"
option. However, this will disable CoW for the entire file system.

To disable CoW for single files/directories do:

    # chattr +C </dir/file>

Note, from chattr man page: For btrfs, the 'C' flag should be set on new
or empty files. If it is set on a file which already has data blocks, it
is undefined when the blocks assigned to the file will be fully stable.
If the 'C' flag is set on a directory, it will have no effect on the
directory, but new files created in that directory will have the No_COW
attribute.

Likewise, to save space by forcing CoW when copying files use:

    # cp --reflink source dest 

As dest file is changed, only those blocks that are changed from source
will be written to the disk. One might consider aliasing aliasing cp to
'cp --reflink=auto'

> Multi-device filesystem and RAID feature

Multi-device filesystem

When creating a btrfs filesystem, you can pass as many partitions or
disk devices as you want to mkfs.btrfs. The filesystem will be created
across these devices. You can "merge" this way, multiple partitions or
devices to get a big btrfs filesystem.

You can also add or remove device from an existing btrfs filesystem
(caution is mandatory).

A multi-device btrfs filesystem (also called a btrfs volume) is not
recognized until

     # btrfs device scan

has been run. This is the purpose of the btrfs mkinitcpio hook or the
USEBTRFS variable in /etc/rc.conf

RAID features

When creating multi-device filesystem, you can also specify to use
RAID0, RAID1 or RAID10 across the devices you have added to the
filesystem. RAID levels can be applied independently to data and meta
data. By default, meta data is duplicated on single volumes or RAID1 on
multi-disk sets.

btrfs works in block-pairs for raid0, raid1, and raid10. This means:

raid0 - block-pair stripped across 2 devices  
 raid1 - block-pair written to 2 devices

For 2 disk sets, this matches raid levels as defined in md-raid (mdadm).
For 3+ disk-sets, the result is entirely different than md-raid.

For example:  
 3 1TB disks in an md based raid1 yields a /dev/md0 with 1TB free space
and the ability to safely loose 2 disks without losing data. 3 1TB disks
in a btrfs volume with data=raid1 will allow the storage of
approximately 1.5TB of data before reporting full. Only 1 disk can
safely be lost without losing data.

btrfs uses a round-robin scheme to decide how block-pairs are spread
among disks. As of Linux 3.0, a quasi-round-robin scheme is used which
prefers larger disks when distributing block pairs. This allows raid0
and raid1 to take advantage of most (and sometimes all) space in a disk
set made of multiple disks. For example, a set consisting of a 1TB disk
and 2 500GB disks with data=raid1 will place a copy of every block on
the 1TB disk and alternate (round-robin) placing blocks on each of the
500GB disks. Full space utilization will be made. A set made from a 1TB
disk, a 750GB disk, and a 500GB disk will work the same, but the
filesystem will report full with 250GB unusable on the 750GB disk. To
always take advantage of the full space (even in the last example), use
data=single. (data=single is akin to JBOD defined by some raid
controllers) See the BTRFS FAQ for more info.

> Sub-volumes

One of the features of Btrfs is the use of sub-volumes. Sub-volumes are
basically a named btree that holds files and directories. They have
inodes inside the tree of tree roots and can have non-root owners and
groups. Sub-volumes can optionally be given a quota of blocks. All of
the blocks and file extents inside of sub-volumes are reference counted
to allow snapshotting. This is similar to the dynamically expanding
storage of a virtual machine that will only use as much space on a
device as needed, eliminating several half-filled partitions. One can
also mount the sub-volumes with different mount options, giving more
flexibility in security.

To create a sub-volume:

    # btrfs subvolume create [<dest>/]

For increased flexibility, install your system into a dedicated
sub-volume, and, in the kernel boot parameters, use:

    rootflags=subvol=<whatever you called the subvol>

This makes system rollbacks possible.

If using for the root partition, it is advisable to add crc32c (or
crc32c-intel for Intel machines) to the modules array in
/etc/mkinitcpio.conf.

> Snapshots

To create a snapshot:

    # btrfs subvolume snapshot <source> [<dest>/]<name>

Snapshots are not recursive, this means that every subvolume inside
subvolume will be an empty directory inside the snapshot.

> Defragmentation

Btrfs supports online defragmentation. To defragment the metadata of the
root folder do:

    # btrfs filesystem defragment /

This will not defragment the entire system. For more information read
this page on the btrfs wiki.

To defragment the entire system verbosely do:

    # find / -xdev -type f -print -exec btrfs filesystem defrag '{}' \;

> Compression

Btrfs supports transparent compression, which means every file on the
partition is automatically compressed. This does not only reduce the
size of those files, but also improves performance, in particular if
using the lzo algorithm. Compression is enabled using the compress=gzip
or compress=lzo mount options. Only files created or modified after the
mount option is added will be compressed, so to fully benefit from
compression it should be enabled during installation. After preparing
the storage drive, simply switch to another terminal (Ctrl+Alt+number),
and run the following command:

    # mount -o remount,compress=lzo /dev/sdXY /mnt/target

After the installation is finished, add compress=lzo to the mount
options of the root filesystem in /etc/fstab.

Resources
---------

-   Btrfs Wiki
-   BTRFS Problem FAQ - Official FAQ
-   Funtoo Btrfs wiki entry - Very well-written article
-   Avi Miller presenting BTRFS at SCALE 10x. Jan/2012.
-   Summary of Chris Mason's talk from LFCS 2012
-   On 2012-03-28, btrfs-progs includes btrfsck, a tool that can fix
    errors on btrfs filesystems.
-   Oracle has packaged this version of btrfs-progs and released it to
    their customers of Oracle Linux 6 and backported to 5.
-   mkinitcpio-btrfs: for roll-back abilities (currently unmaintained).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Btrfs&oldid=255983"

Category:

-   File systems
