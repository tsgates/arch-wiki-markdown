Installing on Btrfs root
========================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: This page needs  
                           to be deleted. As of     
                           today (April 2013) no    
                           additional steps beyond  
                           those outlined in        
                           Installation_Guide are   
                           required to install      
                           Archlinux on Btrfs       
                           (except filesystem       
                           creation, mkfs.btrfs).   
                           First, all entries       
                           regarding bootloader and 
                           partitioning are not     
                           specific to the Btrfs    
                           filesystem and shouldn't 
                           be here. Instead, future 
                           users should be          
                           redirected to their      
                           dedicated pages. Second, 
                           mkinitcpio-btrfs should  
                           have its own wiki page   
                           because it is not in the 
                           official repositories    
                           and it is not required   
                           to be part of the        
                           installation process.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Summary

Installing on btrfs root Outlines a process for installing (or
converting) Arch Linux to a btrfs root drive with syslinux or GRUB2.

> Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

> Resources

Btrfs — Wikipedia

FAQ — Btrfs Wiki

GNU GRUB — GNU Project

Syslinux Website

GUID Partition Table — Wikipedia

btrfs provides a number of features (such as checksumming, snapshots,
and subvolumes) that make it an excellent candidate for using it as the
root partition in an Arch Linux installation. For a tour of btrfs
features see A tour of btrfs. As is common with FLOSS, there are a
number of ways to configure btrfs as the root filesystem.

This article assumes your are doing a fresh install from the Arch Linux
installation media. It is also possible to create a backup of an
existing Arch Linux installation and restore it to a fresh btrfs
configuration. This technique is also shown in this article.

Note:This article is for more advanced Arch Linux users, but if you are
a newbie and are one with the command line, you shouldn't have any
trouble as long as you are determined.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 btrfs-progs                                                        |
| -   2 mkinitcpio-btrfs                                                   |
| -   3 Boot into a live image                                             |
| -   4 Preparing the root drive                                           |
|     -   4.1 GPT partitioning for GRUB2                                   |
|     -   4.2 GPT partitioning for Syslinux                                |
|     -   4.3 Configure the btrfs filesystem                               |
|     -   4.4 btrfs and syslinux                                           |
|                                                                          |
| -   5 Installing the base system                                         |
|     -   5.1 Configuration                                                |
|     -   5.2 /etc/fstab                                                   |
|         -   5.2.1 GRUB2                                                  |
|         -   5.2.2 Syslinux                                               |
|         -   5.2.3 mkinitcpio-btrfs                                       |
|                                                                          |
| -   6 Installing the bootloader                                          |
|     -   6.1 GRUB                                                         |
|     -   6.2 Syslinux                                                     |
|                                                                          |
| -   7 Final configuration                                                |
| -   8 Known issues                                                       |
|     -   8.1 Rollback support                                             |
|     -   8.2 Syslinux                                                     |
|     -   8.3 Slow meta-data after installation                            |
+--------------------------------------------------------------------------+

btrfs-progs
-----------

To create a btrfs filesystem you will need to install the btrfs-progs
from Official Repositories. If using Archboot, it's already available.

mkinitcpio-btrfs
----------------

To get rollback features on your btrfs root device, you will need to
install the mkinitcpio-btrfs package from the Arch User Repository.

For reference, here are the internal variables used by mkinitcpio-btrfs:

    ${BTRFS_HAS_ROLLBACK:=true}
    ${BTRFS_BOOT_SUBVOL:="__active"}
    ${BTRFS_DIR_WORK:="/new_root"}
    ${BTRFS_DIR_SNAP:="/__snapshot"}
    ${BTRFS_DIR_ACTIVE:="/__active"}
    ${BTRFS_DIR_ROLLBACK:="/__rollback"}
    ${BTRFS_ROLLBACK_CHOICE:="default"}
    ${BTRFS_ROLLBACK_LIST:="default"}
    ${BTRFS_ROLLBACK_LIST_COUNT:=0}

Note:The btrfs_advanced mkinitcpio hook (provided by mkinitcpio-btrfs
package) is needed specifically for rollback and possibly other advanced
features. The standard btrfs hook is enough to get multi-device (RAID)
support. The kernel is capable of booting a single-device btrfs root on
its own.

Boot into a live image
----------------------

It is recommended that you boot and install from the latest Archlinux
Netinstall Image, or and up-to-date Archlinux installation, or Archboot.
The latter is capable of installing to a btrfs partition natively but
does not support the unified setup detailed here; it is however a good
option for this procedure because it includes recent builds of all the
necessary packages.

Preparing the root drive
------------------------

Now it is time to actually install the btrfs filesystem. Please make
sure that btrfs-progs is installed and functioning correctly:

    # btrfs --help

Warning:If you need swap support, either make a partition, or use the
loop method detailed below. DO NOT simply use a swap file! Doing so will
corrupt your btrfs filesystem.

Note:It is possible to allow btrfs to use the entire hard drive without
using a partitioning scheme, but that is not recommended.
GRUB2#Install_to_Partition_or_Partitionless_Disk.The method used for the
syslinux directions in this article does not use a partitioning system.
This portion of the article will be updated in the future, but until
then you can study the GUID Partition Table + syslinux installation
method here.

Warning: As of January 7,2012, Syslinux does not support multidevice
btrfs root!!

Note:syslinux and GRUB2 allow booting from a drive without a separate
boot partition. Both syslinux and GRUB2 allow the use of modern GPT
partitioning.

> GPT partitioning for GRUB2

To get started partitioning, we must install the gptfdisk package from
the Official Repositories:

    # pacman -S gptfdisk

GRUB2 requires a +2M boot partition at the front of the drive
GRUB2#GPT_specific_instructions. You can create that with gdisk:

    # gdisk /dev/sda

Once gdisk has loaded, you can begin entering commands into the command
prompt. Type ? to see the available commands. Press o to create a new
partition table. Just use the help command and create two partitions and
then use p to verify the output:

    GPT fdisk (gdisk) version 0.8.2

    Partition table scan:
      MBR: protective
      BSD: not present
      APM: not present
      GPT: present

    Found valid GPT with protective MBR; using GPT.

    Command (? for help): p
    Disk /dev/sda: 234441648 sectors, 111.8 GiB
    Logical sector size: 512 bytes
    Disk identifier (GUID): C75A01F9-D34E-4895-9AAB-2C8118118211
    Partition table holds up to 128 entries
    First usable sector is 34, last usable sector is 234441614
    Partitions will be aligned on 2048-sector boundaries
    Total free space is 2014 sectors (1007.0 KiB)

    Number  Start (sector)    End (sector)  Size       Code  Name
       1            2048            6143   2.0 MiB     EF02  BIOS boot partition
       2            6144       234441614   111.8 GiB   8300  Linux filesystem

    Command (? for help):

Note:Notice the EF02 hex code for the partition type for the 2Mb GRUB2
boot partition. This is needed to allow GRUB2 to install the core.img
file into that partition for booting

Once you have created the partitions, we will need to set the boot flag
on the btrfs partition. Press x for advanced options and then press a to
set attributes. Press the number for the partition you want to alter, in
this example it is 2. Now press 2 to set the legacy boot flag:

    Command (? for help): x

    Expert command (? for help): a
    Partition number (1-2): 2
    Known attributes are:
    0: system partition
    1: hide from EFI
    2: legacy BIOS bootable
    60: read-only
    62: hidden
    63: do not automount

    Attribute value is 0000000000000000. Set fields are:
      No fields set

    Toggle which attribute field (0-63, 64 or <Enter> to exit): 2
    Have enabled the 'legacy BIOS bootable' attribute.
    Attribute value is 0000000000000004. Set fields are:
    2 (legacy BIOS bootable)

    Toggle which attribute field (0-63, 64 or <Enter> to exit):

Finally, press w to write the data to the disk.

> GPT partitioning for Syslinux

This section hasn't been written yet. For a quick tutorial go here;

> Configure the btrfs filesystem

With the drive partitioned and ready for a filesystem, make sure
btrfs-progs is installed and create the filesystem on the root
partition:

    # mkfs.btrfs -L btrfs-root /dev/sda2

Now it is time to mount the new filesystem. First create the mount
directory:

    # mkdir /mnt/btrfs-root

and mount the partition:

    # mount -o defaults,noatime,discard,ssd /dev/sda2 /mnt/btrfs-root && cd /mnt/btrfs-root

Note:If you are not using an SSD drive, remove discard,ssd from the
mount options.

Note:I had performance problems (especially when suspending and halting)
on my notebook with SSD. Disabling the discard option resolved the
problem. [1]

Now you should be in the newly mounted btrfs filesystem! If you plan on
using the rollback features of btrfs, create a __snapshot directory for
containing snapshots:

    # mkdir __snapshot

Note:__snapshot is chosen for integration with current mkinitcpio-btrfs.
See the variable reference above, or the source mkinitcpio-btrfs
package.

If you plan on using Syslinux as your boot loader, you will need to
create a boot directory:

    # mkdir boot

Note:Syslinux currently does not support boot directories within btrfs
subvolumes. For this reason a boot directory must be created in the root
directory of the btrfs filesystem and bound to a boot directory within
the subvolume.

Next we will create the subvolumes. To see all the commands available to
manage subvolumes with btrfs:

    # btrfs subvolume --help

To allow us to easily snapshot the root of our Arch Linux installation,
it is recommended it be contained in a subvolume named __active:

Note:__active is chosen for integration with current mkinitcpio-btrfs.
See the variable reference above, or the source mkinitcpio-btrfs
package.

    # btrfs subvolume create __active && cd __active

Now we will create separate subvolumes for important FHS directories.
This would allow us to monitor and adjust the size allocations for each
subvolume:

    # btrfs subvolume create home
    # btrfs subvolume create var
    # btrfs subvolume create usr

To see your handy work:

    # btrfs subvolume list -p .

    ID 256 parent 5 top level 5 path __active
    ID 258 parent 256 top level 5 path __active/home
    ID 259 parent 256 top level 5 path __active/usr
    ID 260 parent 256 top level 5 path __active/var

Fix the permissions:

    chmod 755 ../\__active var usr home

Now that the subvolumes are created and we have a layout, lets mount the
root subvolume directly:

    # mkdir /mnt/btrfs-active
    # mount -o defaults,discard,noatime,ssd,subvol=__active /dev/sda2 /mnt/btrfs-active && cd /mnt/btrfs-active

Note:If you are not using an SSD drive, remove discard,ssd from the
mount options.

Note:I had performance problems (especially when suspending and halting)
on my notebook with SSD. Disabling the discard option resolved the
problem. [2]

And that's it! You should be ready to install a fresh copy of Arch Linux
or restore from a backup. For example, if you made a tar backup with the
techniques described above, simply:

    # tar -xvpJf <backup_file> -C .

or if using rsync:

    # rsync -avhHPS --exclude={dev,sys,proc,mnt,tmp,media} <backup_dir> .

> btrfs and syslinux

In order to continue the installation (or restoration), boot in the root
of the btrfs filesystem must be bound to the boot directory contained in
the __active subvolume. First we should create a boot directory within
the subvolume:

    # mkdir /mnt/btrfs-active/boot

and then bind the two directories using mount:

    # mount --bind /mnt/btrfs-root/boot /mnt/btrfs-active/boot

Installing the base system
--------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

We will not be relying on AIF to do the install automatically and
instead perform it manually.

Note:The AIF is no longer supported. Installing manually is now the
official way. See the Installation Guide for more info

Note:You may need to uncomment a mirror from
/mnt/btrfs-active/etc/pacman.d/mirrorlist, and/or make other adjustments
to /mnt/btrfs-active/etc/pacman.conf.

Lets begin by creating the necessary directories:

    # mkdir -p dev proc sys var/lib/pacman

Now we bind the system directories to our installation directory:

    # mount -o bind /dev dev/
    # mount -t proc /proc proc/
    # mount -t sysfs /sys sys/

Install base, btrfs-progs, and a bootloader (grub-bios, grub-efi,
syslinux, etc). Switch <boot_loader> to your preferred boot loader.

Also install base-devel to build mkinitcpio-btrfs from the AUR.

    # pacman -r . -Sy base btrfs-progs mkinitcpio-btrfs <boot_loader> --ignore grub

> Configuration

Once the you have successfully configured btrfs and installed (or
recovered) your Arch Linux, it is important that we tweak some settings
to get everything working together so when you reboot everything will
work correctly.

> /etc/fstab

This section has two different configurations depending on the
bootloader you selected. We can begin by editing
/mnt/btrfs-active/etc/fstab:

    # nano /mnt/btrfs-active/etc/fstab

GRUB2

Add the following line, supplement <uuid> for the UUID of the btrfs root
partition:

    UUID=<uuid> / btrfs   defaults,noatime,discard,ssd,subvol=__active 0 0

Note:If you are not using an SSD drive, remove discard,ssd from the
mount options.

Note:I had performance problems (especially when suspending and halting)
on my notebook with SSD. Disabling the discard option resolved the
problem. [3]

Syslinux

Tip:Locations chosen for integration with upcoming release of
mkinitcpio-btrfs

Add everything to /mnt/btrfs-active/etc/fstab ... (btrfs-root)/boot will
be --bind mounted so kernel upgrades work:

    /etc/fstab

    /dev/disk/by-label/btrfs-root  /                    btrfs  defaults,noatime,subvolid=0  0  0
    /dev/disk/by-label/btrfs-root  /var/lib/btrfs-root  btrfs  defaults,noatime             0  0
    /var/lib/btrfs-root/boot       /boot                none   bind                         0  0
    /var/lib/btrfs-root/empty/     /var/lib/btrfs-root/__active    none  bind               0  0

It is not necessary to add a subvol=XX option for /, as it must be
handled by either the initramfs [btrfs_advanced] or via the kernel boot
line [extlinux], and it may not be accurate anyways (e.g. rollback
mode). subvolid=0 corresponds to the btrfs root, and guarantees it will
always be mounted correctly, even if the default is changed.

Optional bind an empty folder over the /var/lib/btrfs-root/__active
folder to prevent apps such as 'find' from complaining of any loops.

mkinitcpio-btrfs

Download the mkinitcpio-btrfs tarball:

    # wget -O /mnt/btrfs-active/root/mkinitcpio-btrfs.tar.gz https://aur.archlinux.org/packages/mk/mkinitcpio-btrfs/mkinitcpio-btrfs.tar.gz

Add btrfs_advanced to the HOOKS section of
/mnt/btrfs-active/etc/mkinitcpio.conf:

    # nano /mnt/btrfs-active/etc/mkinitcpio.conf

    ...
    HOOKS="[...] btrfs_advanced"
    ...

Once you've chroot'ed into the btrfs installation, first install
mkinitcpio-btrfs:

    # cd /root
    # tar -xvzf mkinitcpio-btrfs.tar.gz
    # cd mkinitcpio-btrfs
    # makepkg
    # pacman -U mkinitcpio-btrfs-${version}.pkg.tar.xz

Then rebuild the initramfs:

    # mkinitcpio -p linux

Installing the bootloader
-------------------------

If everything went smoothly (when does it ever?), you should have the
great pleasure of installing your bootloader into the mbr of your root
drive.

> GRUB

See GRUB for advanced instructions. Once you have GRUB configured, and
you chrooted into your install directory, install the boot loader.

Chroot:

If you decided that you liked your current Arch Linux and are restoring
from a backup, you will need to chroot into your installation after
doing all the necessary steps:

    # cp /etc/resolv.conf etc/
    # mount -o bind /dev dev/
    # mount -o bind /dev/pts dev/pts
    # mount -t proc /proc proc/
    # mount -t sysfs /sys sys/
    # chroot . /bin/bash

And now:

    # grub-install --directory=/usr/lib/grub/i386-pc --target=i386-pc --boot-directory=/boot --recheck /dev/sda

Don't forget to update /boot/grub/grub.cfg:

    # grub-mkconfig -o /boot/grub/grub.cfg

You should now be able to reboot into GRUB, provided there were no
problems encountered doing the steps above.

> Syslinux

Syslinux now has an automatic installer that creates the necessary
folders, sets bootflags, installs MBR etc. See
Syslinux#Automatic_Install for more info. Make sure you have /mnt bind
mounted then run:

    # syslinux-install_update -iam

Then edit the syslinux.cfg:

Sample config:

    /boot/syslinux/syslinux.cfg

    PROMPT 0
    TIMEOUT 0
    DEFAULT arch

    LABEL arch
            LINUX ../vmlinuz-linux
            APPEND root=/dev/disk/by-label/btrfs-root rootflags=subvol=__active ro
            INITRD ../initramfs-linux.img

If you ARE using the mkinitcpio hook, remove rootflags=subvol=__active
from the APPEND line.

Final configuration
-------------------

Almost done... be sure to edit /mnt/etc/rc.conf, set the root password,
and similar. Good luck on reboot!

    # reboot

Known issues
------------

> Rollback support

Rollback support, while fully functional, currently has one important
caveat... it cannot handle kernel rollbacks because the kernel is not a
part of the snapshot. This is due to the limitations of the bootloader
described above. Until bootloaders support subvolumes, you must remember
to manually back up your kernel + initramfs before a snapshot. Upcoming
releases of mkinitcpio-btrfs will attempt to address this shortcoming.

> Syslinux

-   Syslinux operates successfully through times, but sometimes fails.

-   Installing syslinux with compression enabled, or editing the
    configuration file after enabling compression, causes boot to fail
    because syslinux cannot read compressed files. This probably also
    affects installing a new kernel with btrfs enabled but I haven't
    tested this.

> Slow meta-data after installation

Do a defragmentation of / after the installation is done to fix the slow
metadata issue. (a simple ls may take seconds)

    # btrfs filesystem defrag /

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_on_Btrfs_root&oldid=253720"

Category:

-   Getting and installing Arch
