USB Installation Media
======================

> Summary

Mutiplatform instructions on creating a bootable USB stick which can be
used for installing Arch Linux, system maintenance or for recovery
purposes.

> Related

CD Burning

This page discusses various methods on how to write an Arch Linux
release to a USB drive (also referred to as "flash drive", "USB stick",
"USB key", etc). The result will be a LiveCD-like system ("LiveUSB", if
you will) that, because of the nature of SquashFS, will discard all
changes once the computer shuts down.

If you would like to run a full install of Arch Linux from a USB drive
(i.e. with persistent settings), see Installing Arch Linux on a USB key.

Note:For UEFI boot, create a bootable USB stick by following these
instructions.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 On GNU/Linux                                                       |
|     -   1.1 Overwrite the USB drive                                      |
|         -   1.1.1 How to restore the USB drive                           |
|                                                                          |
|     -   1.2 Without overwriting the USB drive                            |
|         -   1.2.1 Using UNetbootin                                       |
|                                                                          |
| -   2 On Mac OS X                                                        |
| -   3 On Windows                                                         |
|     -   3.1 Image Writer for Windows                                     |
|     -   3.2 USBWriter for Windows                                        |
|     -   3.3 The Flashnul Way                                             |
|     -   3.4 The Cygwin Way                                               |
|     -   3.5 dd for Windows                                               |
|     -   3.6 Boot the entire ISO from RAM                                 |
|                                                                          |
| -   4 Troubleshooting                                                    |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

On GNU/Linux
------------

> Overwrite the USB drive

Warning:This will irrevocably destroy all data on /dev/sdx.

Note:This method does not work with UEFI boot.

Note:Check with lsblk that the USB device is not mounted, and use
/dev/sdx instead of /dev/sdx1. These are very common mistakes!

    # dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx

Note:Some older firmware does not understand the isohybrid hack where
start of fake partition offset is 0. See
https://bugs.archlinux.org/task/32189 for a fix involving isohybrid.pl.

How to restore the USB drive

Because the ISO image is a hybrid which can either be burned to a disc
or directly written to a USB drive, it doesn't include a standard
partition table.

After you install Arch Linux and you're done with the USB drive, you
should zero out its first 512 bytes (meaning the boot code from the MBR
and the non-standard partition table) if you want to restore it to full
capacity:

    # dd count=1 bs=512 if=/dev/zero of=/dev/sdx

Then create a new partition table (e.g. "msdos") and filesystem (e.g.
EXT4, FAT32) using gparted, or from a terminal:

-   For EXT2/3/4 (adjust accordingly), it would be:

    # cfdisk /dev/sdx
    # mkfs.ext4 /dev/sdx1
    # e2label /dev/sdx1 USB_STICK

-   For FAT32, install the dosfstools package and run:

    # cfdisk /dev/sdx
    # mkfs.vfat -F32 /dev/sdx1
    # dosfslabel /dev/sdx1 USB_STICK

> Without overwriting the USB drive

This method is slightly more complicated than writing the image directly
with dd, but it does keep the drive usable for data storage. Before you
begin, make sure that your USB device is formatted as either FAT32,
EXT2/3/4 or Btrfs. For UEFI boot and/or interoperability with other
operating systems you should use FAT32. Also, make sure that you have
the syslinux package (version 4.04 or newer) installed.

1. Extract the arch folder from the ISO to the USB drive. For UEFI
motherboards follow these instructions.

2. Install the Syslinux bootloader:

Warning:Be very careful where you point dd and please use the drive
itself in the following commands, not the first partition. This is a
very common mistake.

Note:On some distributions mbr.bin may be available as
/usr/share/syslinux/mbr.bin.

    $ cd /path/to/folder/arch/boot/syslinux #Where path/to/folder is the USB drive's mount point
    # extlinux --install .                       #Type it exactly as you see it, including the dot (.)
    # dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/mbr.bin of=/dev/sdx
    # parted /dev/sdx toggle 1 boot

3. Adjust the configuration files:

Warning:Failure to label the drive "ARCH_2013XX" (with the appropriate
release month) or to use an UUID (to re-label it to whatever you like)
will get you the infamous "30 seconds" error.

Here's how you can replace the archisolabel=ARCH_2013XX part with your
equivalent of archisodevice=/dev/disk/by-uuid/47FA-4071 for both config
files at the same time, using a single command:

Note:Adjust /dev/sdx1 before running it, else it will become blank
(since drive sdx doesn't exist).

    $ sed -i "s|label=ARCH_.*|device=/dev/disk/by-uuid/$(blkid -o value -s UUID /dev/sdx1)|" archiso_sys{32,64}.cfg

If the syslinux package on your distribution is older than version 4.06,
as a workaround for FAT32 filesystems (unnecessary for EXT4), the APPEND
line from syslinux.cfg should also be replaced:

    $ sed -i "s|../../|/arch|" syslinux.cfg

Using UNetbootin

You can use UNetbootin on any Linux distribution or Windows to copy your
iso on a USB.

Note:UNetbootin writes over the default syslinux.cfg, which needs to be
reverted.

Edit syslinux.cfg:

    sysconfig.cfg

    default menu.c32
    prompt 0
    menu title Archlinux Installer
    timeout 100

    label unetbootindefault
    menu label Archlinux_x86_64
    kernel /arch/boot/x86_64/vmlinuz
    append initrd=/arch/boot/x86_64/archiso.img archisodevice=/dev/sdx1 ../../

    label ubnentry0
    menu label Archlinux_i686
    kernel /arch/boot/i686/vmlinuz
    append initrd=/arch/boot/i686/archiso.img archisodevice=/dev/sdx1 ../../

In /dev/sdx1 you must replace x with the first free letter after last is
in use in the system where you would install Arch Linux (e.g. if you
have 2 hard drives, use c.). It's possible to make this change during
the first phase of boot pressing Tab when the menu is shown.

On Mac OS X
-----------

To be able to use dd on your USB device on a Mac you have to do some
special maneuvers. First of all insert your usb device, OS X will
automount it, and in Terminal.app run:

    $ diskutil list

Figure out what your USB device is called with mount or
sudo dmesg | tail (e.g. /dev/disk1) and unmount the partitions on the
device (i.e., /dev/disk1s1) while keeping the device proper (i.e.,
/dev/disk1):

    $ diskutil unmountDisk /dev/disk1

Now we can continue in accordance with the instructions above (but use
bs=8192 if you are using the OS X dd, the number comes from 1024*8).

    dd if=image.iso of=/dev/disk1 bs=8192

    20480+0 records in
    20480+0 records out
    167772160 bytes transferred in 220.016918 secs (762542 bytes/sec)

It is probably a good idea to eject your drive before physical removal
at this point:

    $ diskutil eject /dev/disk1

On Windows
----------

> Image Writer for Windows

Download the program from
http://sourceforge.net/projects/win32diskimager/ and run it. Select the
arch image-file and usb stick. The Win32 Disk Imager's file browser
assumes image files end with .img, so if the image file you have
selected ends with .iso, you will have to type its name in manually;
this difference in suffixes is simply cosmetic however, the image will
be written fine regardless. Click on the write button. Now you should be
able to boot from the usb stick and install Arch Linux from it.

> USBWriter for Windows

Download the program from http://sourceforge.net/projects/usbwriter/ and
run it. Select the arch image file, the target USB stick, and click on
the write button. Now you should be able to boot from the usb stick and
install Arch Linux from it.

> The Flashnul Way

flashnul is an utility to verify the functionality and maintenance of
Flash-Memory (USB-Flash, IDE-Flash, SecureDigital, MMC, MemoryStick,
SmartMedia, XD, CompactFlash etc).

From a command prompt, invoke flashnul with -p, and determine which
device index is your USB drive, e.g.:

    C:\>flashnul -p

    Avaible physical drives:
    Avaible logical disks:
    C:\
    D:\
    E:\

When you have determined which device is the correct one, you can write
the image to your drive, by invoking flashnul with the device index, -L,
and the path to your image, e.g:

    C:\>flashnul E: -L path\to\arch.iso

As long as you are really sure you want to write the data, type yes,
then wait a bit for it to write. If you get an access denied error,
close any Explorer windows you have open.

If under Vista or Win7, you should open the console as administrator, or
else flashnul will fail to open the stick as a block device and will
only be able to write via the drive handle windows provides

Note:Confirmed that you need to use drive letter as opposed to number.
flashnul 1rc1, Windows 7 x64.

> The Cygwin Way

Make sure your Cygwin installation contains the dd package. Or if you do
not want to install Cygwin, you can simply download dd for Windows from
http://www.chrysocome.net/dd.

Place your image file in your home directory:

    C:\cygwin\home\John\

Run cygwin as administrator (required for cygwin to access hardware). To
write to your USB drive use the following command:

    dd if=image.iso of=\\.\[x]:

where image.iso is the path to the iso image file within the cygwin
directory and \\.\[x]: is your USB device where x is the windows
designated letter, e.g. \\.\d:.

On cygwin 6.0 find out the correct partition with:

    cat /proc/partitions

and write the ISO image with the information from the output. Example:

Warning:This will irrevocably delete all files on your USB stick, so
make sure you do not have any important files on the stick before doing
this.

    dd if=image.iso of=/dev/sdb

> dd for Windows

A GPL licensed dd version for Windows is available at
http://www.chrysocome.net/dd. The advantage of this over Cygwin is
smaller download. Use it as shown in instructions for Cygwin above.

> Boot the entire ISO from RAM

This method uses Syslinux and MEMDISK to load the entire ISO image in
RAM, so make sure you have enough RAM to hold it. Once it's done loading
and you see the graphical menu you can simply remove the USB stick and
maybe even use it on a different machine to start the process all over
again. It also allows booting and installing Arch from (and to) the same
USB stick.

1. Format the USB stick as FAT32 and create the following folders:

    X:\Boot
    X:\Boot\ISOs
    X:\Boot\Settings

2. Copy the ISO you'd like to boot to the ISOs folder (e.g.
archlinux-2013.04.01-dual.iso), and extract from the latest release
(e.g. syslinux-4.05.zip):

-   ./win32/syslinux.exe to the desktop, or wherever you want.

-   ./memdisk/memdisk to the Settings folder.

And while you're in this folder, create a syslinux.cfg file:

    X:\Boot\Settings\syslinux.cfg

    DEFAULT arch_iso

    LABEL arch_iso
            MENU LABEL Arch Setup
            LINUX memdisk
            INITRD /Boot/ISOs/archlinux-2013.04.01-dual.iso
            APPEND iso

Tip:If you want to add more distributions (Debian and Parted Magic were
tested) you can edit this file. Maybe even give it a nice menu and a
background image, instead of defaulting to the Arch Linux ISO. Refer to
the Syslinux wiki.

3. Finally, create a *.bat file where syslinux.exe is located and run it
("Run as administrator" if you're on Vista or Windows 7):

    C:\Documents and Settings\username\Desktop\install.bat

    @echo off
    syslinux.exe -m -a -d /Boot/Settings X:

Done.

Troubleshooting
---------------

Note:For the MEMDISK Method, if you get the famous "30 seconds" error
trying to boot the i686 version, press the Tab key over the
Boot Arch Linux (i686) entry and add vmalloc=448M at the end. For
reference: If your image is bigger than 128MiB and you have a 32-bit OS,
then you have to increase the maximum memory usage of vmalloc. (*)

Note:If you get the "30 seconds" error due to the
/dev/disk/by-label/ARCH_XXXXXX not mounting, try renaming your USB media
to ARCH_XXXXXX (e.g. ARCH_201302).

See Also
--------

-   Gentoo liveusb document

Retrieved from
"https://wiki.archlinux.org/index.php?title=USB_Installation_Media&oldid=256174"

Category:

-   Getting and installing Arch
