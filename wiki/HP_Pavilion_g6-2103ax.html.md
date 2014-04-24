HP Pavilion g6-2103ax
=====================

(This is a work-in-progress. I recently bought one of these laptops, and
this article will attempt to explain what I did to dual-boot Arch with
the HP Factory installed Windows 7.)

Contents
--------

-   1 Hardware
-   2 Notes about factory settings
-   3 Dual booting with Arch
    -   3.1 Configuring Windows
    -   3.2 Partitioning
    -   3.3 Install
    -   3.4 Notes on configuration
-   4 Arch-only install

Hardware
--------

The g6-2103ax is a 2012 model 15.6” laptop, with the AMD A6 processor
and a dedicated graphics card.

CPU 
    AMD A6-4400M APU with Radeon graphics
    2.7 GHz, 1 MiB second-level cache
GPU 
    Internal: AMD Radeon HD 7520G, 800Mhz, 512MB
    Dedicated: AMD Radeon HD 7670M, 800Mhz, 512MB
Memory 
    4 GiB DDR3, 1600 MHz
Display 
    15.6” LED
Multimedia 
    HP CDDVDW SN-208BB CD/DVD writer
    Sound: ???
Networking 
    Wireless: Atheros AR9485 wireless adaptor
    Ethernet: Realtek RTL8101E/RTL8102E PCI Express fast ethernet
    controller
Storage 
    Seagate ST500LM012 HN0M5, 500GB (465GiB)
    Factory partitions are SYSTEM, WINDOWS C, HP_RECOVERY, and HP_TOOLS
External ports 
    3× USB-3
    SD card reader
    1× HDMI
    1× VGA-compatible

Notes about factory settings
----------------------------

The factory install comes with Windows 7 Professional, set up to occupy
the majority of the hard drive, with three other utility partitions. As
the disk is formatted with the MBR partitioning style, it is impossible
to create space to dual boot another operating system without removing
one of these utility partitions first. The hardware is UEFI-enabled, but
HP uses some BIOS/UEFI trickery to make the system boot in BIOS mode. At
present, this cannot be changed, and I couldn’t get any UEFI bootloaders
to boot at all.

-   The SYSTEM contains files essential for Windows to boot. Altering
    this partition will render Windows unbootable.
-   The HP_RECOVERY partition contains a factory reset program that will
    restore the computer to its initial state. HP no longer provide
    disks for this purpose, but they can be ordered or made using the HP
    Recovery utilities preinstalled.
-   The HP_TOOLS partition contains some system diagnostic tools by HP.
    These are EFI applications only accessible at pre-boot time by
    hitting Esc before the bootloader starts.

Note:HP is rather vague on whether modifying the partitions voids the
warranty. I was able to request recovery disks under warranty after
messing up the partition table, but they may not repair a damaged
computer sent in unless it was in the factory state.

Dual booting with Arch
----------------------

These are the steps I followed to dual-boot Arch and Windows 7.

> Configuring Windows

If you wish to create the Windows recovery disks, use the HP Recovery
Tools to build these.

Warning:These disks will reset the computer to its initial factory
state, wiping all data on the hard drive.

The HP Recovery Tools program includes an option to delete the recovery
partition. Though they don’t recommend this, it’s safe to perform and is
the only way to make room for Arch that will allow a painless dual-boot.

Use the Windows disk management tools to shrink C: drive to the desired
size. If the tool refuses to shrink beyond so-called immovable files, it
can be coerced by temporarily disabling the Page File and removing
Windows Restore Points.

Warning:Using third-party tools to resize the Windows partition may
render Windows unbootable.

Once you’ve created the desired amount of free space, boot the Arch ISO
installer. Select the 64-bit install, and Tab to modify the kernel boot
parameters. Always append radeon.modeset=0 to disable KMS, or you’ll be
left with a blank screen, as neither the open-source drivers or the ATI
Catalyst drivers support KMS on this laptop (at present).

> Partitioning

When partitioning, make sure to align partitions properly for optimum
performance. Do not modify the SYSTEM, Windows, or HP_TOOLS partitions;
instead, create an extended partition filling up all of the free space
left by shrinking C:\ drive. That way you can have a separate /boot
partition. I used LVM to contain the rest of my partitions, and did not
bother with encryption using LUKS.

> Install

Install Arch as per the official guide.

> Notes on configuration

I couldn’t get the system to boot using the open-source drivers, and
I’ve had no issues with the latest ATI Catalyst driver. You will need to
append nomodeset and vga=0 to your kernel options in your bootloader
configs, otherwise the console will be dark, and resuming from suspend
may not work properly. I haven’t been able to get suspend-to-disk
(hibernate) to work, as it just reports an error from fglrx, so your
mileage in that regard may vary.

Arch-only install
-----------------

If you want to remove Windows 7 and opt for a pure Arch install, I’d
recommend retaining the HP_TOOLS partition as it provides options for
installing BIOS updates, as well as thorough hardware tests.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_g6-2103ax&oldid=298250"

Category:

-   HP

-   This page was last modified on 16 February 2014, at 07:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
