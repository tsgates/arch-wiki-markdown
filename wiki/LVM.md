LVM
===

> Summary

This article will provide an example of how to install and configure
Arch Linux with Logical Volume Manager (LVM).

Required software

lvm2

> Related

Software RAID and LVM

System Encryption with LUKS

Encrypted LVM

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 LVM Building Blocks                                          |
|     -   1.2 Advantages                                                   |
|     -   1.3 Disadvantages                                                |
|                                                                          |
| -   2 Installing Arch Linux on LVM                                       |
|     -   2.1 Create physical volumes                                      |
|     -   2.2 Create volume group                                          |
|     -   2.3 Create logical volumes                                       |
|     -   2.4 Create filesystems and mount logical volumes                 |
|     -   2.5 Add lvm hook to mkinitcpio.conf                              |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Advanced options                                             |
|     -   3.2 Grow logical volume                                          |
|     -   3.3 Shrink logical volume                                        |
|     -   3.4 Remove logical volume                                        |
|     -   3.5 Add physical volume to a volume group                        |
|     -   3.6 Remove partition from a volume group                         |
|     -   3.7 Snapshots                                                    |
|         -   3.7.1 Introduction                                           |
|         -   3.7.2 Configuration                                          |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Changes that could be required due to changes in the         |
|         Arch-Linux defaults                                              |
|     -   4.2 LVM commands do not work                                     |
|     -   4.3 Logical Volumes do not show up                               |
|     -   4.4 LVM on removable media                                       |
|     -   4.5 kernel options                                               |
|     -   4.6 obsolete stuff                                               |
|                                                                          |
| -   5 Additional resources                                               |
+--------------------------------------------------------------------------+

Introduction
------------

See the Wikipedia article on this subject for more information: Logical
Volume Manager (Linux)

> LVM Building Blocks

Logical Volume Management makes use of the device-mapper feature of the
Linux kernel to provide a system of partitions that is independent of
the underlying disk's layout. With LVM you can abstract your storage
space and have "virtual partitions" which makes it easier to extend and
shrink partitions (subject to the filesystem you use allowing this) and
add/remove partitions without worrying about whether you have enough
contiguous space on a particular disk, without getting caught up in the
problems of fdisking a disk that is in use (and wondering whether the
kernel is using the old or new partition table) and without having to
move other partition out of the way. This is strictly an
ease-of-management issue: it does not provide any additional security.
However, it sits nicely with the other two technologies we are using.

The basic building blocks of LVM are:

-   Physical volume (PV): Partition on hard disk (or even hard disk
    itself or loopback file) on which you can have volume groups. It has
    a special header and is divided into physical extents. Think of
    physical volumes as big building blocks which can be used to build
    your hard drive.
-   Volume group (VG): Group of physical volumes that are used as
    storage volume (as one disk). They contain logical volumes. Think of
    volume groups as hard drives.
-   Logical volume (LV): A "virtual/logical partition" that resides in a
    volume group and is composed of physical extents. Think of logical
    volumes as normal partitions.
-   Physical extent (PE): A small part of a disk (usually 4MB) that can
    be assigned to a logical Volume. Think of physical extents as parts
    of disks that can be allocated to any partition.

Example:

    Physical disks
                    
      Disk1 (/dev/sda):
         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
        |Partition1 50GB (Physical volume) |Partition2 80GB (Physical volume)     |
        |/dev/sda1                         |/dev/sda2                             |
        |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ |
                                      
      Disk2 (/dev/sdb):
         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
        |Partition1 120GB (Physical volume)                 |
        |/dev/sdb1                                          |
        | _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ __ _ _|

    LVM logical volumes

      Volume Group1 (/dev/MyStorage/ = /dev/sda1 + /dev/sda2 + /dev/sdb1):
         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
        |Logical volume1 15GB  |Logical volume2 35GB      |Logical volume3 200GB               |
        |/dev/MyStorage/rootvol|/dev/MyStorage/homevol    |/dev/MyStorage/mediavol             |
        |_ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ |

  

> Advantages

LVM gives you more flexibility than just using normal hard drive
partitions:

-   Use any number of disks as one big disk.
-   Have logical volumes stretched over several disks.
-   Create small logical volumes and resize them "dynamically" as they
    get more filled.
-   Resize logical volumes regardless of their order on disk. It does
    not depend on the position of the LV within VG, there is no need to
    ensure surrounding available space.
-   Resize/create/delete logical and physical volumes online.
    Filesystems on them still need to be resized, but some support
    online resizing.
-   Online/live migration of LV being used by services to different
    disks without having to restart services.
-   Snapshots allow you to backup a frozen copy of the filesystem, while
    keeping service downtime to a minimum.

These can be very helpful in a server situation, desktop less so, but
you must decide if the features are worth the abstraction.

> Disadvantages

-   Linux exclusive (almost). There is no official support in most other
    OS (FreeBSD, Windows..).
-   Additional steps in setting up the system, more complicated.
-   If you use the btrfs filesystem, its Subvolume feature will also
    give you the benefit of having a flexible layout. In that case,
    using the additional Abstraction layer of LVM may be unnecessary.

Installing Arch Linux on LVM
----------------------------

You should create your LVM Volumes between the Partitioning and mkfs
steps of the Installation Procedure. Instead of directly formating a
partition to be you root file file-system, it will be created inside a
logical volume (LV).

Quick overview:

-   Create partition(s) where your PV will reside. Set the partition
    type to 'Linux LVM', which is 8e if you use MBR, 8e00 for GPT.
-   Create your physical volumes (PV). If you have one disk it is best
    to just create one PV in one large partition. If you have multiple
    disks you can create partitions on each of them and create a PV on
    each partition.
-   Create your volume group (VG) and add all the PV to it.
-   Create logical volumes (LV) inside your VG.
-   Continue with “Format the partitions” step of Beginners Guide.
-   When you reach the “Create initial ramdisk environment” step in the
    Beginners Guide, add the lvm hook to mkinitcpio.conf (see below for
    details).

Warning:/boot cannot reside in LVM when using GRUB Legacy, which does
not support LVM. GRUB users do not have this limitation. If you need to
use GRUB Legacy, you must create a separate /boot partition and format
it directly.

> Create physical volumes

Make sure you target the right partitions! To find the partitions with
type 'Linux LVM':

-   MBR system: fdisk -l
-   GPT system: lsblk and then gdisk -l <disk-device>

Create a physical volume on them:

    # pvcreate <disk-device> (e.g.: pvcreate /dev/sda2)

This command creates a header on each partition so it can be used for
LVM. You can track created physical volumes with:

    # pvdisplay

Note:If using a SSD use pvcreate --dataalignment 1m /dev/sda2 (for erase
block size < 1MiB), see e.g. here

> Create volume group

Next step is to create a volume group on this physical volume. First you
need to create a volume group on one of the new partitions and then add
to it all other physical volumes you want to have in it:

    # vgcreate VolGroup00 /dev/sda2
    # vgextend VolGroup00 /dev/sdb1

Also you can use any other name you like instead of VolGroup00 for a
volume group when creating it. You can track how your volume group grows
with:

    # vgdisplay

Note:You can create more than one volume group if you need to, but then
you will not have all your storage presented as one disk.

> Create logical volumes

Now we need to create logical volumes on this volume group. You create a
logical volume with the next command by giving the name of a new logical
volume, its size, and the volume group it will live on:

    # lvcreate -L 10G VolGroup00 -n lvolhome

This will create a logical volume that you can access later with
/dev/mapper/Volgroup00-lvolhome or /dev/VolGroup00/lvolhome. Same as
with the volume groups, you can use any name you want for your logical
volume when creating it.

To create swap on a logical volume, an additional argument is needed:

    # lvcreate -C y -L 10G VolGroup00 -n lvolswap

The -C y is used to create a contiguous partition, which means that your
swap space does not get partitioned over one or more disks nor over
non-contiguous physical extents.

If you want to fill all the free space left on a volume group, use the
next command:

    # lvcreate -l +100%FREE VolGroup00 -n lvolmedia

You can track created logical volumes with:

    # lvdisplay

Note:You may need to load the device-mapper kernel module (modprobe
dm-mod) for the above commands to succeed:

Tip:You can start out with relatively small logical volumes and expand
them later if needed. For simplicity, leave some free space in the
volume group so there is room for expansion.

> Create filesystems and mount logical volumes

Your logical volumes should now be located in /dev/mapper/ and
/dev/YourVolumeGroupName. If you cannot find them, use the next commands
to bring up the module for creating device nodes and to make volume
groups available:

    # modprobe dm-mod
    # vgscan
    # vgchange -ay

Now you can create filesystems on logical volumes and mount them as
normal partitions (if you are installing Arch linux, refer to mounting
the partitions for additional details):

    # mkfs.ext4 /dev/mapper/VolGroup00-lvolhome
    # mount /dev/mapper/VolGroup00-lvolhome /home

Warning:When choosing mountpoints, just select your newly created
logical volumes (use: /dev/mapper/Volgroup00-lvolhome). Do NOT select
the actual partitions on which logical volumes were created (do not use:
/dev/sda2).

> Add lvm hook to mkinitcpio.conf

You'll need to make sure the udev and lvm2 mkinitcpio hooks are enabled.

udev is there by default. Edit the file and insert lvm2 between block
and filesystem like so:

    /etc/mkinitcpio.conf:

    HOOKS="base udev ... block lvm2 filesystems"

Afterwards, you can continue in normal installation instructions with
the create an initial ramdisk step.

Configuration
-------------

> Advanced options

If you need monitoring (needed for snapshots) you can enable lvmetad.
For this set use_lvmetad = 1 in /etc/lvm/lvm.conf. This is the default
by now.

You can restrict the volumes that are activated automatically by setting
the auto_activation_volume_list in /etc/lvm/lvm.conf. If in doubt, leave
this option commented out.

> Grow logical volume

To grow a logical volume you first need to grow the logical volume and
then the filesystem to use the newly created free space. Let us say we
have a logical volume of 15GB with ext3 on it and we want to grow it to
20G. We need to do the following steps:

    # lvextend -L 20G VolGroup00/lvolhome (or lvresize -L +5G VolGroup00/lvolhome)
    # resize2fs /dev/VolGroup00/lvolhome

You may use lvresize instead of lvextend.

If you want to fill all the free space on a volume group, use the next
command:

    # lvextend -l +100%FREE VolGroup00/lvolhome

Warning:Not all filesystems support growing without loss of data and/or
growing online.

Note:If you do not resize your filesystem, you will still have a volume
with the same size as before (volume will be bigger but partly unused).

> Shrink logical volume

Because your filesystem is probably as big as the logical volume it
resides on, you need to shrink the filesystem first and then shrink the
logical volume. Depending on your filesystem, you may need to unmount it
first. Let us say we have a logical volume of 15GB with ext3 on it and
we want to shrink it to 10G. We need to do the following steps:

    # resize2fs /dev/VolGroup00/lvolhome 9G
    # lvreduce -L 10G VolGroup00/lvolhome (or lvresize -L -5G VolGroup00/lvolhome)
    # resize2fs /dev/VolGroup00/lvolhome

Here we shrunk the filesystem more than needed so that when we shrunk
the logical volume we did not accidentally cut off the end of the
filesystem. After that we normally grow the filesystem to fill all free
space left on logical volume. You may use lvresize instead of lvreduce.

> Warning:

-   Do not reduce the filesystem size to less than the amount of space
    occupied by data or you risk data loss.
-   Not all filesystems support shrinking without loss of data and/or
    shrinking online.

Note:It is better to reduce the filesystem to a smaller size than the
logical volume, so that after resizing the logical volume, we do not
accidentally cut off some data from the end of the filesystem.

> Remove logical volume

Warning:Before you remove a logical volume, make sure to move all data
that you want to keep somewhere else, otherwise it will be lost!

First, find out the name of the logical volume you want to remove. You
can get a list of all logical volumes installed on the system with:

    # lvs

Next, look up the mountpoint for your chosen logical volume...:

    $ df -h

... and unmount it:

    # umount /your_mountpoint

Finally, remove the logical volume:

    # lvremove /dev/yourVG/yourLV

Confirm by typing y and you are done.

Do not forget, to update /etc/fstab!

You can verify the removal of your logical volume by typing "lvs" as
root again (see first step of this section).

> Add physical volume to a volume group

You first create a new physical volume on the block device you wish to
use, then extend your volume group

    # pvcreate /dev/sdb1
    # vgextend VolGroup00 /dev/sdb1

This of course will increase the total number of physical extents on
your volume group, which can be allocated by logical volumes as you see
fit.

Note:It is considered good form to a partition table on your storage
medium below LVM, and use the appropriate type code: 8e for MBR, and
8e00 for GPT partitions.

> Remove partition from a volume group

All of the data on that partition needs to be moved to another
partition. Fortunately, LVM makes this easy:

    # pvmove /dev/sdb1

If you want to have the data on a specific physical volume, specify that
as the second argument to pvmove:

    # pvmove /dev/sdb1 /dev/sdf1

Then the physical volume needs to be removed from the volume group:

    # vgreduce myVg /dev/sdb1

Or remove all empty physical volumes:

    # vgreduce --all vg0

And lastly, if you want to use the partition for something else, and
want to avoid LVM thinking that the partition is a physical volume:

    # pvremove /dev/sdb1

> Snapshots

Introduction

LVM allows you to take a snapshot of your system in a much more
efficient way than a traditional backup. It does this efficiently by
using a COW (copy-on-write) policy. The initial snapshot you take simply
contains hard-links to the inodes of your actual data. So long as your
data remains unchanged, the snapshot merely contains its inode pointers
and not the data itself. Whenever you modify a file or directory that
the snapshot points to, LVM automatically clones the data, the old copy
referenced by the snapshot, and the new copy referenced by your active
system. Thus, you can snapshot a system with 35GB of data using just 2GB
of free space so long as you modify less than 2GB (on both the original
and snapshot).

Configuration

You create snapshot logical volumes just like normal ones.

    # lvcreate --size 100M --snapshot --name snap01 /dev/mapper/vg0-pv

With that volume, you may modify less than 100M of data, before the
snapshot volume fills up.

It is important to have the dm-snapshot module listed in the MODULES
variable of /etc/mkinitcpio.conf, otherwise the system will not boot. If
you do this on an already installed system, make sure to rebuild the
image with

    # mkinitcpio -g /boot/initramfs-linux.img

Todo: scripts to automate snapshots of root before updates, to
rollback... updating menu.lst to boot snapshots (separate article?)

snapshots are primarily used to provide a frozen copy of a filesystem to
make backups; a backup taking two hours provides a more consistent image
of the filesystem than directly backing up the partition.

See Create root filesystem snapshots with LVM for automating the
creation of clean root filesystem snapshots during system startup for
backup and rollback.

Encrypted_LVM

Troubleshooting
---------------

> Changes that could be required due to changes in the Arch-Linux defaults

The use_lvmetad = 1 must be set in /etc/lvm/lvm.conf. This is the
default now - if you have a lvm.conf.pacnew file, you must merge this
change.

> LVM commands do not work

-   Load proper module:

    # modprobe dm_mod

The dm_mod module should be automatically loaded. In case it does not,
you can try:

    /etc/mkinitcpio.conf:

    MODULES="dm_mod ..."

You will need to rebuild the initramfs to commit any changes you made.

  

-   Try preceding commands with lvm like this:

    # lvm pvdisplay

> Logical Volumes do not show up

If you are trying to mount existing logical volumes, but they do not
show up in lvscan, you can use the following commands to activate them:

    # vgscan
    # vgchange -ay

> LVM on removable media

Symptoms:

    ~$ sudo vgscan
     Reading all physical volumes.  This may take a while...
     /dev/backupdrive1/backup: read failed after 0 of 4096 at 319836585984: Input/output error
     /dev/backupdrive1/backup: read failed after 0 of 4096 at 319836643328: Input/output error
     /dev/backupdrive1/backup: read failed after 0 of 4096 at 0: Input/output error
     /dev/backupdrive1/backup: read failed after 0 of 4096 at 4096: Input/output error
     Found volume group "backupdrive1" using metadata type lvm2
     Found volume group "networkdrive" using metadata type lvm2

Cause:

Removing an external LVM drive without deactivating the volume group(s)
first. Before you disconnect, make sure to:

    # vgchange -an <volume group name>

Fix: (assuming you already tried to activate the volume group with
vgchange -ay <vg>, and are receiving the Input/output errors

    # vgchange -an <volume group name>

Unplug the external drive and wait a few minutes

    # vgscan
    # vgchange -ay <volume group name>

> kernel options

In kernel options, you may need dolvm. root= should be set to the
logical volume, e.g /dev/mapper/{vg-name}-{lv-name}

  

> obsolete stuff

If you still use sysvinit, modify USELVM appropriately:

    /etc/rc.conf:

    USELVM="yes"

  

Additional resources
--------------------

-   LVM2 Resource Page on SourceWare.org
-   LVM HOWTO article at The Linux Documentation Project
-   Gentoo LVM2 installation guide at Gentoo Documentation
-   LVM article at Gentoo Wiki
-   LVM2 Mirrors vs. MD Raid 1 post by Josh Bryan

Retrieved from
"https://wiki.archlinux.org/index.php?title=LVM&oldid=255378"

Categories:

-   Getting and installing Arch
-   File systems
