ZFS
===

Related articles

-   ZFS Installation
-   Playing with ZFS
-   Installing Arch Linux on ZFS
-   ZFS on FUSE

ZFS is an advanced filesystem created by Sun Microsystems (now owned by
Oracle) and released for OpenSolaris in November 2005. Features of ZFS
include: pooled storage (integrated volume management -- zpool),
Copy-on-write, snapshots, data integrity verification and automatic
repair (scrubbing), RAID-Z, a maximum 16 Exabyte file size, and a
maximum 256 Zettabyte volume size. ZFS is licensed under the Common
Development and Distribution License (CDDL).

Described as "The last word in filesystems" ZFS is stable, fast, secure,
and future-proof. Being licensed under the GPL incompatible CDDL, it is
not possible for ZFS to be distributed along with the Linux Kernel. This
requirement, however, does not prevent a native Linux kernel module from
being developed and distributed by a third party, as is the case with
zfsonlinux.org (ZOL).

ZOL is a project funded by the Lawrence Livermore National Laboratory to
develop a native Linux kernel module for its massive storage
requirements and super computers.

Contents
--------

-   1 Playing with ZFS
-   2 Installation
-   3 Configuration
    -   3.1 Automatic Start
-   4 Systemd
-   5 Create a storage pool
-   6 Tuning
-   7 Usage
    -   7.1 Scrub
    -   7.2 Check zfs pool status
    -   7.3 Destroy a storage pool
    -   7.4 Export a storage pool
    -   7.5 Rename a Zpool
    -   7.6 Setting a Different Mount Point
    -   7.7 Swap volume
    -   7.8 Automatic snapshots
-   8 Troubleshooting
    -   8.1 does not contain an EFI label
    -   8.2 No hostid found
    -   8.3 On boot the zfs pool does not mount stating: "pool may be in
        use from other system"
        -   8.3.1 Unexported pool
        -   8.3.2 Incorrect hostid
-   9 Tips and tricks
    -   9.1 Embed the archzfs packages into an archiso
    -   9.2 Encryption in ZFS on linux
    -   9.3 Emergency chroot repair with archzfs
-   10 See also

Playing with ZFS
----------------

The rest of this article cover basic setup and usage of ZFS on physical
block devices (HDD and SSD for example). Users wishing to experiment
with ZFS on virtual block devices (known in ZFS terms as VDEVs) which
can be simple files like ~/zfs0.img ~/zfs1.img ~/zfs2.img etc. with no
possibility of real data loss are encouraged to see the Playing_with_ZFS
article. Common tasks like building a RAIDZ array, purposefully
corrupting data and recovering it, snapshotting datasets, etc. are
covered.

Installation
------------

The requisite packages are available in the AUR and in an unofficial
repo. Details are provided on the ZFS Installation article.

Configuration
-------------

ZFS is considered a "zero administration" filesystem by its creators;
therefore, configuring ZFS is very straight forward. Configuration is
done primarily with two commands: zfs and zpool.

Note:The following section is ONLY needed if users wish to install their
root filesystem to a ZFS volume. Users wishing to have a data partition
with ZFS do NOT need to read the next section.

> Automatic Start

For ZFS to live by its "zero administration" namesake, the zfs daemon
must be loaded at startup. A benefit to this is that it is not necessary
to mount the zpool in /etc/fstab; the zfs daemon can import and mount
zfs pools automatically. The daemon mounts the zfs pools reading the
file /etc/zfs/zpool.cache.

For each pool you want automatically mounted by the zfs daemon execute:

    # zpool set cachefile=/etc/zfs/zpool.cache <pool>

Systemd
-------

Enable the service so it is automatically started at boot time:

     # systemctl enable zfs

To manually start the daemon:

     # systemctl start zfs

Create a storage pool
---------------------

Use  # parted --list to see a list of all available drives. It is not
necessary nor recommended to partition the drives before creating the
zfs filesystem.

Having identified the list of drives, it is now time to get the id's of
the drives to add to the zpool. The zfs on Linux developers recommend
using device ids when creating ZFS storage pools of less than 10
devices. To find the id's, simply:

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

-   -m: The mount point of the pool. If this is not specified, than the
    pool will be mounted to /<pool>.

-   pool: This is the name of the pool.

-   raidz: This is the type of virtual device that will be created from
    the pool of devices. Raidz is a special implementation of raid5. See
    Jeff Bonwick's Blog -- RAID-Z for more information about raidz.

-   ids: The names of the drives or partitions that to include into the
    pool. Get it from /dev/disk/by-id.

Here is an example for the full command:

     # zpool create -f -m /mnt/data bigdata raidz ata-ST3000DM001-9YN166_S1F0KDGY ata-ST3000DM001-9YN166_S1F0JKRR ata-ST3000DM001-9YN166_S1F0KBP8 ata-ST3000DM001-9YN166_S1F0JTM1

In case Advanced Format disks are used which have a native sector size
of 4096 bytes instead of 512 bytes, the automated sector size detection
algorithm of ZFS might detect 512 bytes because the backwards
compatibility with legacy systems. This would result in degraded
performance. To make sure a correct sector size is used, the ashift=12
option should be used (See the ZFS on Linux FAQ). The full command would
in this case be:

     # zpool create -f -o ashift=12 -m /mnt/data bigdata raidz ata-ST3000DM001-9YN166_S1F0KDGY ata-ST3000DM001-9YN166_S1F0JKRR ata-ST3000DM001-9YN166_S1F0KBP8 ata-ST3000DM001-9YN166_S1F0JTM1

If the command is successful, there will be no output. Using the $ mount
command will show that the pool is mounted. Using # zpool status will
show that the pool has been created.

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

At this point it would be good to reboot the machine to ensure that the
ZFS pool is mounted at boot. It is best to deal with all errors before
transferring data.

Tuning
------

Although many knobs are available on a zfs pool, there are two major
ones user can consider:

-   atime
-   compression

Atime is enabled by default but for most users, it represents
superfluous writes to the zpool and it can be disabled using the zfs
command:

    # zfs set atime=off <pool>

Compression is just that, transparent compression of data. Consult the
man page for various options. A recent advancement is the lz4 algorithm
which offers excellent compression and performance. Enable it (or any
other) using the zfs command:

    # zfs set compression=lz4 <pool>

Other options for zfs can be displayed again, using the zfs command:

    # sudo zfs get all <pool>

Usage
-----

Users can optionally create a dataset under the zpool as opposed to
manually creating directories under the zpool. Datasets allow for an
increased level of control (quotas for example) in addition to
snapshots. To be able to create and mount a dataset, a directory of the
same name must not pre-exist in the zpool. To create a dataset, use:

     # zfs create <nameofzpool>/<nameofdataset>

It is then possible to apply ZFS specific attributes to the dataset. For
example, one could assign a quota limit to a specific directory within a
dataset:

     # zfs set quota=20G <nameofzpool>/<nameofdataset>/<directory>

To see all the commands available in ZFS, use :

     $ man zfs

or:

     $ man zpool

> Scrub

ZFS pools should be scrubbed at least once a week. To scrub the pool:

     # zpool scrub <pool>

To do automatic scrubbing once a week, set the following line in the
root crontab:

    # crontab -e

    ...
    30 19 * * 5 zpool scrub <pool>
    ...

Replace <pool> with the name of the ZFS pool.

> Check zfs pool status

To print a nice table with statistics about the ZFS pool, including and
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

To find the name of the pool, see #Check zfs pool status.

> Export a storage pool

If a storage pool is to be used on another system, it will first need to
be exported. It is also necessary to export a pool if it has been
imported from the archiso as the hostid is different in the archiso as
it is in the booted system. The zpool command will refuse to import any
storage pools that have not been exported. It is possible to force the
import with the -f argument, but this is considered bad form.

Any attempts made to import an un-exported storage pool will result in
an error stating the storage pool is in use by another system. This
error can be produced at boot time abruptly abandoning the system in the
busybox console and requiring an archiso to do an emergency repair by
either exporting the pool, or adding the zfs_force=1 to the kernel boot
parameters (which is not ideal). See #On boot the zfs pool does not
mount stating: "pool may be in use from other system"

To export a pool,

     # zpool export bigdata

> Rename a Zpool

Renaming a zpool that is already created is accomplished in 2 steps:

    # zpool export oldname
    # zpool import oldname newname

> Setting a Different Mount Point

The mount point for a given zpool can be moved at will with one command:

    # zfs set mountpoint=/foo/bar poolname

> Swap volume

ZFS does not allow to use swapfiles, but users can use a ZFS volume
(ZVOL) as swap. It is importart to set the ZVOL block size to match the
system page size, which can be obtained by the getconf PAGESIZE command
(default on x86_64 is 4KiB). Other options useful for keeping the system
running well in low-memory situations are keeping it always synced and
not caching the zvol data.

Create a 8GiB zfs volume:

  

     # zfs create -V 8G -b $(getconf PAGESIZE) \
                  -o primarycache=metadata \
                  -o sync=always \
                  -o com.sun:auto-snapshot=false <pool>/swap

Prepare it as swap partition:

     # mkswap -f /dev/zvol/<pool>/swap

To make it permanent, edit /etc/fstab. ZVOLs support discard, which can
potentially help ZFS's block allocator and reduce fragmentation for all
other datasets when/if swap is not full.

Add a line to /etc/fstab:

     /dev/zvol/<pool>/swap none swap discard 0 0

Keep in mind the Hibernate hook must be loaded before filesystems, so
using ZVOL as swap will not allow to use hibernate function. If you need
hibernate, keep a partition for it.

> Automatic snapshots

The zfs-auto-snapshot-git package from AUR provides a shell script to
automate the management of snapshots, with each named by date and label
(hourly, daily, etc), giving quick and convenient snapshotting of all
ZFS datasets. The package also installs cron tasks for quarter-hourly,
hourly, daily, weekly, and monthly snapshots. Optionally adjust the
--keep parameter from the defaults depending on how far back the
snapshots are to go (the monthly script by default keeps data for up to
a year).

To prevent a dataset from being snapshotted at all, set
com.sun:auto-snapshot=false on it. Likewise, set more fine-grained
control as well by label, if, for example, no monthlies are to be kept
on a snapshot, for example, set com.sun:auto-snapshot:monthly=false.

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
spl hosted. There are two solutions, for this. Either place the spl
hostid in the kernel parameters in the boot loader. For example, adding
spl.spl_hostid=0x00bab10c.

The other solution is to make sure that there is a hostid in
/etc/hostid, and then regenerate the initramfs image. Which will copy
the hostid into the initramfs image.

     # mkinitcpio -p linux

> On boot the zfs pool does not mount stating: "pool may be in use from other system"

Unexported pool

If the new installation does not boot because the zpool cannot be
imported, chroot into the installation and properly export the zpool.
See ZFS#Emergency chroot repair with archzfs.

Once inside the chroot environment, load the ZFS module and force import
the zpool,

    # zpool import -a -f

now export the pool:

    # zpool export <pool>

To see the available pools, use,

    # zpool status

It is necessary to export a pool because of the way ZFS uses the hostid
to track the system the zpool was created on. The hostid is generated
partly based on the network setup. During the installation in the
archiso the network configuration could be different generating a
different hostid than the one contained in the new installation. Once
the zfs filesystem is exported and then re-imported in the new
installation, the hostid is reset. See Re: Howto zpool import/export
automatically? - msg#00227.

If ZFS complains about "pool may be in use" after every reboot, properly
export pool as described above, and then rebuild ramdisk in normally
booted system:

    # mkinitcpio -p linux

Incorrect hostid

Double check that the pool is properly exported. Exporting the zpool
clears the hostid marking the ownership. So during the first boot the
zpool should mount correctly. If it does not there is some other
problem.

Reboot again, if the zfs pool refuses to mount it means the hostid is
not yet correctly set in the early boot phase and it confuses zfs.
Manually tell zfs the correct number, once the hostid is coherent across
the reboots the zpool will mount correctly.

Boot using zfs_force and write down the hostid. This one is just an
example.

    % hostid
    0a0af0f8

Users can always ignore the check adding zfs_force=1 in the kernel
parameters, but it is not advisable as a permanent solution.

Tips and tricks
---------------

> Embed the archzfs packages into an archiso

It is a good idea make an installation media with the needed software
included. Otherwise, the latest archiso installation media burned to a
CD or a USB key is required.

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

If installing onto a UEFI system, see Unified Extensible Firmware
Interface#Create UEFI bootable USB from ISO for creating UEFI compatible
installation media.

> Encryption in ZFS on linux

ZFS on linux does not support encryption directly, but zpools can be
created in dm-crypt block devices. Since the zpool is created on the
plain-text abstraction it is possible to have the data encrypted while
having all the advantages of ZFS like deduplication, compression, and
data robustness.

dm-crypt, possibly via LUKS, creates devices in /dev/mapper and their
name is fixed. So you just need to change zpool create commands to point
to that names. The idea is configuring the system to create the
/dev/mapper block devices and import the zpools from there. Since zpools
can be created in multiple devices (raid, mirroring, striping, ...), it
is important all the devices are encrypted otherwise the protection
might be partially lost.

  
 For example, an encrypted zpool can be created using plain dm-crypt
(without LUKS) with:

    # cryptsetup --hash=sha512 --cipher=twofish-xts-plain64 --offset=0 --key-file=/dev/sdZ --key-size=512 open --type=plain /dev/sdX enc
    # zpool create zroot /dev/mapper/enc

Since the /dev/mapper/enc name is fixed no import errors will occur.

> Emergency chroot repair with archzfs

Here is how to use the archiso to get into the ZFS filesystem for
maintenance.

Boot the latest archiso and bring up the network:

       # wifi-menu
       # ip link set eth0 up

Test the network connection:

       # ping google.com

Sync the pacman package database:

       # pacman -Syy

(optional) Install a text editor:

       # pacman -S vim

Add archzfs archiso repository to pacman.conf:

    /etc/pacman.conf

    [demz-repo-archiso]
    SigLevel = Required
    Server = http://demizerone.com/$repo/$arch

Sync the pacman package database:

       # pacman -Syy

Install the ZFS package group:

       # pacman -S archzfs

Load the ZFS kernel modules:

       # modprobe zfs

Import the pool:

       # zpool import -a -R /mnt

Mount the boot partitions (if any):

       # mount /dev/sda2 /mnt/boot
       # mount /dev/sda1 /mnt/boot/efi

Chroot into the ZFS filesystem:

       # arch-chroot /mnt /bin/bash

Check the kernel version:

       # pacman -Qi linux
       # uname -r

uname will show the kernel version of the archiso. If they are
different, run depmod (in the chroot) with the correct kernel version of
the chroot installation:

       # depmod -a 3.6.9-1-ARCH (version gathered from pacman -Qi linux)

This will load the correct kernel modules for the kernel version
installed in the chroot installation.

Regenerate the ramdisk:

       # mkinitcpio -p linux

There should be no errors.

See also
--------

-   ZFS on Linux
-   ZFS on Linux FAQ
-   FreeBSD Handbook -- The Z File System
-   Oracle Solaris ZFS Administration Guide
-   Solaris Internals -- ZFS Troubleshooting Guide
-   Pingdom details how it backs up 5TB of MySQL data every day with ZFS

Aaron Toponce has authored a 17-part blog on ZFS which is an excellent
read.

1.  VDEVs
2.  RAIDZ Levels
3.  The ZFS Intent Log
4.  The ARC
5.  Import/export zpools
6.  Scrub and Resilver
7.  Zpool Properties
8.  Zpool Best Practices
9.  Copy on Write
10. Creating Filesystems
11. Compression and Deduplication
12. Snapshots and Clones
13. Send/receive Filesystems
14. ZVOLs
15. iSCSI, NFS, and Samba
16. Get/Set Properties
17. ZFS Best Practices

Retrieved from
"https://wiki.archlinux.org/index.php?title=ZFS&oldid=306052"

Category:

-   File systems

-   This page was last modified on 20 March 2014, at 17:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
