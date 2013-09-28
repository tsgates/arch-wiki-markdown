GParted
=======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 GParted Overview                                             |
|     -   1.2 Supported Filesystems                                        |
|                                                                          |
| -   2 Installation on Arch                                               |
| -   3 Optional Dependencies                                              |
|     -   3.1 Filesystems                                                  |
|     -   3.2 Additional functionality                                     |
|                                                                          |
| -   4 GParted Support                                                    |
| -   5 Tips                                                               |
|     -   5.1 Adding GParted-live to your Grub menu                        |
|     -   5.2 Dual Booting with Windows XP                                 |
|     -   5.3 Fixing Messed-up Partition Order                             |
|     -   5.4 Starting GParted from a menu                                 |
+--------------------------------------------------------------------------+

Introduction
------------

> GParted Overview

GParted is a GTK+ frontend to GNU Parted and the official GNOME
Partition Editor application. Use it to make/delete/resize/check
partitions of nearly any file format. You can also manage drive labels
and flags as well as copy/paste entire partitions. GParted is available
in the extra repo and also as a Live CD if you'd prefer. One reason to
actually download the Live CD would be that you need to make
modifications to your root filesystem's partition which you cannot do
without unmounting it.

Warning:Since GParted can read/write to your drive partitions misuse can
result in data loss. It is recommended that you back-up affected
partitions prior to using GParted.

> Supported Filesystems

For a complete list of filesystems GParted can handle, see the features
table over at GParted's homepage.

Installation on Arch
--------------------

GParted is in the extra repo as mentioned above, to install it simply
use Pacman as you would with any other Arch package:

    # pacman -S gparted

Optional Dependencies
---------------------

> Filesystems

The base GParted package doesn't come with support for all filesystems.
Here is a brief list of additional packages you can install to add
support for different filesystems:

  --------------- -------------------------
  Arch Package    Filesystem
  btrfs-progs     btrfs
  dosfstools      fat16/32
  e2fsprogs       ext2/ext3/ext4 (v1.41+)
  jfsutils        jfs
  ntfsprogs       ntfs
  reiser4progs    reiserfs
  reiserfsprogs   reiserfs
  xfsprogs        xfs
  --------------- -------------------------

> Additional functionality

  -------------- -----------------------------------------------------------------------------------
  Arch Package   Functionality
  mtools         Utilities for MSDOS disks. Needed if you want to change the label of FAT-volumes.
  -------------- -----------------------------------------------------------------------------------

Note that when you install GParted via pacman, it will list these for
you also.

GParted Support
---------------

Have a look at the Official GParted Forums prior to executing a command
if you are unsure about what you're doing.

Tips
----

> Adding GParted-live to your Grub menu

See the Gparted-Live wiki article for instructions on adding
GParted-live to your Grub menu so you can boot into the same live
environment as the GParted-live CD directly from Grub and without the
CD!

> Dual Booting with Windows XP

If you have a Windows XP partition that you would like to move from
drive-to-drive that also happens to be your boot partition, you can do
so easily with GParted and keep Windows happy simply by deleting the
following registry key PRIOR to the partition move:

    HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices

Reference to this little gem: here.

> Fixing Messed-up Partition Order

Your partition order can get messed up if you have logical volumes and
you erase one of them. Consider the following example:

    /dev/sda1 (Primary partition)
    /dev/sda2 (Primary partition)
    /dev/sda3 (Primary partition)
    /dev/sda4 (EXTENDED partition)
    /dev/sda5 (Logical partition)
    /dev/sda6 (Logical partition)
    /dev/sda7 (Logical partition)

So 1-3 are primary partitions. 5-6 are logical partitions within the
extended partition. Let's say you want to nuke /dev/sda5 and copy/paste
/dev/sda2 into the resulting freespace. Now your drive looks like this:

    /dev/sda1 (Primary partition)
    /dev/sda2 (Primary partition)
    /dev/sda3 (Primary partition)
    /dev/sda4 (EXTENDED partition)
    /dev/sda7 (Logical partition)
    /dev/sda5 (Logical partition)
    /dev/sda6 (Logical partition)

Notice that the order is messed up after your delete, copy/paste
operation. This can cause all sorts of problems from not being able to
mount an expected partition, to grub error 17/no bootable system. The
solution to this little problem is simple:

-   Boot with your Arch Live CD or GParted Live CD (or any other live
    Linux CD)
-   Run fdisk on the drive, enter expert mode, fix the partition order,
    and write the changes to disk

Example using /dev/sda

    # fdisk /dev/sda

1.  Once you're in fdisk, choose option x (extra functionality (experts
    only)) and enter.
2.  Then select f (fix partition order) and enter.
3.  Then select option w (write table to disk and exit), and enter.

Note:You must run partprobe (as root) or reboot the system in order for
the kernel to read the new partition table!

> Starting GParted from a menu

If you are having issues loading GParted from a menu, for instance the
xfce applications menu. You will have to install the polkit package and
autostart it with your session.

Retrieved from
"https://wiki.archlinux.org/index.php?title=GParted&oldid=234696"

Categories:

-   File systems
-   System recovery
