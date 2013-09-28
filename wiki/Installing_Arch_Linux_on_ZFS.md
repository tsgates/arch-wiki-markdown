Installing Arch Linux on ZFS
============================

Summary

This article describes the necassary procedures for installing Arch
Linux onto a ZFS root filesystem.

Related

ZFS

ZFS on FUSE

The Zettabyte File System (ZFS) is an advanced copy-on-write filesystem
designed to preserve data integrity from a multitude of possible
corruption scenarios as well as provide simple administration features.
ZFS makes disk administration effortless with support ZFS storage pools
(zpools) and automatic mount handling. First released in 2005 for
Solaris OS, ZFS has since become the flag bearer for next generation
filesystems.

ZFS was first developed and released by Sun (now owned by Oracle) as
Open Source Software licensed under the Common Development and
Distribution License (CDDL) which is famously incompatible with the GNU
Public License. This incompatibility prevents ZFS from being merged into
the mainline kernel, and generally presents some obstacles for users
that want to use ZFS in Linux.

ZFSonLinux.org is a project funded by the Lawrence Livermore National
Laboratory to develop a native Linux kernel module for its massive
storage requirements and super computers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Notes before installation                                          |
| -   2 Boot from the installation media                                   |
| -   3 Setup pacman                                                       |
| -   4 Install needed packages                                            |
| -   5 Partition the destination drive                                    |
|     -   5.1 UEFI systems                                                 |
|     -   5.2 BIOS systems                                                 |
|                                                                          |
| -   6 Format the destination disk                                        |
|     -   6.1 UEFI systems                                                 |
|     -   6.2 BIOS systems                                                 |
|                                                                          |
| -   7 Setup the ZFS filesystem                                           |
|     -   7.1 Create the root zpool                                        |
|     -   7.2 Create necessary filesystems                                 |
|     -   7.3 Configure the root filesystem                                |
|                                                                          |
| -   8 Mount the boot partitions                                          |
|     -   8.1 UEFI systems                                                 |
|     -   8.2 BIOS systems                                                 |
|                                                                          |
| -   9 Install and configure the Arch Linux installation                  |
| -   10 Setup the bootloader                                              |
|     -   10.1 UEFI systems                                                |
|     -   10.2 BIOS systems                                                |
|                                                                          |
| -   11 Unmount and restart                                               |
| -   12 Troubleshooting                                                   |
| -   13 See also                                                          |
+--------------------------------------------------------------------------+

Notes before installation
-------------------------

-   This guide uses the unofficial archzfs repository hosted at
    http://demizerone.com/demz-repo-core. This repository is maintained
    by Jesus Alvarez and is signed with his PGP key: 0EE7A126.

-   The ZFS packages are tied to the kernel version they were built
    against. This means it will not be possible to perform kernel
    updates until new packages (or package sources) are released by the
    ZFS package maintainer.

Boot from the installation media
--------------------------------

It is a good idea make an installation media with the needed software
included. Otherwise, you will need the latest archiso installation media
burned to a CD or a USB key.

To embed zfs in the archiso, from an existing install, download the
archiso package.

    # pacman -S archiso

Start the process:

    # cp -r /usr/share/archiso/configs/releng /root/media

Edit the packages.x86_64 file adding those lines:

    spl-utils
    spl
    zfs-utils
    zfs

Edit the pacman.conf file adding those lines (TODO, correctly embed keys
in the installation media?):

    [demz-repo-archiso]
    SigLevel = Never
    Server = http://demizerone.com/$repo/$arch

Add other packages in packages.both, packages.i686, or packages.x86_64
if needed and create the image.

    # ./build.sh -v

The image will be in the /root/media/out directory.

More informations about the process can be read in this guide or in the
Archiso article.

If you are installing onto a UEFI system, see Unified Extensible
Firmware Interface#Create UEFI bootable USB from ISO for creating UEFI
compatible installation media.

Setup pacman
------------

Activate the required network connection and then edit
/etc/pacman.d/mirrorlist and configure the mirrors for pacman to use.
Once that is done, edit /etc/pacman.conf and add the archzfs repository:

    # nano /etc/pacman.conf

    [demz-repo-core]
    Server = http://demizerone.com/$repo/$arch

Next, add the archzfs maintainer's PGP key to the local trust:

       # pacman-key -r 0EE7A126
       # pacman-key --lsign-key 0EE7A126

Finally, update the pacman databases,

       # pacman -Syy

Install needed packages
-----------------------

This is also the best time to install your favorite text editor,
otherwise nano will have to be used.

       # pacman -S archzfs dosfstools gptfdisk vim

Partition the destination drive
-------------------------------

> UEFI systems

Use the cgdisk partition utility and create a GPT partition table:

      Part     Size   Type
      ====     =====  =============
         1     512M   EFI (ef00)
         2     512M   Ext4 (8300)
         2     XXXG   Solaris Root (bf00)

Note:The EFI partion will be formatted to FAT32 and contain the UEFI
boot loader. The Ext4 partition will contain the boot partition and
kernel images.

Note:The filesystem type codes for cgdisk are indicated in the
parenthesis after the filesystem name.

Warning:The EFI partition must be at least 512MB specified by the UEFI
standard.

> BIOS systems

      Part     Size   Type
      ====     =====  =============
         2     1007K  BIOS Boot Partition (ef02)
         1     512M   Ext4 (8300)
         3     XXXG   Solaris Root (bf00)

Note:You will have to create the ext4 partition first due to cgdisk's
disk alignment policies. Start it at sector 2048 to leave room for the
BIOS parition.

Format the destination disk
---------------------------

> UEFI systems

Format the EFI partition to FAT32

       mkfs.vfat -F 32 /dev/sda1 -n EFIBOOT

Format the Ext4 boot partition

       mkfs.ext4 /dev/sda2 -L BOOT

> BIOS systems

Format the Ext4 boot partition

       mkfs.ext4 /dev/sda1 -L BOOT

Note:The boot filesystem is sda1 because of the order we created the
partitions

The BIOS partition does not need a filesystem.

Setup the ZFS filesystem
------------------------

First, make sure the ZFS modules are loaded,

       # modprobe zfs

> Create the root zpool

       # zpool create zroot /dev/disk/by-id/<id-to-partition>

Warning:Always use id names when working with ZFS, otherwise import
errors will occur.

> Create necessary filesystems

If so desired, sub-filesystem mount points such as /home and /root can
be created with the following commands:

       # zfs create zroot/home
       # zfs create zroot/root

For safety, unmount all zfs filesystems if they are mounted:

       # zfs umount -a

> Configure the root filesystem

Now it is time to set the mount point of the root filesystem:

       # zfs set mountpoint=/ zroot

and optionally, any sub-filesystems:

       # zfs set mountpoint=/home zroot/home
       # zfs set mountpoint=/root zroot/root

Set the bootfs property on the descendant root filesystem so the boot
loader knows where to find the operating system.

       # zpool set bootfs=zroot zroot

Export the pool,

       # zpool export zroot

Warning:Don't skip this, otherwise you will be required to use -f when
importing your pools. This unloads the imported pool.

Finally, re-import the pool,

       # zpool import -d /dev/disk/by-id -R /mnt zroot

Note:"-d" is not the actual device id, but the /dev/by-id directory
containing the symlinks.

If there is an error in this step, you can export the pool to redo the
command. The ZFS filesystem is now ready to use.

Mount the boot partitions
-------------------------

> UEFI systems

       # mkdir /mnt/boot
       # mount /dev/sda2 /mnt/boot
       # mkdir /mnt/boot/efi
       # mount /dev/sda1 /mnt/boot/efi

> BIOS systems

       # mkdir /mnt/boot
       # mount /dev/sda1 /mnt/boot

Install and configure the Arch Linux installation
-------------------------------------------------

Install the base packages,

       # pacstrap -i /mnt base base-devel archzfs sudo gnupg vim

Generate the fstab,

       # genfstab -U -p /mnt | grep boot >> /mnt/etc/fstab

Note:ZFS auto mounts its own partitions, so we do not need ZFS
partitions in fstab file.

If installing on a UEFI system, you will need to load the efivars kernel
module before chrooting into the installation:

       # modprobe efivars

Chroot into the installation

       # arch-chroot /mnt /bin/bash

Next, follow the Beginners' Guide from the "Locale" section to the
"Configure Pacman Section". Once done, edit pacman.conf, add the archzfs
repository, and update the pacman database,

       # pacman -Syy

Re-create the initramfs, edit /etc/mkinitcpio.conf and add zfs before
filesystems. Also, move keyboard hook before zfs so you can type in
console if something goes wrong. Remove fsck and then regenerate the
initramfs:

       # mkinitcpio -p linux

Finally, set root password and add a regular user.

Setup the bootloader
--------------------

> UEFI systems

Use EFISTUB and rEFInd for the UEFI boot loader. See Beginners'
Guide#For UEFI motherboards. The kernel parameters in refind_linux.conf
for zfs should include "zfs=bootfs", or "zfs=zroot", so the system can
boot from ZFS. The 'root' and 'rootfstype' parameters aren't needed.

> BIOS systems

Follow the Grub2#BIOS_systems_2 wiki. grub-mkconfig fails for me, so I
edited grub.cfg manually.

    /boot/grub/grub.cfg

    set timeout=2
    set default=0

    # (0) Arch Linux
    menuentry "Arch Linux" {
        set root=(hd0,1)
        linux /vmlinuz-linux zfs=zroot
        initrd /initramfs-linux.img
    }

Unmount and restart
-------------------

This is it, we are done!

       # exit
       # umount /mnt/boot
       # zfs umount -a
       # zpool export zroot
       # reboot

Warning:If you do not properly export the zpool, the pool will refuse to
import in the ramdisk environment and you will be stuck at the busybox
terminal.

Troubleshooting
---------------

If the new installation does not boot because the zpool cannot be
imported, you will need to chroot into the installation and properly
export the zpool. See ZFS#Emergency chroot repair with archzfs.

Once inside the chroot environment, load the ZFS module and force import
the zpool,

       # zpool import -a -f

now export the pool:

       # zpool export <pool>

To see your available pools, use,

       # zpool status

It is necessary to export a pool because of the way ZFS uses the hostid
to track the system the zpool was created on. The hostid is generated
partly based on your network setup. During the installation in the
archiso your network configuration could be different generating a
different hostid than the one contained in your new installation. Once
the zfs filesystem is exported and then re-imported in the new
installation, the hostid is reset. See Re: Howto zpool import/export
automatically? - msg#00227.

If ZFS complains about "pool may be in use" after every reboot, you
should properly export pool as described above, and then rebuild ramdisk
in normally booted system:

       # mkinitcpio -p linux

See also
--------

-   HOWTO install Ubuntu to a Native ZFS Root
-   ZFS Cheatsheet

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_on_ZFS&oldid=255764"

Category:

-   Getting and installing Arch
