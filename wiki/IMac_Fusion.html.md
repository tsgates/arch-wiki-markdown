IMac Fusion
===========

Apple uses a Wikipedia:RAID alternative called CoreStorage to merge the
ssd and hdd into a single logical volume (sold as Fusion). We need to
remove this volume, so we can reinstall OSx to the hdd without using the
ssd.

Contents
--------

-   1 Boot into recovery
-   2 Destroy CoreStorage and prepare new volumes
-   3 Install OSX on hdd
-   4 Proceed installing Archlinux
-   5 See also

Boot into recovery
------------------

The iMacs that come with Fusion also come with a Rescue partition that
runs itself from RAM (a virtual disk2). This will allow you to play with
the hdd and sdd without problems caused by mounted disks. Power on your
iMac, holding down apple+R to enter the recovery environment.

When the Recovery has started, start a Terminal (under menu 'Utilities).

Destroy CoreStorage and prepare new volumes
-------------------------------------------

Find the CoreStorage 'Logical volume group' ID, and take note of the ssd
and larger disk (disk0 & 1)

    diskutil cs list

Remove the CoreStorage volume

    diskutil cs delete <VOLUMEID>

Sometimes you need to unmount a volume or try the above command twice
for OSX to 'understand' and actually run it successful.

Zero the ssd (if you specify the correct disk this takes ~ 5 minutes)
This will remove everything including the partition table so OSX doesn't
'see' the disk and won't try to use it during installation.

    diskutil zeroDisk disk1

Erase the hdd (this is faster then zeroDisk plus it creates a new HFS+
volume for OSx)

    diskutil eraseDisk JHFS+ Macintosh disk0

Install OSX on hdd
------------------

Quit the terminal and start the OSX installer. Do not use the GUI based
Disk Utility at this point, it will show your disks as errored (red) and
will want to fix them for you. This will actually screw things up as it
will recreate the CoreStorage volume (even if you choose not to 'fix'
anything). The OSX installer should show you 1 disk; which is the
created JHFS+ volume on the hdd.

Proceed by installing a fresh OSX version on the hdd. You can play
around in OSX, for example use the 'Disk Utility' to resize the OSX
partition so you can allocate some space for Linux to use besides the
ssd. Now boot the Archlinux usb-stick by holding the left-ALT key while
booting your iMac (you might need to use an apple keyboard for this to
work). This will show you a bootmenu where you can select the USB drive
for booting.

Proceed installing Archlinux
----------------------------

Installing Archlinux requires no special tricks; follow the Installation
guide; mount /dev/sda1 (the first partition of the hdd is the UEFI
partition) on /boot/efi; install grub-efi-x86_64 and you should be good
to go! Since you will be installing on the Solid_State_Drives, use
parted and created aligned partitions. I use this scheme:

    Model: ATA APPLE SSD SM128E (scsi)
    Disk /dev/sdb: 121332826112B
    Sector size (logical/physical): 512B/4096B
    Partition Table: gpt
    Disk Flags: 

    Number  Start         End            Size           File system     Name  Flags
    1      1048576B      16383999999B   16382951424B   linux-swap(v1)
    2      16384000000B  121331777535B  104947777536B  ext4

Also, to use the internal network-card you will need at least kernel
3.9! I use a thunderbolt cable (which works in kernel 3.7+) to download
the latest 3.9-rc

When rebooting; hold left-alt to show the internal bootloader so you can
select your new install. To change the default boot-option to Archlinux,
you need to 'bless' the earlier created UEFI file. It is best to rename
the created 'EFI/arch_grub/grubx64_standalone.efi' to
'EFI/BOOT/BOOTX64.EFI', then run the following command from MacOSx,
after mounting the EFI partition:

    sudo bless --device=/dev/disk1s2 --file=/Volumes/EFI/efi/BOOT/BOOTX64.EFI --setBoot

Make sure you specify a partition on the ssd as '--device'! Otherwise
OSX will boot efi from the partition, but grub will not find the ssd
(where the actual install is) and you'll end up in rescue-mode.

See also
--------

-   IMac_Aluminium
-   http://blog.fosketts.net/2011/08/05/undocumented-corestorage-commands/
-   http://arstechnica.com/apple/2012/11/achieving-fusion-with-a-service-training-doc-ars-tears-open-apples-fusion-drive/2/

Retrieved from
"https://wiki.archlinux.org/index.php?title=IMac_Fusion&oldid=298255"

Category:

-   Apple

-   This page was last modified on 16 February 2014, at 07:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
