Removing System Encryption
==========================

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: written in first 
                           person. (Discuss)        
  ------------------------ ------------------------ ------------------------

Removing system encryption with dm-crypt and LUKS.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Boot into a Live Environment                                       |
| -   3 Activate Partitions                                                |
|     -   3.1 Note About Different Setups                                  |
|     -   3.2 Once Partitions Are Located                                  |
|         -   3.2.1 Mounting backup space                                  |
|                                                                          |
| -   4 Backup Data                                                        |
| -   5 Undo Encryption                                                    |
| -   6 Restore Data                                                       |
| -   7 Reconfigure the Operating System                                   |
+--------------------------------------------------------------------------+

Prerequisites
-------------

-   An encrypted root filesystem or other filesystem that cannot be
    umounted while booted into the operating system.
-   Enough drive space to store a backup.
-   An Arch Linux (or other) live CD.
-   A few hours.

Boot into a Live Environment
----------------------------

Download and burn the latest archlive cd, reboot system and boot to cd.

Activate Partitions
-------------------

> Note About Different Setups

An example setup is shown here:

disk

ntfs

myvg(lvm)

ntfs

other os

cryptswap(lv)

cryptroot(lv)

Shared

luks

luks

swap

root(xfs)

The grey sections only add a frame of reference and can be disregarded.
The green partitions will be modified. Green text must match your
system's setup. The yellow partition will be used as storage space and
may be changed at will. In the example system: myvg contains lvs called
cryptroot and cryptswap. they are located at /dev/mapper/myvg_cryptroot
and /dev/mapper/myvg_cryptswap. Upon boot, luks is used along with a few
crypttab entries to create /dev/mapper/root and /dev/mapper/swap. Swap
will not be unencrypted as part of this guide, as undoing the swap
encryption does not require any complex backup or restoration.

The example system is not indicative of all systems. Different
filesystems require different tools to effectively backup and restore
their data. LVM can be ignored if not used. XFS requires xfs_copy to
ensure an effective backup and restore, DD is insufficient. DD may be
used with ext2,3,and 4. (Someone please comment on jfs, reiserfs and
reiser4fs)

> Once Partitions Are Located

Load necessary modules:

    modprobe dm-mod #device mapper/lvm
    modprobe dm-crypt #luks

Activate lvm volume group:

    pvscan #scan for Physical Volumes
    vgscan #scan for volume groups
    lvscan #scan for logical volumes
    lvchange -ay myvg/cryptroot

Open the encrypted filesystem with luks so it can be read:

    cryptSetup luksOpen /dev/mapper/myvg_cryptroot root

Enter password. Note: The only partition that will be operated on that
should be mounted at this point is the backup partition. If a partition
other than the backup partition is already mounted, it can be safely
umounted it now.

  

Mounting backup space

Only if using NTFS to store the backup

    # pacman -S ntfs-3g

The next step is important for backup storage.

    # mount -t ntfs-3g -o rw /dev/sda5 /media/Shared

or use netcat to store the backup on a remote system

TODO: add netcat instructions.

Backup Data
-----------

Using xfs_copy:

    xfs_copy -db /dev/mapper/root /media/Shared/backup_root.img

Note: -d flag preserves uuids and -b ensures direct IO is not attempted
to any of the target files.

Using dd:

    dd if=/dev/mapper/root of=/media/Shared/backup_root.img

Undo Encryption
---------------

Now the crucial moment, the point of no return if you will. Make sure
you are ready to do this. If you plan to undo this later, you will have
to almost start from scratch. You know how fun that is.

    cryptsetup luksClose root
    lvm lvremove myvg/cryptroot

Restore Data
------------

We have to create a new logical volume to house our root filesystem,
then we restore our filesystem.

    lvm lvcreate -l 100%FREE -n root myvg
    xfs_copy -db /media/Shared/backup_root.img /dev/mapper/myvg-root #notice the second drive name is changed now.

Reconfigure the Operating System
--------------------------------

You need to boot into your operating system and edit /etc/crypttab,
/etc/mkinitcpio.conf, /etc/fstab, and possibly /boot/grub/menu.lst.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Removing_System_Encryption&oldid=254949"

Category:

-   Security
