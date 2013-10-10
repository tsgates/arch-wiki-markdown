Installing Arch Linux on a USB key
==================================

> Summary

Guide to installing, configuring and using a full-featured Arch Linux
system on a USB flash drive.

> Related

Beginners' Guide

Installation Guide

General Recommendations

General Troubleshooting

This page explains how to perform a regular Arch installation onto a USB
key (or "flash drive"). In contrast to having a LiveUSB as covered in
USB Installation Media, the result will be a persistent installation
identical to normal installation to HDD, but on a USB flash drive.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preparation                                                        |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
|     -   3.1 GRUB legacy                                                  |
|     -   3.2 Syslinux                                                     |
|                                                                          |
| -   4 Tips                                                               |
|     -   4.1 Using your USB install on multiple machines                  |
|         -   4.1.1 Architecture                                           |
|         -   4.1.2 Input drivers                                          |
|         -   4.1.3 Video drivers                                          |
|         -   4.1.4 Boot without using UUID                                |
|         -   4.1.5 Kernel parameters                                      |
|                                                                          |
|     -   4.2 Optimizing for the lifespan of flash memory                  |
|                                                                          |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Preparation
-----------

Note:At least 2 GiB of storage space is recommended. A modest set of
packages will fit, leaving a little free space for storage.

There are various ways of installing Arch on a USB stick, the simplest
being from within Arch itself:

-   If you are already running Arch, simply install arch-install-scripts
    and proceed with the Installation Guide just like you would from the
    iso, but you will not be using /dev/sda. Use lsblk to get the
    /dev/sd* name of your USB key prior to installation.

Warning:If you mistakingly format /dev/sda, you are likely to go about
deleting everything on your hard drive.

-   An Arch Linux CD/USB can be used to install Arch onto the USB key,
    via booting the CD/USB and following the Installation Guide. If
    booting from a Live USB, the installation will have to be made on a
    different USB stick.
-   Or, if you have another linux computer available (it need not be
    Arch), you can follow the instructions to install from existing
    linux, and then skip to the configuration section.

Installation
------------

Follow the Installation Guide as you normally would, with these
exceptions:

-   If cfdisk fails with "Partition ends in the final partial cylinder"
    fatal error, the only way to proceed is to kill all partitions on
    the drive. Open another terminal (Alt+F2), type fdisk /dev/sdX
    (where sdX is your usb drive), print partition table (p), check that
    it's ok, delete it (d) and write changes (w). Now return to cfdisk.
-   It is highly recommended to review the Tips for Minimizing SSD
    Read/Writes on the SSD wiki article prior to selecting a filesystem.
    To sum up, ext4 without a journal should be fine. Recognize that
    flash has a limited number of writes, and a journaling file system
    will take some of these as the journal is updated. For this same
    reason, it is best to forgo a swap partition. Note that this does
    not affect installing onto a USB hard drive.
-   Before creating the initial RAM disk # mkinitcpio -p linux, in
    /etc/mkinitcpio.conf add the block hook to the hooks array right
    after udev. This is necessary for appropriate module loading in
    early userspace.

Configuration
-------------

-   Make sure that /etc/fstab includes the correct partition information
    for /, and for any other partitions on the USB key. If the usb key
    is to be booted on several machines, it is quite likely that devices
    and number of available hard disks vary. So it is advised to use
    UUID or label:

To get the proper UUIDs for your partitions issue blkid

-   menu.lst, the Grub configuration file, should be edited to (loosely)
    match the following:

Note:When grub is installed on the USB key, the key will always be hd0,0

Note:It seems that current versions of GRUB2 will automatically default
to using uuid. The following directions are for GRUB legacy

> GRUB legacy

With the static /dev/sdaX:

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

With the static /dev/sdaX

    LABEL Arch
            MENU LABEL Arch Linux
            LINUX ../vmlinuz-linux
            APPEND root=/dev/sdax ro
            INITRD ../initramfs-linux.img

Using your UUID

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
the x64_32 architecture with multilib support because it will run on
both 32 and 64 bit architectures.

Note:If you have installed i686 architecture and would like to migrate
to x64_32 please refer to the
Migrating_Between_Architectures_Without_Reinstalling wiki article for
help

Input drivers

For laptop use (or use with a tactile screen) you will need the
xf86-input-synaptics package for the touchpad/touchscreen to work:

    # pacman -S xf86-input-synaptics

For instructions on fine tuning or troubleshooting touchpad issues, see
the Touchpad Synaptics article.

Video drivers

For the most versatile compatibility install all of the open source
video drivers including their multilib counterparts.

Note:The use of proprietary video drivers is not recommended for this
type of installation.

The recommended video drivers are:

-   xf86-video-vesa
-   mesa
-   xf86-video-ati
-   xf86-video-intel
-   xf86-video-nouveau
-   xf86-video-nv
-   lib32-ati-dri
-   lib32-intel-dri
-   lib32-nouveau-dri

To install all of these drivers at once:

    # pacman -S xf86-video-vesa mesa xf86-video-ati xf86-video-intel xf86-video-nouveau xf86-video-nv lib32-ati-dri lib32-intel-dri lib32-nouveau-dri

Boot without using UUID

When using the USB key on various target machines, it is helpful to have
multiple entries in GRUB, for machines with different setups. For
example, the GRUB configuration could contain:

    # (0) Arch Linux
    title  Arch Linux (first drive)
    root   (hd0,0)
    kernel /boot/vmlinuz-linux root=/dev/sda1 ro
    initrd /boot/initramfs-linux.img

As well as

    # (1) Arch Linux
    title  Arch Linux (second drive)
    root   (hd0,0)
    kernel /boot/vmlinuz-linux root=/dev/sdb1 ro
    initrd /boot/initramfs-linux.img

And so forth, giving you the option to select a configuration for a
wider variety of machines. However, changing the root= option in GRUB
does not change /etc/fstab and you must do something (in our example
using udev symlink), so the root partition will always be mounted
correctly.

-   Run udevinfo -p /sys/block/sdx/ -a (where sdx is the device name of
    your usb key)
-   Find unique information pertaining to your usb key. I chose
    SYSFS{model}=="DataTraveler 2.0"
-   Make a new file: /etc/udev/udev.rules/10-my-usb-key.rules and
    insert:

    KERNEL=="sd**", SYSFS{product}=="DataTraveler 2.0", SYMLINK+="WHATEVERYOUWANTOTCALLIT%n"

(KERNEL=="sd**" is because the kernel - 2.6.16 here - names all usb
devices sd as it uses the scsi sub-system and you want to look at every
sd device and apply the setting to every partition), with SYSFS{model}==
being the unique identifier collected from udevinfo.

-   Run /etc/start-udev uevents and make sure the symlinks appears in
    /dev.
-   If so, edit /etc/fstab, replacing your old sdx with the new
    symlinks.

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

> Optimizing for the lifespan of flash memory

-   Again, it is highly recommended to review the Tips for Minimizing
    SSD Read/Writes on the SSD wiki article.

See Also
--------

-   Official Arch Linux Install Guide
-   Installing Arch Linux from VirtualBox
-   Solid State Drives

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_on_a_USB_key&oldid=254919"

Category:

-   Getting and installing Arch
