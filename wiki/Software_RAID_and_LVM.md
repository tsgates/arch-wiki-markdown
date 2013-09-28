Software RAID and LVM
=====================

Summary

This article will provide an example of how to install and configure
Arch Linux with a software RAID or Logical Volume Manager (LVM).

Required software

[ Software]

Related

RAID

LVM

Installing with Fake RAID

Convert a single drive system to RAID

The combination of RAID and LVM provides numerous features with few
caveats compared to just using RAID.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 Swap space                                                   |
|     -   1.2 MBR vs. GPT                                                  |
|     -   1.3 Boot loader                                                  |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Load kernel modules                                          |
|     -   2.2 Prepare the hard drives                                      |
|         -   2.2.1 Install gdisk                                          |
|         -   2.2.2 Partition hard drives                                  |
|         -   2.2.3 Clone partitions with sgdisk                           |
|                                                                          |
|     -   2.3 RAID installation                                            |
|         -   2.3.1 Synchronization                                        |
|         -   2.3.2 Data Scrubbing                                         |
|                                                                          |
|     -   2.4 LVM installation                                             |
|         -   2.4.1 Create physical volumes                                |
|         -   2.4.2 Create the volume group                                |
|         -   2.4.3 Create logical volumes                                 |
|                                                                          |
|     -   2.5 Update RAID configuration                                    |
|     -   2.6 Prepare hard drive                                           |
|     -   2.7 Configure system                                             |
|         -   2.7.1 /etc/mkinitcpio.conf                                   |
|                                                                          |
|     -   2.8 Conclusion                                                   |
|     -   2.9 Install the bootloader on the Alternate Boot Drives          |
|         -   2.9.1 Syslinux                                               |
|         -   2.9.2 Grub Legacy                                            |
|                                                                          |
|     -   2.10 Archive your Filesystem Partition Scheme                    |
|                                                                          |
| -   3 Management                                                         |
| -   4 Additional Resources                                               |
+--------------------------------------------------------------------------+

Introduction
------------

Warning:Be sure to review the RAID article and be aware of all
applicable warnings, particularly if you select RAID5.

Although RAID and LVM may seem like analogous technologies they each
present unique features. This article uses an example with three similar
1TB SATA hard drives. The article assumes that the drives are accessible
as /dev/sda, /dev/sdb, and /dev/sdc. If you are using IDE drives, for
maximum performance make sure that each drive is a master on its own
separate channel.

Tip:It is good practice to ensure that only the drives involved in the
installation are attached while performing the installation.

  --------------------- --- ------ ------- -------
  LVM Logical Volumes   /   /var   /swap   /home
  --------------------- --- ------ ------- -------

  ------------------- --------------------
  LVM Volume Groups   /dev/VolGroupArray
  ------------------- --------------------

  ------------- ---------- ----------
  RAID Arrays   /dev/md0   /dev/md1
  ------------- ---------- ----------

  --------------------- ----------- ----------- ----------- ----------- ----------- -----------
  Physical Partitions   /dev/sda1   /dev/sdb1   /dev/sdc1   /dev/sda2   /dev/sdb2   /dev/sdc2
  --------------------- ----------- ----------- ----------- ----------- ----------- -----------

  ------------- ---------- ---------- ----------
  Hard Drives   /dev/sda   /dev/sdb   /dev/sdc
  ------------- ---------- ---------- ----------

> Swap space

Note:If you want extra performance, just let the kernel use distinct
swap partitions as it does striping by default.

Many tutorials treat the swap space differently, either by creating a
separate RAID1 array or a LVM logical volume. Creating the swap space on
a separate array is not intended to provide additional redundancy, but
instead, to prevent a corrupt swap space from rendering the system
inoperable, which is more likely to happen when the swap space is
located on the same partition as the root directory.

> MBR vs. GPT

See the Wikipedia article on this subject for more information: GUID
Partition Table

The widespread Master Boot Record (MBR) partitioning scheme, dating from
the early 1980s, imposed limitations which affected the use of modern
hardware. GUID Partition Table (GPT) is a new standard for the layout of
the partition table based on the UEFI specification derived from Intel.
Although GPT provides a significant improvement over a MBR, it does
require the additional step of creating an additional partition at the
beginning of each disk for GRUB2 (see: GPT specific instructions).

> Boot loader

This tutorial will use SYSLINUX instead of GRUB2. GRUB2 when used in
conjunction with GPT requires an additional BIOS Boot Partition.
Additionally, the 2011.08.19 Arch Linux installer does not support
GRUB2.

GRUB2 supports the default style of metadata currently created by mdadm
(i.e. 1.2) when combined with an initramfs, which has replaced in Arch
Linux with mkinitcpio. SYSLINUX only supports version 1.0, and therefore
requires the --metadata=1.0 option.

Some boot loaders (e.g. GRUB, LILO) will not support any 1.x metadata
versions, and instead require the older version, 0.90. If you would like
to use one of those boot loaders make sure to add the option
--metadata=0.90 to the /boot array during RAID installation.

Installation
------------

Obtain the latest installation media and boot the Arch Linux installer
as outlined in the Beginners' Guide, or alternatively, in the Official
Arch Linux Install Guide. Follow the directions outlined there until you
have configured your network.

Load kernel modules

Enter another TTY terminal by typing Alt+F2. Load the appropriate RAID
(e.g. raid0, raid1, raid5, raid6, raid10) and LVM (i.e. dm-mod) modules.
The following example makes use of RAID1 and RAID5.

    # modprobe raid1
    # modprobe raid5
    # modprobe dm-mod

> Prepare the hard drives

Note:If your hard drives are already prepared and all you want to do is
activate RAID and LVM jump to Activate existing RAID devices and LVM
volumes. This can be achieved with alternative partitioning software
(see: Article).

Each hard drive will have a 100MB /boot partition, 2048MB /swap
partition, and a / partition that takes up the remainder of the disk.

The boot partition must be RAID1, because GRUB does not have RAID
drivers. Any other level will prevent your system from booting.
Additionally, if there is a problem with one boot partition, the boot
loader can boot normally from the other two partitions in the /boot
array. Finally, the partition you boot from must not be striped (i.e.
RAID5, RAID0).

Install gdisk

Since most disk partitioning software does not support GPT (i.e. fdisk,
sfdisk) you will need to install gptfdisk to set the partition type of
the boot loader partitions.

Update the pacman database:

    $ pacman-db-upgrade

Refresh the package list:

    $ pacman -Syy

Install gptfdisk:

    $ pacman -S gdisk

Partition hard drives

We will use gdisk to create three partitions on each of the three hard
drives (i.e. /dev/sda, /dev/sdb, /dev/sdc):

       Name        Flags      Part Type  FS Type          [Label]        Size (MB)
    -------------------------------------------------------------------------------
       sda1        Boot        Primary   linux_raid_m                       100.00  # /boot
       sda2                    Primary   linux_raid_m                      2000.00  # /swap
       sda3                    Primary   linux_raid_m                     97900.00  # /

Open gdisk with the first hard drive:

    $ gdisk /dev/sda

and type the following commands at the prompt:

1.  Add a new partition: n
2.  Select the default partition number: Enter
3.  Use the default for the first sector: Enter
4.  For sda1 and sda2 type the appropriate size in MB (i.e. +100MB and
    +2048M). For sda3 just hit Enter to select the remainder of the
    disk.
5.  Select Linux RAID as the partition type: fd00
6.  Write the table to disk and exit: w

Repeat this process for /dev/sdb and /dev/sdc or use the alternate
sgdisk method below. You may need to reboot to allow the kernel to
recognize the new tables.

Note:Make sure to create the same exact partitions on each disk. If a
group of partitions of different sizes are assembled to create a RAID
partition, it will work, but the redundant partition will be in
multiples of the size of the smallest partition, leaving the unallocated
space to waste.

Clone partitions with sgdisk

If you are using GPT, then you can use sgdisk to clone the partition
table from /dev/sda to the other two hard drives:

    $ sgdisk --backup=table /dev/sda
    $ sgdisk --load-backup=table /dev/sdb
    $ sgdisk --load-backup=table /dev/sdc

> RAID installation

After creating the physical partitions, you are ready to setup the
/boot, /swap, and / arrays with mdadm. It is an advanced tool for RAID
management that will be used to create a /etc/mdadm.conf within the
installation environment.

Create the / array at /dev/md0:

    # mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sd[abc]3

Create the /swap array at /dev/md1:

    # mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sd[abc]2

Note:If you plan on installing a boot loader that does not support the
1.x version of RAID metadata make sure to add the --metadata=0.90 option
to the following command.

Create the /boot array at /dev/md2:

    # mdadm --create /dev/md2 --level=1 --raid-devices=3 --metadata=1.0 /dev/sd[abc]1

Synchronization

Tip:If you want to avoid the initial resync with new hard drives add the
--assume-clean flag.

After you create a RAID volume, it will synchronize the contents of the
physical partitions within the array. You can monitor the progress by
refreshing the output of /proc/mdstat ten times per second with:

    # watch -n .1 cat /proc/mdstat

Tip:Follow the synchronization in another TTY terminal by typing ALT +
F3 and then execute the above command.

Further information about the arrays is accessible with:

    # mdadm --misc --detail /dev/md[012] | less

Once synchronization is complete the State line should read clean. Each
device in the table at the bottom of the output should read spare or
active sync in the State column. active sync means each device is
actively in the array.

Note:Since the RAID synchronization is transparent to the file-system
you can proceed with the installation and reboot your computer when
necessary.

Data Scrubbing

It is good practice to regularly run data scrubbing to check for and fix
errors, especially on RAID 5 type volumes. See the Gentoo Wiki on Data
Scrubbing for details.

In short, the following will trigger a data scrub:

    # echo check >> /sys/block/mdX/md/sync_action

The progress can be watched with:

    # watch -n 1 cat /proc/mdstat

To stop a currently running data scrub safely:

    # echo idle >> /sys/block/mdX/md/sync_action

It is a good idea to set up a cron job as root to schedule a weekly
scrub. See raid-check which can assist with this.

> LVM installation

This section will convert the two RAIDs into physical volumes (PVs).
Then combine those PVs into a volume group (VG). The VG will then be
divided into logical volumes (LVs) that will act like physical
partitions (e.g. /, /var, /home). If you did not understand that make
sure you read the LVM Introduction section.

Create physical volumes

Make the RAIDs accessible to LVM by converting them into physical
volumes (PVs):

    # pvcreate /dev/md0

Note:This might fail if you are creating PVs on an existing Volume
Group. If so you might want to add -ff option.

Confirm that LVM has added the PVs with:

    # pvdisplay

Create the volume group

Next step is to create a volume group (VG) on the PVs.

Create a volume group (VG) with the first PV:

    # vgcreate VolGroupArray /dev/md0

Confirm that LVM has added the VG with:

    # vgdisplay

Create logical volumes

Now we need to create logical volumes (LVs) on the VG, much like we
would normally prepare a hard drive. In this example we will create
separate /, /var, /swap, /home LVs. The LVs will be accessible as
/dev/mapper/VolGroupArray-<lvname> or /dev/VolGroupArray/<lvname>.

Create a / LV:

    # lvcreate -L 20G VolGroupArray -n lvroot

Create a /var LV:

    # lvcreate -L 15G VolGroupArray -n lvvar

Note:If you would like to add the swap space to the LVM create a /swap
LV with the -C y option, which creates a contiguous partition, so that
your swap space does not get partitioned over one or more disks nor over
non-contiguous physical extents:

    # lvcreate -C y -L 2G VolGroupArray -n lvswap

Create a /home LV that takes up the remainder of space in the VG:

    # lvcreate -l +100%FREE VolGroupArray -n lvhome

Confirm that LVM has created the LVs with:

    # lvdisplay

Tip:You can start out with relatively small logical volumes and expand
them later if needed. For simplicity, leave some free space in the
volume group so there is room for expansion.

> Update RAID configuration

Since the installer builds the initrd using /etc/mdadm.conf in the
target system, you should update that file with your RAID configuration.
The original file can simply be deleted because it contains comments on
how to fill it correctly, and that is something mdadm can do
automatically for you. So let us delete the original and have mdadm
create you a new one with the current setup:

    # mdadm --examine --scan > /etc/mdadm.conf

Note:Read the note in the Update configuration file section about
ensuring that you write to the correct mdadm.conf file from within the
installer.

> Prepare hard drive

Follow the directions outlined the Installation section until you reach
the Prepare Hard Drive section. Skip the first two steps and navigate to
the Manually Configure block devices, filesystems and mountpoints page.
Remember to only configure the PVs (e.g.
/dev/mapper/VolGroupArray-lvhome) and not the actual disks (e.g.
/dev/sda1).

Warning:mkfs.xfs will not align the chunk size and stripe size for
optimum performance (see: Optimum RAID).

> Configure system

Warning:Follow the steps in the LVM Important section before proceeding
with the installation.

/etc/mkinitcpio.conf

mkinitcpio can use a hook to assemble the arrays on boot. For more
information see mkinitpcio Using RAID.

1.  Add the dm_mod module to the MODULES list in /etc/mkinitcpio.conf.
2.  Add the mdadm_udev and lvm2 hooks to the HOOKS list in
    /etc/mkinitcpio.conf after udev.

> Conclusion

Once it is complete you can safely reboot your machine:

    # reboot

> Install the bootloader on the Alternate Boot Drives

Once you have successfully booted your new system for the first time,
you will want to install the bootloader onto the other two disks (or on
the other disk if you have only 2 HDDs) so that, in the event of disk
failure, the system can be booted from any of the remaining drives (e.g.
by switching the boot order in the BIOS). The method depends on the
bootloader system you're using:

Syslinux

Log in to your new system as root and do:

    # /usr/sbin/syslinux-install_update -iam

Note:For this to work with GPT, the gptfdisk package is needed as the
backend for setting the boot flag.

Syslinux will deal with installing the bootloader to the MBR on each of
the members of the RAID array:

    Detected RAID on /boot - installing Syslinux with --raid
    Syslinux install successful

    Attribute Legacy Bios Bootable Set - /dev/sda1
    Attribute Legacy Bios Bootable Set - /dev/sdb1
    Installed MBR (/usr/lib/syslinux/gptmbr.bin) to /dev/sda
    Installed MBR (/usr/lib/syslinux/gptmbr.bin) to /dev/sdb

Grub Legacy

Log in to your new system as root and do:

    # grub
    grub> device (hd0) /dev/sdb
    grub> root (hd0,0)
    grub> setup (hd0)
    grub> device (hd0) /dev/sdc
    grub> root (hd0,0)
    grub> setup (hd0)
    grub> quit

> Archive your Filesystem Partition Scheme

Now that you are done, it is worth taking a second to archive off the
partition state of each of your drives. This guarantees that it will be
trivially easy to replace/rebuild a disk in the event that one fails.
You do this with the sfdisk tool and the following steps:

    # mkdir /etc/partitions
    # sfdisk --dump /dev/sda >/etc/partitions/disc0.partitions
    # sfdisk --dump /dev/sdb >/etc/partitions/disc1.partitions
    # sfdisk --dump /dev/sdc >/etc/partitions/disc2.partitions

Management
----------

For further information on how to maintain your software RAID or LVM
review the RAID and LVM aritcles.

Additional Resources
--------------------

-   Setup Arch Linux on top of raid, LVM2 and encrypted partitions by
    Yannick Loth
-   RAID vs. LVM on Stack Overflow
-   What is better LVM on RAID or RAID on LVM? on Server Fault
-   Managing RAID and LVM with Linux (v0.5) by Gregory Gulik
-   Gentoo Linux x86 with Software Raid and LVM2 Quick Install Guide

Forum threads

-   2011-09-08 - Arch Linux - LVM & RAID (1.2 metadata) + SYSLINUX
-   2011-04-20 - Arch Linux - Software RAID and LVM questions
-   2011-03-12 - Arch Linux - Some newbie questions about installation,
    LVM, grub, RAID

Retrieved from
"https://wiki.archlinux.org/index.php?title=Software_RAID_and_LVM&oldid=255249"

Categories:

-   Getting and installing Arch
-   File systems
