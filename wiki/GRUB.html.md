GRUB
====

Related articles

-   GRUB Legacy
-   Arch Boot Process
-   Boot Loaders
-   Master Boot Record
-   GUID Partition Table
-   Unified Extensible Firmware Interface
-   GRUB EFI Examples

GRUB — not to be confused with GRUB Legacy — is the next generation of
the GRand Unified Bootloader. GRUB is derived from PUPA which was a
research project to develop the next generation of what is now GRUB
Legacy. GRUB has been rewritten from scratch to clean up everything and
provide modularity and portability [1].

In brief, the bootloader is the first software program that runs when a
computer starts. It is responsible for loading and transferring control
to the Linux kernel. The kernel, in turn, initializes the rest of the
operating system.

Contents
--------

-   1 Preface
    -   1.1 Notes for GRUB Legacy users
        -   1.1.1 Backup important data
    -   1.2 Preliminary requirements
        -   1.2.1 BIOS systems
            -   1.2.1.1 GUID Partition Table (GPT) specific instructions
            -   1.2.1.2 Master Boot Record (MBR) specific instructions
        -   1.2.2 UEFI systems
            -   1.2.2.1 Check if you have GPT and an ESP
            -   1.2.2.2 Create an ESP
-   2 Installation
    -   2.1 BIOS systems
        -   2.1.1 Install boot files
            -   2.1.1.1 Install to disk
            -   2.1.1.2 Install to partition or partitionless disk
            -   2.1.1.3 Generate core.img alone
    -   2.2 UEFI systems
        -   2.2.1 Install boot files
            -   2.2.1.1 Recommended method
            -   2.2.1.2 Alternative method
        -   2.2.2 Create a GRUB entry in the firmware boot manager
        -   2.2.3 GRUB Standalone
            -   2.2.3.1 GRUB Standalone - Technical Info
-   3 Generating main configuration file
    -   3.1 Converting GRUB Legacy's config file to the new format
-   4 Basic configuration
    -   4.1 Additional arguments
    -   4.2 Visual configuration
        -   4.2.1 Setting the framebuffer resolution
        -   4.2.2 915resolution hack
        -   4.2.3 Background image and bitmap fonts
        -   4.2.4 Theme
        -   4.2.5 Menu colors
        -   4.2.6 Hidden menu
        -   4.2.7 Disable framebuffer
    -   4.3 Persistent block device naming
    -   4.4 Recall previous entry
    -   4.5 Changing the default menu entry
    -   4.6 Root encryption
    -   4.7 Boot non-default entry only once
-   5 Advanced configuration
    -   5.1 Manually creating grub.cfg
    -   5.2 Dual-booting
        -   5.2.1 Automatically generating using /etc/grub.d/40_custom
            and grub-mkconfig
            -   5.2.1.1 GNU/Linux menu entry
            -   5.2.1.2 FreeBSD menu entry
            -   5.2.1.3 Windows XP menu entry
            -   5.2.1.4 Windows installed in UEFI-GPT Mode menu entry
            -   5.2.1.5 "Shutdown" menu entry
            -   5.2.1.6 "Restart" menu entry
            -   5.2.1.7 Windows installed in BIOS-MBR mode
        -   5.2.2 With Windows via EasyBCD and NeoGRUB
    -   5.3 Booting an ISO directly from GRUB
        -   5.3.1 Arch ISO
            -   5.3.1.1 x86_64
            -   5.3.1.2 i686
        -   5.3.2 Ubuntu ISO
        -   5.3.3 Other ISOs
    -   5.4 LVM
    -   5.5 RAID
    -   5.6 Using labels
    -   5.7 Password protection of GRUB menu
    -   5.8 Hide GRUB unless the Shift key is held down
    -   5.9 Combining the use of UUIDs and basic scripting
-   6 Using the command shell
    -   6.1 Pager support
    -   6.2 Using the command shell environment to boot operating
        systems
        -   6.2.1 Chainloading a partition
        -   6.2.2 Chainloading a disk/drive
        -   6.2.3 Normal loading
-   7 GUI configuration tools
-   8 parttool for hide/unhide
-   9 Using the rescue console
-   10 Troubleshooting
    -   10.1 Intel BIOS not booting GPT
        -   10.1.1 MBR
        -   10.1.2 EFI path
    -   10.2 Enable debug messages
    -   10.3 "No suitable mode found" error
    -   10.4 msdos-style error message
    -   10.5 GRUB UEFI drops to shell
    -   10.6 GRUB UEFI not loaded
    -   10.7 Invalid signature
    -   10.8 Boot freezes
    -   10.9 Restore GRUB Legacy
    -   10.10 Arch not found from other OS
    -   10.11 Redundant menu entries
-   11 See also

Preface
-------

-   The name GRUB officially refers to version 2 of the software, see
    [2]. If you are looking for the article on the legacy version, see
    GRUB Legacy.
-   GRUB supports Btrfs as root (without a separate /boot file system)
    compressed with either zlib or LZO
-   GRUB does not support F2fs as root so you will need a separate /boot
    with a supported file system.

> Notes for GRUB Legacy users

-   Upgrading from GRUB Legacy to GRUB is much the same as freshly
    installing GRUB. This topic is covered here.
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
-   GRUB is noticeably bigger than GRUB legacy (occupies ~13 MB in
    /boot). If you are booting from a separate /boot partition, and this
    partition is smaller than 32 MB, you will run into disk space
    issues, and pacman will refuse to install new kernels.

Backup important data

Although a GRUB installation should run smoothly, it is strongly
recommended to keep the GRUB Legacy files before upgrading to GRUB v2.

    # mv /boot/grub /boot/grub-legacy

Backup the MBR which contains the boot code and partition table (replace
/dev/sdX with your actual disk path):

    # dd if=/dev/sdX of=/path/to/backup/mbr_backup bs=512 count=1

Only 446 bytes of the MBR contain boot code, the next 64 contain the
partition table. If you do not want to overwrite your partition table
when restoring, it is strongly advised to backup only the MBR boot code:

    # dd if=/dev/sdX of=/path/to/backup/bootcode_backup bs=446 count=1

If unable to install GRUB2 correctly, see Restore GRUB Legacy.

> Preliminary requirements

BIOS systems

GUID Partition Table (GPT) specific instructions

GRUB in BIOS-GPT configuration requires a BIOS boot partition to embed
its core.img in the absence of post-MBR gap in GPT partitioned systems
(which is taken over by the GPT Primary Header and Primary Partition
table). This partition is used by GRUB only in BIOS-GPT setups. No such
partition type exists in case of MBR partitioning (at least not for
GRUB). This partition is also not required if the system is UEFI based,
as no embedding of boot sectors takes place in that case.

For a BIOS-GPT configuration, create a 1007 KiB partition at the
beginning of the disk using gdisk, cgdisk or GNU Parted with no file
system. The size of 1007 KiB, plus the size of the preceding GPT of 17
KiB, will allow for the following partition to be correctly aligned at
1024 KiB. If needed, the partition can also be located somewhere else on
the disk, but it should be within the first 2 TiB region. Set the
partition type to ef02 in (c)gdisk or set BOOT_PART_NUM bios_grub on in
GNU Parted.

The GPT partition also creates a protective MBR partition to stop
unsupported tools from modifying it. You may need to set a bootable flag
on this protective MBR e.g., using cfdisk, or some BIOSes/EFIs will
refuse to boot.

> Note:

-   You will probably need to explicitly set the grub-install target to
    i386-pc using --target=i386-pc. Otherwise grub-install sometimes
    guesses that your configuration is EFI-GPT.
-   This partition should be created before grub-install or grub-setup
    is run
-   gdisk will only allow you to create this partition on the position
    which will waste the least amount of space (sector 34-2047) if you
    create it last, after all the other partitions. This is because
    gdisk will auto-align partitions to 2048-sector boundaries if
    possible

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

UEFI systems

Note:It is recommended to read and understand the UEFI, GPT and UEFI
Bootloaders pages.

Check if you have GPT and an ESP

An EFI System Partition (ESP) is needed on every disc you want to boot
using EFI. GPT is not strictly necessary, but it is highly recommended
and is the only method currently supported in this article. If you are
installing Arch Linux on an EFI-capable computer with an already-working
operating system, like Windows 8 for example, it is very likely that you
already have an ESP. To check for GPT and for an ESP, use parted as root
to print the partition table of the disk you want to boot from. (We are
calling it /dev/sda.)

    # parted /dev/sda print

For GPT, you are looking for "Partition Table: GPT". For EFI, you are
looking for a small (512 MiB or less) partition with a vfat file system
and the boot flag enabled. On it, there should be a directory named
"EFI". If these criteria are met, this is your ESP. Make note of the
partition number. You will need to know which one it is, so you can
mount it later on while installing GRUB to it.

Create an ESP

If you do not have an ESP, you will need to create it. Follow UEFI#EFI
System Partition for instructions on creating an ESP.

Installation
------------

Note:If you are performing an initial installation from the Arch live
CD, make sure you have chrooted into the installed system before
installing grub. Using the CD's own grub installation scripts may result
in an invalid grub.cfg, or other problems that will prevent the system
from booting.

> BIOS systems

GRUB can be installed with the grub package from the official
repositories. It will replace grub-legacy , if it is installed.

Note:Simply installing the package will not update the
/boot/grub/i386-pc/core.img file and the GRUB modules in
/boot/grub/i386-pc. You need to update them manually using grub-install
as explained below.

Install boot files

There are 3 ways to install GRUB boot files in BIOS booting:

-   Install to disk (recommended)
-   Install to partition or partitionless disk (not recommended)
-   Generate core.img alone (safest method, but requires another BIOS
    bootloader like Syslinux to be installed to chainload
    /boot/grub/i386-pc/core.img)

Note:See
https://www.gnu.org/software/grub/manual/html_node/BIOS-installation.html
for additional documentation.

Install to disk

Note:The method is specific to installing GRUB to a partitioned (MBR or
GPT) disk, with GRUB files installed to /boot/grub and its first stage
code installed to the 440-byte MBR boot code region (not to be confused
with MBR partition table). For partitionless disk (super-floppy) please
refer to #Install to partition or partitionless disk

To set up GRUB in the 440-byte Master Boot Record boot code region,
populate the /boot/grub directory, generate the
/boot/grub/i386-pc/core.img file, and embed it in the 31 KiB (minimum
size - varies depending on partition alignment) post-MBR gap in case of
MBR partitioned disk (or BIOS Boot Partition in case of GPT partitioned
disk, denoted by bios_grub flag in parted and EF02 type code in gdisk),
run:

    # grub-install --target=i386-pc --recheck --debug /dev/sdx
    # grub-mkconfig -o /boot/grub/grub.cfg

  

Note: --target=i386-pc instructs grub-install to install for BIOS
systems only. It is recommended to always use this option to remove
ambiguity in grub-install.

If you use LVM for your /boot, you can install GRUB on multiple physical
disks.

Install to partition or partitionless disk

Note:GRUB does not encourage installation to a partition boot sector or
a partitionless disk like GRUB Legacy or Syslinux does. This kind of
setup is prone to breakage, especially during updates, and is not
supported by Arch devs.

To set up grub to a partition boot sector, to a partitionless disk (also
called superfloppy) or to a floppy disk, run (using for example
/dev/sdaX as the /boot partition):

    # chattr -i /boot/grub/i386-pc/core.img
    # grub-install --target=i386-pc --recheck --debug --force /dev/sdaX
    # chattr +i /boot/grub/i386-pc/core.img

> Note:

-   /dev/sdaX used for example only.
-   --target=i386-pc instructs grub-install to install for BIOS systems
    only. It is recommended to always use this option to remove
    ambiguity in grub-install.

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
case of partition or a partitionless disk is that GRUB relies on
embedded blocklists in the partition bootsector to locate the
/boot/grub/i386-pc/core.img file and the prefix directory /boot/grub.
The sector locations of core.img may change whenever the file system in
the partition is being altered (files copied, deleted etc.). For more
info, see https://bugzilla.redhat.com/show_bug.cgi?id=728742 and
https://bugzilla.redhat.com/show_bug.cgi?id=730915.

The workaround for this is to set the immutable flag on
/boot/grub/i386-pc/core.img (using chattr command as mentioned above) so
that the sector locations of the core.img file in the disk is not
altered. The immutable flag on /boot/grub/i386-pc/core.img needs to be
set only if GRUB is installed to a partition boot sector or a
partitionless disk, not in case of installation to MBR or simple
generation of core.img without embedding any bootsector (mentioned
above).

Unfortunately, the grub.cfg file that is created will not contain the
proper UUID in order to boot, even if it reports no errors. see
https://bbs.archlinux.org/viewtopic.php?pid=1294604#p1294604. In order
to fix this issue the following commands:

    # mount /dev/sdxY /mnt        #Your root partition.
    # mount /dev/sdxZ /mnt/boot   #Your boot partiton (if you have one).
    # arch-chroot /mnt
    # pacman -S linux
    # grub-mkconfig -o /boot/grub/grub.cfg

Generate core.img alone

To populate the /boot/grub directory and generate a
/boot/grub/i386-pc/core.img file without embedding any GRUB bootsector
code in the MBR, post-MBR region, or the partition bootsector, add
--grub-setup=/bin/true to grub-install:

    # grub-install --target=i386-pc --grub-setup=/bin/true --recheck --debug /dev/sda

> Note:

-   /dev/sda used for example only.
-   --target=i386-pc instructs grub-install to install for BIOS systems
    only. It is recommended to always use this option to remove
    ambiguity in grub-install.

You can then chainload GRUB's core.img from GRUB Legacy or syslinux as a
Linux kernel or as a multiboot kernel.

> UEFI systems

Note:It is well known that different motherboard manufactures implement
UEFI differently. Users experiencing problems getting GRUB or EFI to
work properly are encouraged to share detailed steps for
hardware-specific cases where UEFI booting does not work as described
below. In an effort to keep the parent GRUB article neat and tidy, see
the GRUB EFI Examples page for these special cases.

First install the grub, dosfstools, and efibootmgr packages, then follow
the instructions below. (The last two packages are required for EFI
support in grub.)

Note:Simply installing the package will not update the core.efi file and
the GRUB modules in the ESP. You need to do this manually using
grub-install as explained below.

Install boot files

Recommended method

> Note:

-   The below commands assume you are using installing GRUB for
    x86_64-efi (for IA32-efi replace x86_64-efi with i386-efi in the
    below commands)
-   To do this, you need to be booted using UEFI and not BIOS, or
    grub-install will show errors.

First, mount the ESP at your preferred mountpoint (usually /boot/efi,
hereafter referred to as $esp). On a first install, you will need to
mkdir /boot/efi, if that's where you want to mount it.

Now, install the GRUB UEFI application to $esp/EFI/grub and its modules
to /boot/grub/x86_64-efi:

    # grub-install --target=x86_64-efi --efi-directory=$esp --bootloader-id=grub --recheck --debug

> Note:

-   If you have a problem when running grub-install with sysfs or procfs
    and it says you have to "modprobe efivars", try
    Unified_Extensible_Firmware_Interface#Switch_to_efivarfs.
-   Without --target or --directory option, grub-install cannot
    determine for which firmware to install. In such cases grub-install
    will print
    source_dir does not exist. Please specify --target or --directory.
-   --efi-directory and --bootloader-id are specific to GRUB UEFI.
    --efi-directory specifies the mountpoint of the ESP. It replaces
    --root-directory, which is deprecated. --bootloader-id specifies the
    name of the directory used to store the grubx64.efi file.
-   If you notice carefully, there is no <device_path> option (Eg:
    /dev/sda) at the end of the grub-install command unlike the case of
    setting up GRUB for BIOS systems. Any <device_path> provided will be
    ignored by the install script, as UEFI bootloaders do not use MBR or
    Partition boot sectors at all.

GRUB is now installed.

Alternative method

If you want to keep all of the GRUB boot files inside the EFI System
Partition itself, add --boot-directory=$esp/EFI to the grub-install
command:

    # grub-install --target=x86_64-efi --efi-directory=$esp --bootloader-id=grub --boot-directory=$esp/EFI --recheck --debug

This puts the GRUB modules in $esp/EFI/grub. ('/grub' is hard coded onto
the end of this path.) Using this method, grub.cfg is kept on the EFI
System Partition as well, so make sure you point grub-mkconfig to the
right place in the configuration phase:

    # grub-mkconfig -o $esp/EFI/grub/grub.cfg

Configuration is otherwise the same.

Create a GRUB entry in the firmware boot manager

grub-install automatically tries to create a menu entry in the boot
manager. If it does not, then see Beginners' guide#GRUB for instructions
to use efibootmgr to create a menu entry. However, the problem is likely
to be that you have not booted your CD/USB in UEFI mode, as in
UEFI#Create UEFI bootable USB from ISO.

GRUB Standalone

Note:Use grub-git package for standalone GRUB EFI image as the grub
package does not contain various grub-mkstandalone specific fixes
(specifically ${cmdpath}  support, which is necessary).

It is possible to create a grubx64_standalone.efi application which has
all the modules embedded in a tar archive within the UEFI application,
thus removing the need for having a separate directory populated with
all of the GRUB UEFI modules and other related files. This is done using
the grub-mkstandalone command (included in grub) as follows:

    # echo 'configfile ${cmdpath}/grub.cfg' > /tmp/grub.cfg                                ## use single quotes, ${cmdpath} should be present as it is
    # grub-mkstandalone -d /usr/lib/grub/x86_64-efi/ -O x86_64-efi --modules="part_gpt part_msdos" --fonts="unicode" --locales="en@quot" --themes="" -o "$esp/EFI/grub/grubx64_standalone.efi"  "/boot/grub/grub.cfg=/tmp/grub.cfg" -v

Note:The option --modules="part_gpt part_msdos" (with the quotes) is
necessary for the ${cmdpath}  feature to work properly.

Then copy the GRUB config file to $esp/EFI/grub/grub.cfg and create a
UEFI Boot Manager entry for $esp/EFI/grub/grubx64_standalone.efi using
efibootmgr.

GRUB Standalone - Technical Info

The GRUB EFI file always expects its config file to be at
${prefix}/grub.cfg. However in the standalone GRUB EFI file, the
${prefix}  is located inside a tar archive and embedded inside the
standalone GRUB EFI file itself (inside the GRUB environment, it is
denoted by "(memdisk)", without quotes). This tar archive contains all
the files that would be stored normally at /boot/grub in case of a
normal GRUB EFI install.

Due to this embedding of /boot/grub contents inside the standalone image
itself, it does not rely on actual (external) /boot/grub for anything.
Thus in case of standalone GRUB EFI file ${prefix}==(memdisk)/boot/grub
and the standalone GRUB EFI file reads expects the config file to be at
${prefix}/grub.cfg==(memdisk)/boot/grub/grub.cfg.

Hence to make sure the standalone GRUB EFI file reads the external
grub.cfg located in the same directory as the EFI file (inside the GRUB
environment, it is denoted by ${cmdpath} ), we create a simple
/tmp/grub.cfg which instructs GRUB to use ${cmdpath}/grub.cfg as its
config (configfile ${cmdpath}/grub.cfg command in
(memdisk)/boot/grub/grub.cfg). We then instruct grub-mkstandalone to
copy this /tmp/grub.cfg file to ${prefix}/grub.cfg (which is actually
(memdisk)/boot/grub/grub.cfg) using the option
"/boot/grub/grub.cfg=/tmp/grub.cfg".

This way, the standalone GRUB EFI file and actual grub.cfg can be stored
in any directory inside the EFI System Partition (as long as they are in
the same directory), thus making them portable.

Generating main configuration file
----------------------------------

After the installation, the main configuration file grub.cfg needs to be
generated. The generation process can be influenced by a variety of
options in /etc/default/grub and scripts in /etc/grub.d/, this is
covered in the #Basic configuration and #Advanced configuration
sections.

Note:Remember that grub.cfg has to be re-generated after any change to
/etc/default/grub or /etc/grub.d/*.

Warning:Since package version 1:2.02.beta2-1 (2014-01-10) grub-mkconfig
generates weird configuration files. The generated grub.cfg contains
duplicated boot-entries which are sometimes missing the initramfs,
furthermore self-compiled kernels are hidden in a submenu. (FS#38455)

Use the grub-mkconfig tool to generate grub.cfg:

    # grub-mkconfig -o /boot/grub/grub.cfg

> Note:

-   The file path for BIOS systems is /boot/grub/grub.cfg, NOT
    /boot/grub/i386-pc/grub.cfg.
-   For EFI systems, if GRUB was installed with the
    --boot-directory=$esp/EFI option set, the grub.cfg file must be
    placed in the same directory as grubx64.efi. Otherwise, the grub.cfg
    file goes in /boot/grub/, just like in BIOS systems.
-   If you are trying to run grub-mkconfig in a chroot or systemd-nspawn
    container, you might notice that it does not work, complaining that
    grub-probe cannot get the "canonical path of /dev/sdaX". In this
    case, try using arch-chroot as described here.

By default the generation scripts automatically add menu entries for
Arch Linux to any generated configuration. However, entries for other
operating systems do not work out of the box. On BIOS systems, you may
want to install os-prober, which detects other operating systems
installed on your machine and adds entries for them into grub.cfg. If
installed, it will be executed when running grub-mkconfig. See
#Dual-booting for advanced configuration.

> Converting GRUB Legacy's config file to the new format

If grub-mkconfig fails, convert your /boot/grub/menu.lst file to
/boot/grub/grub.cfg using:

    # grub-menulst2cfg /boot/grub/menu.lst /boot/grub/grub.cfg

Note:This option works only in BIOS systems, not in UEFI systems.

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

Basic configuration
-------------------

This section covers only editing the /etc/default/grub configuration
file. See #Advanced configuration if you need more.

Note:Remember to always re-generate the main configuration file after
you make changes to /etc/default/grub.

Additional arguments

To pass custom additional arguments to the Linux image, you can set the
GRUB_CMDLINE_LINUX + GRUB_CMDLINE_LINUX_DEFAULT variables in
/etc/default/grub. The two are appended to each other and passed to
kernel when generating regular boot entries. For the recovery boot
entry, only GRUB_CMDLINE_LINUX is used in the generation.

It is not necessary to use both, but can be useful. For example, you
could use GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/sdaX quiet" where sdaX
is your swap partition to enable resume after hibernation. This would
generate a recovery boot entry without the resume and without quiet
suppressing kernel messages during a boot from that menu entry. Though,
the other (regular) menu entries would have them as options.

For generating the GRUB recovery entry you also have to comment out
#GRUB_DISABLE_RECOVERY=true in /etc/default/grub.

You can also use
GRUB_CMDLINE_LINUX="resume=/dev/disk/by-uuid/${swap_uuid}", where
${swap_uuid}  is the UUID of your swap partition.

Multiple entries are separated by spaces within the double quotes. So,
for users who want both resume and systemd it would look like this:
GRUB_CMDLINE_LINUX="resume=/dev/sdaX init=/usr/lib/systemd/systemd"

See Kernel parameters for more info.

> Visual configuration

In GRUB it is possible, by default, to change the look of the menu. Make
sure to initialize, if not done already, GRUB graphical terminal,
gfxterm, with proper video mode, gfxmode, in GRUB. This can be seen in
the section #"No suitable mode found" error. This video mode is passed
by GRUB to the linux kernel via 'gfxpayload' so any visual
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

> Note:

-   If this example does not work for you try to replace
    gfxmode="1024x768x32" by vbemode="0x105". Remember to replace the
    specified resolution with one suitable for your screen
-   To show all the modes you can use # hwinfo --framebuffer (hwinfo is
    available in [community]), while at GRUB prompt you can use the
    vbeinfo command

If this method does not work for you, the deprecated vga= method will
still work. Just add it next to the "GRUB_CMDLINE_LINUX_DEFAULT=" line
in /etc/default/grub for example:
"GRUB_CMDLINE_LINUX_DEFAULT="quiet splash vga=792" will give you a
1024x768 resolution.

You can choose one of these resolutions: 640×480, 800×600, 1024×768,
1280×1024, 1600×1200, 1920×1200

915resolution hack

Some times for Intel graphic adapters neither # hwinfo --framebuffer nor
vbeinfo will show you the desired resolution. In this case you can use
915resolution hack. This hack will temporarily modify video BIOS and add
needed resolution. See 915resolution's home page

First you need to find a video mode which will be modified later. For
that we need the GRUB command shell:

    sh:grub> 915resolution -l

    Intel 800/900 Series VBIOS Hack : version 0.5.3
    [...]
    Mode 30 : 640x480, 8 bits/pixel
    [...]

Next, we overwrite the Mode 30 with 1440x900 resolution:

    /etc/grub.d/00_header

    [...]
    915resolution 30 1440 900  # Inserted line
    set gfxmode=${GRUB_GFXMODE}
    [...]

Lastly we need to set GRUB_GFXMODE as described earlier, regenerate
grub.cfg and reboot to test changes.

Background image and bitmap fonts

GRUB comes with support for background images and bitmap fonts in pf2
format. The unifont font is included in the grub package under the
filename unicode.pf2, or, as only ASCII characters under the name
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

Re-generate grub.cfg to apply the changes. If adding the splash image
was successful, the user will see "Found background image..." in the
terminal as the command is executed. If this phrase is not seen, the
image information was probably not incorporated into the grub.cfg file.

If the image is not displayed, check:

-   The path and the filename in /etc/default/grub are correct
-   The image is of the proper size and format (tga, png, 8-bit jpg)
-   The image was saved in the RGB mode, and is not indexed
-   The console mode is not enabled in /etc/default/grub
-   The command grub-mkconfig must be executed to place the background
    image information into the /boot/grub/grub.cfg file

Theme

Here is an example for configuring Starfield theme which was included in
GRUB package.

Edit /etc/default/grub

    GRUB_THEME="/usr/share/grub/themes/starfield/theme.txt"

Re-generate grub.cfg to apply the changes. If configuring the theme was
successful, you will see
Found theme: /usr/share/grub/themes/starfield/theme.txt in the terminal.

Your splash image will usually not be displayed when using a theme.

Menu colors

You can set the menu colors in GRUB. The available colors for GRUB can
be found in the GRUB Manual. Here is an example:

Edit /etc/default/grub:

    GRUB_COLOR_NORMAL="light-blue/black"
    GRUB_COLOR_HIGHLIGHT="light-cyan/blue"

Hidden menu

One of the unique features of GRUB is hiding/skipping the menu and
showing it by holding Esc when needed. You can also adjust whether you
want to see the timeout counter.

Edit /etc/default/grub as you wish. Here is an example where the
comments from the beginning of the two lines have been removed to enable
the feature, the timeout has been set to five seconds and to be shown to
the user:

    GRUB_TIMEOUT=0
    GRUB_HIDDEN_TIMEOUT=5
    GRUB_HIDDEN_TIMEOUT_QUIET=false

GRUB_HIDDEN_TIMEOUT is how many seconds before displaying menu. You also
need to set GRUB_TIMEOUT=0 if you want to hide menu.

Disable framebuffer

Users who use NVIDIA proprietary driver might wish to disable GRUB's
framebuffer as it can cause problems with the binary driver.

To disable framebuffer, edit /etc/default/grub and uncomment the
following line:

    GRUB_TERMINAL_OUTPUT=console

Another option if you want to keep the framebuffer in GRUB is to revert
to text mode just before starting the kernel. To do that modify the
variable in /etc/default/grub:

    GRUB_GFXPAYLOAD_LINUX=text

> Persistent block device naming

One naming scheme for Persistent block device naming is the use of
globally unique UUIDs to detect partitions instead of the "old"
/dev/sd*. Advantages are covered up in the above linked article.

Persistent naming via file system UUIDs are used by default in GRUB.

Note:The /boot/grub.cfg file needs regeneration with the new UUID in
/etc/default/grub every time a relevant file system is resized or
recreated. Remember this when modifying partitions & file systems with a
Live-CD.

Whether to use UUIDs is controlled by an option in /etc/default/grub:

    GRUB_DISABLE_LINUX_UUID=true

> Recall previous entry

GRUB can remember the last entry you booted from and use this as the
default entry to boot from next time. This is useful if you have
multiple kernels (i.e., the current Arch one and the LTS kernel as a
fallback option) or operating systems. To do this, edit
/etc/default/grub and change the value of GRUB_DEFAULT:

    GRUB_DEFAULT=saved

This ensures that GRUB will default to the saved entry. To enable saving
the selected entry, add the following line to /etc/default/grub:

    GRUB_SAVEDEFAULT=true

Note:Manually added menu items, e.g. Windows in /etc/grub.d/40_custom or
/boot/grub/custom.cfg, will need savedefault added.

> Changing the default menu entry

To change the default selected entry, edit /etc/default/grub and change
the value of GRUB_DEFAULT:

Using numbers :

    GRUB_DEFAULT=0

Grub identifies entries in generated menu counted from zero. That means
0 for the first entry which is the default value, 1 for the second and
so on.

Or using menu titles :

    GRUB_DEFAULT='Arch Linux, with Linux core repo kernel'

> Root encryption

To let GRUB automatically add the kernel parameters for root encryption,
add cryptdevice=/dev/yourdevice:label to GRUB_CMDLINE_LINUX in
/etc/default/grub.

Tip:If you are upgrading from a working GRUB Legacy configuration, check
/boot/grub/menu.lst.pacsave for the correct device/label to add. Look
for them after the text kernel /vmlinuz-linux.

Example with root mapped to /dev/mapper/root:

    GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:root"

Also, disable the usage of UUIDs for the rootfs:

    GRUB_DISABLE_LINUX_UUID=true

> Boot non-default entry only once

The command grub-reboot is very helpful to boot another entry than the
default only once. GRUB loads the entry passed in the first command line
argument, when the system is rebooted the next time. Most importantly
GRUB returns to loading the default entry for all future booting.
Changing the configuration file or selecting an entry in the GRUB menu
is not necessary.

Note:This requires GRUB_DEFAULT=saved in /etc/default/grub (and then
regenerating grub.cfg) or, in case of hand-made grub.cfg, the line
set default="${saved_entry}".

Advanced configuration
----------------------

This section covers manual editing of grub.cfg, writing custom scripts
in /etc/grub.d/ and other advanced settings.

> Manually creating grub.cfg

Warning:Editing this file is strongly discouraged. The file is generated
by the grub-mkconfig command, and it is best to edit your
/etc/default/grub or one of the scripts in the /etc/grub.d directory.

A basic GRUB config file uses the following options:

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
    #  set root=(hd0,3)
    #  chainloader +1
    #}

> Dual-booting

Note:If you want GRUB to automatically search for other systems, you may
wish to install os-prober.

Automatically generating using /etc/grub.d/40_custom and grub-mkconfig

The best way to add other entries is editing the /etc/grub.d/40_custom
or /boot/grub/custom.cfg. The entries in this file will be automatically
added when running grub-mkconfig. After adding the new lines, run:

    # grub-mkconfig -o /boot/grub/grub.cfg

or, for UEFI-GPT Mode:

    # grub-mkconfig -o /boot/efi/EFI/GRUB/grub.cfg

to generate an updated grub.cfg.

For example, a typical /etc/grub.d/40_custom file, could appear similar
to the following one, created for HP Pavilion 15-e056sl Notebook PC,
originally with Microsoft Windows 8 preinstalled. Each menuentry should
mantain a structure similar to the following ones. Note that the UEFI
partition /dev/sda2 within GRUB is called hd0,gpt2 and ahci0,gpt2 (see
here for more info).

    /etc/grub.d/40_custom

    #!/bin/sh
    exec tail -n +3 $0
    # This file provides an easy way to add custom menu entries.  Simply type the
    # menu entries you want to add after this comment.  Be careful not to change
    # the 'exec tail' line above.

    menuentry "HP / Microsoft Windows 8.1" {
    	echo "Loading HP / Microsoft Windows 8.1..."
    	insmod part_gpt
    	insmod fat
    	insmod search_fs_uuid
    	insmod chain
    	search --fs-uuid --set=root --hint-bios=hd0,gpt2 --hint-efi=hd0,gpt2 --hint-baremetal=ahci0,gpt2 763A-9CB6
    	chainloader (${root})/EFI/Microsoft/Boot/bootmgfw.efi
    }

    menuentry "HP / Microsoft Control Center" {
    	echo "Loading HP / Microsoft Control Center..."
    	insmod part_gpt
    	insmod fat
    	insmod search_fs_uuid
    	insmod chain
    	search --fs-uuid --set=root --hint-bios=hd0,gpt2 --hint-efi=hd0,gpt2 --hint-baremetal=ahci0,gpt2 763A-9CB6
    	chainloader (${root})/EFI/HP/boot/bootmgfw.efi
    }

    menuentry "System shutdown" {
    	echo "System shutting down..."
    	halt
    }

    menuentry "System restart" {
    	echo "System rebooting..."
    	reboot
    }

GNU/Linux menu entry

Assuming that the other distro is on partition sda2:

    menuentry "Other Linux" {
    	set root=(hd0,2)
    	linux /boot/vmlinuz (add other options here as required)
    	initrd /boot/initrd.img (if the other kernel uses/needs one)
    }

FreeBSD menu entry

Requires that FreeBSD is installed on a single partition with UFS.
Assuming it is installed on sda4:

    menuentry "FreeBSD" {
    	set root=(hd0,4)
    	chainloader +1
    }

Windows XP menu entry

This assumes that your Windows partition is sda3. Remember you need to
point set root and chainloader to the system reserve partition that
windows made when it installed, not the actual partition windows is on.
This example works if your system reserve partition is sda3.

    # (2) Windows XP
    menuentry "Windows XP" {
    	set root="(hd0,3)"
    	chainloader +1
    }

If the Windows bootloader is on an entirely different hard drive than
GRUB, it may be necessary to trick Windows into believing that it is the
first hard drive. This was possible with drivemap. Assuming GRUB is on
hd0 and Windows is on hd2, you need to add the following after set root:

    drivemap -s hd0 hd2

Windows installed in UEFI-GPT Mode menu entry

    if [ "${grub_platform}" == "efi" ]; then
    	menuentry "Microsoft Windows Vista/7/8 x86_64 UEFI-GPT" {
    		insmod part_gpt
    		insmod fat
    		insmod search_fs_uuid
    		insmod chain
    		search --fs-uuid --set=root $hints_string $uuid
    		chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    	}
    fi

where $hints_string and $uuid are obtained with the following two
commands. $uuid's command:

    # grub-probe --target=fs_uuid $esp/EFI/Microsoft/Boot/bootmgfw.efi
    1ce5-7f28

$hints_string's command:

    # grub-probe --target=hints_string $esp/EFI/Microsoft/Boot/bootmgfw.efi
     --hint-bios=hd0,gpt1 --hint-efi=hd0,gpt1 --hint-baremetal=ahci0,gpt1

These two commands assume the ESP Windows uses is mounted at $esp. There
might be case differences in the path to Windows's EFI file, what with
being Windows, and all.

"Shutdown" menu entry

    menuentry "System shutdown" {
    	echo "System shutting down..."
    	halt
    }

"Restart" menu entry

    menuentry "System restart" {
    	echo "System rebooting..."
    	reboot
    }

Windows installed in BIOS-MBR mode

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: This section     
                           does not fit into the    
                           others, should be        
                           slimmed down a bit.      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Note:GRUB supports booting bootmgr directly and chainload of partition
boot sector is no longer required to boot Windows in a BIOS-MBR setup.

Warning:It is the system partition that has bootmgr, not your "real"
Windows partition (usually C:). When showing all UUIDs with blkid, the
system partition is the one with LABEL="SYSTEM RESERVED" or
LABEL="SYSTEM" and is only about 100 to 200 MB in size (much like the
boot partition for Arch). See Wikipedia:System partition and boot
partition for more info.

Throughout this section, it is assumed your Windows partition is
/dev/sda1. A different partition will change every instance of
hd0,msdos1. First, find the UUID of the NTFS file system of the
Windows's SYSTEM PARTITION where the bootmgr and its files reside. For
example, if Windows bootmgr exists at /media/SYSTEM_RESERVED/bootmgr:

For Windows Vista/7/8:

    # grub-probe --target=fs_uuid /media/SYSTEM_RESERVED/bootmgr
    69B235F6749E84CE

    # grub-probe --target=hints_string /media/SYSTEM_RESERVED/bootmgr
    --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1

Note:For Windows XP, replace bootmgr with NTLDR in the above commands.
And note that there may not be a separate SYSTEM_RESERVED partition;
just probe the file NTLDR on your Windows partition.

Then, add the below code to /etc/grub.d/40_custom or
/boot/grub/custom.cfg and regenerate grub.cfg with grub-mkconfig as
explained above to boot Windows (XP, Vista, 7 or 8) installed in
BIOS-MBR mode:

For Windows Vista/7/8:

    if [ "${grub_platform}" == "pc" ]; then
      menuentry "Microsoft Windows Vista/7/8 BIOS-MBR" {
        insmod part_msdos
        insmod ntfs
        insmod search_fs_uuid
        insmod ntldr     
        search --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 69B235F6749E84CE
        ntldr /bootmgr
      }
    fi

For Windows XP:

    if [ "${grub_platform}" == "pc" ]; then
      menuentry "Microsoft Windows XP" {
        insmod part_msdos
        insmod ntfs
        insmod search_fs_uuid
        insmod ntldr     
        search --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 69B235F6749E84CE
        ntldr /bootmgr
      }
    fi

Note:In some cases, mine I have installed GRUB before a clean Windows 8,
you cannot boot Windows having an error with \boot\bcd (error code
0xc000000f). You can fix it going to Windows Recovery Console (cmd from
install disk) and executing:

    x:\> "bootrec.exe /fixboot" 
    x:\> "bootrec.exe /RebuildBcd".

Do not use bootrec.exe /Fixmbr because it will wipe GRUB out.

/etc/grub.d/40_custom can be used as a template to create
/etc/grub.d/nn_custom. Where nn defines the precendence, indicating the
order the script is executed. The order scripts are executed determine
the placement in the grub boot menu.

Note:nn should be greater than 06 to ensure necessary scripts are
executed first.

With Windows via EasyBCD and NeoGRUB

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with NeoGRUB.    
                           Notes: New page has been 
                           created, so this section 
                           should be merged there.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Since EasyBCD's NeoGRUB currently does not understand the GRUB menu
format, chainload to it by replacing the contents of your
C:\NST\menu.lst file with lines similar to the following:

    default 0
    timeout 1

    title       Chainload into GRUB v2
    root        (hd0,7)
    kernel      /boot/grub/i386-pc/core.img

Finally, recreate your grub.cfg using grub-mkconfig.

> Booting an ISO directly from GRUB

Edit /etc/grub.d/40_custom or /boot/grub/custom.cfg to add an entry for
the target ISO. When finished, update the GRUB menu as with the usual
grub-mkconfig -o /boot/grub/grub.cfg (as root).

Arch ISO

Note:The following examples assume the ISO is in /archives on hd0,6.

Tip:For thumbdrives, use something like (hd1,$partition) and either
/dev/sdbY for the img_dev parameter or a persistent name, e.g.
img_dev=/dev/disk/by-label/CORSAIR.

x86_64

    menuentry "Archlinux-2013.05.01-dual.iso" --class iso {
      set isofile="/archives/archlinux-2013.05.01-dual.iso"
      set partition="6"
      loopback loop (hd0,$partition)/$isofile
      linux (loop)/arch/boot/x86_64/vmlinuz archisolabel=ARCH_201305 img_dev=/dev/sda$partition img_loop=$isofile earlymodules=loop
      initrd (loop)/arch/boot/x86_64/archiso.img
    }

i686

    menuentry "Archlinux-2013.05.01-dual.iso" --class iso {
      set isofile="/archives/archlinux-2013.05.01-dual.iso"
      set partition="6"
      loopback loop (hd0,$partition)/$isofile
      linux (loop)/arch/boot/i686/vmlinuz archisolabel=ARCH_201305 img_dev=/dev/sda$partition img_loop=$isofile earlymodules=loop
      initrd (loop)/arch/boot/i686/archiso.img
    }

Ubuntu ISO

Note:The example assumes that the ISO is in /archives on hd0,6. Users
must adjust the location and hdd/partition in the lines below to match
their systems.

    menuentry "ubuntu-13.04-desktop-amd64.iso" {
      set isofile="/archives/ubuntu-13.04-desktop-amd64.iso"
      loopback loop (hd0,6)/$isofile
      linux (loop)/casper/vmlinuz.efi boot=casper iso-scan/filename=$isofile quiet noeject noprompt splash --
      initrd (loop)/casper/initrd.lz
    }

    menuentry "ubuntu-12.04-desktop-amd64.iso" {
      set isofile="/archives/ubuntu-12.04-desktop-amd64.iso"
      loopback loop (hd0,6)/$isofile
      linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile quiet noeject noprompt splash --
      initrd (loop)/casper/initrd.lz
    }

Other ISOs

Other working configurations from link Source.

> LVM

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

> RAID

GRUB provides convenient handling of RAID volumes. You need to add
insmod mdraid which allows you to address the volume natively. For
example, /dev/md0 becomes:

    set root=(md/0)

whereas a partitioned RAID volume (e.g. /dev/md0p1) becomes:

    set root=(md/0,1)

To install grub when using RAID1 as the /boot partition (or using /boot
housed on a RAID1 root partition), on devices with GPT ef02/'BIOS boot
partition', simply run grub-install on both of the drives, such as:

    # grub-install --target=i386-pc --recheck --debug /dev/sda
    # grub-install --target=i386-pc --recheck --debug /dev/sdb

Where the RAID 1 array housing /boot is housed on /dev/sda and /dev/sdb.

> Using labels

It is possible to use labels, human-readable strings attached to file
systems, by using the --label option to search. First of all, label your
existing partition:

    # tune2fs -L LABEL PARTITION

Then, add an entry using labels. An example of this:

    menuentry "Arch Linux, session texte" {
      search --label --set=root archroot
      linux /boot/vmlinuz-linux root=/dev/disk/by-label/archroot ro
      initrd /boot/initramfs-linux.img
    }

> Password protection of GRUB menu

If you want to secure GRUB so it is not possible for anyone to change
boot parameters or use the command line, you can add a user/password
combination to GRUB's configuration files. To do this, run the command
grub-mkpasswd-pbkdf2. Enter a password and confirm it:

    grub-mkpasswd-pbkdf2

    [...]
    Your PBKDF2 is grub.pbkdf2.sha512.10000.C8ABD3E93C4DFC83138B0C7A3D719BC650E6234310DA069E6FDB0DD4156313DA3D0D9BFFC2846C21D5A2DDA515114CF6378F8A064C94198D0618E70D23717E82.509BFA8A4217EAD0B33C87432524C0B6B64B34FBAD22D3E6E6874D9B101996C5F98AB1746FE7C7199147ECF4ABD8661C222EEEDB7D14A843261FFF2C07B1269A

Then, add the following to /etc/grub.d/00_header:

    /etc/grub.d/00_header

    cat << EOF

    set superusers="username"
    password_pbkdf2 username <password>

    EOF

where <password> is the string generated by grub-mkpasswd_pbkdf2.

Regenerate your configuration file. Your GRUB command line, boot
parameters and all boot entries are now protected.

This can be relaxed and further customized with more users as described
in the "Security" part of the GRUB manual.

> Hide GRUB unless the Shift key is held down

In order to achieve the fastest possible boot, instead of having GRUB
wait for a timeout, it is possible for GRUB to hide the menu, unless the
Shift key is held down during GRUB's start-up.

In order to achieve this, you should add the following line to
/etc/default/grub:

     GRUB_FORCE_HIDDEN_MENU="true"

And the following file should be created:

    /etc/grub.d/31_hold_shift

    #! /bin/sh
    set -e

    # grub-mkconfig helper script.
    # Copyright (C) 2006,2007,2008,2009  Free Software Foundation, Inc.
    #
    # GRUB is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.
    #
    # GRUB is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with GRUB.  If not, see <http://www.gnu.org/licenses/>.

    prefix="/usr"
    exec_prefix="${prefix}"
    datarootdir="${prefix}/share"

    export TEXTDOMAIN=grub
    export TEXTDOMAINDIR="${datarootdir}/locale"
    source "${datarootdir}/grub/grub-mkconfig_lib"

    found_other_os=

    make_timeout () {

      if [ "x${GRUB_FORCE_HIDDEN_MENU}" = "xtrue" ] ; then 
        if [ "x${1}" != "x" ] ; then
          if [ "x${GRUB_HIDDEN_TIMEOUT_QUIET}" = "xtrue" ] ; then
        verbose=
          else
        verbose=" --verbose"
          fi

          if [ "x${1}" = "x0" ] ; then
        cat <<EOF
    if [ "x\${timeout}" != "x-1" ]; then
      if keystatus; then
        if keystatus --shift; then
          set timeout=-1
        else
          set timeout=0
        fi
      else
        if sleep$verbose --interruptible 3 ; then
          set timeout=0
        fi
      fi
    fi
    EOF
          else
        cat << EOF
    if [ "x\${timeout}" != "x-1" ]; then
      if sleep$verbose --interruptible ${GRUB_HIDDEN_TIMEOUT} ; then
        set timeout=0
      fi
    fi
    EOF
          fi
        fi
      fi
    }

    adjust_timeout () {
      if [ "x$GRUB_BUTTON_CMOS_ADDRESS" != "x" ]; then
        cat <<EOF
    if cmostest $GRUB_BUTTON_CMOS_ADDRESS ; then
    EOF
        make_timeout "${GRUB_HIDDEN_TIMEOUT_BUTTON}" "${GRUB_TIMEOUT_BUTTON}"
        echo else
        make_timeout "${GRUB_HIDDEN_TIMEOUT}" "${GRUB_TIMEOUT}"
        echo fi
      else
        make_timeout "${GRUB_HIDDEN_TIMEOUT}" "${GRUB_TIMEOUT}"
      fi
    }

      adjust_timeout

        cat <<EOF
    if [ "x\${timeout}" != "x-1" ]; then
      if keystatus; then
        if keystatus --shift; then
          set timeout=-1
        else
          set timeout=0
        fi
      else
        if sleep$verbose --interruptible 3 ; then
          set timeout=0
        fi
      fi
    fi
    EOF

> Combining the use of UUIDs and basic scripting

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
        search --fs-uuid $the_root_uuid --set=root
        search --fs-uuid $the_boot_uuid --set=grub_boot

        # Check to see if boot and root are equal.
        # If they are, then append /boot to $grub_boot (Since $grub_boot is actually the root partition)
        if [ $the_boot_uuid == $the_root_uuid ] ; then
            set grub_boot=($grub_boot)/boot
        else
            set grub_boot=($grub_boot)
        fi

        # $grub_boot now points to the correct location, so the following will properly find the kernel and initrd
        linux $grub_boot/vmlinuz-linux root=/dev/disk/by-uuid/$the_root_uuid ro
        initrd $grub_boot/initramfs-linux.img
    }

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

> Using the command shell environment to boot operating systems

    grub> 

The GRUB's command shell environment can be used to boot operating
systems. A common scenario may be to boot Windows / Linux stored on a
drive/partition via chainloading.

Chainloading means to load another boot-loader from the current one, ie,
chain-loading.

The other bootloader may be embedded at the starting of the disk(MBR) or
at the starting of a partition.

Chainloading a partition

    set root=(hdX,Y)
    chainloader +1
    boot

X=0,1,2... Y=1,2,3...

For example to chainload Windows stored in the first partiton of the
first hard disk,

    set root=(hd0,1)
    chainloader +1
    boot

Similarly GRUB installed to a partition can be chainloaded.

Chainloading a disk/drive

    set root=hdX
    chainloader +1
    boot

Normal loading

See the examples in #Using_the_rescue_console

GUI configuration tools
-----------------------

Following package may be installed:

-   grub-customizer — Customize the bootloader (GRUB or BURG)

https://launchpad.net/grub-customizer || grub-customizer

-   grub2-editor — KDE4 control module for configuring the GRUB
    bootloader

http://kde-apps.org/content/show.php?content=139643 || grub2-editor

-   kcm-grub2 — This Kcm module manages the most common settings of GRUB

http://kde-apps.org/content/show.php?content=137886 || kcm-grub2

-   startupmanager — GUI app for changing the settings of GRUB Legacy,
    GRUB, Usplash and Splashy (abandonned)

http://sourceforge.net/projects/startup-manager/ || startupmanager

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
(see #Advanced configuration).

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
needed. See #Installation for details.

Troubleshooting
---------------

> Intel BIOS not booting GPT

MBR

Some Intel BIOS's require at least one bootable MBR partition to be
present at boot, causing GPT-partitioned boot setups to be unbootable.

This can be circumvented by using (for instance) fdisk to mark one of
the GPT partitions (preferably the 1007 KiB partition you have created
for GRUB already) bootable in the MBR. This can be achieved, using
fdisk, by the following commands: Start fdisk against the disk you are
installing, for instance fdisk /dev/sda, then press a and select the
partition you wish to mark as bootable (probably #1) by pressing the
corresponding number, finally press w to write the changes to the MBR.

Note:The bootable-marking must be done in fdisk or similar, not in
GParted or others, as they will not set the bootable flag in the MBR.

More information is available here

EFI path

Some UEFI firmwares require a bootable file at a known location before
they will show UEFI NVRAM boot entries. If this is the case,
grub-install will claim efibootmgr has added an entry to boot GRUB,
however the entry will not show up in the VisualBIOS boot order
selector. The solution is to place a file at one of the known locations.
Assuming the EFI partition is at /boot/efi/ this will work:

    mkdir /boot/efi/EFI/boot
    cp /boot/efi/EFI/grub/grubx64.efi /boot/efi/EFI/boot/bootx64.efi

This solution worked for an Intel DH87MC motherboard with firmware dated
Jan 2014.

> Enable debug messages

Add:

    set pager=1
    set debug=all

to grub.cfg.

> "No suitable mode found" error

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
--boot-directory=$esp/EFI set, then the directory is $esp/EFI/grub/:

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

    grub-setup: warn: This msdos-style partition label has no post-MBR gap; embedding will not be possible!
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

An example of a working EFI:

    # efibootmgr -v

    BootCurrent: 0000
    Timeout: 3 seconds
    BootOrder: 0000,0001,0002
    Boot0000* Grub	HD(1,800,32000,23532fbb-1bfa-4e46-851a-b494bfe9478c)File(\efi\grub\grub.efi)
    Boot0001* Shell	HD(1,800,32000,23532fbb-1bfa-4e46-851a-b494bfe9478c)File(\EfiShell.efi)
    Boot0002* Festplatte	BIOS(2,0,00)P0: SAMSUNG HD204UI

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

-   Move GRUB v2 files out of the way:

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

> Arch not found from other OS

Some have reported that other distributions have trouble finding Arch
Linux automatically with os-prober. If this problem arises, it has been
reported that detection can be improved with the presence of
/etc/lsb-release. This file and updating tool is available with the
package lsb-release in the official repositories.

> Redundant menu entries

For new installations of GRUB it is possible that multiple redundant
menu entries will be generated. This is because both the upstream
default /etc/grub.d/10_linux script and the Arch specific
/etc/grub.d/10_archlinux script are creating menu entries when the
grub-mkconfig command is run. To correct this behaviour disable the
10_linux script and then run the grub-mkconfig command again.

    # chmod -x /etc/grub.d/10_linux
    # grub-mkconfig -o /boot/grub/grub.cfg

See also
--------

1.  Official GRUB Manual -
    https://www.gnu.org/software/grub/manual/grub.html
2.  Ubuntu wiki page for GRUB - https://help.ubuntu.com/community/Grub2
3.  GRUB wiki page describing steps to compile for UEFI systems -
    https://help.ubuntu.com/community/UEFIBooting
4.  Wikipedia's page on BIOS Boot partition
5.  http://members.iinet.net/~herman546/p20/GRUB2%20Configuration%20File%20Commands.html
    - quite complete description of how to configure GRUB

Retrieved from
"https://wiki.archlinux.org/index.php?title=GRUB&oldid=305967"

Category:

-   Boot loaders

-   This page was last modified on 20 March 2014, at 17:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
