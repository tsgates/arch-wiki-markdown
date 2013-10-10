GRUB
====

> Summary

Covers various aspects of the next generation of the GRand Unified
Bootloader (GRUB2).

> Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

> Related

BURG - BURG is a brand-new boot loader based on GRUB2. It can be built
on a wider range of OS, and has a highly configurable menu system which
works in both text and graphic mode.

GRUB Legacy - previous Version, now obsolete.

> Resources

GRUB EFI Examples

GNU GRUB - GNU Project

GRUB - not to be confused with GRUB Legacy - is the next generation of
the GRand Unified Bootloader. GRUB is derived from PUPA which was a
research project to develop the next generation of what is now GRUB
Legacy. GRUB has been rewritten from scratch to clean up everything and
provide modularity and portability [1].

In brief, the bootloader is the first software program that runs when a
computer starts. It is responsible for loading and transferring control
to the Linux kernel. The kernel, in turn, initializes the rest of the
operating system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preface                                                            |
|     -   1.1 Notes for current GRUB Legacy users                          |
|         -   1.1.1 Backup Important Data                                  |
|                                                                          |
|     -   1.2 Preliminary Requirements                                     |
|         -   1.2.1 BIOS systems                                           |
|             -   1.2.1.1 GUID Partition Table (GPT) specific instructions |
|             -   1.2.1.2 Master Boot Record (MBR) specific instructions   |
|                                                                          |
|         -   1.2.2 UEFI systems                                           |
|             -   1.2.2.1 Create and Mount the UEFI System Partition       |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 BIOS systems                                                 |
|         -   2.1.1 Install boot files                                     |
|             -   2.1.1.1 Install to GPT BIOS Boot Partition               |
|             -   2.1.1.2 Install to 440-byte MBR boot code region         |
|             -   2.1.1.3 Install to Partition or Partitionless Disk       |
|             -   2.1.1.4 Generate core.img alone                          |
|                                                                          |
|         -   2.1.2 Generate config file                                   |
|         -   2.1.3 Multiboot                                              |
|             -   2.1.3.1 Microsoft Windows installed in BIOS-MBR mode     |
|                                                                          |
|     -   2.2 UEFI systems                                                 |
|         -   2.2.1 Install boot files                                     |
|             -   2.2.1.1 Install to UEFI System Partition                 |
|                                                                          |
|         -   2.2.2 Generate config file                                   |
|         -   2.2.3 Create GRUB entry in the Firmware Boot Manager         |
|         -   2.2.4 Create GRUB Standalone UEFI Application                |
|         -   2.2.5 Multiboot                                              |
|             -   2.2.5.1 Microsoft Windows installed in UEFI-GPT mode     |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Automatically generating using grub-mkconfig                 |
|         -   3.1.1 Additional arguments                                   |
|                                                                          |
|     -   3.2 Manually creating grub.cfg                                   |
|     -   3.3 Dual-booting                                                 |
|         -   3.3.1 Using grub-mkconfig                                    |
|             -   3.3.1.1 With GNU/Linux                                   |
|             -   3.3.1.2 With FreeBSD                                     |
|             -   3.3.1.3 With Windows                                     |
|                                                                          |
|         -   3.3.2 With Windows via EasyBCD and NeoGRUB                   |
|                                                                          |
|     -   3.4 Visual Configuration                                         |
|         -   3.4.1 Setting the framebuffer resolution                     |
|         -   3.4.2 915resolution hack                                     |
|         -   3.4.3 Background image and bitmap fonts                      |
|         -   3.4.4 Theme                                                  |
|         -   3.4.5 Menu colors                                            |
|         -   3.4.6 Hidden menu                                            |
|         -   3.4.7 Disable framebuffer                                    |
|                                                                          |
|     -   3.5 Other Options                                                |
|         -   3.5.1 LVM                                                    |
|         -   3.5.2 RAID                                                   |
|         -   3.5.3 Persistent block device naming                         |
|         -   3.5.4 Using Labels                                           |
|         -   3.5.5 Recall previous entry                                  |
|         -   3.5.6 Security                                               |
|         -   3.5.7 Root Encryption                                        |
|         -   3.5.8 Boot non-default entry only once                       |
|                                                                          |
|     -   3.6 Booting an ISO Directly From GRUB                            |
|         -   3.6.1 Arch ISO                                               |
|         -   3.6.2 Ubuntu ISO                                             |
|         -   3.6.3 Other ISOs                                             |
|                                                                          |
| -   4 Using the command shell                                            |
|     -   4.1 Pager support                                                |
|                                                                          |
| -   5 GUI configuration tools                                            |
| -   6 parttool for hide/unhide                                           |
| -   7 Using the rescue console                                           |
| -   8 Combining the use of UUIDs and basic scripting                     |
| -   9 Troubleshooting                                                    |
|     -   9.1 Intel BIOS not booting GPT                                   |
|     -   9.2 Enable debug messages                                        |
|     -   9.3 Correct No Suitable Mode Found Error                         |
|     -   9.4 msdos-style error message                                    |
|     -   9.5 GRUB UEFI drops to shell                                     |
|     -   9.6 GRUB UEFI not loaded                                         |
|     -   9.7 Invalid signature                                            |
|     -   9.8 Boot freezes                                                 |
|     -   9.9 Restore GRUB Legacy                                          |
|                                                                          |
| -   10 References                                                        |
| -   11 External Links                                                    |
+--------------------------------------------------------------------------+

Preface
-------

-   The name GRUB officially refers to version 2 of the software, see
    [2]. If you are looking for the article on the legacy version, see
    GRUB Legacy.
-   GRUB supports Btrfs as root (without a separate /boot filesystem)
    compressed with either zlib or LZO.

> Notes for current GRUB Legacy users

-   Upgrade from GRUB Legacy to GRUB is the much same as fresh
    installing GRUB which is covered below.
-   There are differences in the commands of GRUB Legacy and GRUB.
    Familiarize yourself with GRUB commands before proceeding (e.g.
    "find" has been replaced with "search").
-   GRUB is now modular and no longer requires "stage 1.5". As a result,
    the bootloader itself is limited -- modules are loaded from the hard
    drive as needed to expand functionality (e.g. for LVM or RAID
    support).
-   Device naming has changed between GRUB Legacy and GRUB. Partitions
    are numbered from 1 instead of 0 while drives are still numbered
    from 0, and prefixed with partition-table type. For example,
    /dev/sda1 would be referred to as (hd0,msdos1) (for MBR) or
    (hd0,gpt1) (for GPT).

Backup Important Data

Although a GRUB installation should run smoothly, it is strongly
recommended to keep the GRUB Legacy files before upgrading to GRUB2.

    # mv /boot/grub /boot/grub-legacy

Backup the MBR which contains the boot code and partition table (Replace
/dev/sdX with your actual disk path)

    # dd if=/dev/sdX of=/path/to/backup/mbr_backup bs=512 count=1

Only 446 bytes of the MBR contain boot code, the next 64 contain the
partition table. If you do not want to overwrite your partition table
when restoring, it is strongly advised to backup only the MBR boot code:

    # dd if=/dev/sdX of=/path/to/backup/bootcode_backup bs=446 count=1

If unable to install GRUB2 correctly, see #Restore GRUB Legacy.

> Preliminary Requirements

BIOS systems

GUID Partition Table (GPT) specific instructions

GRUB in BIOS-GPT configuration requires a BIOS Boot Partition to embed
its core.img in the absence of post-MBR gap in GPT partitioned systems
(which is taken over by the GPT Primary Header and Primary Partition
table). This partition is used by GRUB only in BIOS-GPT setups. No such
partition type exists in case of MBR partitioning (at least not for
GRUB). This partition is also not required if the system is UEFI based,
as no embedding of bootsectors takes place in that case.

For a BIOS-GPT configuration, create a 1007 KiB partition at the
beginning of the disk using cgdisk or GNU Parted with no filesystem. The
size of 1007 KiB will allow for the following partition to be correctly
alligned at 1024 KiB. If needed, the partition can also be located
somewhere else on the disk, but it should be within the first 2 TiB
region. Set the partition type to 0xEF02 in gdisk, EF02 in cgdisk or
set <BOOT_PART_NUM> bios_grub on in GNU Parted.

Note:This partition should be created before grub-install or grub-setup
is run.

Note:gdisk will only allow you to create this partition on the position
which will waste the least amount of space (sector 34-2047) if you
create it last, after all the other partitions. This is because gdisk
will auto-align partitions to 2048-sector boundaries if possible.

Master Boot Record (MBR) specific instructions

Usually the post-MBR gap (after the 512 byte MBR region and before the
start of the 1st partition) in many MBR (or msdos disklabel) partitioned
systems is 31 KiB when DOS compatibility cylinder alignment issues are
satisfied in the partition table. However a post-MBR gap of about 1 to 2
MiB is recommended to provide sufficient room for embedding GRUB's
core.img (FS#24103). It is advisable to use a partitioner which supports
1 MiB partition alignment to obtain this space as well as satisfy other
non-512 byte sector issues (which are unrelated to embedding of
core.img).

MBR partitioning has better support than GPT partitioning in some
operating systems, such as older versions of Microsoft Windows (up to
Windows 7) and Haiku. If you dual boot such an operating system,
consider using MBR partitioning.

A MBR disk may be convertible to GPT if there is a small amount of extra
space available. See GUID Partition Table#Convert from MBR to GPT.

UEFI systems

Note:It is recommended to read and understand the UEFI, GPT and UEFI
Bootloaders pages.

Create and Mount the UEFI System Partition

Follow Unified Extensible Firmware Interface#EFI System Partition for
instructions on creating a UEFI System Partition. Then mount the UEFI
System Partition at /boot/efi. If you have mounted the UEFI System
Partition at some other mountpoint, replace /boot/efi in the below
instructions with that mountpoint:

    # mkdir -p /boot/efi
    # mount -t vfat <UEFI_SYSTEM_PARTITION> /boot/efi

Create a /boot/efi/EFI directory:

    # mkdir /boot/efi/EFI

Installation
------------

> BIOS systems

GRUB can be installed with the grub-bios package from the official
repositories. It will replace grub-legacy or grub, if it is installed.

Note:Simply installing the package won't update the
/boot/grub/i386-pc/core.img file and the GRUB modules in
/boot/grub/i386-pc. You need to update them manually using grub-install
as explained below.

Install boot files

There are 3 ways to install GRUB boot files in BIOS booting:

-   #Install to GPT BIOS Boot Partition (recommended with GPT)
-   #Install to 440-byte MBR boot code region (recommended with MBR)
-   #Install to Partition or Partitionless Disk (not recommended)
-   #Generate core.img alone (safest method, but requires another BIOS
    bootloader like GRUB Legacy or Syslinux to be installed to chainload
    /boot/grub/i386-pc/core.img)

Note:See
http://www.gnu.org/software/grub/manual/html_node/BIOS-installation.html
for additional documentation.

Install to GPT BIOS Boot Partition

GUID Partition Table disks do not have a reserved "boot track".
Therefore you must create a BIOS Boot Partition (0xEF02) to hold the
GRUB core image.

Using GNU Parted, you can set this using a command such as the
following:

    # parted /dev/disk set <partition-number> bios_grub on

If you are using gdisk, set the partition type to 0xEF02. With
partitioning programs that require setting the GUID directly, it should
be ‘21686148-6449-6e6f-744e656564454649’ (stored on disk as
"!haHdInotNeedEFI" if interpreted as ASCII).

Warning:Be very careful which partition you select when marking it as a
BIOS Boot Partition. When GRUB finds a BIOS Boot Partition during
installation, it will automatically overwrite part of it. Make sure that
the partition does not contain any other data.

To setup grub-bios on a GPT disk, populate the /boot/grub directory,
generate the /boot/grub/i386-pc/core.img file, and embed it in the BIOS
Boot Partition, run:

    # modprobe dm-mod
    # grub-install --target=i386-pc --recheck --debug /dev/sda
    # mkdir -p /boot/grub/locale
    # cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

where /dev/sda is the destination of the installation.

Install to 440-byte MBR boot code region

To setup grub-bios in the 440-byte Master Boot Record boot code region,
populate the /boot/grub directory, generate the
/boot/grub/i386-pc/core.img file, embed it in the 31 KiB (minimum size -
varies depending on partition alignment) post-MBR gap, and generate the
configuration file, run:

    # modprobe dm-mod
    # grub-install --recheck /dev/sda
    # grub-mkconfig -o /boot/grub/grub.cfg

where /dev/sda is the destination of the installation (in this case the
MBR of the first SATA disk). If you use LVM for your /boot, you can
install GRUB on multiple physical disks.

Warning:Make sure to check the /boot directory if you use the latter.
Sometimes the boot-directory parameter creates another /boot folder
inside of /boot. A wrong install would look like: /boot/boot/grub/.

Install to Partition or Partitionless Disk

Note:grub-bios does not encourage installation to a partition boot
sector or a partitionless disk like GRUB Legacy or Syslinux does. This
kind of setup is prone to breakage, especially during updates, and is
not supported by Arch devs.

To set up grub-bios to a partition boot sector, to a partitionless disk
(also called superfloppy) or to a floppy disk, run (using for example
/dev/sdaX as the /boot partition):

    # modprobe dm-mod 
    # grub-install --target=i386-pc --recheck --debug --force /dev/sdaX
    # chattr -i /boot/grub/i386-pc/core.img
    # mkdir -p /boot/grub/locale
    # cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    # chattr +i /boot/grub/i386-pc/core.img

You need to use the --force option to allow usage of blocklists and
should not use --grub-setup=/bin/true (which is similar to simply
generating core.img).

grub-install will give out warnings like which should give you the idea
of what might go wrong with this approach:

    /sbin/grub-setup: warn: Attempting to install GRUB to a partitionless disk or to a partition. This is a BAD idea.
    /sbin/grub-setup: warn: Embedding is not possible. GRUB can only be installed in this setup by using blocklists. 
                            However, blocklists are UNRELIABLE and their use is discouraged.

Without --force you may get the below error and grub-setup will not
setup its boot code in the partition boot sector:

    /sbin/grub-setup: error: will not proceed with blocklists

With --force you should get:

    Installation finished. No error reported.

The reason why grub-setup does not by default allow this is because in
case of partition or a partitionless disk is that grub-bios relies on
embedded blocklists in the partition bootsector to locate the
/boot/grub/i386-pc/core.img file and the prefix dir /boot/grub. The
sector locations of core.img may change whenever the filesystem in the
partition is being altered (files copied, deleted etc.). For more info
see https://bugzilla.redhat.com/show_bug.cgi?id=728742 and
https://bugzilla.redhat.com/show_bug.cgi?id=730915.

The workaround for this is to set the immutable flag on
/boot/grub/i386-pc/core.img (using chattr command as mentioned above) so
that the sector locations of the core.img file in the disk is not
altered. The immutable flag on /boot/grub/i386-pc/core.img needs to be
set only if grub-bios is installed to a partition boot sector or a
partitionless disk, not in case of installation to MBR or simple
generation of core.img without embedding any bootsector (mentioned
above).

Generate core.img alone

To populate the /boot/grub directory and generate a
/boot/grub/i386-pc/core.img file without embedding any grub-bios
bootsector code in the MBR, post-MBR region, or the partition
bootsector, add --grub-setup=/bin/true to grub-install:

    # modprobe dm-mod
    # grub-install --target=i386-pc --grub-setup=/bin/true --recheck --debug /dev/sda
    # mkdir -p /boot/grub/locale
    # cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

You can then chainload GRUB's core.img from GRUB Legacy or syslinux as a
Linux kernel or a multiboot kernel.

Generate config file

Finally, generate a configuration for GRUB (this is explained in greater
detail in the Configuration section):

    # grub-mkconfig -o /boot/grub/grub.cfg

Note:The file path is /boot/grub/grub.cfg, NOT
/boot/grub/i386-pc/grub.cfg.

If GRUB complains about "no suitable mode found" while booting, go to
#Correct No Suitable Mode Found Error.

If grub-mkconfig fails, convert your /boot/grub/menu.lst file to
/boot/grub/grub.cfg using:

    # grub-menulst2cfg /boot/grub/menu.lst /boot/grub/grub.cfg

For example:

    /boot/grub/menu.lst

    default=0
    timeout=5

    title  Arch Linux Stock Kernel
    root   (hd0,0)
    kernel /vmlinuz-linux root=/dev/sda2 ro
    initrd /initramfs-linux.img

    title  Arch Linux Stock Kernel Fallback
    root   (hd0,0)
    kernel /vmlinuz-linux root=/dev/sda2 ro
    initrd /initramfs-linux-fallback.img

    /boot/grub/grub.cfg

    set default='0'; if [ x"$default" = xsaved ]; then load_env; set default="$saved_entry"; fi
    set timeout=5

    menuentry 'Arch Linux Stock Kernel' {
      set root='(hd0,1)'; set legacy_hdbias='0'
      legacy_kernel   '/vmlinuz-linux' '/vmlinuz-linux' 'root=/dev/sda2' 'ro'
      legacy_initrd '/initramfs-linux.img' '/initramfs-linux.img'
      
    }

    menuentry 'Arch Linux Stock Kernel Fallback' {
      set root='(hd0,1)'; set legacy_hdbias='0'
      legacy_kernel   '/vmlinuz-linux' '/vmlinuz-linux' 'root=/dev/sda2' 'ro'
      legacy_initrd '/initramfs-linux-fallback.img' '/initramfs-linux-fallback.img'
    }

If you forgot to create a GRUB /boot/grub/grub.cfg config file and
simply rebooted into GRUB Command Shell, type:

    sh:grub> insmod legacycfg
    sh:grub> legacy_configfile ${prefix}/menu.lst

Boot into Arch and re-create the proper GRUB /boot/grub/grub.cfg config
file.

Note:This option works only in BIOS systems, not in UEFI systems.

Multiboot

Microsoft Windows installed in BIOS-MBR mode

Note:GRUB supports booting bootmgr directly and chainload of partition
boot sector is no longer required to boot Windows in a BIOS-MBR setup.

Warning:Take note that it is the system partition that has bootmgr, not
your "real" Windows partition (usually C:). When showing all UUIDs with
blkid, the system partition is the one with LABEL="SYSTEM RESERVED" and
is only about 100 MB in size (much like the boot partition for Arch).
See Wikipedia:System partition and boot partition for more info.

Find the UUID of the NTFS filesystem of the Windows's SYSTEM PARTITION
where the bootmgr and its files reside. For example, if Windows bootmgr
exists at /media/SYSTEM_RESERVED/bootmgr:

For Windows Vista/7/8:

    # grub-probe --target=fs_uuid /media/SYSTEM_RESERVED/bootmgr
    69B235F6749E84CE

    # grub-probe --target=hints_string /media/SYSTEM_RESERVED/bootmgr
    --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1

Note:For Windows XP, replace bootmgr with ntldr in the above commands.

Then, add the below code to /etc/grub.d/40_custom or
/boot/grub/custom.cfg and regenerate grub.cfg with grub-mkconfig as
explained above to boot Windows (XP, Vista, 7 or 8) installed in
BIOS-MBR mode:

For Windows Vista/7/8:

    menuentry "Microsoft Windows Vista/7/8 BIOS-MBR" {
        insmod part_msdos
        insmod ntfs
        insmod search_fs_uuid
        insmod ntldr     
        search --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 69B235F6749E84CE
        ntldr /bootmgr
    }

For Windows XP:

    menuentry "Microsoft Windows XP" {
        insmod part_msdos
        insmod ntfs
        insmod search_fs_uuid
        insmod ntldr     
        search --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 69B235F6749E84CE
        ntldr /ntldr
    }

/etc/grub.d/40_custom can be used as a template to create
/etc/grub.d/nn_custom. Where nn defines the precendence, indicating the
order the script is executed. The order scripts are executed determine
the placement in the grub boot menu.

Note:nn should be greater than 06 to ensure necessary scripts are
executed first.

> UEFI systems

Note:It is well know that different motherboard manufactures implement
UEFI differently. Users experiencing problems getting Grub/EFI to work
properly are encouraged to share detailed steps for hardware-specific
cases where UEFI booting does not work as described below. In an effort
to keep the parent GRUB article neat and tidy, see the GRUB EFI Examples
page for these special cases.

First detect which UEFI firmware arch you have (either x86_64 or i386).
Depending on the result, install the appropriate package:

-   For 64-bit aka x86_64 UEFI firmware, install grub-efi-x86_64
-   For 32-bit aka i386 UEFI firmware, install grub-efi-i386

Note:Simply installing the package will not update the core.efi file and
the GRUB modules in the UEFI System Partition. You need to do this
manually using grub-install as explained below.

Install boot files

Install to UEFI System Partition

Note:The below commands assume you are using grub-efi-x86_64 (for
grub-efi-i386 replace x86_64 with i386 in the below commands).

Note:To do this, you need to boot using UEFI and not the BIOS. If you
booted by just copying the ISO file to the USB drive, you will need to
follow this guide or grub-install will show errors.

The UEFI system partition will need to be mounted at /boot/efi/ for the
GRUB install script to detect it:

    # mkdir -p /boot/efi
    # mount -t vfat /dev/sdXY /boot/efi

Install GRUB UEFI application to /boot/efi/EFI/arch_grub and its modules
to /boot/grub/x86_64-efi (recommended) using:

    # modprobe dm-mod
    # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck --debug
    # mkdir -p /boot/grub/locale
    # cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

Note:Without --target or --directory option, grub-install cannot
determine for which firmware GRUB is being installed. In such cases
grub-install will show
source_dir doesn't exist. Please specify --target or --directory
message.

If you want to install GRUB modules and grub.cfg at the directory
/boot/efi/EFI/grub and the grubx64.efi application at
/boot/efi/EFI/arch_grub (ie. all the GRUB UEFI files inside the UEFISYS
partition itself) use:

    # modprobe dm-mod 
    # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --boot-directory=/boot/efi/EFI --recheck --debug
    # mkdir -p /boot/efi/EFI/grub/locale
    # cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/efi/EFI/grub/locale/en.mo

The --efi-directory option mentions the mountpoint of UEFI SYSTEM
PARTITION , --bootloader-id mentions the name of the directory used to
store the grubx64.efi file and --boot-directory mentions the directory
wherein the actual modules will be installed (and into which grub.cfg
should be created).

The actual paths are:

    <efi-directory>/<EFI or efi>/<bootloader-id>/grubx64.efi

    <boot-directory>/grub/x86_64-efi/<all modules, grub.efi, core.efi, grub.cfg>

Note:the --bootloader-id option does not change <boot-directory>/grub,
i.e. you cannot install the modules to <boot-directory>/<bootloader-id>,
the path is hard-coded to be <boot-directory>/grub.

In
--efi-directory=/boot/efi --boot-directory=/boot/efi/EFI --bootloader-id=grub:

    <efi-directory>/<EFI or efi>/<bootloader-id> == <boot-directory>/grub == /boot/efi/EFI/grub

In
--efi-directory=/boot/efi --boot-directory=/boot/efi/EFI --bootloader-id=arch_grub:

    <efi-directory>/<EFI or efi>/<bootloader-id> == /boot/efi/EFI/arch_grub
    <boot-directory>/grub == /boot/efi/EFI/grub

In
--efi-directory=/boot/efi --boot-directory=/boot --bootloader-id=arch_grub:

    <efi-directory>/<EFI or efi>/<bootloader-id> == /boot/efi/EFI/arch_grub
    <boot-directory>/grub == /boot/grub

In
--efi-directory=/boot/efi --boot-directory=/boot --bootloader-id=grub:

    <efi-directory>/<EFI or efi>/<bootloader-id> == /boot/efi/EFI/grub
    <boot-directory>/grub == /boot/grub

The <efi-directory>/<EFI or efi>/<bootloader-id>/grubx64.efi is an exact
copy of <boot-directory>/grub/x86_64-efi/core.efi.

Note:In GRUB 2.00, the grub-install option --efi-directory replaces
--root-directory and the latter is deprecated.

Note:The options --efi-directory and --bootloader-id are specific to
GRUB UEFI.

In all the cases the UEFI SYSTEM PARTITION should be mounted for
grub-install to install grubx64.efi in it, which will be launched by the
firmware (using the efibootmgr created boot entry in non-Mac systems).

If you notice carefully, there is no <device_path> option (Eg: /dev/sda)
at the end of the grub-install command unlike the case of setting up
GRUB for BIOS systems. Any <device_path> provided will be ignored by the
install script as UEFI bootloaders do not use MBR or Partition boot
sectors at all.

You may now be able to UEFI boot your system by creating a grub.cfg file
by following #Generate UEFI Config file and #Create GRUB entry in the
Firmware Boot Manager.

Generate config file

Finally, generate a configuration for GRUB (this is explained in greater
detail in the Configuration section):

    # grub-mkconfig -o <boot-directory>/grub/grub.cfg

Note:The file path is <boot-directory>/grub/grub.cfg, NOT
<boot-directory>/grub/x86_64-efi/grub.cfg.

If you used --boot-directory=/boot:

    # grub-mkconfig -o /boot/grub/grub.cfg

If you used --boot-directory=/boot/efi/EFI:

    # grub-mkconfig -o /boot/efi/EFI/grub/grub.cfg

This is independent of the value of --bootloader-id option.

If GRUB complains about "no suitable mode found" while booting, try
#Correct No Suitable Mode Found Error.

Create GRUB entry in the Firmware Boot Manager

grub-install automatically tries to create a menu entry in the boot
manager. If it doesn't, then see Beginners' Guide#GRUB for instructions
to use efibootmgr to create a menu entry. However, the problem is likely
to be that you haven't booted your CD/USB in UEFI mode, as in Unified
Extensible Firmware Interface#Create UEFI bootable USB from ISO.

Create GRUB Standalone UEFI Application

It is possible to create a grubx64_standalone.efi application which has
all the modules embeddded in a memdisk within the UEFI application, thus
removing the need for having a separate directory populated with all the
GRUB UEFI modules and other related files. This is done using the
grub-mkstandalone command which is included in grub-common.

The easiest way to do this would be with the install command already
mentioned before, but specifying the modules to include. For example:

    # grub-mkstandalone --directory="/usr/lib/grub/x86_64-efi/" --format="x86_64-efi" --compression="xz" \
    --output="/boot/efi/EFI/arch_grub/grubx64_standalone.efi" <any extra files you want to include>

The grubx64_standalone.efi file expects grub.cfg to be within its
$prefix which is (memdisk)/boot/grub. The memdisk is embedded within the
efi app. The grub-mkstandlone script allow passing files to be included
in the memdisk image to be as the arguments to the script (in <any extra
files you want to include>).

If you have the grub.cfg at /home/user/Desktop/grub.cfg, then create a
temporary /home/user/Desktop/boot/grub/ directory, copy the
/home/user/Desktop/grub.cfg to /home/user/Desktop/boot/grub/grub.cfg, cd
into /home/user/Desktop/boot/grub/ and run:

    # grub-mkstandalone --directory="/usr/lib/grub/x86_64-efi/" --format="x86_64-efi" --compression="xz" \
    --output="/boot/efi/EFI/arch_grub/grubx64_standalone.efi" "boot/grub/grub.cfg"

The reason to cd into /home/user/Desktop/boot/grub/ and to pass the file
path as boot/grub/grub.cfg (notice the lack of a leading slash - boot/
vs /boot/ ) is because dir1/dir2/file is included as
(memdisk)/dir1/dir2/file by the grub-mkstandalone script.

If you pass /home/user/Desktop/grub.cfg the file will be included as
(memdisk)/home/user/Desktop/grub.cfg. If you pass
/home/user/Desktop/boot/grub/grub.cfg the file will be included as
(memdisk)/home/user/Desktop/boot/grub/grub.cfg. That is the reason for
cd'ing into /home/user/Desktop/boot/grub/ and passing
boot/grub/grub.cfg, to include the file as (memdisk)/boot/grub/grub.cfg,
which is what grub.efi expects the file to be.

You need to create an UEFI Boot Manager entry for
/boot/efi/EFI/arch_grub/grubx64_standalone.efi using efibootmgr. Follow
#Create GRUB entry in the Firmware Boot Manager.

Multiboot

Microsoft Windows installed in UEFI-GPT mode

Find the UUID of the FAT32 filesystem in the UEFI SYSTEM PARTITION where
the Windows UEFI Bootloader files reside. For example, if Windows
bootmgfw.efi exists at /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi (ignore
the upper-lower case differences since that is immaterial in FAT
filesystem):

    # grub-probe --target=fs_uuid /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
    1ce5-7f28

    # grub-probe --target=hints_string /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
    --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1 --hint-baremetal=ahci0,gpt1

Then, add this code to /etc/grub.d/40_custom to chainload Windows x86_64
(Vista SP1+, 7 or 8) installed in UEFI-GPT mode:

    menuentry "Microsoft Windows Vista/7/8 x86_64 UEFI-GPT" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1 --hint-baremetal=ahci0,gpt1 1ce5-7f28
        chainloader /efi/Microsoft/Boot/bootmgfw.efi
    }

Afterwards remake /boot/grub/grub.cfg

    # grub-mkconfig -o /boot/grub/grub.cfg

Configuration
-------------

You can also choose to automatically generate or manually edit grub.cfg.

Note:For EFI systems, if GRUB was installed with the --boot-directory
option set, the grub.cfg file must be placed in the same directory as
grubx64.efi. Otherwise, the grub.cfg file goes in /boot/grub/, just like
in GRUB BIOS.

Note:Here is a quite complete description of how to configure GRUB:
http://members.iinet.net/~herman546/p20/GRUB2%20Configuration%20File%20Commands.html

> Automatically generating using grub-mkconfig

The GRUB menu.lst equivalent configuration files are /etc/default/grub
and /etc/grub.d/*. grub-mkconfig uses these files to generate grub.cfg.
By default the script outputs to stdout. To generate a grub.cfg file run
the command:

    # grub-mkconfig -o /boot/grub/grub.cfg

/etc/grub.d/10_linux is set to automatically add menu items for Arch
linux that work out of the box, to any generated configuration. Other
operating systems may need to be added manually to /etc/grub.d/40_custom
or /boot/grub/custom.cfg

Additional arguments

To pass custom additional arguments to the Linux image, you can set the
GRUB_CMDLINE_LINUX variable in /etc/default/grub.

For example, use GRUB_CMDLINE_LINUX="resume=/dev/sdaX" where sdaX is
your swap partition to enable resume after hibernation.

You can also use
GRUB_CMDLINE_LINUX="resume=/dev/disk/by-uuid/${swap_uuid}", where
${swap_uuid}  is the UUID of your swap partition.

Multiple entries are separated by spaces within the double quotes. So,
for users who want both resume and systemd it would look like this:
GRUB_CMDLINE_LINUX="resume=/dev/sdaX init=/usr/lib/systemd/systemd"

See Kernel parameters for more info.

> Manually creating grub.cfg

Warning:Editing this file is strongly not recommended. The file is
generated by the grub-mkconfig command, and it is best to edit your
/etc/default/grub or one of the scripts in the /etc/grub.d folder.

A basic GRUB config file uses the following options

-   (hdX,Y) is the partition Y on disk X, partition numbers starting at
    1, disk numbers starting at 0
-   set default=N is the default boot entry that is chosen after timeout
    for user action
-   set timeout=M is the time M to wait in seconds for a user selection
    before default is booted
-   menuentry "title" {entry options} is a boot entry titled title
-   set root=(hdX,Y) sets the boot partition, where the kernel and GRUB
    modules are stored (boot need not be a separate partition, and may
    simply be a directory under the "root" partition (/)

An example configuration:

    /boot/grub/grub.cfg

    # Config file for GRUB - The GNU GRand Unified Bootloader
    # /boot/grub/grub.cfg

    # DEVICE NAME CONVERSIONS
    #
    #  Linux           Grub
    # -------------------------
    #  /dev/fd0        (fd0)
    #  /dev/sda        (hd0)
    #  /dev/sdb2       (hd1,2)
    #  /dev/sda3       (hd0,3)
    #

    # Timeout for menu
    set timeout=5

    # Set default boot entry as Entry 0
    set default=0

    # (0) Arch Linux
    menuentry "Arch Linux" {
        set root=(hd0,1)
        linux /vmlinuz-linux root=/dev/sda3 ro
        initrd /initramfs-linux.img
    }

    ## (1) Windows
    #menuentry "Windows" {
    #set root=(hd0,3)
    #chainloader +1
    #}

> Dual-booting

Note:If you want GRUB to automatically search for other systems, you may
wish to install os-prober.

Using grub-mkconfig

The best way to add other entries is editing the /etc/grub.d/40_custom
or /boot/grub/custom.cfg . The entries in this file will be
automatically added when running grub-mkconfig. After adding the new
lines, run:

    # grub-mkconfig -o /boot/grub/grub.cfg 

to generate an updated grub.cfg.

With GNU/Linux

Assuming that the other distro is on partition sda2:

    menuentry "Other Linux" {
    set root=(hd0,2)
    linux /boot/vmlinuz (add other options here as required)
    initrd /boot/initrd.img (if the other kernel uses/needs one)
    }

With FreeBSD

Requires that FreeBSD is installed on a single partition with UFS.
Assuming it is installed on sda4:

    menuentry "FreeBSD" {
    set root=(hd0,4)
    chainloader +1
    }

With Windows

This assumes that your Windows partition is sda3. Remember you need to
point set root and chainloader to the system reserve partition that
windows made when it installed, not the actual partition windows is on.
This example works if your system reserve partition is sda3.

    # (2) Windows XP
    menuentry "Windows XP" {
        set root=(hd0,3)
        chainloader (hd0,3)+1
    }

If the Windows bootloader is on an entirely different hard drive than
GRUB, it may be necessary to trick Windows into believing that it is the
first hard drive. This was possible with drivemap. Assuming GRUB is on
hd0 and Windows is on hd2, you need to add the following after set root:

    drivemap -s hd0 hd2

With Windows via EasyBCD and NeoGRUB

Since EasyBCD's NeoGRUB currently does not understand the GRUB menu
format, chainload to it by replacing the contents of your
C:\NST\menu.lst file with lines similar to the following:

    default 0
    timeout 1

    title       Chainload into GRUB v2
    root        (hd0,7)
    kernel      /boot/grub/i386-pc/core.img

> Visual Configuration

In GRUB it is possible, by default, to change the look of the menu. Make
sure to initialize, if not done already, GRUB graphical terminal,
gfxterm, with proper video mode, gfxmode, in GRUB. This can be seen in
the section #Correct No Suitable Mode Found Error. This video mode is
passed by GRUB to the linux kernel via 'gfxpayload' so any visual
configurations need this mode in order to be in effect.

Setting the framebuffer resolution

GRUB can set the framebuffer for both GRUB itself and the kernel. The
old vga= way is deprecated. The preferred method is editing
/etc/default/grub as the following sample:

    GRUB_GFXMODE=1024x768x32
    GRUB_GFXPAYLOAD_LINUX=keep

To generate the changes, run:

    # grub-mkconfig -o /boot/grub/grub.cfg

The gfxpayload property will make sure the kernel keeps the resolution.

Note:If this example does not work for you try to replace
gfxmode="1024x768x32" by vbemode="0x105". Remember to replace the
specified resolution with one suitable for your screen.

Note:To show all the modes you can use # hwinfo --framebuffer (hwinfo is
available in [community]), while at GRUB prompt you can use the vbeinfo
command.

If this method does not work for you, the deprecated vga= method will
still work. Just add it next to the "GRUB_CMDLINE_LINUX_DEFAULT=" line
in /etc/default/grub for eg:
"GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vga=792" will give you a
1024x768 resolution.

You can choose one of these resolutions: 640×480, 800×600, 1024×768,
1280×1024, 1600×1200, 1920×1200

915resolution hack

Some times for Intel graphic adapters neither # hwinfo --framebuffer nor
vbeinfo will show you the desired resolution. In this case you can use
915resolution hack. This hack will temporarily modify video BIOS and add
needed resolution. See 915resolution's home page

In the following I will proceed with the example for my system. Please
adjust the recipe for your needs. First you need to find a video mode
which will be modified later. For that, run 915resolution in GRUB
command shell:

    915resolution -l

The output will be something like:

    Intel 800/900 Series VBIOS Hack : version 0.5.3
    ...
    Mode 30 : 640x480, 8 bits/pixel
    ...

Next, our purpose is to overwrite mode 30. (You can choose what ever
mode you want.) In the file /etc/grub.d/00_header just before the
set gfxmode=${GRUB_GFXMODE} line insert:

    915resolution 30 1440 900

Here we are overwriting the mode 30 with 1440x900 resolution. Lastly we
need to set GRUB_GFXMODE as described earlier, regenerate GRUB
configuration file and reboot to test changes:

    # grub-mkconfig -o /boot/grub/grub.cfg
    # reboot

Background image and bitmap fonts

GRUB comes with support for background images and bitmap fonts in pf2
format. The unifont font is included in the grub-common package under
the filename unicode.pf2, or, as only ASCII characters under the name
ascii.pf2.

Image formats supported include tga, png and jpeg, providing the correct
modules are loaded. The maximum supported resolution depends on your
hardware.

Make sure you have set up the proper framebuffer resolution.

Edit /etc/default/grub like this:

    GRUB_BACKGROUND="/boot/grub/myimage"
    #GRUB_THEME="/path/to/gfxtheme"
    GRUB_FONT="/path/to/font.pf2"

Note:If you have installed GRUB on a separate partition,
/boot/grub/myimage becomes /grub/myimage.

To generate the changes and add the information into grub.cfg, run:

    grub-mkconfig -o /boot/grub/grub.cfg

If adding the splash image was successful, the user will see
"Found background image..." in the terminal as the command is executed.
If this phrase is not seen, the image information was probably not
incorporated into the grub.cfg file.

If the image is not displayed, check:

-   The path and the filename in /etc/default/grub are correct.
-   The image is of the proper size and format (tga, png, 8-bit jpg).
-   The image was saved in the RGB mode, and is not indexed.
-   The console mode is not enabled in /etc/default/grub.
-   The command grub-mkconfig must be executed to place the background
    image information into the /boot/grub/grub.cfg file.

Theme

Here is an example for configuring Starfield theme which was included in
GRUB package.

Edit /etc/default/grub

    GRUB_THEME="/usr/share/grub/themes/starfield/theme.txt"

Generate the changes:

    grub-mkconfig -o /boot/grub/grub.cfg

If configuring the theme was successful, you'll see
Found theme: /usr/share/grub/themes/starfield/theme.txt in the terminal.
Your splash image will usually not be displayed when using a theme.

Menu colors

You can set the menu colors in GRUB. The available colors for GRUB can
be found in the GRUB Manual. Here is an example:

Edit /etc/default/grub:

    GRUB_COLOR_NORMAL="light-blue/black"
    GRUB_COLOR_HIGHLIGHT="light-cyan/blue"

Generate the changes:

    grub-mkconfig -o /boot/grub/grub.cfg

Hidden menu

One of the unique features of GRUB is hiding/skipping the menu and
showing it by holding Esc when needed. You can also adjust whether you
want to see the timeout counter.

Edit /etc/default/grub as you wish. Here is an example where the
comments from the beginning of the two lines have been removed to enable
the feature, the timeout has been set to five seconds and to be shown to
the user:

    GRUB_HIDDEN_TIMEOUT=5
    GRUB_HIDDEN_TIMEOUT_QUIET=false

and run:

    # grub-mkconfig -o /boot/grub/grub.cfg

Disable framebuffer

Users who use NVIDIA proprietary driver might wish to disable GRUB's
framebuffer as it can cause problems with the binary driver.

To disable framebuffer, edit /etc/default/grub and uncomment the
following line:

    GRUB_TERMINAL_OUTPUT=console

and run:

    grub-mkconfig -o /boot/grub/grub.cfg

Another option if you want to keep the framebuffer in GRUB is to revert
to text mode just before starting the kernel. To do that modify the
variable in /etc/default/grub:

    GRUB_GFXPAYLOAD_LINUX=text

and rebuild the configuration as before.

> Other Options

LVM

If you use LVM for your /boot, add the following before menuentry lines:

    insmod lvm

and specify your root in the menuentry as:

    set root=lvm/lvm_group_name-lvm_logical_boot_partition_name

Example:

    # (0) Arch Linux
    menuentry "Arch Linux" {
    insmod lvm
    set root=lvm/VolumeGroup-lv_boot
    # you can only set following two lines
    linux /vmlinuz-linux root=/dev/mapper/VolumeGroup-root ro
    initrd /initramfs-linux.img
    }

RAID

GRUB provides convenient handling of RAID volumes. You need to add
insmod mdraid which allows you to address the volume natively. For
example, /dev/md0 becomes:

    set root=(md0)

whereas a partitioned RAID volume (e.g. /dev/md0p1) becomes:

    set root=(md0,1)

Persistent block device naming

One naming scheme for Persistent block device naming is the use of
globally unique UUIDs to detect partitions instead of the "old"
/dev/sd*. Advantages are covered up in the above linked article.

Persistent naming via filesystem UUIDs are used by default in GRUB.

Note:The /boot/grub.cfg file needs regeneration with the new UUID in
/etc/default/grub every time a relevant filesystem is resized or
recreated. Remember this when modifying partitions & filesystems with a
Live-CD.

Whether to use UUIDs is controlled by an option in /etc/default/grub:

    # GRUB_DISABLE_LINUX_UUID=true

Either way, do not forget to generate the changes:

    # grub-mkconfig -o /boot/grub/grub.cfg

Using Labels

It is possible to use labels, human-readable strings attached to
filesystems, by using the --label option to search. First of all, label
your existing partition:

    # tune2fs -L <LABEL> <PARTITION>

Then, add an entry using labels. An example of this:

    menuentry "Arch Linux, session texte" {
        search --label --set=root archroot
        linux /boot/vmlinuz-linux root=/dev/disk/by-label/archroot ro
        initrd /boot/initramfs-linux.img
    }

Recall previous entry

GRUB can remember the last entry you booted from and use this as the
default entry to boot from next time. This is useful if you have
multiple kernels (i.e., the current Arch one and the LTS kernel as a
fallback option) or operating systems. To do this, edit
/etc/default/grub and change the setting of GRUB_DEFAULT:

    GRUB_DEFAULT=saved

This ensures that GRUB will default to the saved entry. To enable saving
the selected entry, add the following line to /etc/default/grub:

    GRUB_SAVEDEFAULT=true

Note:Manually added menu items, eg Windows in /etc/grub.d/40_custom or
/boot/grub/custom.cfg , will need savedefault added. Remember to
regenerate your configuration file.

Security

If you want to secure GRUB so it is not possible for anyone to change
boot parameters or use the command line, you can add a user/password
combination to GRUB's configuration files. To do this, run the command
grub-mkpasswd-pbkdf2. Enter a password and confirm it. The output will
look like this:

    Your PBKDF2 is grub.pbkdf2.sha512.10000.C8ABD3E93C4DFC83138B0C7A3D719BC650E6234310DA069E6FDB0DD4156313DA3D0D9BFFC2846C21D5A2DDA515114CF6378F8A064C94198D0618E70D23717E82.509BFA8A4217EAD0B33C87432524C0B6B64B34FBAD22D3E6E6874D9B101996C5F98AB1746FE7C7199147ECF4ABD8661C222EEEDB7D14A843261FFF2C07B1269A

Then, add the following to /etc/grub.d/00_header:

    cat << EOF

    set superusers="username"
    password_pbkdf2 username <password>

    EOF

where <password> is the string generated by grub-mkpasswd_pbkdf2.

Regenerate your configuration file. Your GRUB command line, boot
parameters and all boot entries are now protected.

This can be relaxed and further customized with more users as described
in the "Security" part of the GRUB manual.

Root Encryption

To let GRUB automatically add the kernel parameters for root encryption,
add cryptdevice=/dev/yourdevice:label to GRUB_CMDLINE_LINUX in
/etc/default/grub.

Example with root mapped to /dev/mapper/root:

    GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:root"

Also, disable the usage of UUIDs for the rootfs:

    GRUB_DISABLE_LINUX_UUID=true

Regenerate the configuration.

Boot non-default entry only once

The command grub-reboot is very helpful to boot another entry than the
default only once. GRUB loads the entry passed in the first command line
argument, when the system is rebooted the next time. Most importantly
GRUB returns to loading the default entry for all future booting.
Changing the configuration file or selecting an entry in the GRUB menu
is not necessary.

> Booting an ISO Directly From GRUB

Edit /etc/grub.d/40_custom or /boot/grub/custom.cfg to add an entry for
the target ISO. When finished, update the GRUB menu as with the usual
grub-mkconfig -o /boot/grub/grub.cfg (as root).

Arch ISO

Note:The example assumes that the iso is in /archives on hd0,6. Users
must adjust the location and hdd/partition in ALL of the lines below to
match their systems. However, if booting the ISO from USB on a computer
which also has one internal HDD, then it needs to be hd0,Y with sdbY,
instead of sdaY.

Example using x86_64

    menuentry "Archlinux-2013.01.04-dual.iso" --class iso {
      set isofile="/archives/archlinux-2013.01.04-dual.iso"
      loopback loop (hd0,6)$isofile
      linux (loop)/arch/boot/x86_64/vmlinuz archisolabel=ARCH_201301 img_dev=/dev/sda6 img_loop=$isofile earlymodules=loop
      initrd (loop)/arch/boot/x86_64/archiso.img
    }

Example using i686

    menuentry "Archlinux-2013.01.04-dual.iso" --class iso {
      set isofile="/archives/archlinux-2013.01.04-dual.iso"
      loopback loop (hd0,6)$isofile
      linux (loop)/arch/boot/i686/vmlinuz archisolabel=ARCH_201301 img_dev=/dev/sda6 img_loop=$isofile earlymodules=loop
      initrd (loop)/arch/boot/i686/archiso.img
    }

Tip:For thumbdrives, use Persistent block device names for the "img_dev"
kernel parameter. Ex: img_dev=/dev/disk/by-label/CORSAIR

Ubuntu ISO

Note:The example assumes that the iso is in /archives on hd0,6. Users
must adjust the location and hdd/partition in the lines below to match
their systems.

    menuentry "ubuntu-13.04-desktop-amd64.iso" {
        set isofile="/archives/ubuntu-13.04-desktop-amd64.iso"
        loopback loop (hd0,6)$isofile
        linux (loop)/casper/vmlinuz.efi boot=casper iso-scan/filename=$isofile quiet noeject noprompt splash --
        initrd (loop)/casper/initrd.lz
    }

    menuentry "ubuntu-12.04-desktop-amd64.iso" {
        set isofile="/archives/ubuntu-12.04-desktop-amd64.iso"
        loopback loop (hd0,6)$isofile
        linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile quiet noeject noprompt splash --
        initrd (loop)/casper/initrd.lz
    }

Other ISOs

Other working configurations from link Source.

Using the command shell
-----------------------

Since the MBR is too small to store all GRUB modules, only the menu and
a few basic commands reside there. The majority of GRUB functionality
remains in modules in /boot/grub, which are inserted as needed. In error
conditions (e.g. if the partition layout changes) GRUB may fail to boot.
When this happens, a command shell may appear.

GRUB offers multiple shells/prompts. If there is a problem reading the
menu but the bootloader is able to find the disk, you will likely be
dropped to the "normal" shell:

    sh:grub>

If there is a more serious problem (e.g. GRUB cannot find required
files), you may instead be dropped to the "rescue" shell:

    grub rescue>

The rescue shell is a restricted subset of the normal shell, offering
much less functionality. If dumped to the rescue shell, first try
inserting the "normal" module, then starting the "normal" shell:

    grub rescue> set prefix=(hdX,Y)/boot/grub
    grub rescue> insmod (hdX,Y)/boot/grub/i386-pc/normal.mod
    rescue:grub> normal

> Pager support

GRUB supports pager for reading commands that provide long output (like
the help command). This works only in normal shell mode and not in
rescue mode. To enable pager, in GRUB command shell type:

    sh:grub> set pager=1

GUI configuration tools
-----------------------

Following package may be installed from AUR

-   grub-customizer (requires gettext gksu gtkmm hicolor-icon-theme
    openssl)
    Customize the bootloader (GRUB or BURG)
-   grub2-editor (requires kdelibs)
    A KDE4 control module for configuring the GRUB bootloader
-   kcm-grub2 (requires kdelibs python2-qt kdebindings-python)
    This Kcm module manages the most common settings of GRUB.
-   startupmanager (requires gnome-python imagemagick yelp python2
    xorg-xrandr)
    GUI app for changing the settings of GRUB Legacy, GRUB, Usplash and
    Splashy

parttool for hide/unhide
------------------------

If you have a Windows 9x paradigm with hidden C:\ disks GRUB can
hide/unhide it using parttool. For example, to boot the third C:\ disk
of three Windows 9x installations on the CLI enter the CLI and:

    parttool hd0,1 hidden+ boot-
    parttool hd0,2 hidden+ boot-
    parttool hd0,3 hidden- boot+
    set root=hd0,3
    chainloader +1
    boot

Using the rescue console
------------------------

See #Using the command shell first. If unable to activate the standard
shell, one possible solution is to boot using a live CD or some other
rescue disk to correct configuration errors and reinstall GRUB. However,
such a boot disk is not always available (nor necessary); the rescue
console is surprisingly robust.

The available commands in GRUB rescue include insmod, ls, set, and
unset. This example uses set and insmod. set modifies variables and
insmod inserts new modules to add functionality.

Before starting, the user must know the location of their /boot
partition (be it a separate partition, or a subdirectory under their
root):

    grub rescue> set prefix=(hdX,Y)/boot/grub

where X is the physical drive number and Y is the partition number.

To expand console capabilities, insert the linux module:

    grub rescue> insmod (hdX,Y)/boot/grub/linux.mod

Note:With a separate boot partition, omit /boot from the path, (i.e.
type set prefix=(hdX,Y)/grub and insmod (hdX,Y)/grub/linux.mod).

This introduces the linux and initrd commands, which should be familiar
(see #Configuration).

An example, booting Arch Linux:

    set root=(hd0,5)
    linux /boot/vmlinuz-linux root=/dev/sda5
    initrd /boot/initramfs-linux.img
    boot

With a separate boot partition, again change the lines accordingly:

    set root=(hd0,5)
    linux /vmlinuz-linux root=/dev/sda6
    initrd /initramfs-linux.img
    boot

After successfully booting the Arch Linux installation, users can
correct grub.cfg as needed and then reinstall GRUB.

To reinstall GRUB and fix the problem completely, changing /dev/sda if
needed. See #Bootloader installation for details.

Combining the use of UUIDs and basic scripting
----------------------------------------------

If you like the idea of using UUIDs to avoid unreliable BIOS mappings or
are struggling with GRUB's syntax, here is an example boot menu item
that uses UUIDs and a small script to direct GRUB to the proper disk
partitions for your system. All you need to do is replace the UUIDs in
the sample with the correct UUIDs for your system. The example applies
to a system with a boot and root partition. You will obviously need to
modify the GRUB configuration if you have additional partitions:

     menuentry "Arch Linux 64" {
         # Set the UUIDs for your boot and root partition respectively
         set the_boot_uuid=ece0448f-bb08-486d-9864-ac3271bd8d07
         set the_root_uuid=c55da16f-e2af-4603-9e0b-03f5f565ec4a
       
         # (Note: This may be the same as your boot partition)
       
         # Get the boot/root devices and set them in the root and grub_boot variables
         search --fs-uuid --set=root $the_root_uuid
         search --fs-uuid --set=grub_boot $the_boot_uuid
       
         # Check to see if boot and root are equal.
         # If they are, then append /boot to $grub_boot (Since $grub_boot is actually the root partition)
         if [ $the_boot_uuid == $the_root_uuid] ; then
             set grub_boot=$grub_boot/boot
         fi
       
         # $grub_boot now points to the correct location, so the following will properly find the kernel and initrd
         linux ($grub_boot)/vmlinuz-linux root=/dev/disk/by-uuid/$uuid_os_root ro
         initrd ($grub_boot)/initramfs-linux.img
     }

Troubleshooting
---------------

Any troubleshooting should be added here.

> Intel BIOS not booting GPT

Some Intel BIOS's require at least one bootable MBR partition to be
present at boot, causing GPT-partitioned boot setups to be unbootable.

This can be circumvented by using (for instance) fdisk to mark one of
the GPT partitions (preferably the 1007KiB partition you've created for
GRUB already) bootable in the MBR. This can be achieved, using fdisk, by
the following commands: Start fdisk against the disk you're installing,
for instance "fdisk /dev/sda", then press "a" and select the partition
you wish to mark as bootable (probably #1) by pressing the corresponding
number, finally press "w" to write the changes to the MBR.

Note that the bootable-marking must be done in fdisk or similar, not in
GParted or others, as they will not set the bootable flag in the MBR.

More information is available here

> Enable debug messages

Add:

    set pager=1
    set debug=all

to grub.cfg.

> Correct No Suitable Mode Found Error

If you get this error when booting any menuentry:

    error: no suitable mode found
    Booting however

Then you need to initialize GRUB graphical terminal (gfxterm) with
proper video mode (gfxmode) in GRUB. This video mode is passed by GRUB
to the linux kernel via 'gfxpayload'. In case of UEFI systems, if the
GRUB video mode is not initialized, no kernel boot messages will be
shown in the terminal (atleast until KMS kicks in).

Copy /usr/share/grub/unicode.pf2 to ${GRUB_PREFIX_DIR} (/boot/grub/ in
case of BIOS and UEFI systems). If GRUB UEFI was installed with
--boot-directory=/boot/efi/EFI set, then the directory is
/boot/efi/EFI/grub/:

    # cp /usr/share/grub/unicode.pf2 ${GRUB_PREFIX_DIR}

If /usr/share/grub/unicode.pf2 does not exist, install bdf-unifont,
create the unifont.pf2 file and then copy it to ${GRUB_PREFIX_DIR}:

    # grub-mkfont -o unicode.pf2 /usr/share/fonts/misc/unifont.bdf

Then, in the grub.cfg file, add the following lines to enable GRUB to
pass the video mode correctly to the kernel, without of which you will
only get a black screen (no output) but booting (actually) proceeds
successfully without any system hang.

BIOS systems:

    insmod vbe

UEFI systems:

    insmod efi_gop
    insmod efi_uga

After that add the following code (common to both BIOS and UEFI):

    insmod font

    if loadfont ${prefix}/fonts/unicode.pf2
    then
        insmod gfxterm
        set gfxmode=auto
        set gfxpayload=keep
        terminal_output gfxterm
    fi

As you can see for gfxterm (graphical terminal) to function properly,
unicode.pf2 font file should exist in ${GRUB_PREFIX_DIR}.

> msdos-style error message

    grub-setup: warn: This msdos-style partition label has no post-MBR gap; embedding won't be possible!
    grub-setup: warn: Embedding is not possible. GRUB can only be installed in this setup by using blocklists.
                However, blocklists are UNRELIABLE and its use is discouraged.
    grub-setup: error: If you really want blocklists, use --force.

This error may occur when you try installing GRUB in a VMware container.
Read more about it here. It happens when the first partition starts just
after the MBR (block 63), without the usual space of 1 MiB (2048 blocks)
before the first partition. Read #Master Boot Record (MBR) specific
instructions

> GRUB UEFI drops to shell

If GRUB loads but drops you into the rescue shell with no errors, it may
be because of a missing or misplaced grub.cfg. This will happen if GRUB
UEFI was installed with --boot-directory and grub.cfg is missing OR if
the partition number of the boot partition changed (which is hard-coded
into the grubx64.efi file).

> GRUB UEFI not loaded

In some cases the EFI may fail to load GRUB correctly. Provided
everything is set up correctly, the output of:

    efibootmgr -v

might look something like this:

    BootCurrent: 0000
    Timeout: 3 seconds
    BootOrder: 0000,0001,0002
    Boot0000* Grub	HD(1,800,32000,23532fbb-1bfa-4e46-851a-b494bfe9478c)File(\efi\grub\grub.efi)
    Boot0001* Shell	HD(1,800,32000,23532fbb-1bfa-4e46-851a-b494bfe9478c)File(\EfiShell.efi)
    Boot0002* Festplatte	BIOS(2,0,00)P0: SAMSUNG HD204UI

If everything works correctly, the EFI would now automatically load
GRUB.

If the screen only goes black for a second and the next boot option is
tried afterwards, according to this post, moving GRUB to the partition
root can help. The boot option has to be deleted and recreated
afterwards. The entry for GRUB should look like this then:

    Boot0000* Grub	HD(1,800,32000,23532fbb-1bfa-4e46-851a-b494bfe9478c)File(\grub.efi)

> Invalid signature

If trying to boot Windows results in an "invalid signature" error, e.g.
after reconfiguring partitions or adding additional hard drives,
(re)move GRUB's device configuration and let it reconfigure:

    # mv /boot/grub/device.map /boot/grub/device.map-old
    # grub-mkconfig -o /boot/grub/grub.cfg

grub-mkconfig should now mention all found boot options, including
Windows. If it works, remove /boot/grub/device.map-old.

> Boot freezes

If booting gets stuck without any error message after GRUB loading the
kernel and the initial ramdisk, try removing the add_efi_memmap kernel
parameter.

> Restore GRUB Legacy

-   Move GRUB2 files out of the way:

    # mv /boot/grub /boot/grub.nonfunctional

-   Copy GRUB Legacy back to /boot:

    # cp -af /boot/grub-legacy /boot/grub

-   Replace MBR and next 62 sectors of sda with backed up copy

Warning:This command also restores the partition table, so be careful of
overwriting a modified partition table with the old one. It will mess up
your system.

    # dd if=/path/to/backup/first-sectors of=/dev/sdX bs=512 count=1

A safer way is to restore only the MBR boot code use:

    # dd if=/path/to/backup/mbr-boot-code of=/dev/sdX bs=446 count=1

References
----------

1.  Official GRUB Manual -
    https://www.gnu.org/software/grub/manual/grub.html
2.  Ubuntu wiki page for GRUB - https://help.ubuntu.com/community/Grub2
3.  GRUB wiki page describing steps to compile for UEFI systems -
    https://help.ubuntu.com/community/UEFIBooting
4.  Wikipedia's page on BIOS Boot partition

External Links
--------------

1.  A Linux Bash Shell script to compile and install GRUB for BIOS from
    BZR Source
2.  A Linux Bash Shell script to compile and install GRUB for UEFI from
    BZR Source

Retrieved from
"https://wiki.archlinux.org/index.php?title=GRUB&oldid=255662"

Category:

-   Boot loaders
