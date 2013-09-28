Persistent block device naming
==============================

Summary

An overview of persistent block device naming; the preferred method of
referencing block devices.

Related articles

fstab

udev

LVM

This article describes how to use persistent names for your block
devices. This has been made possible by the introduction of udev and has
some advantages over bus-based naming. If your machine has more than one
SATA, SCSI or IDE disk controller, the order in which their
corresponding device nodes are added is arbitrary. This may result in
device names like /dev/sda and /dev/sdb switching around on each boot,
culminating in an unbootable system, kernel panic, or a block device
disappearing. Persistent naming solves these issues.

Note:If you are using LVM2, this article is not relevant as LVM takes
care of this automatically.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Persistent naming methods                                          |
|     -   1.1 by-label                                                     |
|     -   1.2 by-uuid                                                      |
|     -   1.3 by-id and by-path                                            |
|     -   1.4 Individual device names                                      |
|                                                                          |
| -   2 Using persistent naming                                            |
|     -   2.1 fstab                                                        |
|     -   2.2 Boot managers                                                |
+--------------------------------------------------------------------------+

Persistent naming methods
-------------------------

There are four different schemes for persistent naming: by-label,
by-uuid, by-id and by-path. The following sections describes what the
different persistent naming methods are and how they are used.

Here is a good command for viewing all the information.

    # lsblk -f

    NAME   FSTYPE LABEL    UUID                                 MOUNTPOINT
    sda                                                         
    ├─sda1 ext2            7f4cef7e-7ee2-489a-b759-d52ba23b692c /boot
    ├─sda2 swap            a807fff3-e89f-46d0-ab17-9b7ad3efa7b5 [SWAP]
    ├─sda3 ext4            81917291-fd1a-4ffe-b95f-61c05cfba76f /
    └─sda4 ext4            c4c23598-19fb-4562-892b-6fb18a09c7d3 /home
    sdb
    └─sdb1 ext4   X2       4bf265f7-da17-4575-8758-acd40885617b /mnt/X1
    sdc
    └─sdc1 ext4   X1       4bf265f7-da17-4575-8758-acd40885617b /mnt/X2
    sdd
    └─sdd1 ext4   Y2       8a976a06-3e56-476f-b73a-ea3cad41d915 /mnt/Y2
    sde
    └─sde1 ext4   Z2       9d35eaae-983f-4eba-abc9-434ecd4da09c /mnt/Z2
    sdf
    └─sdf1 ext4   Y1       e2ec37a9-0689-46a8-a07b-0609ce2b7ea2 /mnt/Y1
    sdg
    └─sdg1 ext4   Z1       9fa239c1-720f-42e0-8aed-39cf53a743ed /mnt/Z1
    sdj
    ├─sdj1 ext4   RAPT     a9ed7ecb-96ce-40fe-92fa-e07a532ed157
    └─sdj2 swap            20826c74-eb6d-46f8-84d8-69b933a4bf3f [SWAP]

> by-label

Almost every filesystem type can have a label. All your partitions that
have one are listed in the /dev/disk/by-label directory. This directory
is created and destroyed dynamically, depending on whether you have
partitions with labels attached.

    $ ls -lF /dev/disk/by-label

    total 0
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 data -> ../../sdb2
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 data2 -> ../../sda2
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 fat -> ../../sda6
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 home -> ../../sda7
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 root -> ../../sda1
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 swap -> ../../sda5
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 windows -> ../../sdb1

The labels of your filesystems can be changed, but note that they have
to be unambiguous to prevent any possible conflicts. Following are some
methods for changing labels on common filesystems:

 swap 
    swaplabel -L <label> /dev/XXX
 ext2/3/4 
    e2label /dev/XXX <label> using e2fsprogs
 btrfs 
    btrfs filesystem label /dev/XXX <label> using btrfs-progs
 reiserfs 
    reiserfstune -l <label> /dev/XXX using reiserfsprogs
 jfs 
    jfs_tune -L <label> /dev/XXX using jfsutils
 xfs 
    xfs_admin -L <label> /dev/XXX using xfsprogs
 fat/vfat 
    dosfslabel /dev/XXX <label> using dosfstools
 fat/vfat 
    mlabel -i /dev/XXX ::<label> using mtools
 ntfs 
    ntfslabel /dev/XXX <label> using ntfsprogs

Note:Labels can be up to 16 characters long.

> by-uuid

UUID is a mechanism to give each filesystem a unique identifier. It is
designed so that collisions are unlikely. All GNU/Linux filesystems
(including swap and LUKS headers of raw encrypted devices) support UUID.
FAT and NTFS filesystems (fat and windows labels above) do not support
UUID, but are still listed in /dev/disk/by-uuid with a shorter UID
(unique identifier):

    # ls -l /dev/disk/by-uuid/

    total 0
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 2d781b26-0285-421a-b9d0-d4a0d3b55680 -> ../../sda1
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 31f8eb0d-612b-4805-835e-0e6d8b8c5591 -> ../../sda7
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 3FC2-3DDB -> ../../sda6
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 5090093f-e023-4a93-b2b6-8a9568dd23dc -> ../../sda2
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 912c7844-5430-4eea-b55c-e23f8959a8ee -> ../../sda5
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 B0DC1977DC193954 -> ../../sdb1
    lrwxrwxrwx 1 root root 10 Oct 16 10:27 bae98338-ec29-4beb-aacf-107e44599b2e -> ../../sdb2

The advantage about using the UUID method is that it is less likely that
you have name collisions than with labels. The disadvantage is that
UUIDs make long code lines hard to read and break formatting in many
configuration files (e.g. fstab or crypttab). Also every time a
partition is resized or reformatted a new UUID is generated and configs
have to get adjusted (manually).

> by-id and by-path

by-id creates a unique name depending on the hardware serial number,
by-path depending on the shortest physical path (according to sysfs).
Both contain strings to indicate which subsystem they belong to (i.e.
-ide- for by-path, and -ata- for by-id) and thus are not suitable for
solving the problems mentioned in the beginning of this article. They
will not be discussed any further here.

> Individual device names

You can also create individual device names: udev#Setting static device
names (for iscsi).

Using persistent naming
-----------------------

There are various applications that can be configured using persistent
naming. Following are some examples of how to configure them.

> fstab

To enable persistent naming in /etc/fstab replace the device kernel name
in the first column with the persistent name path as follows:

    /dev/disk/by-label/home_myhost ...
    /dev/disk/by-uuid/31f8eb0d-612b-4805-835e-0e6d8b8c5591 [...]

or directly specify the persistent name type using a prefix:

    LABEL=home_myhost ...
    UUID=1f8eb0d-612b-4805-835e-0e6d8b8c5591 [...]

> Boot managers

To use persistent names in your boot manager, the following
prerequisites must be met:

-   You are using a mkinitcpio initial RAM disk image
-   You have udev enabled in /etc/mkinitcpio.conf

In the above example, /dev/sda1 is the root partition. In the GRUB
grub.cfg file, the linux line looks like this:

    linux /boot/vmlinuz-linux root=/dev/sda1 ro quiet

Depending on which naming scheme you would prefer, change it to one of
the following:

    linux /boot/vmlinuz-linux root=/dev/disk/by-label/root_myhost ro quiet

or:

    linux /boot/vmlinuz-linux root=UUID=2d781b26-0285-421a-b9d0-d4a0d3b55680 ro quiet

If you are using LILO, then do not try this with the root=...
configuration option; it will not work. Use append="root=..." or
addappend="root=..." instead. Read the LILO man page for more
information on append and addappend.

There is an alternative way to use the label embedded in the filesystem.
For example if (as above) the filesystem in /dev/sda1 is labeled
root_myhost, you would give this line to GRUB:

    linux /boot/vmlinuz-linux root=LABEL=root_myhost ro quiet

Retrieved from
"https://wiki.archlinux.org/index.php?title=Persistent_block_device_naming&oldid=255294"

Categories:

-   Boot process
-   File systems
-   Hardware detection and troubleshooting
