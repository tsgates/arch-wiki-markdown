Bcache
======

Contents
--------

-   1 Introduction
-   2 Setting up a bcache device on an existing system
-   3 Installation to a bcache device
-   4 Configuring
-   5 Advanced operations
    -   5.1 Resize backing device
        -   5.1.1 Example of growing
        -   5.1.2 Example of shrinking
-   6 Troubleshooting
    -   6.1 /dev/bcache device doesn't exist on bootup
    -   6.2 /sys/fs/bcache/ doesn't exist

Introduction
------------

Bcache allows one to use an SSD as a read/write cache (in writeback
mode) or read cache (writethrough or writearound) for another
blockdevice (generally a rotating HDD or array). This article will show
how to install arch using Bcache as the root partition. For an intro to
bcache itself, see the bcache homepage. Be sure to read and reference
the bcache manual. Bcache is in the mainline kernel since 3.10. The
kernel on the arch install disk includes the bcache module since
2013.08.01.

An alternative to Bcache is Facebook's Flashcache and its offspring
Enhanceio.

Bcache needs the backing device to be formatted as a bcache block
device. In most cases, blocks to-bcache can do an in-place conversion.

Warning:Be sure you back up any important data first.

Setting up a bcache device on an existing system
------------------------------------------------

1. Install the bcache-tools package from AUR.

2. Create a backing device (This will typically be your mechanical
drive). The backing device can be a whole device, a partition or any
other standard block device. This will create /dev/bcache0

       # make-bcache -B /dev/sdx1

3. Create a cache device (This will typically be your SSD). The cache
device can be a whole device, a partition or any other standard block
device

       # make-bcache -C /dev/sdx1

4. Register the cache device against your backing device. We need to
find the UUID of your cache device and then add it to the bcache device
initially. Udev rules will take care of this on reboot and will only
need to be done once.

       # cd /sys/fs/bcache
       # ls
       # echo "UUID" > /sys/block/bcache0/bcache/attach

5. Change your cache mode (if you want to cache writes as well as
reads):

       # echo writeback > /sys/block/bcache0/bcache/cache_mode

6. If you want to have this partition available during the initcpio
(i.e. you require it at some point in the boot process) you need to add
'bcache' to your modules array in /etc/mkinitcpio.conf as well as adding
the 'bcache' hook in your list between block and filesystem.

  

Installation to a bcache device
-------------------------------

1. Boot on the install disk (2013.08.01 minimum).

2. Install the bcache-tools package from AUR.

3. Partition your hdd

Note:While it may be true that Grub2 does not offer support for bcache
as noted below, it does, however, fully support UEFI. It follows then,
that so long as the necessary modules for the linux kernel to properly
handle your boot device are either compiled into the kernel or are
included in an initramfs, and you can include these files on it, the
separate boot partition described below may be omitted in favor of the
FAT EFI system partition. See GRUB and/or UEFI for more.

grub can't handle bcache, so you'll need at least 2 partitions (boot and
one for the bcache backing device). If you're doing UEFI, you'll need an
EFI System Partition (ESP) as well. E.g.:

         1            2048           22527   10.0 MiB    EF00  EFI System
         2           22528          432127   200.0 MiB   8300  arch_boot
         3          432128       625142414   297.9 GiB   8300  bcache_backing

Note:This example has no swapfile/partition. For a swap partition on the
cache, use LVM in step 7. For a swap partition outside the cache, be
sure to make a swap partition now.

4. Configure your HDD as a bcache backing device.

    # make-bcache -B /dev/sda3

> Note:

-   When preparing any boot disk it is important to know the
    ramifications of any decision you may make. Please review and review
    again the documentation for your chosen boot-loader/-manager and
    consider seriously how it might relate to bcache.
-   If all associated disks are partitioned at once as below bcache will
    automatically attach "-B backing stores" to the "-C ssd cache" and
    step 6 is unnecessary.

    # make-bcache -B /dev/sd? /dev/sd? -C /dev/sd?

5. Register any bcache devices with the kernel (this needs to done every
bootup if you do not use the bcache hook in your mkinitcpio, unless you
attach the bcache devices after boot has completed)

    # for i in /dev/sd*; do echo $i; echo $i > /sys/fs/bcache/register_quiet; done

You now have a /dev/bcache0 device.

Note:the bcache user manual says to do
echo /dev/sd* > /sys/fs/bcache/register_quiet, but this did not work for
me.

6. Configure your SSD

Format the SSD as a caching device and link it to the backing device

    # make-bcache -C /dev/sdb
    # echo /dev/sdb > /sys/fs/bcache/register 
    # echo UUID__from_previous_command > /sys/block/bcache0/bcache/attach

Note:If the UUID is forgotten, it can be found with ls /sys/fs/bcache/
after the cache device has been registered.

7. Format the bcache device. Use LVM or btrfs subvolumes if you want to
divide up the /dev/bcache0 device how you like (ex for seperate /,
/home, /var, etc):

    # mkfs.btrfs /dev/bcache0
    # mount /dev/bcache0 /mnt/
    # btrfs subvolume create /mnt/root
    # btrfs subvolume create /mnt/home
    # umount /mnt

8. Prepare the installation mount point:

    # mkfs.ext4 /dev/sda2
    # mkfs.msdos /dev/sda1 (if your ESP is at least 500MB, use mkfs.vfat to make a FAT32 partition instead)
    # pacman -S arch-install-scripts
    # mount /dev/bcache0 -o subvol=root,compress=lzo /mnt/
    # mkdir /mnt/boot /mnt/home
    # mount /dev/bcache0 -o subvol=home,compress=lzo /mnt/home
    # mount /dev/sda2 /mnt/boot
    # mkdir /boot/efi
    # mount /dev/sda1 /mnt/boot/efi/

9. Install the system as per the Installation Guide as normal except
this:

Before you edit /etc/mkinitcpio.conf and run mkinitcpio -p linux:

-   install bcache-tools package from the AUR.
-   Edit /etc/mkinitcpio.conf:
    -   add the "bcache" module
    -   add the "bcache" hook between block and filesystem hooks

Configuring
-----------

There are many options that can be configured (such as cache mode, cache
flush interval, sequential write heuristic, etc.) This is currently done
by writing to files in /sys. See the bcache user documentation.

Changing the cache mode is done by echoing one of 'writethrough',
'writeback', 'writearound' or 'none' to
/sys/block/bcache[0-9]/bcache/cache_mode.

Advanced operations
-------------------

> Resize backing device

It's possible to resize the backing device so long as you don't move the
partition start. This process is described on the mailing list. Here is
an example using btrfs volume directly on bcache0. For LVM containers or
for other filesystems, procedure will differ.

Example of growing

In this example, I grow the filesystem by 4GB.

1. Reboot to a live CD/USB Drive (need not be bcache enabled) and use
fdisk, gdisk, parted, or your other favorite tool to delete the backing
partition and recreate it with the same start and a total size 4G
larger.

Warning:Do not use a tool like GParted that might perform filesystem
operations! It will not recognize the bcache partition and might
overwrite part of it!!

2. Reboot to your normal install. Your filesystem will be currently
mounted. That is fine. Issue the command to resize the partition to its
maximum. For btrfs, that is

    # btrfs filesystem resize max /

For ext3/4, that is:

    # resize2fs /dev/bcache0

Example of shrinking

In this example, I shrink the filesystem by 4GB.

1. Disable writeback cache (switch to writethrough cache) and wait for
the disk to flush.

    # echo writethrough > /sys/block/bcache0/bcache/cache_mode
    $ watch cat /sys/block/bcache0/bcache/state

wait until state reports "clean". This might take a while.

2. Shrink the mounted filesystem by something more than the desired
amount, to ensure we don't accidentally clip it later. For btrfs, that
is:

    # btrfs filesystem resize -5G /

For ext3/4 you can use resize2fs, but only if the partition is unmounted

    $ df -h /home
    /dev/bcache0    290G   20G   270G   1% /home
    # umount /home
    # resize2fs /dev/bcache0 283G

3. Reboot to a LiveCD/USB drive (doesn't need to support bcache) and use
fdisk, gdisk, parted, or your other favorite tool to delete the backing
partition and recreate it with the same start and a total size 4G
smaller.

Warning:Do not use a tool like GParted that might perform filesystem
operations! It won't recognize the bcache partition and might overwrite
part of it!!

4. Reboot to your normal install. Your filesystem will be currently
mounted. That is fine. Issue the command to resize the partition to its
maximum (that is, the size we shrunk the actual partition to in step 3).
For btrfs, that is:

    # btrfs filesystem resize max /

For ext3/4, that is:

    # resize2fs /dev/bcache0

5. Re-enable writeback cache if you want that enabled:

    # echo writeback > /sys/block/bcache0/bcache/cache_mode

Note:If you're very careful you can shrink the filesystem to the exact
size in step 2 and avoid step 4. Be careful, though, many partition
tools don't do exactly what you want, but instead adjust the requested
partition start/end points to end on sector boundaries. This may be
difficult to calculate ahead of time

Troubleshooting
---------------

> /dev/bcache device doesn't exist on bootup

If you are sent to a busy box shell with an error:

    ERROR: Unable to find root device 'UUID=b6b2d82b-f87e-44d5-bbc5-c51dd7aace15'.
    You are being dropped to a recovery shell
        Type 'exit' to try and continue booting

This might happen if the backing device is configured for "writeback"
mode (default is writearound). When in "writeback" mode, the
/dev/bcache0 device is not started until the cache device is both
registered and attached. Registering is something that needs to happen
every bootup, but attaching should only have to be done once. I've
sometime had to re-attach.

To continue booting, try one of the following:

-   Register both the backing device and the cacheing device

    # echo /dev/sda3 > /sys/fs/bcache/register
    # echo /dev/sdb > /sys/fs/bcache/register

If the /dev/bcache0 device now exists, type exit and continue booting.
You will need to fix your initcpio to ensure devices are registered
before mounting the root device.

> Note:

-   An error of "sh: echo: write error: Invalid argument" means the
    device was already registered or is not recognized as either a
    bcache backing device or cache. If using the udev rule on boot it
    should only attempt to register a device if it finds a bcache
    superblock
-   This can also happen if using udev's 69-bcache.rules in
    Installation's step 7 and blkid and bcache-probe "disagree" due to
    rogue superblocks. See bcache's wiki for a possible
    explanation/resolution.

-   Re-attach the cache to the backing device:

If the cache device was registered, a folder with the UUID of the cache
should exist in /sys/fs/bcache. Use that UUID when following the example
below:

    # ls /sys/fs/bcache/
    b6b2d82b-f87e-44d5-bbc5-c51dd7aace15     register     register_quiet
    # echo b6b2d82b-f87e-44d5-bbc5-c51dd7aace15 > /sys/block/sda/sda3/bcache/attach

If the /dev/bcache0 device now exists, type exit and continue booting.
You should not have to do this again. If it persists, ask on the bcache
mailing list.

Note:An error of sh: echo: write error: Invalid argument means the
device was already attached. An error of
sh: echo: write error: No such file or directory means the UUID is not a
valid cache (make sure you typed it correctly).

-   Invalidate the cache and force the backing device to run without it.
    You might want to check some stats, such as "dirty_data" so you have
    some idea of how much data will be lost.

    # cat /sys/block/sda/sda3/bcache/dirty_data
    -3.9M

dirty data is data in the cache that has not been written to the backing
device. If you force the backing device to run, this data will be lost,
even if you later re-attach the cache.

    # cat /sys/block/sda/sda3/bcache/running
    0
    # echo 1 > /sys/block/sda/sda3/bcache/running

The /dev/bcache0 device will now exist. Type exit and continue booting.
You might want to unregister the cache device and run make-bcache again.
An fsck on /dev/bcache0 would also be wise. See the bcache user
documentation.

Warning:Only invalidate the cache if one of the two options above did
not work.

> /sys/fs/bcache/ doesn't exist

The kernel you booted is not bcache enabled.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bcache&oldid=298254"

Category:

-   File systems

-   This page was last modified on 16 February 2014, at 07:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
