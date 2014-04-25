Installing Arch Linux with EVMS
===============================

  
 This HOWTO describes how to install Arch Linux with all filesytems
(including the root-filesystem) managed by Enterprise Volume Management
System (EVMS).

  

Note: EVMS is no longer being developed. The last stable version was
released in 2006. An alternative to EVMS is LVM. Also many of the
features in EVMS were added to LVM.

Contents
--------

-   1 Disclaimer
-   2 Introduction
-   3 Storage plan
-   4 Installing Arch Linux on the temporary partition
-   5 Install EVMS in Arch Linux
-   6 Create EVMS-volumes
-   7 Copy the installation to the right volumes
-   8 Links

Disclaimer
----------

Following this guide can destroy your data. Backup all your data first
or live with it if something goes wrong.

Introduction
------------

EVMS is a tool that provides easy and unified access to RAID
(0,1,4,5,6,10), LVM, expanding and shrinking of volumes and file
systems, bad block relocation and more.   
 EVMS is not supported on the Arch Linux install CDs, so the install
requires some extra steps:

1.  Install a minimal Arch Linux system on a normal partition
2.  Install the EVMS package and create EVMS-volumes
3.  Copy all files to the EVMS-volumes

It's not my intention to explain all ins and outs of EVMS, readers
unfamiliar with EVMS should read the EVMS User Guide.

I've tested EVMS on Arch Linux in a virtual machine (VirtualBox). I'm
relatively new to Arch Linux, but I've used EVMS for about 2 years on
Gentoo.

Storage plan
------------

An important part of setting up a system with EVMS is making a plan that
describes how the harddisk space will be used, where you use RAID or LVM
and so on. Because the install CD does not support EVMS, you need a
partition of a minimum of 500MB for the initial installation. After the
installation this partition is available for normal use, for example as
Swap-space. Another solution is to use a portable medium (e.g. a flash
drive) with Arch installed already, and perform these operations on a
mounted hard drive within the target system; however, this method will
not be covered in the procedure below.

In this HOWTO I will use an example setup with 2 disks, 4GB and 2GB.
I'll create 5 volumes: A picture tells more than a thousand words:

[Storage-plan-evms.png]

You'll need at least one "Compatibility volume" with enough space for a
minimal Arch Linux install; 500MB should be enough.

Installing Arch Linux on the temporary partition
------------------------------------------------

Install Arch Linux using the Installation guide.

-   Partition the hard drives to match your design from the previous
    step; for our example, it is as follows:

                                 Disk Drive: /dev/sda
       Name        Flags      Part Type  FS Type          [Label]        Size (MB)
    ------------------------------------------------------------------------------
       sda1                    Primary   Linux                               98.71
       sda2                    Primary   Linux                             2048.10
       sda5                    Logical   Linux                             1497.01
       sda6                    Logical   Linux                              649.80

                                 Disk Drive: /dev/sdb
       Name        Flags      Part Type  FS Type          [Label]        Size (MB)
    ------------------------------------------------------------------------------
       sdb1                    Primary   Linux                               98.71
       sdb2                    Primary   Linux                             2048.10

-   Install Arch Linux on the compatibility volume (/dev/sda6 in the
    example)
-   Do not mount the other partitions
-   The packages for mdadm and LVM are not necessary
-   Answer "No" to all questions about RAID or LVM.

Install EVMS in Arch Linux
--------------------------

Boot your new Arch Linux system and install the EVMS package:

    # pacman -S evms glib

Glib is needed for evmsn, the Ncurses interface to EVMS

Edit /etc/mkinicpio.conf:

    - HOOKS=“base udev autodetect block keymap filesystems”
    + HOOKS=“base udev evms block keymap filesystems”

Edit /lib/initcpio/install/evms (FS#8895):

    - MODULES="dm_mod md_mod"
    + MODULES=" $(checked_modules "drivers/md/*") "

Make a new initial RAM disk environment:

    # mkinitcpio -p linux

Add the following to /etc/rc.sysinit, after the LVM block:

    if [ "$USEEVMS" = "yes" -o "$USEEVMS" = "YES" ]; then
            if [ -x /usr/sbin/evms_activate ]; then
                    stat_busy "Activating EVMS"
                    /usr/sbin/evms_activate
                    if [ $? -ne 0 ]; then
                            stat_fail
                    else
                            stat_done
                    fi
            fi
    fi

Add this line to /etc/rc.conf:

    USEEVMS="yes"

Change root-device in /etc/fstab ...

    - /dev/sda6 / ext3 defaults 0 1
    + /dev/evms/sda6 / ext3 defaults 0 1

... and in /boot/grub/menu.lst

    - kernel /boot/vmlinuz-linux root=/dev/sda6 ro
    + kernel /boot/vmlinuz-linux root=/dev/evms/sda6 ro

Reboot.

Create EVMS-volumes
-------------------

Start evmsn:

    # evmsn

Remove automagicly created compatibility volumes on partitions you want
to use with RAID and/or LVM

    Actions » Delete » Volume...

    +------------------------ Delete Logical Volume -------------------------+
    |                                                                        |
    |     Logical Volume                          Size                       |
    | ---------------------------------------------------------------------- |
    | X   /dev/evms/sda1                       94.1 MB                       |
    | X   /dev/evms/sda2                        1.9 GB                       |
    | X   /dev/evms/sda5                        1.4 GB                       |
    | X   /dev/evms/sdb1                       94.1 MB                       |
    | X   /dev/evms/sdb2                        1.9 GB                       |
    |                                                                        |
    |                                                                        |
    | Use the spacebar key to make selections and choose Delete to continue  |
    |                                                                        |
    | [Help]                          [Cancel] [Recursive Delete] [Delete]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +------------------------------------------------------------------------+
    |Engine: Volume "/dev/evms/sda1" does not have a File System Interface Mo|
    |dule (FSIM) assigned to it.  The volume may have a file system on it, bu|
    |t none of the installed FSIM plug-ins recognizes it.  Do you want to wri|
    |te zeros to the first 1MB of the volume to potentially disable any file |
    |system that may be on the volume?                                       |
    |                                                                        |
    |                          [Write zeros] [Do not write zeros] [Cancel]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +------------------------------------------------------------------------+
    |Engine: Volume "/dev/evms/sda1" is not an EVMS volume.  Removing a non-E|
    |VMS volume requires writing 1024 bytes of metadata at the end of the vol|
    |ume. The metadata will overwrite any data that may be at the end of the |
    |volume.  Do you want to continue with the delete?                       |
    |                                                                        |
    |                                                  [Continue] [Cancel]   |
    |                                                                        |
    +------------------------------------------------------------------------+

-   Create RAID1 array on sda1 and sdb1

    Actions » Create » Region...

    +------------------------ Create Storage Region -------------------------+
    |                                                                        |
    |     Region Manager                                                     |
    | ---------------------------------------------------------------------- |
    |     MD Linear Raid Region Manager                                      |
    | X   MD Raid 1 Region Manager                                           |
    |     MD RAID0 Region Manager                                            |
    |     MD RAID 4/5 Region Manager                                         |
    |     MD Multipath Region Manager                                        |
    |                                                                        |
    |  Use the spacebar key to make selections and choose Next to continue   |
    |                                                                        |
    | [Help]                                    [Cancel]            [Next]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +-------------- Create Storage Region - Acceptable Objects --------------+
    |                                                                        |
    |     Name                                    Size                       |
    | ---------------------------------------------------------------------- |
    | X   sda1                                 94.1 MB                       |
    |     sda2                                  1.9 GB                       |
    |     sda5                                  1.4 GB                       |
    | X   sdb1                                 94.1 MB                       |
    |     sdb2                                  1.9 GB                       |
    |                                                                        |
    |                                                                        |
    |  Use the spacebar key to make selections and choose Next to continue   |
    |                                                                        |
    | [Help]                                    [Cancel] [Previous] [Next]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +------------ Create Storage Region - Configuration Options -------------+
    |                                                                        |
    | Option                  Value                                          |
    | ---------------------------------------------------------------------- |
    | Version 1 Super Block   No                                             |
    | Degraded array          No                                             |
    | Spare Disk              None                                           |
    |                                                                        |
    |  Use spacebar to select an option to change. Select Create to finish.  |
    |                                                                        |
    | [Help]                                  [Cancel] [Previous] [Create]   |
    |                                                                        |
    +------------------------------------------------------------------------+

-   Create RAID1 array on sda2 and sdb2
    -   repeat the previous step
-   Create LVM container 'main' on md/md1 and sda5

    Actions » Create » container...

    +----------------------- Create Storage Container -----------------------+
    |                                                                        |
    |     Plug-in                                                            |
    | ---------------------------------------------------------------------- |
    |     LVM Region Manager                                                 |
    | X   LVM2 Region Manager                                                |
    |                                                                        |
    |  Use the spacebar key to make selections and choose Next to continue   |
    |                                                                        |
    | [Help]                                    [Cancel]            [Next]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +------------ Create Storage Container - Acceptable Objects -------------+
    |                                                                        |
    |     Name                                    Size                       |
    | ---------------------------------------------------------------------- |
    | X   sda5                                  1.4 GB                       |
    |     md/md0                               94.0 MB                       |
    | X   md/md1                                1.9 GB                       |
    |                                                                        |
    |  Use the spacebar key to make selections and choose Next to continue   |
    |                                                                        |
    | [Help]                                    [Cancel] [Previous] [Next]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +----------- Create Storage Container - Configuration Options -----------+
    |                                                                        |
    | Option                                    Value                        |
    | ---------------------------------------------------------------------- |
    | Name for the new LVM2 container.          main                         |
    | Extent-size for the new LVM2 container.   32.0 MB                      |
    |                                                                        |
    |  Use spacebar to select an option to change. Select Create to finish.  |
    |                                                                        |
    | [Help]                                  [Cancel] [Previous] [Create]   |
    |                                                                        |
    +------------------------------------------------------------------------+

-   Create LVM region 'root' on 'lvm2/main/Freespace', mapping to object
    md/md1

    Actions » Create » Region...

    +------------------------ Create Storage Region -------------------------+
    |                                                                        |
    |     Region Manager                                                     |
    | ---------------------------------------------------------------------- |
    | X   LVM2 Region Manager                                                |
    |     MD Linear Raid Region Manager                                      |
    |     MD Raid 1 Region Manager                                           |
    |     MD RAID0 Region Manager                                            |
    |                                                                        |
    |  Use the spacebar key to make selections and choose Next to continue   |
    |                                                                        |
    | [Help]                                    [Cancel]            [Next]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +-------------- Create Storage Region - Acceptable Objects --------------+
    |                                                                        |
    |     Name                                    Size                       |
    | ---------------------------------------------------------------------- |
    | X   lvm2/main/Freespace                   3.3 GB                       |
    |                                                                        |
    |  Use the spacebar key to make selections and choose Next to continue   |
    |                                                                        |
    | [Help]                                    [Cancel] [Previous] [Next]   |
    |                                                                        |
    +------------------------------------------------------------------------+

    +------------ Create Storage Region - Configuration Options -------------+
    |                                                                        |
    | Option                                           Value                 |
    | ---------------------------------------------------------------------- |
    | Name for the new LVM2 region.                    root                  |
    | Size for the new LVM2 region.                    1.0 GB                |
    | Number of stripes for the new LVM2 region.       1                     |
    | Objects (PVs) to place the new LVM2 region on.   md/md1                |
    |                                                                        |
    |  Use spacebar to select an option to change. Select Create to finish.  |
    |                                                                        |
    | [Help]                                  [Cancel] [Previous] [Create]   |
    |                                                                        |
    +------------------------------------------------------------------------+

-   Create LVM region 'home' on 'lvm2/main/Freespace', mapping to object
    md/md1
    -   Only the last step is different. If you choose Object 'md/md1'
        the size is automaticly adjusted.

    +------------ Create Storage Region - Configuration Options -------------+
    |                                                                        |
    | Option                                           Value                 |
    | ---------------------------------------------------------------------- |
    | Name for the new LVM2 region.                    home                  |
    | Size for the new LVM2 region.                    928.0 MB                |
    | Number of stripes for the new LVM2 region.       1                     |
    | Objects (PVs) to place the new LVM2 region on.   md/md1                |
    |                                                                        |
    |  Use spacebar to select an option to change. Select Create to finish.  |
    |                                                                        |
    | [Help]                                  [Cancel] [Previous] [Create]   |
    |                                                                        |
    +------------------------------------------------------------------------+

-   Create LVM region 'var' on 'lvm2/main/Freespace'
    -   Choosing an object is not necessary

    +------------ Create Storage Region - Configuration Options -------------+
    |                                                                        |
    | Option                                           Value                 |
    | ---------------------------------------------------------------------- |
    | Name for the new LVM2 region.                    var                  |
    | Size for the new LVM2 region.                    1.4 GB                |
    | Number of stripes for the new LVM2 region.       1                     |
    | Objects (PVs) to place the new LVM2 region on.                         |
    |                                                                        |
    |  Use spacebar to select an option to change. Select Create to finish.  |
    |                                                                        |
    | [Help]                                  [Cancel] [Previous] [Create]   |
    |                                                                        |
    +------------------------------------------------------------------------+

-   Create EVMS-volumes on md/md0, lvm2/main/root, lvm2/main/home and
    lvm2/main/var

    Actions » Create » EVMS Volume...

    +-------------------------- Create EVMS Volume --------------------------+
    |                                                                        |
    |     Storage Object                          Size                       |
    | ---------------------------------------------------------------------- |
    |     lvm2/main/home                      928.0 MB                       |
    |     lvm2/main/root                        1.0 GB                       |
    |     lvm2/main/var                         1.4 GB                       |
    | X   md/md0                               94.0 MB                       |
    |                                                                        |
    | Use the spacebar key to make selections and choose Create to continue  |
    |                                                                        |
    | [Help]                                  [Cancel]            [Create]   |
    |                                                                        |
    +------------------------------------------------------------------------+

-   This is the new situation:

    Actions   Settings                                                        Help
    0=Logical Volumes

    Name                          Size Modified Active R/O  Plug-in   Mountpoint
    ------------------------------------------------------------------------------
    /dev/evms/boot             94.0 MB    X
    /dev/evms/home            928.0 MB    X
    /dev/evms/root           1024.0 MB    X
    /dev/evms/sda6            619.7 MB             X        Ext2/3    /
    /dev/evms/var               1.4 GB    X

-   Save

    Actions » Save...

-   Quit

    Actions » Quit

Edit /etc/evms.conf:

      lvm2 {
                # Should the LVM2 plugin prompt you for confirmation when it finds
                # LVM2 metadata on an object, but the object does not pass the
                # necessary size checks? If yes, it will ask you if the object is
                # really an LVM2 PV. If no, it will assume the object is not a PV.
                #
                # If you have used EVMS to create an LVM2 container on top of an
                # MD Software-RAID region, you'll most likely want to set this
                # parameter to no.
                #
                # The default is yes.

    -           device_size_prompt = yes
    +           device_size_prompt = no
      }

Copy the installation to the right volumes
------------------------------------------

Make filesystems on the new volumes:

    # mkfs.ext3 /dev/evms/root
    # mkfs.ext3 /dev/evms/boot
    # mkfs.ext3 /dev/evms/home
    # mkfs.ext3 /dev/evms/var

Mount the volumes under /new:

    # mkdir /new
    # mount /dev/evms/root /new
    # mkdir /new/boot /new/home /new/var
    # mount /dev/evms/boot /new/boot
    # mount /dev/evms/home /new/home
    # mount /dev/evms/var /new/var

Go to single-user mode:

    # telinit 1

Copy the system to the new volumes:

    # cd /
    # ls | grep -vE "dev|proc|sys|new" | xargs cp -a -t /new
    # mkdir /new/dev /new/proc /new/sys
    # cp -a /dev/console /dev/zero /dev/null /new/dev

Edit /new/etc/fstab

    - /dev/evms/sda6 / ext3 defaults 0 1
    + /dev/evms/root / ext3 defaults 0 1
    + /dev/evms/boot /boot ext3 defaults,noauto 0 2
    + /dev/evms/home /home ext3 defaults 0 2
    + /dev/evms/var /var ext3 defaults 0 2

If /boot is on a separate volume, make a symlink to itself:

    # cd /new/boot
    # ln -s . boot

Add an entry to /new/boot/grub/menu.lst:

    # (0) Arch Linux EVMS
    title  Arch Linux EVMS
    root   (hd0,0)
    kernel /boot/vmlinuz-linux root=/dev/evms/root ro quiet
    initrd /boot/initramfs-linux.img

Reinstall GRUB on both disks:

    # grub
    grub> root (hd0,0)
    grub> setup (hd0)
    grub> device (hd0) /dev/sdb
    grub> root (hd0,0)
    grub> setup (hd0)
    grub> quit

Find a new life for /dev/evms/sda6

Links
-----

-   EVMS User Guide

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_with_EVMS&oldid=298283"

Categories:

-   Getting and installing Arch
-   File systems

-   This page was last modified on 16 February 2014, at 07:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
