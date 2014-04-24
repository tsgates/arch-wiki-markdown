Partitioning
============

Related articles

-   fstab
-   LVM
-   Swap
-   File Systems

Partitioning a hard drive allows one to logically divide the available
space into sections that can be accessed independently of one another.

An entire hard drive may be allocated to a single partition, or one may
divide the available storage space across multiple partitions. A number
of scenarios require creating multiple partitions: dual- or
multi-booting, for example, or maintaining a swap partition. In other
cases, partitioning is used as a means of logically separating data,
such as creating separate partitions for audio and video files. Common
partitioning schemes are discussed in detail below.

Each partition should be formatted to a file system type before being
used.

Contents
--------

-   1 Partition table
    -   1.1 Master Boot Record
    -   1.2 GUID Partition Table
    -   1.3 Btrfs Partitioning
    -   1.4 Choosing between GPT and MBR
-   2 Partition scheme
    -   2.1 Single root partition
    -   2.2 Discrete partitions
    -   2.3 Mount points
        -   2.3.1 Root partition
        -   2.3.2 /boot
        -   2.3.3 /home
        -   2.3.4 /var
        -   2.3.5 /tmp
        -   2.3.6 Swap
        -   2.3.7 How big should my partitions be?
-   3 Partitioning tools
-   4 SSD partition alignment
-   5 Using GPT - modern method
    -   5.1 Gdisk usage summary
-   6 Using MBR - legacy method
    -   6.1 Fdisk usage summary
-   7 See also

Partition table
---------------

Partition information is stored in the partition table; today, there are
2 main formats in use: the classic Master Boot Record, and the modern
GUID Partition Table. The latter is an improved version that does away
with several limitations of MBR style.

> Master Boot Record

See the Wikipedia article on this subject for more information: Master
boot record

MBR originally only supported up to 4 partitions. Later on, extended and
logical partitions were introduced to get around this limitation.

There are 3 types of partitions:

-   Primary
-   Extended
    -   Logical

Primary partitions can be bootable and are limited to four partitions
per disk or RAID volume. If a partitioning scheme requires more than
four partitions, an extended partition containing logical partitions is
used. Extended partitions can be thought of as containers for logical
partitions. A hard disk can contain no more than one extended partition.
The extended partition is also counted as a primary partition so if the
disk has an extended partition, only three additional primary partitions
are possible (i.e. three primary partitions and one extended partition).
The number of logical partitions residing in an extended partition is
unlimited. A system that dual boots with Windows will require that
Windows reside in a primary partition.

The customary numbering scheme is to create primary partitions sda1
through sda3 followed by an extended partition sda4. The logical
partitions on sda4 are numbered sda5, sda6, etc.

> GUID Partition Table

See the Wikipedia article on this subject for more information: GUID
Partition Table

There is only one type of partition, primary. The amount of partitions
per disk or RAID volume is unlimited.

> Btrfs Partitioning

See the Wikipedia article on this subject for more information: Btrfs

Btrfs can occupy an entire data storage device and replace the MBR or
GPT partitioning schemes. See the Btrfs Partitioning instructions for
details.

> Choosing between GPT and MBR

GUID Partition Table (GPT) is an alternative, contemporary partitioning
style. It is intended to replace the old Master Boot Record (MBR)
system. GPT has several advantages over MBR, which has quirks dating
back to MS-DOS times. With recent developments to the formatting tools
fdisk (MBR) and gdisk (GPT), it is equally easy to use GPT or MBR and
get maximum performance.

The choice basically boils down to this:

-   If using GRUB legacy as the bootloader, one must use MBR.
-   To dual-boot with Windows (both 32-bit and 64-bit) using Legacy
    BIOS, one must use MBR.
-   To dual-boot Windows 64-bit using UEFI instead of BIOS, one must use
    GPT.
-   If none of the above apply, choose freely between GPT and MBR. Since
    GPT is more modern, it is recommended in this case.
-   It is recommended to use always GPT for UEFI boot as some UEFI
    firmwares do not allow UEFI-MBR boot.

Partition scheme
----------------

There are no strict rules for partitioning a hard drive, although one
may follow the general guidance given below. A disk partitioning scheme
is determined by various issues such as desired flexibility, speed,
security, as well as the limitations imposed by available disk space. It
is essentially personal preference. If you would like to dual boot Arch
Linux and a Windows operating system please see Windows and Arch Dual
Boot.

Warning:Don't forget to allow space for the boot-loader. This was not an
issue for MBR and GRUB-Legacy, but more modern schemes may require a
special, small partition.

> Single root partition

This scheme is the simplest and should be enough for most use cases. A
swapfile can be created and easily resized as needed. It usually makes
sense to start by considering a single / partition and then separate out
others based on specific use cases like RAID, encryption, a shared media
partition, etc. Note that installing GRUB on a BIOS system partitioned
with GPT requires an additional BIOS boot partition.

> Discrete partitions

Separating out a path as a partition allows for the choice of a
different filesystem and mount options. In some cases like a media
partition, they can also be shared between operating systems.

> Mount points

The following mount points are possible choices for separate partitions,
you can make your decision based on actual needs.

Root partition

The root directory is the top of the hierarchy, the point where the
primary filesystem is mounted and from which all other filesystems stem.
All files and directories appear under the root directory /, even if
they are stored on different physical devices. The contents of the root
filesystem must be adequate to boot, restore, recover, and/or repair the
system. Therefore, certain directories under / are not candidates for
separate partitions.

The / partition or root partition is necessary and it is the most
important. The other partitions can be replaced by it.

Warning:Directories essential for booting (except for /boot) must be on
the same partition as / or mounted in early userspace by the initramfs.
These essential directories are: /etc and /usr [1].

/boot

The /boot directory contains the kernel and ramdisk images as well as
the bootloader configuration file and bootloader stages. It also stores
data that is used before the kernel begins executing user-space
programs. /boot is not required for normal system operation, but only
during boot and kernel upgrades (when regenerating the initial ramdisk).

A separate /boot partition is needed if installing a software RAID0
(stripe) system.

/home

The /home directory contains user-specific configuration files, caches,
application data and media files.

Separating out /home allows / to be re-partitioned separately, but note
that you can still reinstall Arch with /home untouched even if it isn't
separate - the other top-level directories just need to be removed, and
then pacstrap can be run.

You should not share home directories between users on different
distributions, because they use incompatible software versions and
patches. Instead, consider sharing a media partition or at least using
different home directories on the same /home partition.

/var

The /var directory stores variable data such as spool directories and
files, administrative and logging data, pacman's cache, the ABS tree,
etc. It is used, for example, for caching and logging, and hence
frequently read or written. Keeping it in a separate partition avoids
running out of disk space due to flunky logs, etc.

It exists to make it possible to mount /usr as read-only. Everything
that historically went into /usr that is written to during system
operation (as opposed to installation and software maintenance) must
reside under /var.

Note:/var contains many small files. The choice of file system type
should consider this fact if a separate partition is used.

/tmp

This is already a separate partition by default, by virtue of being
mounted as tmpfs by systemd.

Swap

A swap partition provides memory that can be used as virtual RAM. A swap
file should be considered too, as they have almost no performance
overhead compared to a partition but are much easier to resize as
needed. A swap partition can potentially be shared between operating
systems, but not if hibernation is used.

How big should my partitions be?

Note:The below are simply recommendations; there is no hard rule
dictating partition size.

The size of the partitions depends on personal preference, but the
following information may be helpful:

 /boot - 200 MB 
    It requires only about 100 MB, but if multiple kernels/boot images
    are likely to be in use, 200 or 300 MB is a better choice.
 / - 15-20 GB 
    It traditionally contains the /usr directory, which can grow
    significantly depending upon how much software is installed. 15-20
    GB should be sufficient for most users with modern hard disks.
 /var - 8-12 GB 
    It will contain, among other data, the ABS tree and the pacman
    cache. Keeping cached packages is useful and versatile as it
    provides the ability to downgrade. As a result, /var tends to grow
    in size. The pacman cache in particular will grow as the system is
    expanded and updated. It can, however, be safely cleared if space
    becomes an issue. 8-12 GB on a desktop system should be sufficient
    for /var, depending on how much software will be installed.
 /home - [varies] 
    It is typically where user data, downloads, and multimedia reside.
    On a desktop system, /home is typically the largest filesystem on
    the drive by a large margin.
 swap - [varies] 
    Historically, the general rule for swap partition size was to
    allocate twice the amount of physical RAM. As computers have gained
    ever larger memory capacities, this rule has become deprecated. On
    machines with up to 512MB RAM, the 2x rule is usually adequate. If a
    sufficient amount of RAM (more than 1024MB) is available, it may be
    possible to have a smaller swap partition or even eliminate it. With
    more than 2 GB of physical RAM, one can generally expect good
    performance without a swap partition.
    Note:If you plan to hibernate into a swap partition/file, you should
    see Suspend and Hibernate#About swap partition/file size.
 /data - [varies] 
    One can consider mounting a "data" partition to cover various files
    to be shared by all users. Using the /home partition for this
    purpose is fine as well.

Note:If available, an extra 25% of space added to each filesystem will
provide a cushion for future expansion and help protect against
fragmentation.

Partitioning tools
------------------

-   fdisk — Terminal partitioning tools included in Linux.

https://www.kernel.org/ || util-linux

-   cfdisk — Terminal partitioning tool written with ncurses libraries.

https://www.kernel.org/ || util-linux

Warning:The first partition created by cfdisk starts at sector 63,
instead of the usual 2048. This can lead to reduced performance on SSD
and advanced format (4k sector) drives. It will cause problems with
GRUB2. GRUB legacy and Syslinux should work fine.

-   gdisk — GPT version of fdisk.

http://www.rodsbooks.com/gdisk/ || gptfdisk

-   cgdisk — GPT version of cfdisk.

http://www.rodsbooks.com/gdisk/ || gptfdisk

-   GNU Parted — Terminal partitioning tool.

http://www.gnu.org/software/parted/parted.html || parted

-   GParted — Graphical tool written in GTK.

http://gparted.sourceforge.net/ || gparted

-   Partitionmanager — Graphical tool written in QT.

http://sourceforge.net/projects/partitionman/ || partitionmanager

-   QtParted — Similar to Partitionmanager, available in AUR.

http://qtparted.sourceforge.net/ || qtparted

SSD partition alignment
-----------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Manual SSD       
                           alignment may no longer  
                           be necessary. See        
                           discussion for more      
                           information. (Discuss)   
  ------------------------ ------------------------ ------------------------

Proper partition alignment is essential for optimal performance and
longevity. The key to alignment is partitioning to (at least) the EBS
(erase block size) of the SSD.

Note:The EBS is largely vendor specific.

If the partitions are not aligned to begin at multiples of the EBS (512
KiB for example), aligning the file system is a pointless exercise
because everything is skewed by the start offset of the partition.
Traditionally, hard drives were addressed by indicating the cylinder,
the head, and the sector at which data was to be read or written. These
represented the radial position, the drive head (= platter and side) and
the axial position of the data respectively. With LBA (logical block
addressing), this is no longer the case. Instead, the entire hard drive
is addressed as one continuous stream of data.

Using GPT - modern method
-------------------------

> Gdisk usage summary

Using GPT, the utility for editing the partition table is called gdisk.
It can perform partition alignment automatically on a 2048 sector (or
1024KiB) block size base which should be compatible with the vast
majority of SSDs if not all. GNU parted also supports GPT, but is less
user-friendly for aligning partitions. The environment provided by the
Arch install ISO includes the gdisk command. If you need it later on in
the installed system, gdisk is available in the gptfdisk package.

A summary of the typical usage of gdisk:

-   Start gdisk against your drive as root (disk-device may be e.g.
    /dev/sda):

    # gdisk disk-device

-   If the drive is brand new or if you are wanting to start over,
    create a new empty GUID partition table with the o command.
-   Create a new partition with the n command (primary type/1st
    partition).
-   Assuming the partition is new, gdisk will pick the highest possible
    alignment. Otherwise, it will pick the largest power of two that
    divides all partition offsets.
-   If choosing to start on a sector before the 2048th gdisk will
    automatically shift the partition start to the 2048th disk sector.
    This is to ensure a 2048-sectors alignment (as a sector is 512B,
    this is a 1024KiB alignment which should fit any SSD NAND erase
    block).
-   Use the +x{M,G} format to extend the partition x mebibytes or
    gibibytes, if choosing a size that is not a multiple of the
    alignment size (1024kiB), gdisk will shrink the partition to the
    nearest inferior multiple. For example, if you want to create a
    15GiB partition, you would enter +15G
-   Select the partition's type id, the default, Linux filesystem (code
    8300), should be fine for most use. Press L to show the codes list.
    If planning to use LVM select Linux LVM (8e00).
-   Assign other partitions in a like fashion.
-   Write the table to disk and exit via the w command.
-   Format the new partitions with a file system.

> Note:

-   To boot from a GPT partitioned disk on a BIOS based system you have
    to create, preferably at the disk's beginning, a BIOS boot partition
    with no filesystem and with the partition type as BIOS boot or
    bios_grub partition (gdisk type code EF02) for booting from the disk
    using GRUB. For Syslinux, you do not need to create this bios_grub
    partition, but you need to have separate /boot partition and enable
    Legacy BIOS Bootable partition attribute for that partition (using
    gdisk).
-   GRUB Legacy does not support GPT, users must use BURG, GRUB or
    Syslinux.

Warning:If planning to dual boot with Windows in BIOS mode (this is the
only available option for 32-bit Windows versions and 64-bit Windows
XP), do not use GPT since Windows does not support booting from a GPT
disk in BIOS systems. You will need to use MBR partitioning and boot in
BIOS mode, as described below. This limitation does not apply if booting
a modern 64-bit Windows version in UEFI mode.

Using MBR - legacy method
-------------------------

Using MBR, the utility for editing the partition table is called fdisk.
Recent versions of fdisk have abandoned the deprecated system of using
cylinders as the default display unit, as well as MS-DOS compatibility
by default. The latest fdisk automatically aligns all partitions to 2048
sectors, or 1024 KiB, which should work for all EBS sizes that are known
to be used by SSD manufacturers. This means that the default settings
will give you proper alignment.

Note that in the olden days, fdisk used cylinders as the default display
unit, and retained an MS-DOS compatibility quirk that messed with SSD
alignment. Therefore one will find many guides around the internet from
around 2008-2009 making a big deal out of getting everything correct.
With the latest fdisk, things are much simpler, as reflected in this
guide.

> Fdisk usage summary

-   Start fdisk against your drive as root (disk-device may be e.g.
    /dev/sda):

    # fdisk disk-device

-   If the drive is brand new or if you are wanting to start over,
    create a new empty DOS partition table with the o command.
-   Create a new partition with the n command (primary type/1st
    partition).
-   Use the +xG format to extend the partition x gibibytes. For example,
    if you want to create a 15GiB partition, you would enter +15G
-   Change the partition's system id from the default type of Linux
    (type 83) to the desired type via the t command. This is an optional
    step should the user wish to create another type of partition for
    example, swap, NTFS, LVM, etc. Note that a complete listing of all
    valid partition types is available via the l command.
-   Assign other partitions in a like fashion.
-   Write the table to disk and exit via the w command.
-   Format the new partitions with a file system.

See also
--------

-   Creating ext4 partitions from scratch
-   Wikipedia:Disk partitioning
-   Manually Partitioning Your Hard Drive with fdisk

Retrieved from
"https://wiki.archlinux.org/index.php?title=Partitioning&oldid=291406"

Category:

-   File systems

-   This page was last modified on 3 January 2014, at 00:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
