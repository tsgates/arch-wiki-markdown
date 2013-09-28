Bcache
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Temporary install to SSD                                           |
| -   3 Final install to the HDD                                           |
| -   4 Configuring                                                        |
| -   5 Advanced Operations                                                |
|     -   5.1 Resize backing device                                        |
|         -   5.1.1 Example of growing                                     |
|         -   5.1.2 Example of shrinking                                   |
|                                                                          |
| -   6 Troubleshooting                                                    |
|     -   6.1 /dev/bcache device doesn't exist on bootup                   |
|     -   6.2 /sys/fs/bcache/ doesn't exist                                |
+--------------------------------------------------------------------------+

Introduction
------------

Bcache allows one to use an SSD as a read/write cache (in writeback
mode) or read cache (writethrough or writearound) for another
blockdevice (generally a rotating HDD or array. This article will show
how to install arch using Bcache as the root partition. For an intro to
bcache itself, see the bcache homepage. Be sure to read and reference
the bcache manual. Bcache is currently in the process of getting merged
into the kernel.

An alternative to Bcache is Facebook's Flashcache

Warning:Until bcache patches are accepted into mainline, installation is
non-trivial. Follow the instructions carefully and read the upstream
bcache documentation. Commands are included as examples only, and may
differ slightly on your setup.

Warning:Bcache requires the backing device is formatted as a bcache
block device. This is a destructive processes, so be sure you back up
any important data first.

Temporary install to SSD
------------------------

The ArchLinux install disk does not include bcache in its kernel. You
could either re-master to the install disk to include this kernel, or do
the install twice. The example below is for installing twice.

1.  Install archlinux as normal to the SSD. Don't go crazy with
    partitions, just a / and an EFI system partition if you're not
    booting bios mode. This is just the temporary system we'll use to
    install the final system.
2.  Reboot to verify the install in step 1 worked.
3.  Install the "linux-bcache-git" and "bcache-tools-git" packages from
    AUR.
4.  Reboot to the bcache enabled kernel

Note: The PKGBUILD for the aur/linux-bcache-git package can be edited to
build a v3.2 Linux kernel. By default it builds the latest (currently
3.8).

Final install to the HDD
------------------------

1. Partition your hdd  
 grub can't handle bcache, so you'll need at least 2 partitions (boot
and one for the bcache backing device). If you're doing UEFI, you'll
need an EFI System Partition (ESP) as well.

      ex:
         1            2048           22527   10.0 MiB    EF00  EFI System
         2           22528          432127   200.0 MiB   8300  arch_boot
         3          432128       625142414   297.9 GiB   8300  bcache_backing

Note:This example has no swapfile/partition. Keep in mind swapfile on
btrfs does not work. For a swap partition on the cache, use LLVM in step
7. For a swap partition outside the cache, be sure to make a swap
partition now.

2. Configure your HDD as a bcache backing device.

     # make-bcache -B /dev/sda3

Note:GRUB2 either needs an EFI partition, "bios boot" partition, or an
'embedding area' of 2KB or so after the MBR that doesn't get
overwritten. Also, since GRUB2 does not know about bcache, so you also
need a /boot partition that grub can read. Partitioning /dev/sda is a
must unless you're booting from a different device.

3. Register any bcache devices with the kernel (this needs to done every
bootup)

      for i in /dev/sd*; do echo $i; echo $i > /sys/fs/bcache/register_quiet; done

You now have a /dev/bcache0 device

Note:the bcache user manual says to do "echo /dev/sd* >
/sys/fs/bcache/register_quiet", but this didn't work for me

7. Format the bcache device. Use LLVM or btrfs subvolumes if you want to
divide up the /dev/bcache0 device how you like (ex for seperate /,
/home, /var, etc).

      # mkfs.btrfs /dev/bcache0
      # mount /dev/bcache0 /mnt/
      # btrfs subvolume create /mnt/root
      # btrfs subvolume create /mnt/home
      # umount /mnt

8. Reinstall to the bcache volume (alternatively you can rsync the
install you made on the SSD)

      # mkfs.ext4 /dev/sda2
      # mkfs.msdos /dev/sda1 (if your ESP is at least 500MB, use mkfs.vfat to make a FAT32 partition instead)
      # pacman -S arch-install-scripts
      # mount /dev/bcache0 -o subvol=root,compress=lzo /mnt/
      # mkdir /mnt/boot
      # mkdir /mnt/home
      # mount /dev/bcache0 -o subvol=home,compress=lzo /mnt/home
      # mount /dev/sda2 /mnt/boot
      # mkdir /boot/efi
      # mount /dev/sda1 /mnt/boot/efi/

do the rest of the installation as normal

9, Edit /etc/mkinitcpio.conf and add the bcache hook between block and
filesystems.

10. In the arch-chroot, first install "bcache-tools-git" then the
"linux-bcache-git" packages from [[AUR]b ]. (Don't forget to update your
bootloader to use the new kernel!)

11. Reboot and make sure it works from the /dev/bcache0 device

12. delete the partitions from /dev/sdb, format it as a caching device,
and link it to the backing device

       # parted /dev/sdb mklabel msdos; dd if=/dev/zero of=/dev/sdb bs=512 count=1
       # make-bcache -C /dev/sdb
       # echo /dev/sdb > /sys/fs/bcache/register 
       # echo <Set UUID from previous command> > /sys/block/bcache0/bcache/attach

Note: If the UUID is forgotten, it can be found with ls /sys/fs/bcache/
after the cache device has been registered.

Configuring
-----------

There are many options that can be configured (such as writeback cache
mode, cache flush interval, sequential write heuristic, etc.) This is
currently done by writing to files in /sys. See the bcache user
documentation.

Advanced Operations
-------------------

> Resize backing device

It's possible to resize the backing device so long as you don't move the
partition start. This process is described on the mailing list. Here's
an example using btrfs volume directly on bcache0. For LLVM containers
or for other filesystems, procedure will differ.

Example of growing

In this example, I grow the filesystem by 4GB.

1. Reboot to a live CD/USB Drive (need not be bcache enabled) and use
fdisk, gdisk, parted, or your other favorite tool to delete the backing
partition and recreate it with the same start and a total size 4G
larger.

Warning:Do not use a tool like GParted that might perform filesystem
operations! It won't recognize the bcache partition and might overwrite
part of it!!

2. Reboot to your normal install. Your filesystem will be currently
mounted. That's fine. Issue the command to resize the partition to its
maximum. For btrfs, that's

       sudo btrfs filesystem resize max /

For ext3/4, that's

       sudo resize2fs /dev/bcache0

3. That's it!

Example of shrinking

In this example, I shrink the filesystem by 4GB.

1. Disable writeback cache (switch to writethrough cache) and wait for
the disk to flush.

       echo writethrough | sudo tee /sys/block/bcache0/bcache/cache_mode
       watch cat /sys/block/bcache0/bcache/state

wait until state reports "clean". This might take a while.

2. Shrink the mounted filesystem by something more than the desired
amount, to ensure we don't accidentally clip it later. for btrfs, that's

      sudo btrfs filesystem resize -5G /

for ext3/4 you can use resize2fs, but only if the partition is unmounted

      $ df -h /home
      /dev/bcache0    290G   20G   270G   1% /home
      $ sudo umount /home
      $ sudo resize2fs /dev/bcache0 283G

3. Reboot to a LiveCD/USB drive (doesn't need to support bcache) and use
fdisk, gdisk, parted, or your other favorite tool to delete the backing
partition and recreate it with the same start and a total size 4G
smaller.

Warning:Do not use a tool like GParted that might perform filesystem
operations! It won't recognize the bcache partition and might overwrite
part of it!!

4. Reboot to your normal install. Your filesystem will be currently
mounted. That's fine. Issue the command to resize the partition to its
maximum (that is, the size we shrunk the actual partition to in step 3).
For btrfs, that's

       sudo btrfs filesystem resize max /

For ext3/4, that's

       sudo resize2fs /dev/bcache0

5. Re-enable writeback cache if you want that enabled:

       echo writeback | sudo tee /sys/block/bcache0/bcache/cache_mode

6. That's it!

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

Note:An error of "sh: echo: write error: Invalid argument" means the
device was already registered or is not recognized as either a bcache
backing device or cache.

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

Note:An error of "sh: echo: write error: Invalid argument" means the
device was already attached. An error of "sh: echo: write error: No such
file or directory" means the UUID is not a valid cache (make sure you
typed it correctly)

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

Warning: Only invalidate the cache if one of the two options above did
not work.

  

> /sys/fs/bcache/ doesn't exist

The kernel you booted is not bcache enabled.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bcache&oldid=254948"

Category:

-   File systems
