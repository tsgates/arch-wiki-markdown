Installing Arch Linux on a USB key
==================================

Related articles

-   Beginners' guide
-   Installation guide
-   General recommendations
-   General Troubleshooting

This page explains how to perform a regular Arch installation onto a USB
key (or "flash drive"). In contrast to having a LiveUSB as covered in
USB Flash Installation Media, the result will be a persistent
installation identical to normal installation to HDD, but on a USB flash
drive.

Contents
--------

-   1 Preparation
-   2 Installation
-   3 Configuration
    -   3.1 GRUB legacy
    -   3.2 Syslinux
-   4 Tips
    -   4.1 Using your USB install on multiple machines
        -   4.1.1 Architecture
        -   4.1.2 Input drivers
        -   4.1.3 Video drivers
        -   4.1.4 Persistent block device naming
        -   4.1.5 Kernel parameters
    -   4.2 Compatibility
    -   4.3 Optimizing for the lifespan of flash memory
-   5 See also

Preparation
-----------

Note:At least 2 GiB of storage space is recommended. A modest set of
packages will fit, leaving a little free space for storage.

There are various ways of installing Arch on a USB stick, the simplest
being from within Arch itself:

-   If you are already running Arch, simply install arch-install-scripts
    and proceed with the installation guide just like you would from the
    iso, but you will not be using /dev/sda. Use $ lsblk to get the
    /dev/sd* name of your USB key prior to installation.

Warning:If you mistakingly format /dev/sda, you are likely to go about
deleting everything on your hard drive.

-   An Arch Linux CD/USB can be used to install Arch onto the USB key,
    via booting the CD/USB and following the installation guide. If
    booting from a Live USB, the installation will have to be made on a
    different USB stick.
-   Or, if you have another Linux computer available (it need not be
    Arch), you can follow the instructions to install from existing
    Linux, and then skip to the configuration section.

Installation
------------

Follow the installation guide as you normally would, with these
exceptions:

-   If cfdisk fails with "Partition ends in the final partial cylinder"
    fatal error, the only way to proceed is to kill all partitions on
    the drive. Open another terminal (Alt+F2), type fdisk /dev/sdX
    (where sdX is your usb drive), print partition table (p), check that
    it's ok, delete it (d) and write changes (w). Now return to cfdisk.
-   It is highly recommended to review the Tips for Minimizing SSD
    Read/Writes on the SSD wiki article prior to selecting a filesystem.
    To sum up, ext4 without a journal should be fine, which can be
    created with # mkfs.ext4 -O ^has_journal /dev/sdXX. Recognize that
    flash has a limited number of writes, and a journaling file system
    will take some of these as the journal is updated. For this same
    reason, it is best to forget the swap partition. Note that this does
    not affect installing onto a USB hard drive.
-   Before creating the initial RAM disk # mkinitcpio -p linux, in
    /etc/mkinitcpio.conf add the block hook to the hooks array right
    after udev. This is necessary for appropriate module loading in
    early userspace.
-   If you want to be able to continue to use the UFD device as a
    cross-platform removable drive, this can be accomplished by creating
    a partition housing an appropriate file system (most likely NTFS).
    Note that the data partition may need to be the first partition on
    the device, as Windows assumes that there can only be one partition
    on a removable device, and will happily automount an EFI system
    partition otherwise. Remember to install dosfstools and ntfs-3g.
    Some tools are available online that may allow you to flip the
    removable media bit on your UFD device this would trick operating
    systems into treating your UFD device as an external hard disk and
    allow you to use whichever partitioning scheme you choose.

Warning:It is not possible to flip the removable media bit on every UFD
device and attempting to use software that is incompatible with your
device may damage it. Attempting to flip the removable media bit is not
recommended.

Configuration
-------------

-   Make sure that /etc/fstab includes the correct partition information
    for /, and for any other partitions on the USB key. If the usb key
    is to be booted on several machines, it is quite likely that devices
    and number of available hard disks vary. So it is advised to use
    UUID or label:

To get the proper UUIDs for your partitions issue blkid

> Note:

-   When GRUB is installed on the USB key, the key will always be hd0,0.
-   It seems that current versions of GRUB will automatically default to
    using uuid. The following directions are for GRUB legacy.

> GRUB legacy

menu.lst, the GRUB legacy configuration file, should be edited to
(loosely) match the following: With the static /dev/sdaX:

    root (hd0,0)
    kernel /boot/vmlinuz-linux root=/dev/sda1 ro
    initrd /boot/initramfs-linux.img

When using label your menu.lst should look like this:

    root (hd0,0)
    kernel /boot/vmlinuz-linux root=/dev/disk/by-label/Arch ro
    initrd /boot/initramfs-linux.img

And for UUID, it should be like this:

    root (hd0,0)
    kernel /boot/vmlinuz-linux root=/dev/disk/by-uuid/3a9f8929-627b-4667-9db4-388c4eaaf9fa ro
    initrd /boot/initramfs-linux.img

> Syslinux

With the static /dev/sdaX:

    LABEL Arch
            MENU LABEL Arch Linux
            LINUX ../vmlinuz-linux
            APPEND root=/dev/sdax ro
            INITRD ../initramfs-linux.img

Using your UUID:

    LABEL Arch
            MENU LABEL Arch Linux
            LINUX ../vmlinuz-linux
            APPEND root=UUID=3a9f8929-627b-4667-9db4-388c4eaaf9fa ro
            INITRD ../initramfs-linux.img

Tips
----

> Using your USB install on multiple machines

Architecture

For the most versatile compatibility it is recommended that you install
the i686 architecture because it will run on both 32 (IA-32) and 64
(amd64) bit architectures.

Additionally, due to the reduzed size of 32 bit binaries and the absence
of (possible) multilib packages, an i686 installation typically consumes
less space than an equivalent x86_64 one.

Note:Chrooting into a 64 bit linux installation (eg. when using the USB
key as install/rescue media) is only possible from x86_64 Arch.

Input drivers

For laptop use (or use with a tactile screen) you will need the
xf86-input-synaptics package for the touchpad/touchscreen to work.

For instructions on fine tuning or troubleshooting touchpad issues, see
the Touchpad Synaptics article.

Video drivers

Note:The use of proprietary video drivers is not recommended for this
type of installation.

The recommended video drivers are: xf86-video-vesa mesa xf86-video-ati
xf86-video-intel xf86-video-nouveau xf86-video-nv.

For the most versatile compatibility install all of the open source
video drivers include their multilib counterparts: lib32-ati-dri
lib32-intel-dri lib32-nouveau-dri.

Persistent block device naming

It is recommended to use UUID in both fstab and bootloader
configuration. See Persistent block device naming for details.

Alternatively, you may create udev rule to create custom symlink for
your usb key. Then use this symlink in fstab and bootloader
configuration. See udev#Setting static device names for details.

Kernel parameters

You may want to disable KMS for various reasons, such as getting a blank
screen or a "no signal" error from the display, when using some Intel
video cards, etc. To disable KMS, add nomodeset as a kernel parameter.
See Kernel parameters for more info.

Warning:Some Xorg drivers will not work with KMS disabled. See the wiki
page on your specific driver for details. Nouveau in particular needs
KMS to determine the correct display resolution. If you add nomodeset as
a kernel parameter as a preemptive measure you may have to adjust the
display resolution manually when using machines with Nvidia video cards.
See Xrandr for more info.

> Compatibility

The fallback image should be used for maximum compatibility.

> Optimizing for the lifespan of flash memory

-   Again, it is highly recommended to review the Tips for Minimizing
    SSD Read/Writes on the SSD wiki article.

See also
--------

-   Installing Arch Linux from VirtualBox
-   Solid State Drives

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_on_a_USB_key&oldid=299052"

Category:

-   Getting and installing Arch

-   This page was last modified on 20 February 2014, at 10:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
