GUID Partition Table
====================

Summary

An overview of the GUID Partition Table.

Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

Related

Unified Extensible Firmware Interface

Master Boot Record

Arch Boot Process

GUID Partition Table (GPT) is a new style of partitioning which is part
of the Unified Extensible Firmware Interface Specification, using the
globally unique identifier for devices. It is different from the Master
Boot Record (the more commonly used partitioning style) in many aspects
and has many advantages.

To understand GPT, it is important to understand what MBR is and what
its disadvantages are.

For any partitioning style, the number of partitions that can be defined
is based on the total space allotted for the partition table and the
space required for storing the information of a single partition.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Master Boot Record                                                 |
|     -   1.1 Problems with MBR                                            |
|                                                                          |
| -   2 GUID Partition Table                                               |
|     -   2.1 Advantages of GPT                                            |
|     -   2.2 Kernel Support                                               |
|                                                                          |
| -   3 Bootloader Support                                                 |
|     -   3.1 UEFI systems                                                 |
|     -   3.2 BIOS systems                                                 |
|                                                                          |
| -   4 Partitioning Utilities                                             |
|     -   4.1 GPT fdisk                                                    |
|         -   4.1.1 Convert from MBR to GPT                                |
|                                                                          |
|     -   4.2 GNU Parted                                                   |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Master Boot Record
------------------

The MBR partition table stores the partitions info in the first sector
of a hard disk as follows

  Location in the HDD   Purpose of the Code
  --------------------- ----------------------------------------------------------------------------------------------------------------------------
  First 440 bytes       MBR boot code that is launched by the BIOS.
  441-446 bytes         MBR disk signature.
  447-510 bytes         Actual partition table with info about primary and extended partitions. (Note that logical partitions are not listed here)
  511-512 bytes         MBR boot signature 0xAA55.

The entire information about the primary partitions is limited to the 64
bytes allotted. To extend this, extended partitions were used. An
extended partition is simply a primary partition in the MBR which acts
like a container for other partitions called logical partitions. So one
is limited to either 4 primary partitions, or 3 primary and 1 extended
partitions with many logical partitions inside it.

> Problems with MBR

1.  Only 4 primary partitions or 3 primary + 1 extended partitions (with
    arbitrary number of logical partitions within the extended
    partition) can be defined. If you have 3 primary + 1 extended
    partitions, and you have some free space outside the extended
    partition area, you cannot create a new partition over that free
    space.
2.  Within the extended partition, the logical partitions' meta-data is
    stored in a linked-list structure. If one link is lost, all the
    logical partitions following that metadata are lost.
3.  MBR supports only 1 byte partition type codes which leads to many
    collisions.
4.  MBR stores partition sector information using 32-bit LBA values.
    This LBA length along with 512 byte sector size (more commonly used)
    limits the maximum addressable size of the disk to be 2 TiB. Any
    space beyond 2 TiB cannot be defined as a partition if MBR
    partitioning is used.

GUID Partition Table
--------------------

GUID Partition Table (GPT) uses GUIDs (or UUIDs in linux world) to
define partitions and its types, hence the name. The GPT consists of:

  Location in the HDD                                                   Purpose
  --------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  First logical sector of the disk or First 512 bytes                   Protective MBR - Same as a normal MBR but the 64-byte area contains a single 0xEE type Primary partition entry defined over the entire size of the disk or in case of >2 TiB, upto a partition size of 2 TiB.
  Second logical sector of the disk or Next 512 bytes                   Primary GPT Header - Contains the Unique Disk GUID, Location of the Primary Partition Table, Number of possible entries in partition table, CRC32 checksums of itself and the Primary Partition Table, Location of the Secondary (or Backup) GPT Header
  16 KiB (by default) following the second logical sector of the disk   Primary GPT Table - 128 Partition entries (by default, can be higher), each with an entry of size 128 bytes (hence total of 16 KiB for 128 partition entries). Sector numbers are stored as 64-bit LBA and each partition has a Partition Type GUID and a Unique Partition GUID.
  16 KiB (by default) before the last logical sector of the disk        Secondary GPT table - It is byte-for-byte identical to the Primary table. Used mainly for recovery in case the primary partition table is damaged.
  Last logical sector of the disk or Last 512 bytes                     Secondary GPT Header - Contains the Unique Disk GUID, Location of the Secondary Partition Table, Number of possible entries in the partition table, CRC32 checksums of itself and the Secondary Partition Table, Location of the Primary GPT Header. This header can be used to recover GPT info in case the primary header is corrupted.

> Advantages of GPT

1.  Uses GUIDs (UUIDs) to identify partition types - No collisions.
2.  Provides a unique disk GUID and unique partition GUID for each
    partition - A good filesystem-independent way of referencing
    partitions and disks.
3.  Arbitrary number of partitions - depends on space allocated for the
    partition table - No need for extended and logical partitions. By
    default the GPT table contains space for defining 128 partitions.
    However if the user wants to define more partitions, he/she can
    allocate more space to the partition table (currently only gdisk is
    known to support this feature).
4.  Uses 64-bit LBA for storing Sector numbers - maximum addressable
    disk size is 2 ZiB.
5.  Stores a backup header and partition table at the end of the disk
    that aids in recovery in case the primary ones are damaged.
6.  CRC32 checksums to detect errors and corruption of the header and
    partition table.

> Kernel Support

CONFIG_EFI_PARTITION option in the kernel config enables GPT support in
the kernel (despite the name EFI PARTITION). This options must be
built-in the kernel and not compiled as a loadable module. This option
is required even if GPT disks are used only for data storage and not for
booting. This option is enabled by default in Arch's linux and linux-lts
kernels in [core] repo. In case of a custom kernel enable this option by
doing CONFIG_EFI_PARTITION=y.

Bootloader Support
------------------

> UEFI systems

All UEFI Bootloaders support GPT disks since GPT is a part of UEFI
Specification and thus mandatory for UEFI boot. See UEFI_Bootloaders for
more info.

> BIOS systems

Note:Some BIOS systems may not boot from GPT disks. See
http://mjg59.dreamwidth.org/8035.html and
http://rodsbooks.com/gdisk/bios.html for more info and possible
workarounds.

-   GRUB requires a 1007 KiB BIOS Boot Partition (EF02 type code in
    gdisk and bios_grub flag in GNU Parted) in BIOS systems to embed its
    core.img file due to lack of post-MBR embed gap in GPT disks.
    Runtime GPT support in GRUB is provided by the part_gpt module.

-   Syslinux requires the partition containing
    /boot/syslinux/ldlinux.sys (irrespective whether /boot is a separate
    partition or not) to be marked as "Legacy BIOS Bootable" GPT
    attribute (legacy_boot flag in GNU Parted) to identify the partition
    containing the Syslinux boot files by its 440-byte MBR boot code
    gptmbr.bin. See Syslinux#GUID Partition Table aka GPT for more
    information. It is equivalent to "boot" flag in MBR disks.

-   GRUB Legacy, does not support GPT disks. Fedora's heavily patched
    GRUB Legacy fork grub-legacy-fedora-git contains GPT patches from
    Intel (tested in Fedora, not tested in Arch). This fork is no longer
    maintained sicne Fedora already uses GRUB as its default BIOS
    bootloader since F16. Users are recommended to switch to GRUB or
    Syslinux instead.

Note:Some Intel Desktop Board motherboards will only boot a GPT disk if
the protective MBR partition has its Boot flag set. This can be done
safely with fdisk/cfdisk without damaging the GPT (but have backups /
double-check the integrity of the GPT afterwards anyway).

-   LILO's GPT support has not been tested so it is unclear whether it
    has issues booting in GPT disks.

Partitioning Utilities
----------------------

> GPT fdisk

GPT fdisk is a set of text-mode utilities for editing GPT disks. It
consists of gdisk, sgdisk and cgdisk which are equivalent to respective
tools from util-linux fdisk (used for MBR disks). It is available in the
[extra] repository as gptfdisk.

Note:The fdisk partitioning utilities from util-linux (i.e. fdisk,
cfdisk and sfdisk) do not support GPT, and may damage the GPT header and
partition table if used on a GPT disk.

Convert from MBR to GPT

One of the best features of gdisk (and sgdisk and cgdisk too) is its
ability to convert MBR and BSD disklabels to GPT without data loss. Upon
conversion, all the MBR primary partitions and the logical partitions
become GPT partitions with the correct partition type GUIDs and Unique
partition GUIDs created for each partition.

Just open the MBR disk using gdisk and exit with "w" option to write the
changes back to the disk (similar to fdisk) to convert the MBR disk to
GPT. Watch out for any error and fix them before writing any change to
disk because you may risk losing data. See
http://www.rodsbooks.com/gdisk/mbr2gpt.html for more info. After
conversion, the bootloaders will need to be reinstalled to configure
them to boot from GPT.

Note:Remember that GPT stores a secondary table at the end of disk. You
must make sure that the last 1 MiB of the disk is not used by any
partition.

Note:Keep in mind that if your Boot-Manager is GRUB, it needs a BIOS
Boot Partition. If your MBR Partitioning Layout isn't too old, there is
a good chance that the first partition starts at sector 2048 for
alignment reasons. That means at the beginning will be 1007KiB of empty
space where this bios-boot partition can be created. To do this, first
do the mbr->gpt conversion with gdisk as described above. Afterwards,
create a new partition with gdisk and manually specify its position to
be sectors 34 - 2047, and set the EF02 partition type.

> GNU Parted

In GNU Parted >=3.0, the parted command-line utility does not support
any filesystem related operation, and most of the FS related code has
been removed from the libparted, leaving only minimal code required by
external applications like gparted. The upstream recommends using the
filesystem specific tools or one of the parted's GUI wrappers like
gparted (which calls these external tools) for filesystem related
operations.

See also
--------

1.  Wikipedia's Page on GPT and MBR
2.  Homepage of Rod Smith's GPT fdisk tool and its Sourceforge.net
    Project page - gptfdisk
3.  Rod Smith's page on Converting MBR to GPT and Booting OSes from GPT
4.  Rod Smith's page on the New Partition Type GUID for Linux data
    partitions
5.  System Rescue CD's page on GPT
6.  Wikipedia page on BIOS Boot Partition
7.  Make the most of large drives with GPT and Linux - IBM Developer
    Works
8.  Microsoft's Windows and GPT FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=GUID_Partition_Table&oldid=255304"

Category:

-   File systems
