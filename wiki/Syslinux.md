Syslinux
========

Summary

Describes installing and configuring Syslinux, a collection of
bootloaders.

Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           Network_Installation_Gui 
                           de#Pxelinux.             
                           Notes: No mention of PXE 
                           capability in this       
                           article (Discuss)        
  ------------------------ ------------------------ ------------------------

Syslinux is a collection of boot loaders capable of booting from hard
drives, CDs, and over the network via PXE. It supports the FAT, ext2,
ext3, ext4, and Btrfs file systems.

Note:Since Syslinux 4, Extlinux and Syslinux are the same thing.

Note:Syslinux UEFI support is present in version 6.00-preXX and is
currently of alpha quality. See UEFI_Bootloaders#SYSLINUX for more info.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Syslinux Boot Process                                              |
| -   2 Installation                                                       |
|     -   2.1 Automatic Install                                            |
|     -   2.2 Manual Install                                               |
|         -   2.2.1 MBR Partition Table                                    |
|         -   2.2.2 GUID Partition Table aka GPT                           |
|         -   2.2.3 Rebooting                                              |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Examples                                                     |
|         -   3.1.1 Basic Config                                           |
|         -   3.1.2 Text Boot menu                                         |
|         -   3.1.3 Graphical Boot menu                                    |
|                                                                          |
|     -   3.2 Auto Boot                                                    |
|     -   3.3 Chainloading                                                 |
|     -   3.4 Chainloading other Linux systems                             |
|     -   3.5 Using memtest                                                |
|     -   3.6 HDT                                                          |
|     -   3.7 Reboot and power off                                         |
|     -   3.8 Clear Menu                                                   |
|     -   3.9 Keyboard remapping                                           |
|     -   3.10 Hiding the menu                                             |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Using the Syslinux prompt                                    |
|         -   4.1.1 Fsck fails on root partition                           |
|                                                                          |
|     -   4.2 No Default or UI found on some computers                     |
|     -   4.3 Missing Operating System                                     |
|     -   4.4 Windows boots up, ignoring Syslinux                          |
|     -   4.5 Menu entries do nothing                                      |
|     -   4.6 Cannot remove ldlinux.sys                                    |
|     -   4.7 White block in upper left corner when using vesamenu         |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Syslinux Boot Process
---------------------

1.  Load MBR. At boot, the computer loads the MBR
    (/usr/lib/syslinux/mbr.bin).
2.  Search active partition. The MBR looks for the partition that is
    marked as active (boot flag).
3.  Execute volume boot record. Once found, the volume boot record (VBR)
    will be executed. In the case of ext2/3/4 and FAT12/16/32, the
    starting sector of ldlinux.sys is hard-coded into the VBR.
4.  Execute ldlinux.sys. The VBR will execute (ldlinux.sys). Therefore,
    if the location of ldlinux.sys changes, Syslinux will no longer
    boot. (In the case of Btrfs, the above method will not work since
    files move around resulting in the sector location of ldlinux.sys
    changing. Therefore, the entire Syslinux code needs to be stored
    outside the filesystem. The code is stored in the sectors following
    the VBR.)
5.  Search configuration file. Once Syslinux is fully loaded, it looks
    for a configuration file, either extlinux.conf or syslinux.cfg.
6.  Load configuration. If one is found, the configuration file is
    loaded. If no configuration file is found, you will be given a
    Syslinux prompt.

Installation
------------

Install syslinux from the official repositories.

> Automatic Install

The syslinux-install_update script will install Syslinux, copy/symlink
*.c32 modules to /boot/syslinux, set the boot flag and install the boot
code in the MBR. It can handle MBR and GPT disks along with software
RAID.

1. If you use a separate boot partition make sure that it is mounted.
Check with lsblk; if you don't see a /boot mountpoint, mount it before
you go any further.

2. Run syslinux-install_update with flags: -i (install the files), -a
(mark the partition active with the boot flag), -m (install the MBR boot
code):

    # syslinux-install_update -i -a -m

3. Edit /boot/syslinux/syslinux.cfg.

Note:For this to work with GPT, the gptfdisk package is needed as the
backend for setting the boot flag.

> Manual Install

Note: If you are unsure of which partition table you are using (MBR or
GPT), you are likely using the MBR partition table. Most of the time GPT
will create a special MBR-style partition (type 0xEE) using the whole
disk which will be displayed with the following command:

    # fdisk -l /dev/sda

or alternatively:

    # sgdisk -p /dev/sda

will show "GPT: not present" if it is not a GPT disk.

Note: If you are trying to rescue an installed system with a live CD, be
sure to chroot into it before executing these commands. If you do not
chroot first, you must prepend all file paths (not /dev/ paths) with the
mount point.

Your boot partition, on which you plan to install Syslinux, must contain
a FAT, ext2, ext3, ext4, or Btrfs file system. You should install it on
a mounted directory, not a /dev/sdXY device. You do not have to install
it on the root directory of a file system, e.g., with device /dev/sda1
mounted on /boot you can install Syslinux in the syslinux directory:

    # mkdir /boot/syslinux
    # extlinux --install /boot/syslinux 

MBR Partition Table

See the main article: Master Boot Record

Next you need to mark your boot partition active in your partition
table. Applications capable of doing this include fdisk, cfdisk, sfdisk,
parted/gparted. It should look like this:

    # fdisk -l /dev/sda

    [...]
      Device Boot      Start         End      Blocks   Id  System
    /dev/sda1   *        2048      104447       51200   83  Linux
    /dev/sda2          104448   625142447   312519000   83  Linux

Install the MBR:

    # dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/mbr.bin of=/dev/sda

An alternate MBR which Syslinux provides is: altmbr.bin. This MBR does
not scan for bootable partitions; instead, the last byte of the MBR is
set to a value indicating which partition to boot from. Here is an
example of how altmbr.bin can be copied into position:

    # printf '\x5' | cat /usr/lib/syslinux/altmbr.bin - | dd bs=440 count=1 iflag=fullblock conv=notrunc of=/dev/sda

In this case, a single byte of value 5 is appended to the contents of
altmbr.bin and the resulting 440 bytes are written to the MBR on device
sda. Syslinux was installed on the first logical partition (/dev/sda5)
of the disk.

GUID Partition Table aka GPT

See the main article: GUID Partition Table

Bit 2 of the attributes for the /boot partition needs to be set.

    # sgdisk /dev/sda --attributes=1:set:2

This would toggle the attribute legacy BIOS bootable on partition 1. To
check:

    # sgdisk /dev/sda --attributes=1:show
    1:2:1 (legacy BIOS bootable)

Install the MBR:

    # dd bs=440 conv=notrunc count=1 if=/usr/lib/syslinux/gptmbr.bin of=/dev/sda

If this doesn't work you can also try:

    # syslinux-install_update -i -m

Rebooting

When you reboot your system now, you will have a Syslinux prompt. To
automatically boot your system or get a boot menu, you still need to
create a configuration file.

Configuration
-------------

The Syslinux configuration file, syslinux.cfg, should be created in the
same directory where you installed Syslinux. In our case,
/boot/syslinux/.

The bootloader will look for either syslinux.cfg (preferred) or
extlinux.conf

Tip:

-   Instead of LINUX, the keyword KERNEL can also be used. KERNEL tries
    to detect the type of the file, while LINUX always expects a Linux
    kernel.
-   TIMEOUT value is in units of 1/10 of a second.

> Examples

Basic Config

This is a simple configuration file that will show a boot: prompt and
automatically boot after 5 seconds.

Note:The partition in question needs to be whatever you have as /
(root), not /boot.

Configuration:

    /boot/syslinux/syslinux.cfg

     PROMPT 1
     TIMEOUT 50
     DEFAULT arch
     
     LABEL arch
             LINUX ../vmlinuz-linux
             APPEND root=/dev/sda2 ro
             INITRD ../initramfs-linux.img
     
     LABEL archfallback
             LINUX ../vmlinuz-linux
             APPEND root=/dev/sda2 ro
             INITRD ../initramfs-linux-fallback.img

If you want to boot directly without seeing a prompt, set PROMPT to 0.

If you want to use UUID for persistent device naming instead of device
names, change the APPEND line to your equivalent UUID of the root
partition:

    APPEND root=UUID=978e3e81-8048-4ae1-8a06-aa727458e8ff ro

If you use encryption LUKS change the APPEND line to use your encrypted
volume:

    APPEND root=/dev/mapper/<group>-<name> cryptdevice=/dev/sda2:<name> ro

If you are using software RAID using mdadm, change the APPEND line to
accommodate your RAID arrays. As an example the following accommodates
three RAID 1 array's and sets the appropriate one as root:

    APPEND root=/dev/md1 ro md=0,/dev/sda2,/dev/sdb2 md=1,/dev/sda3,/dev/sdb3 md=2,/dev/sda4,/dev/sdb4

Text Boot menu

Syslinux also allows you to use a boot menu. To use it, copy the menu
COM32 module to your Syslinux directory:

    # cp /usr/lib/syslinux/menu.c32 /boot/syslinux/

If /boot is in the same partition as /usr, a symlink will also work:

    # ln -s /usr/lib/syslinux/menu.c32 /boot/syslinux/

Configuration:

    /boot/syslinux/syslinux.cfg

     UI menu.c32
     PROMPT 0
     
     MENU TITLE Boot Menu
     TIMEOUT 50
     DEFAULT arch
     
     LABEL arch
             MENU LABEL Arch Linux
             LINUX ../vmlinuz-linux
             APPEND root=/dev/sda2 ro
             INITRD ../initramfs-linux.img
     
     LABEL archfallback
             MENU LABEL Arch Linux Fallback
             LINUX ../vmlinuz-linux
             APPEND root=/dev/sda2 ro
             INITRD ../initramfs-linux-fallback.img

For more details about the menu system, see the Syslinux documentation.

Graphical Boot menu

Syslinux also allows you to use a graphical boot menu. To use it, copy
the vesamenu COM32 module to your Syslinux folder:

    # cp /usr/lib/syslinux/vesamenu.c32 /boot/syslinux/

If /boot is the same partition as /, a symlink will also work:

    # ln -s /usr/lib/syslinux/vesamenu.c32 /boot/syslinux/

This config uses the same menu design as the Arch Install CD. The
background file can be found there too. To make sure that your system
can boot with this config, check that it is pointing to the correct
partition.

Configuration:

    /boot/syslinux/syslinux.cfg

     UI vesamenu.c32
     DEFAULT arch
     PROMPT 0
     MENU TITLE Boot Menu
     MENU BACKGROUND splash.png
     TIMEOUT 50
     
     MENU WIDTH 78
     MENU MARGIN 4
     MENU ROWS 5
     MENU VSHIFT 10
     MENU TIMEOUTROW 13
     MENU TABMSGROW 11
     MENU CMDLINEROW 11
     MENU HELPMSGROW 16
     MENU HELPMSGENDROW 29
     
     # Refer to http://www.syslinux.org/wiki/index.php/Comboot/menu.c32
     
     MENU COLOR border       30;44   #40ffffff #a0000000 std
     MENU COLOR title        1;36;44 #9033ccff #a0000000 std
     MENU COLOR sel          7;37;40 #e0ffffff #20ffffff all
     MENU COLOR unsel        37;44   #50ffffff #a0000000 std
     MENU COLOR help         37;40   #c0ffffff #a0000000 std
     MENU COLOR timeout_msg  37;40   #80ffffff #00000000 std
     MENU COLOR timeout      1;37;40 #c0ffffff #00000000 std
     MENU COLOR msg07        37;40   #90ffffff #a0000000 std
     MENU COLOR tabmsg       31;40   #30ffffff #00000000 std
     
     
     LABEL arch
             MENU LABEL Arch Linux
             LINUX ../vmlinuz-linux
             APPEND root=/dev/sda2 ro
             INITRD ../initramfs-linux.img
     
     
     LABEL archfallback
             MENU LABEL Arch Linux Fallback
             LINUX ../vmlinuz-linux
             APPEND root=/dev/sda2 ro
             INITRD ../initramfs-linux-fallback.img

Since Syslinux 3.84, vesamenu.c32 supports the
MENU RESOLUTION $WIDTH $HEIGHT directive. To use it, insert
MENU RESOLUTION 1440 900 into your config for a 1440x900 resolution. The
background picture has to have exactly the right resolution, however, as
Syslinux will otherwise refuse to load the menu.

> Auto Boot

If you don't want to see the Syslinux menu at all, comment out all UI
commands and make sure there is a DEFAULT set in your syslinux.cfg.

> Chainloading

If you want to chainload other operating systems (such as Windows) or
boot loaders, copy (or symlink) the chain.c32 module to the Syslinux
directory (for details, see the instructions in the previous section).
Then create a section in the configuration file:

    /boot/syslinux/syslinux.cfg

    ...
     LABEL windows
             MENU LABEL Windows
             COM32 chain.c32
             APPEND hd0 3
    ...

hd0 3 is the third partition on the first BIOS drive - drives are
counted from zero, but partitions are counted from one.

If you are unsure about which drive your BIOS thinks is "first", you can
instead use the MBR identifier, or if you are using GPT, the filesystem
labels. To use the MBR identifier, run the command

    # fdisk -l /dev/sdb

     Disk /dev/sdb: 128.0 GB, 128035676160 bytes 
     255 heads, 63 sectors/track, 15566 cylinders, total 250069680 sectors
     Units = sectors of 1 * 512 = 512 bytes
     Sector size (logical/physical): 512 bytes / 512 bytes
     I/O size (minimum/optimal): 512 bytes / 512 bytes
     Disk identifier: 0xf00f1fd3
      
     Device Boot      Start         End      Blocks   Id  System
     /dev/sdb1            2048     4196351     2097152    7  HPFS/NTFS/exFAT
     /dev/sdb2         4196352   250066943   122935296    7  HPFS/NTFS/exFAT

replacing /dev/sdb with the drive you wish to chainload. Using the
hexadecimal number under Disk identifier: 0xf00f1fd3 in this case, the
syntax in syslinux.cfg is

    /boot/syslinux/syslinux.cfg

    ...
     LABEL windows
             MENU LABEL Windows
             COM32 chain.c32
             APPEND mbr:0xf00f1fd3
    ...

For more details about chainloading, see the Syslinux wiki.

If you have GRUB installed on the same partition, you can chainload it
by using:

    /boot/syslinux/syslinux.cfg

    ...
     LABEL grub2
            MENU LABEL Grub2
            COM32 chain.c32
            append file=../grub/boot.img
    ...

This may be required for booting from ISO images.

> Chainloading other Linux systems

Chainloading another bootloader such as Windows' is pretty obvious, as
there is a definite bootloader to chain to. But with Syslinux, it is
only able to load files residing on the same partition as the
configuration file. Thus, if you have another version of Linux on a
separate partition, without a shared /boot, it becomes necessary to
employ Extlinux. Essentially, Extlinux can be installed on the partition
superblock and be called as a separate bootloader from the MBR installed
by Syslinux. Extlinux is part of the Syslinux project and is included
with the syslinux package.

The following instructions assume you have Syslinux installed already.
These instructions will also assume that the typical Arch Linux
configuration path of /boot/syslinux is being used and the chainloaded /
is on /dev/sda3.

From a booted Linux (likely the partition that Syslinux is set up to
boot), mount the other root partition to your desired mount point. In
this example this will be /mnt. Also, if a separate /boot partition is
used on the second operating system, that will also need to be mounted.
The example assumes this is /dev/sda2.

    # mount /dev/sda3 /mnt
    # mount /dev/sda2 /mnt/boot (only necessary for separate /boot)

Install Extlinux and copy necessary *.c32 files

    # extlinux -i /mnt/boot/syslinux
    # cp /usr/lib/syslinux/{chain,menu}.c32 /mnt/boot/syslinux

Create /mnt/boot/syslinux/syslinux.cfg. Below is an example:

    /boot/syslinux/syslinux.cfg on /dev/sda3

    timeout 10

    ui menu.c32


    label Other Linux
        linux /boot/vmlinuz-linux
        initrd /boot/initramfs-linux.img
        append root=/dev/sda3 ro quiet


    label MAIN
        com32 chain.c32
        append hd0 0

taken from Djgera's user wiki page.

> Using memtest

Install memtest86+ from the official repositories.

Use this LABEL section to launch memtest:

    /boot/syslinux/syslinux.cfg

    ...
     LABEL memtest
             MENU LABEL Memtest86+
             LINUX ../memtest86+/memtest.bin
    ...

> HDT

HDT (Hardware Detection Tool) displays hardware information. Like
before, the .c32 file has to be copied or symlinked from
/boot/syslinux/. For PCI info, either copy or symlink
/usr/share/hwdata/pci.ids to /boot/syslinux/pci.ids and add the
following to your configuration file:

    /boot/syslinux/syslinux.cfg

     LABEL hdt
             MENU LABEL Hardware Info
             COM32 hdt.c32

> Reboot and power off

Use the following sections to reboot or power off your machine:

    /boot/syslinux/syslinux.cfg

     LABEL reboot
             MENU LABEL Reboot
             COM32 reboot.c32
     
     LABEL poweroff
             MENU LABEL Power Off
             COMBOOT poweroff.com

> Clear Menu

To clear the screen when exiting the menu, add the following line:

    /boot/syslinux/syslinux.cfg

     MENU CLEAR

> Keyboard remapping

If you often have to edit your boot parameters, you might want to remap
your keyboard layout. This allows you to enter "=", "/" and other
characters easily on a non-US keyboard.

First you have to create a compatible keymap (for example a German one):

    # cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz ./
    # cp /usr/share/kbd/keymaps/i386/qwertz/de.map.gz ./
    # gunzip {de,us}.map.gz
    # mv de.{,k}map
    # mv us.{,k}map
    # keytab-lilo de > de.ktl

The last command has to be run as root, otherwise it won't work.

Copy de.ktl as root to /boot/syslinux/ and set ownership to root:

    # chown root:root /boot/syslinux/de.ktl

Now edit syslinux.conf and add:

    /boot/syslinux/syslinux.cfg

     KBDMAP de.ktl

> Hiding the menu

Use the option:

    /boot/syslinux/syslinux.cfg

     MENU HIDDEN

to hide the menu while displaying only the timeout. Press any key to
bring up the menu.

Troubleshooting
---------------

> Using the Syslinux prompt

You can type in the LABEL name of the entry that you want to boot (as
per your syslinux.cfg). If you used the example configurations, just
type:

    boot: arch

If you get an error that the configuration file could not be loaded, you
can pass your needed boot parameters, e.g.:

    boot: ../vmlinuz-linux root=/dev/sda2 ro initrd=../initramfs-linux.img

If you do not have access to boot: in ramfs, and therefore temporarily
unable to boot kernel again,

1. Create a temporary directory, in order to mount your root partition
(if it does not exist already):

     # mkdir -p /new_root

2. Mount / under /new_root (in case /boot/ is on the same partition,
otherwise you will need to mount them both):

Note:Busybox cannot mount /boot if it is on its own ext2 partition.

     # mount /dev/sd[a-z][1-9] /new_root

3. Use vim and edit syslinux.cfg again to suit your needs and save file.

4. Reboot.

Fsck fails on root partition

In the case of a badly corrupted root partition (in which the journal is
damaged), run the following commands in the syslinux emergency shell :

    # mount /dev/<root partition> /new_root;  ## mount the root partition
    # cp /new_root/sbin/tune2fs /sbin/;  ## grab the tune2fs binary from the root partition (it is not included in syslinux)

Follow the instructions at ext2fs: no external journal to create a new
journal for the root partition.

> No Default or UI found on some computers

Certain motherboard manufacturers have less compatibility for booting
from USB devices than others. While an ext4 formatted USB drive may boot
on a more recent computer, some computers may hang if the boot partition
containing the kernel and initrd are not on a FAT16 partition. To
prevent an older machine from loading ldlinux and failing to read
syslinux.cfg, use cfdisk to create a FAT16 partition (<=2GB) and format
using dosfstools:

    # mkfs.msdos -F 16 /dev/sda1

then install and configure Syslinux.

> Missing Operating System

If you get this message, check if the partition that contains /boot has
the boot flag enabled. If the flag is enabled, then perhaps this
partition starts at sector 1 rather than sector 63 or 2048. Check this
with fdisk -l. If it starts at sector 1, you can move the partition(s)
with gparted from a rescue disk. Or, if you have a separate boot
partition, you can back up /boot with

    # cp -a /boot /boot.bak

and then boot up with the Arch install disk. Next, use cfdisk to delete
the /boot partition, and recreate it. This time it should begin at the
proper sector, 63. Now mount your partitions and chroot into your
mounted system, as described in the beginners guide. Restore /boot with
the command

    # cp -a /boot.bak/* /boot

Check if /etc/fstab is correct, run:

    # syslinux-install_update -iam

and reboot.

> Windows boots up, ignoring Syslinux

Solution: Make sure the partition that contains /boot has the boot flag
enabled. Also, make sure the boot flag is not enabled on the Windows
partition. See the installation section above.

The MBR that comes with Syslinux looks for the first active partition
that has the boot flag set. The Windows partition was likely found first
and had the boot flag set. If you wanted, you could use the MBR that
Windows or MS-DOS fdisk provides.

> Menu entries do nothing

You select a menu entry and it does nothing, it just "refreshes" the
menu. This usually means that you have an error in your syslinux.cfg
file. Hit Tab to edit your boot parameters. Alternatively, press Esc and
type in the LABEL of your boot entry (e.g. arch).

> Cannot remove ldlinux.sys

The ldlinux.sys file has the immutable attribute set, which prevents it
from being deleted or overwritten. This is because the sector location
of the file must not change or else Syslinux has to be reinstalled. To
remove it, run:

    # chattr -i /boot/syslinux/ldlinux.sys
    # rm /boot/syslinux/ldlinux.sys

> White block in upper left corner when using vesamenu

Problem: As of linux-3.0, the modesetting driver tries to keep the
current contents of the screen after changing the resolution (at least
it does so with my Intel, when having Syslinux in text mode). It seems
that this goes wrong when combined with the vesamenu module in Syslinux
(the white block is actually an attempt to keep the Syslinux menu, but
the driver fails to capture the picture from vesa graphics mode).

If you have a custom resolution and a vesamenu with early modesetting,
try to append the following in syslinux.cfg to remove the white block
and continue in graphics mode:

    APPEND root=/dev/sda6 ro 5 vga=current quiet splash

See also
--------

-   Official Website
-   PXELinux configuration

Retrieved from
"https://wiki.archlinux.org/index.php?title=Syslinux&oldid=254742"

Category:

-   Boot loaders
