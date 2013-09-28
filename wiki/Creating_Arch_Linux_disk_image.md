Creating Arch Linux disk image
==============================

This page describes how to create a file that contains a disk image of
Arch Linux. This disk image can be run in a virtual machine using
software such as QEMU, VirtualBox, or VMware, and it can be customized
however you want.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Archiso                                                            |
| -   2 Install Arch Linux in a disk image using the installation media    |
| -   3 Install Arch Linux in a disk image without the installation media  |
|     -   3.1 Make a file containing the disk image                        |
|     -   3.2 Create filesystem(s) on the virtual disk                     |
|         -   3.2.1 Use entire disk as one filesystem                      |
|         -   3.2.2 Partitioned disk                                       |
|                                                                          |
|     -   3.3 Install packages on the guest's filesystem                   |
|     -   3.4 Write a fstab file for the guest                             |
|     -   3.5 Generate initramfs for the guest                             |
|     -   3.6 Install bootloader on the guest                              |
|         -   3.6.1 Extlinux                                               |
|         -   3.6.2 GRUB2                                                  |
|                                                                          |
|     -   3.7 Cleanup                                                      |
|     -   3.8 Boot the guest                                               |
|     -   3.9 Other tips                                                   |
+--------------------------------------------------------------------------+

Archiso
-------

The official installation media for Arch Linux is a hybrid ISO/disk
image, so it can already be booted either as a CD-ROM or as a disk.
However, it uses an ISO filesystem, so nothing on it can be changed
without re-making the installation media.

You can also create your own live Arch Linux systems using the Archiso
tools. This may be what you want, but Archiso is only designed for
building live systems that boot from a read-only filesystem.

Install Arch Linux in a disk image using the installation media
---------------------------------------------------------------

Using QEMU, VirtualBox, or other virtualization software, you can
install Arch Linux into a disk image by booting the virtual machine from
the installation media with the disk image file attached as a virtual
hard disk. This is the preferred way to make a virtual disk image
containing Arch Linux because other than starting up the virtual
machine, the installation will proceed exactly as in the Official
Installation Guide.

Install Arch Linux in a disk image without the installation media
-----------------------------------------------------------------

It is also possible to create a disk image of Arch Linux directly from
software and packages on a host Arch Linux system. This has several
advantages:

-   You do not need to have a copy of the installation media.
-   You can include the most up-to-date software packages in the disk
    image by installing them directly from the host's package manager,
    and you can do this before you have even booted up the guest for the
    first time.
-   You can customize the disk image in ways that may not be supported
    by the official Arch Linux installer.

However, this method is more difficult than using the installation
media. In addition, it will not work if your host machine does not have
pacman (i.e. is not running Arch Linux).

In these directions, the host system refers to the Arch Linux system you
are currently running, while the guest system refers to the Arch Linux
system you are creating as a disk image.

> Make a file containing the disk image

-   Create a raw disk image for the virtual machine. In this example, it
    is made with a size of 1 GiB.

    $ dd if=/dev/zero of=archlinux.raw bs=4096 count=262144

Or, on filesystems supporting the fallocate() system call:

    $ fallocate -l 1G archlinux.raw

-   If you have installed QEMU, you may instead use qemu-img create to
    create the raw disk image. qemu-img can also create a disk image in
    a non-raw format such as qcow2, provided that you export the image
    using qemu-nbd to set up a device that appears to contain the actual
    data of the disk image.

> Create filesystem(s) on the virtual disk

Use entire disk as one filesystem

If you do not need multiple partitions in your Arch Linux guest, it's
easiest to leave the virtual disk unpartitioned and use the whole thing
as a filesystem.

-   To make an ext4 filesystem:

    $ mkfs.ext4 -F archlinux.raw

Partitioned disk

Or you can partition the disk. In this simple example, it will be given
only one partition, and it will be a bootable primary partition
formatted as an ext4 filesystem containing the guest's entire
filesystem. There will be no swap partition.

-   Partition the disk.

    $ fdisk archlinux.raw <<< '
    $ > o
    $ > n
    $ > p
    $ > 1
    $ >
    $ >
    $ > a
    $ > 1
    $ > w'

-   Make the partitions available as loopback devices. The rest of the
    instructions will assume that the loopback device created for
    archlinux.raw is /dev/loop0, but it will be a higher number if you
    already have set up loop devices.

    # losetup -f --show archlinux.raw
    # kpartx -a /dev/loop0

Note:kpartx is part of the multipath-tools package. See
QEMU#Mounting_a_partition_inside_a_raw_disk_image for other ways to
mount a partition inside a disk image. But beware: GRUB2 will not
install correctly to the disk image unless the partition loopback device
is created through the device mapper (using kpartx).

-   Make the needed filesystems on the partitions.

    # mkfs.ext4 /dev/mapper/loop0p1

> Install packages on the guest's filesystem

-   Mount the guest's root filesystem on a temporary directory.

    # TMPDIR=/full/path/to/temporary/directory

For a partitioned disk:

    # mount /dev/mapper/loop0p1 $TMPDIR

or, for an unpartitioned disk:

    # mount archlinux.raw $TMPDIR

Install the packages you want on the system (like the base group):

    # pacstrap $TMPDIR base

> Write a fstab file for the guest

-   Add any mountpoints to the guest's fstab file. In this example, we
    just need a mountpoint for the guest's root filesystem. You do not
    have to specify it by UUID, but it is a good idea to do so because
    it guarantees that the root partition will be found regardless of
    what type of disk is emulated.

    # UUID=$(blkid -s UUID -o value /dev/mapper/loop0p1)
    # echo "UUID=$UUID   /   ext4   defaults   0   1" >> $TMPDIR/etc/fstab 

> Generate initramfs for the guest

As noted earlier, initramfs generation failed when installing linux.

-   You may need to edit $TMPDIR/etc/mkinitcpio.conf to remove the
    autodetect hook, to stop your host system's hardware configuration
    from removing essential modules (e.g. those needed to access the
    root filesystem) from the initramfs of the guest, which is going to
    be running in a different environment in a virtual machine. In
    addition, it would be a good idea to have the MODULES line read

    MODULES="virtio_blk virtio_pci"

so that it will be possible to boot your Arch Linux guest using a
paravirtualized block device.

-   Generate the initramfs for the guest manually by running the
    following command:

    # mkinitcpio -g $TMPDIR/boot/initramfs-linux.img -k $TMPDIR/boot/vmlinuz-linux -c $TMPDIR/etc/mkinitcpio.conf

> Install bootloader on the guest

For your bootloader, you can choose Extlinux, GRUB2, or another
bootloader. Due to the possible problems installing GRUB2 in this
setting, I suggest using Extlinux.

Extlinux

-   Install Extlinux on the guest's bootable partition.

    # extlinux --install $TMPDIR/boot

-   Install Syslinux's MBR in the guest's MBR (only for partitioned
    disks).

    # dd if=/usr/lib/syslinux/mbr.bin conv=notrunc bs=440 count=1 of=/dev/loop0

-   Create a configuration file for Extlinux. Replace $UUID with the
    UUID of the guest's root filesystem, which was set to the variable
    $UUID above.

    $TMPDIR/boot/extlinux.conf

    DEFAULT archlinux
    LABEL   archlinux
    SAY     Booting Arch Linux
    LINUX   /boot/vmlinuz-linux
    APPEND  root=/dev/disk/by-uuid/$UUID ro
    INITRD  /boot/initramfs-linux.img

Note:In order for Extlinux to be booted from the MBR on a partitioned
disk, it must be installed on a partition marked as bootable.

GRUB2

In this example, we will install the GRUB2 bootloader on the partitioned
disk of the guest. Make sure you have grub2-bios installed on the host
system.

Note:You may run into some problems when trying to install GRUB2 on a
virtual disk. It seems to only work on partition loopback devices
created through the device mapper, not those created using the loop
module or setting up a loop device with an offset. In addition, GRUB2
may fail to detect your ext4 filesystem for some reason. I would suggest
first trying Extlinux, unless you need to use GRUB.

-   Install GRUB2. --boot-directory must be set to the /boot directory
    within the guest's root filesystem, while the given device must be
    the loopback device corresponding to the guest's entire disk image.
    Be careful not to overwrite the bootloader of your host system!

    # grub-install --boot-directory=$TMPDIR/boot /dev/loop0

-   Write a grub.cfg file. Replace $UUID, in both places, with the UUID
    of the guest's root filesystem, which was set to the variable $UUID
    above.

    $TMPDIR/boot/grub/grub.cfg

    set default="0"
    set timeout="3"
    insmod msdospart
    insmod ext2
    set root='(/dev/sda, msdos1)'
    search --no-floppy --fs-uuid --set=root $UUID
    menuentry "Arch Linux" {
       linux /boot/vmlinuz-linux root=/dev/disk/by-uuid/$UUID ro
       initrd /boot/initramfs-linux.img
    }

> Cleanup

You should not boot the guest while its filesystem is still mounted;
otherwise, the files on it may be corrupted. Unmount the guest's
filesystem and get rid of the loopback devices first.

    # umount $TMPDIR
    # kpartx -d /dev/loop0
    # losetup -d /dev/loop0

> Boot the guest

Finally, boot the guest Arch Linux using your virtualization software of
choice, such as QEMU:

    # qemu archlinux.raw

Tip:If you have built the virtio block drivers into your guest's
initramfs, then you can boot it using a paravirtualized block device.
Combine it with KVM and a minimal Arch Linux guest will boot to a login
prompt in as little as 3 seconds after starting QEMU.

    # qemu-system-x86_64 -enable-kvm -drive file=archlinux.raw,media=disk,if=virtio

> Other tips

-   If you use QEMU, you can specify the guest's kernel and initramfs on
    the command line. If you do this, you don't need to install a
    bootloader on the disk image, nor do you need to install the linux
    package.

-   Since you have full control over the guest's hardware, it is not too
    hard compile a custom kernel for the guest that has all the needed
    modules built in, if you are familiar with configuring the Linux
    kernel.

-   You can make copies of your disk image and run multiple Arch Linux
    virtual machines at the same time.

-   See Install from Existing Linux for some more general tips about
    installing Arch Linux from an existing Linux installation that
    doesn't necessarily have to be Arch Linux.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Creating_Arch_Linux_disk_image&oldid=253925"

Categories:

-   Virtualization
-   Getting and installing Arch
