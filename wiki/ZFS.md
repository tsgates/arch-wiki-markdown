ZFS
===

Summary

This page provides basic guidelines for installing the native ZFS Linux
kernel module.

Related

Installing Arch Linux on ZFS

ZFS on FUSE

ZFS is an advanced filesystem created by Sun Microsystems (now owned by
Oracle) and released for OpenSolaris in November 2005. Features of ZFS
include: pooled storage (integrated volume management -- zpool),
Copy-on-write, snapshots, data integrity verification and automatic
repair (scrubbing), RAID-Z, and a maximum 16 Exabyte volume size. ZFS is
licensed under the Common Development and Distribution License (CDDL).

Described as "The last word in filesystems" ZFS is stable, fast, secure,
and future-proof. Being licensed under the GPL incompatible CDDL, it is
not possible for ZFS to be distributed along with the Linux Kernel. This
requirement, however, does not prevent a native Linux kernel module from
being developed and distributed by a third party, as is the case with
zfsonlinux.org (ZOL).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Building from AUR                                            |
|     -   1.2 Unofficial repository                                        |
|     -   1.3 Archzfs testing repository                                   |
|     -   1.4 Archiso tracking repository                                  |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 mkinitramfs hook                                             |
|     -   2.2 Automatic Start                                              |
|                                                                          |
| -   3 Systemd                                                            |
| -   4 Create a storage pool                                              |
| -   5 Usage                                                              |
|     -   5.1 Scrub                                                        |
|     -   5.2 Check zfs pool status                                        |
|     -   5.3 Destroy a storage pool                                       |
|     -   5.4 Export a storage pool                                        |
|     -   5.5 Swap partition                                               |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 does not contain an EFI label                                |
|     -   6.2 No hostid found                                              |
|     -   6.3 On boot the zfs pool does not mount stating: "pool may be in |
|         use from other system"                                           |
|                                                                          |
| -   7 Tips and tricks                                                    |
|     -   7.1 Emergency chroot repair with archzfs                         |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

> Building from AUR

The ZFS kernel module is available in the AUR via zfs.

Note:The ZFS and SPL (Solaris Porting Layer is a Linux kernel module
which provides many of the Solaris kernel APIs) kernel modules are tied
to a specific kernel version. It would not be possible to apply any
kernel updates until updated packages are uploaded to AUR or the archzfs
repository.

Should you wish to update the core/linux package before the AUR/zfs and
AUR/spl packages' dependency lists are updated, a possible work-around
is to remove (uninstall) spl and zfs packages (the respective modules
and file system may stay in-use), update the core/linux package, build +
install zfs and spl packages - just do not forget to edit PKGBUILD and
correct the core/linux version number in "depends" section to match the
updated version). Finally, the system may be rebooted. [ This is only
for the situation, when ZFS is not used for root filesystem. ]

> Unofficial repository

For fast and effortless installation and updates, the "archzfs" signed
repository is available to add to your pacman.conf:

    /etc/pacman.conf

    [demz-repo-core]
    Server = http://demizerone.com/$repo/$arch

The repository and packages are signed with the maintainer's PGP key
which is verifiable here: http://demizerone.com. This key is not trusted
by any of the Arch Linux master keys, so it will need to be locally
signed before use. See pacman-key.

Add the maintainer's key,

    # pacman-key -r 0EE7A126

and locally sign to add it to the system's trust database,

    # pacman-key --lsign-key 0EE7A126

Once the key has been signed, it is now possible to update the package
database,

    # pacman -Syy

and install ZFS packages:

    # pacman -S archzfs

> Archzfs testing repository

If you have the testing repository active in pacman.conf then it is
possible to use the archzfs repository that tracks the testing kernel.

    # /etc/pacman.conf

    [demz-repo-testing]
    Server = http://demizerone.com/$repo/$arch

> Archiso tracking repository

ZFS can easily be used from within the archiso live environment by using
the special archiso tracking repository for ZFS. This repository makes
it easy to install Arch Linux on a root ZFS filesystem, or to mount ZFS
pools from within an archiso live environment using an up-to-date live
medium. To use this repository from the live environment, add the
following server line to pacman.conf:

    /etc/pacman.conf

    [demz-repo-archiso]
    Server = http://demizerone.com/$repo/$arch

This repository and packages are also signed, so the key must be locally
signed following the steps listed in the previous section before use.
For a guide on how to install Arch Linux on to a root ZFS filesystem,
see Installing Arch Linux on ZFS.

Configuration
-------------

ZFS is considered a "zero administration" filesystem by its creators;
therefore, configuring ZFS is very straight forward. Configuration is
done primarily with two commands: zfs and zpool.

> mkinitramfs hook

If you are using ZFS on your root filesystem, then you will need to add
the ZFS hook to mkinitcpio.conf; if you are not using ZFS for your root
filesystem, then you do not need to add the ZFS hook.

You will need to change your kernel parameters to include the dataset
you want to boot. You can use zfs=bootfs to use the ZFS bootfs (set via
zpool set bootfs=rpool/ROOT/arch rpool) or you can set the kernel
parameters to zfs=<pool>/<dataset> to boot directly from a ZFS dataset.

To see all available options for the ZFS hook:

     $ mkinitcpio -H zfs

To use the mkinitcpio hook, you will need to add zfs to your HOOKS in
/etc/mkinitcpio.conf:

    /etc/mkinitcpio.conf

    ...
    HOOKS="base udev autodetect modconf encrypt zfs filesystems usbinput"
    ...

Note:It is not necessary to use the "fsck" hook with ZFS. ZFS
automatically fixes any errors that occur within the filesystem.
However, if the hook is required for another filesystem used on the
system, such as ext4, the current ZFS packaging implementation does not
yet properly handle fsck requests from mkinitcpio and an error is
produced when generating a new ramdisk.

It is important to place this after any hooks which are needed to
prepare the drive before it is mounted. For example, if your ZFS volume
is encrypted, then you will need to place encrypt before the zfs hook to
unlock it first.

Recreate the ramdisk:

     # mkinitcpio -p linux

> Automatic Start

For ZFS to live by its "zero administration" namesake, the zfs daemon
must be loaded at startup. A benefit to this is that it is not necessary
to mount your zpool in /etc/fstab; the zfs daemon imports and mounts one
zfs pool automatically. The daemon mounts a zfs pool reading the file
/etc/zfs/zpool.cache, so the zfs pool that you want to automatically
mounted must write the file there.

Set a pool as to be automatically mounted by the zfs daemon:

    # zpool set cachefile=/etc/zfs/zpool.cache <pool>

Systemd
-------

Enable the service so it is automatically started at boot time:

     # systemctl enable zfs.service

To manually start the daemon:

     # systemctl start zfs.service

Create a storage pool
---------------------

Use  # parted --list to see a list of all available drives. It is not
necessary to partition your drives before creating the zfs filesystem,
this will be done automatically. However, if you feel the need to
completely wipe your drive before creating the filesystem, this can be
easily done with the dd command.

     # dd if=/dev/zero of=/dev/<device>

It should not have to be stated, but be careful with this command!

Once you have the list of drives, it is now time to get the id's of the
drives you will be using. The zfs on Linux developers recommend using
device ids when creating ZFS storage pools of less than 10 devices. To
find the id's for your device, simply:

     $ ls -lah /dev/disk/by-id/

The ids should look similar to the following:

     lrwxrwxrwx 1 root root  9 Aug 12 16:26 ata-ST3000DM001-9YN166_S1F0JKRR -> ../../sdc
     lrwxrwxrwx 1 root root  9 Aug 12 16:26 ata-ST3000DM001-9YN166_S1F0JTM1 -> ../../sde
     lrwxrwxrwx 1 root root  9 Aug 12 16:26 ata-ST3000DM001-9YN166_S1F0KBP8 -> ../../sdd
     lrwxrwxrwx 1 root root  9 Aug 12 16:26 ata-ST3000DM001-9YN166_S1F0KDGY -> ../../sdb

Now, finally, create the ZFS pool:

     # zpool create -f -m <mount> <pool> raidz <ids>

-   create: subcommand to create the pool.

-   -f: Force creating the pool. This is to overcome the "EFI label
    error". See #does not contain an EFI label.

-   -m: The mount point of the pool. If this is not specified, than your
    pool will be mounted to /<pool>.

-   pool: This is the name of the pool. Change it to whatever you like.

-   raidz: This is the type of virtual device that will be created from
    the pool of devices. Raidz is a special implementation of raid5. See
    Jeff Bonwick's Blog -- RAID-Z for more information about raidz.

-   ids: The names of the drives or partitions that you want to include
    into your pool. Get it from /dev/disk/by-id.

Here is an example for the full command:

     # zpool create -f -m /mnt/data bigdata raidz ata-ST3000DM001-9YN166_S1F0KDGY ata-ST3000DM001-9YN166_S1F0JKRR ata-ST3000DM001-9YN166_S1F0KBP8 ata-ST3000DM001-9YN166_S1F0JTM1

If the command is successful, there will be no output. Using the $ mount
command will show that you pool is mounted. Using # zpool status will
show that your pool has been created.

    # zpool status

      pool: bigdata
     state: ONLINE
     scan: none requested
    config:

            NAME                                       STATE     READ WRITE CKSUM
            bigdata                                    ONLINE       0     0     0
              -0                                       ONLINE       0     0     0
                ata-ST3000DM001-9YN166_S1F0KDGY-part1  ONLINE       0     0     0
                ata-ST3000DM001-9YN166_S1F0JKRR-part1  ONLINE       0     0     0
                ata-ST3000DM001-9YN166_S1F0KBP8-part1  ONLINE       0     0     0
                ata-ST3000DM001-9YN166_S1F0JTM1-part1  ONLINE       0     0     0

    errors: No known data errors

At this point it would be good to reboot your computer to make sure your
ZFS pool is mounted at boot. It is best to deal with all errors before
transferring your data.

Usage
-----

To see all the commands available in ZFS, use :

     $ man zfs

or:

     $ man zpool

> Scrub

ZFS pools should be scrubbed at least once a week. To scrub your pool:

     # zpool scrub <pool>

To do automatic scrubbing once a week, set the following line in your
root crontab:

    # crontab -e

    ...
    30 19 * * 5 zpool scrub <pool>
    ...

Replace <pool> with the name of your ZFS storage pool.

> Check zfs pool status

To print a nice table with statistics about your ZFS pool, including and
read/write errors, use

     # zpool status -v

> Destroy a storage pool

ZFS makes it easy to destroy a mounted storage pool, removing all
metadata about the ZFS device. This command destroys any data contained
in the pool:

     # zpool destroy <pool>

And now when checking the status:

    # zpool status

    no pools available

To find the name of your pool, see #Check zfs pool status.

> Export a storage pool

If you are going to use the pool in a different system, or are doing

> Swap partition

ZFS does not allow to use swapfiles, but you can use a ZFS volume as
swap partition. It is importart to set the ZVOL block size to match the
system page size, for x86_64 systems that is 4k.

Create a 8gb zfs volume:

     # zfs create -V 8gb -b 4K <pool>/swap

Prepare it as swap partition:

     # mkswap /dev/zvol/<pool>/maindisk/swap

Enable swap:

     # swapon /dev/zvol/<pool>/maindisk/swap

To make it permament you need to edit your /etc/fstab.

Add a line to /etc/fstab:

     /dev/zvol/<pool>/swap none swap defaults 0 0

Troubleshooting
---------------

> does not contain an EFI label

The following error will occur when attempting to create a zfs
filesystem,

     /dev/disk/by-id/<id> does not contain an EFI label but it may contain partition

The way to overcome this is to use -f with the zfs create command.

> No hostid found

An error that occurs at boot with the following lines appearing before
initscript output:

     ZFS: No hostid found on kernel command line or /etc/hostid.

This warning occurs because the ZFS module does not have access to the
spl hosted. There are two solutions, for this. You can either place your
spl hostid in the kernel parameters in your boot loader. For example,
adding spl.spl_hostid=0x00bab10c.

The other solution is to make sure that there is a hostid in
/etc/hostid, and then regenerate the initramfs image. Which will copy
the hostid into the initramfs image.

     # mkinitcpio -p linux

> On boot the zfs pool does not mount stating: "pool may be in use from other system"

You can always ignore the check adding zfs_force=1 in your kernel
parameters, but it is not advisable as a permanent solution.

First of all double check you actually exported the pool correctly.
Exporting the zpool clears the hostid marking the ownership. So during
the first boot the zpool should mount correctly. If it does not there is
some other problem.

Reboot again, if the zfs pool refuses to mount it means your hostid is
not yet correctly set in the early boot phase and it confuses zfs. So
you have to manually tell zfs the correct number, once the hostid is
coherent across the reboots the zpool will mount correctly.

Boot using zfs_force and write down your hostid. This one is just an
example.

    % hostid
    0a0af0f8

Follow the previous section to set it.

Tips and tricks
---------------

> Emergency chroot repair with archzfs

Here is how to use the archiso to get into your ZFS filesystem for
maintenance.

Boot the latest archiso and bring up your network:

       # wifi-menu
       # ip link set eth0 up

Test the network connection:

       # ping google.com

Sync the pacman package database:

       # pacman -Syy

(optional) Install your favorite text editor:

       # pacman -S vim

Add archzfs archiso repository to pacman.conf:

    /etc/pacman.conf

    [demz-repo-archiso]
    Server = http://demizerone.com/$repo/$arch

Sync the pacman package database:

       # pacman -Syy

Install the ZFS package group:

       # pacman -S archzfs

Load the ZFS kernel modules:

       # modprobe zfs

Import your pool:

       # zpool import -a -R /mnt

Mount your boot partitions (if you have them):

       # mount /dev/sda2 /mnt/boot
       # mount /dev/sda1 /mnt/boot/efi

Chroot into your ZFS filesystem:

       # arch-chroot /mnt /bin/bash

Check your kernel version:

       # pacman -Qi linux
       # uname -r

uname will show the kernel version of the archiso. If they are
different, you will need to run depmod (in the chroot) with the correct
kernel version of your chroot installation:

       # depmod -a 3.6.9-1-ARCH (version gathered from pacman -Qi linux)

This will load the correct kernel modules for the kernel version
installed in your chroot installation.

Regenerate your ramdisk:

       # mkinitcpio -p linux

There should be no errors.

See also
--------

-   ZFS on Linux
-   ZFS on Linux FAQ
-   FreeBSD Handbook -- The Z File System
-   Oracle Solaris ZFS Administration Guide
-   Solaris Internals -- ZFS Troubleshooting Guide

Retrieved from
"https://wiki.archlinux.org/index.php?title=ZFS&oldid=256001"

Category:

-   File systems
