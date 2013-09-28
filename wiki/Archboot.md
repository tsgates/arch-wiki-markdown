Archboot
========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is Archboot?                                                  |
| -   2 Archboot ISO Releases                                              |
|     -   2.1 Burning Release                                              |
|     -   2.2 Supported boot modes of Archboot media                       |
|     -   2.3 PXE booting / Rescue system                                  |
|     -   2.4 News                                                         |
|         -   2.4.1 General                                                |
|         -   2.4.2 Kernel changes                                         |
|         -   2.4.3 Environment changes                                    |
|         -   2.4.4 setup changes                                          |
|         -   2.4.5 quickinst changes                                      |
|                                                                          |
|     -   2.5 History                                                      |
|     -   2.6 The difference to the archiso install media                  |
|     -   2.7 Interactive setup features                                   |
|     -   2.8 Bootparameters                                               |
|         -   2.8.1 General boot parameters                                |
|         -   2.8.2 Video and framebuffer options                          |
|                                                                          |
|     -   2.9 FAQ, Known Issues and limitations                            |
|     -   2.10 UEFI hints                                                  |
|     -   2.11 Bugs                                                        |
|                                                                          |
| -   3 Links                                                              |
| -   4 Restore Usbstick                                                   |
| -   5 Create image files                                                 |
|     -   5.1 Archboot Allinone ISO Howto                                  |
|         -   5.1.1 Requirements                                           |
|         -   5.1.2 Create archboot chroots                                |
|         -   5.1.3 Install archboot and update to latest packages         |
|         -   5.1.4 Generate images                                        |
+--------------------------------------------------------------------------+

What is Archboot?
-----------------

-   Archboot is a set of scripts to generate bootable media for
    CD/USB/PXE.
-   It is designed for installation or rescue operation.
-   It only runs in RAM, without any special filesystems like squashfs,
    thus it is limited to the RAM which is installed in your system.

Install archboot from the official repositories.

Archboot ISO Releases
---------------------

-   Hybrid image files and torrents are provided, which include i686
    and/or x86_64 core repository.
-   Please read the according Changelog files for RAM limitations.
-   Please check md5sum before using it.
-   Download 2013.03 „2k13-R1“ / Changelog / Forum thread

> Burning Release

Hybrid image file is a standard CD-burnable image and also a raw disk
image.

-   Can be burned to CD(RW) media using most CD-burning utilities.
-   Can be raw-written to a drive using 'dd' or similar utilities. This
    method is intended for use with USB thumb drives.

    'dd if=<imagefile> of=/dev/<yourdevice> bs=1M'

> Supported boot modes of Archboot media

-   It supports BIOS booting with syslinux.
-   It supports UEFI booting with gummiboot and EFISTUB,

for booting LTS kernels with efilinux-efi .

(only UEFI USB is supported, UEFI CD booting is not supported!)

-   It supports grub's iso loopback support.

variables used (below for example):

iso_loop_dev=UUID=XXXX

iso_loop_path=/blah/archboot.iso

-   It supports booting using syslinux's memdisk (only in BIOS mode).

> PXE booting / Rescue system

Download 2013.03 „2k13-R1“ needed files from the directory.

-   vmlinuz_i686 + initramfs_i686.img (i686)
-   vmlinuz_x86_64 + initramfs_x86_64.img(x86_64)
-   vmlinuz_i686_lts + initramfs_i686.img (i686 LTS kernel)
-   vmlinuz_x86_64_lts + initramfs_x86_64.img (x86_64 LTS kernel)
-   For PXE booting add the kernel and initrd to your tftp setup and you
    will get a running installation/rescue system.
-   For Rescue booting add an entry to your bootloader pointing to the
    kernel and initrd.

> News

2013.03 „2k13-R1“

-   major update/cleanup on all components

General

-   kernel 3.8.4 / LTS kernel 3.0.70
-   pacman 4.0.3 usage
-   RAM recommendations: 768 MB

Kernel changes

-   bump to latest 3.8.x series and bump lts to latest 3.0.x series

Environment changes

-   updated pacman mirrorlist
-   replaced netcfg with netctl
-   removed ide-legacy hook
-   replaced arch_virtio, arch_fw with block hook
-   replaced usbinput with keyboard hook
-   replaced dbus-core with dbus
-   bump to latest mkinitcpio code
-   bump syslinux from 4.x to 5.0
-   removed bind and dnsutils
-   blacklist floppy module during boot

setup changes

-   replaced netcfg network setup with netctl
-   always install netctl instead of netcfg
-   replaced gummiboot-efi with gummiboot
-   removed initscripts compat mode
-   always install systemd-sysvcompat
-   updated gummiboot install routine
-   updated refind install routine
-   removed persistent soundcard and network hack,

systemd handles everything now.

-   no need to add hostname to /etc/hosts anymore

quickinst changes

-   removed initscripts compat mode
-   removed rc.conf hint
-   removed double check on ntfs

> History

History of old releases can be found here.

> The difference to the archiso install media

-   It provides an additional interactive setup and quickinst script.
-   It contains [core] repository on media.
-   It provides the long time support kernel as boot and installation
    option.
-   It runs a modified Arch Linux system in initramfs.
-   It is restricted to RAM usage, everything which is not necessary
    like

man or info pages etc. is not provided.

-   It doesn't mount anything during boot process.

> Interactive setup features

-   Media and Network installation mode
-   Changing keymap and consolefont
-   Changing time and date
-   Setup network with netctl
-   Preparing storage disk, like auto-prepare, partitioning, GUID (gpt)
    support, 4k sector drive support etc.
-   Creation of software raid/raid partitions, lvm2 devices and luks
    encrypted devices
-   Supports standard linux,raid/raid_partitions,dmraid,lvm2 and
    encrypted devices
-   Filesystem support: ext2/3/4, btrfs, nilfs2,
    reiserfs,xfs,jfs,ntfs-3g,vfat
-   Name scheme support: PARTUUID, PARTLABEL, FSUUID, FSLABEL and KERNEL
-   Mount support of grub loopback and memdisk installation media
-   Package selection support
-   Signed package installation
-   hwdetect script is used for preconfiguration
-   Auto/Preconfiguration of framebuffer, uvesafb, kms mode, fstab,
    mkinitcpio.conf, systemd, crypttab and mdadm.conf
-   Configuration of basic system files
-   Setting root password
-   grub-bios, grub-efi-x86_64, grub-efi-i386, refind-efi-x86_64,
    gummiboot, efilinux-efi, lilo, extlinux/syslinux, bootloader support

> Bootparameters

General boot parameters

-   earlymodules

load modules before hooks are executed

Usage:

earlymodules=<comma-separated-array>

earlymodules=ahci,ehci-hcd

-   disablehooks

disable a hook which is run during bootup

Usage:

disablehooks=<comma-separated-array>

disablehooks=arch_floppy,arch_cdrom

-   root

Using this option will boot you into your specified existing system.

Usage:

root=/dev/<your-root-of-installed-system>

root=/dev/sda3

-   rootflags

Using this option will pass special mount options for your root device

Usage:

rootflags=<comma-separated-array>

rootflags=subvol=root,compress,ssd

-   advanced

This will override advanced hooks running order for your system.

Default order is arch_mdadm,arch_lvm2,arch_encrypt

Advanced hooks are: arch_mdadm,arch_lvm2,arch_encrypt

Usage:

advanced=hook1,hook2,hook3

advanced=arch_encrypt,arch_mdadm

-   arch-addons

You want to load external addon packages or configs into the install
environment.

Place external addon packages in /packages directory of your external
device.

Place external configs in /config directory of your external device.

Video and framebuffer options

-   uvesafb

enables uvesafb mode during boot and activates setup routine to use it
later on installed system.

you need to specify your supported resolution eg.:

uvesafb=<resolution>-<depth>

uvesafb=1024x768-16

-   fbmodule

Loads the fb module you specify durin boot process and activates setup
routine to use it later on installed system.

Use it like this fbmodule=<yourmodule>, e.g. fbmodule=cirrusfb

> FAQ, Known Issues and limitations

-   Release specific known issues and workarounds are posted in
    changelog files.
-   Check also the forum threads for posted fixes and workarounds.
-   Why screen stays blank or other weird screen issues happen?

Some hardware doesn't like the KMS activation, use radeon.modeset=0 or
i915.modeset=0 on boot prompt.

-   dmraid might be broken on some boards, support is not perfect here.

The reason is there are so many different hardware components out there.
At the moment 1.0.0rc16 is included, with latest fedora patchset.

-   grub2 cannot detect correct bios boot order:

It may happen that hd(x,x) entries are not correct, thus first reboot
may not work.

Reason: grub cannot detect bios boot order.

Fix: Either change bios boot order or change menu.lst to correct entries
after successful boot. This cannot be fixed it is a restriction in
grub/grub2!

-   Why is parted used in setup routine, instead of cfdisk in msdos
    partitiontable mode?

parted is the only linux partition program that can handle all type of
things the setup routine offers.

cfdisk cannot handle GPT/GUID nor it can allign partitions correct with
1MB spaces for 4k sector disks.

cfdisk is a nice tool but is too limited to be the standard partitioner
anymore.

cfdisk is still included but has to be run in an other terminal.

> UEFI hints

-   Create UEFI bootable USB from ISO
-   Remove UEFI boot support from ISO

> Bugs

Arch Linux Bugtracker

Links
-----

-   GIT repository

Restore Usbstick
----------------

Take care about which device actually is your USB stick. The next
command will render all data on /dev/sdX inaccessible.

-   First, wipe the bootsector of the USB stick:

    dd if=/dev/zero of=/dev/sdX bs=512 count=1

-   Then, create a new FAT32 partition on the stick and write a FAT32
    filesystem on it (vfat or type b in fdisk terminology):

    fdisk /dev/sdX <<EOF
    n
    p
    1

    t
    b
    w
    EOF

    mkdosfs -F32 /dev/sdX1

Create image files
------------------

> Archboot Allinone ISO Howto

(Quick regeneration of installation media with latest available core
packages)

Requirements

-   x86_64 architecture
-   archboot ISO
-   ~ 3GB free space on disk

Create archboot chroots

    # install archboot
    pacman -S archboot
    mkdir <x86_64_chroot>
    pacman --root "<x86_64_chroot>" -S base --noconfirm --noprogressbar
    mkdir <i686_chroot>
    linux32 pacman --root "<i686_chroot>" -S base --noconfirm --noprogressbar

-   Mount and copy the following files to each chroot:

    mount -o bind /dev <chrootpath>/dev
    mount -o bind /tmp <chrootpath>/tmp
    mount -o bind /sys <chrootpath>/sys
    mount -o bind /proc <chrootpath>/proc
    cp -a /etc/mtab <chrootpath>/etc/mtab
    cp /etc/resolv.conf  <chrootpath>/etc/resolv.conf

-   Enter archboot x86_64 chroot:

    chroot <chrootpath>

-   Enter archboot i686 chroot:

    linux32 chroot <chrootpath>

Install archboot and update to latest packages

    # install in both chroots archboot:
    pacman -S archboot
    # update in both chroots to latest available packages
    pacman -Syu

Generate images

    # run in both chroots (needs quite some time ...)
    archboot-allinone.sh -t
    # put the generated tarballs in one directory and run (needs quite some time ...)
    archboot-allinone.sh -g

-   Finished you get a burnable iso image, a rawwrite usb image and a
    hybrid image which is both in one.
-   Do not forget to unmount for each chroot after leaving:

    umount <chrootpath>/dev
    umount <chrootpath>/tmp
    umount <chrootpath>/sys
    umount <chrootpath>/proc

Have fun! tpowa (Archboot Developer)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Archboot&oldid=253880"

Categories:

-   System recovery
-   Getting and installing Arch
-   Live Arch systems
