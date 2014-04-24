Unified Extensible Firmware Interface
=====================================

Related articles

-   Arch Boot Process
-   Master Boot Record
-   GUID Partition Table

Unified Extensible Firmware Interface (or UEFI for short) is a new type
of firmware that was initially designed by Intel (known as EFI then)
mainly for its Itanium based systems. It introduces new ways of booting
an OS that is distinct from the commonly used "MBR boot code" method
followed for BIOS systems. It started as Intel's EFI in versions 1.x and
then a group of companies called the UEFI Forum took over its
development from which it was called Unified EFI starting with version
2.0. As of 24 July 2013, UEFI Specification 2.4 (released July 11, 2013)
is the most recent version.

> Note:

-   This page explains What is UEFI and UEFI support in Linux kernel. It
    does not describe setting up UEFI Boot Loaders. For that information
    see Boot Loaders.
-   Unless specified as EFI 1.x, EFI and UEFI terms are used
    interchangeably to denote UEFI 2.x firmware. Also unless stated
    explicitly, these instructions are general and some of them may not
    work or may be different in Apple Macs. Apple's EFI implementation
    is neither a EFI 1.x version nor UEFI 2.x version but mixes up both.
    This kind of firmware does not fall under any one (U)EFI
    specification and therefore is not a standard UEFI firmware.

Contents
--------

-   1 Differences between BIOS and UEFI
-   2 Boot Process under UEFI
    -   2.1 Multibooting in UEFI
        -   2.1.1 Booting Microsoft Windows
    -   2.2 Detecting UEFI Firmware bitness
        -   2.2.1 Non Macs
        -   2.2.2 Apple Macs
    -   2.3 Secure Boot
-   3 Linux Kernel Config options for UEFI
-   4 UEFI Variables
    -   4.1 UEFI Variables Support in Linux Kernel
        -   4.1.1 Inconsistency between efivarfs and sysfs-efivars
    -   4.2 Requirements for UEFI Variables support to work properly
        -   4.2.1 Mount efivarfs
    -   4.3 Userspace Tools
        -   4.3.1 efibootmgr
-   5 EFI System Partition
    -   5.1 GPT partitioned disks
    -   5.2 MBR partitioned disks
-   6 UEFI Shell
    -   6.1 Obtaining UEFI Shell
    -   6.2 Launching UEFI Shell
    -   6.3 Important UEFI Shell Commands
        -   6.3.1 bcfg
        -   6.3.2 edit
-   7 UEFI Linux Hardware Compatibility
-   8 UEFI Bootable Media
    -   8.1 Create UEFI bootable USB from ISO
    -   8.2 Remove UEFI boot support from Optical Media
-   9 Testing UEFI in systems without native support
    -   9.1 OVMF for Virtual Machines
    -   9.2 DUET for BIOS only systems
-   10 Troubleshooting
    -   10.1 Windows 7 will not boot in UEFI Mode
    -   10.2 USB media gets struck with black screen
        -   10.2.1 Using GRUB
-   11 See also

Differences between BIOS and UEFI
---------------------------------

See Arch_Boot_Process#Firmware_types for more details.

Boot Process under UEFI
-----------------------

1.  System switched on - Power On Self Test, or POST process.
2.  UEFI firmware is loaded. Firmware initializes the hardware required
    for booting.
3.  Firmware then reads its Boot Manager data to determine which UEFI
    application to be launched and from where (i.e. from which disk and
    partition).
4.  Firmware then launches the UEFI application as defined in the boot
    entry in the firmware's boot manager.
5.  The launched UEFI application may launch another application (in
    case of UEFI Shell or a boot manager like rEFInd) or the kernel and
    initramfs (in case of a boot loader like GRUB) depending on how the
    UEFI application was configured.

Note:On some UEFI systems the only possible way to launch UEFI
application on boot (if it does not have custom entry in UEFI boot menu)
is to put it in this fixed location:
<EFI SYSTEM PARTITION>/EFI/boot/bootx64.efi (for 64-bit x86 system)

> Multibooting in UEFI

Since each OS or vendor can maintain its own files within the EFI System
Partition without affecting the other, multi-booting using UEFI is just
a matter of launching a different UEFI application corresponding to the
particular OS's bootloader. This removes the need for relying on
chainloading mechanisms of one boot loader to load another to switch
OSes.

Booting Microsoft Windows

64-bit Windows Vista (SP1+), Windows 7 and Windows 8 versions support
booting using x86_64 EFI firmware. Windows forces type of partitioning
depending on the firmware used, i.e. if Windows is booted in UEFI mode,
it can be installed only to a GPT disk. If the Windows is booted in
Legacy BIOS mode, it can be installed only to a MBR disk. This is a
limitation enforced by Windows installer. Thus Windows supports either
UEFI-GPT boot or BIOS-MBR boot only, not UEFI-MBR or BIOS-GPT boot.

Such a limitation is not enforced by the Linux kernel, but can depend on
how the bootloader is configured. The Windows limitation should be
considered if the user wishes to boot Windows and Linux from the same
disk, since setting up the bootloader itself depends on the firmware
type and disk partitioning used. In case where Windows and Linux dual
boot from the same disk, it is advisable to follow the method used by
Windows, either go for UEFI-GPT boot or BIOS-MBR boot only, not the
other two cases.

32-bit Windows versions only support BIOS-MBR booting. So, in case of
Linux and 32-bit Windows booting from the same disk, the disk has to use
MBR. See http://support.microsoft.com/kb/2581408 for more info.

> Detecting UEFI Firmware bitness

Non Macs

Check whether the dir /sys/firmware/efi exists, if it exists it means
the kernel has booted in EFI mode. In that case the UEFI bitness is same
as kernel bitness. (ie. i686 or x86_64)

Note:Intel Atom System-on-Chip systems ship with 32-bit UEFI (as on 2
November 2013). See this page for more info.

Apple Macs

Pre-2008 Macs mostly have i386-efi firmware while >=2008 Macs have
mostly x86_64-efi. All Macs capable of running Mac OS X Snow Leopard
64-bit Kernel have x86_64 EFI 1.x firmware.

To find out the arch of the efi firmware in a Mac, type the following
into the Mac OS X terminal:

    ioreg -l -p IODeviceTree | grep firmware-abi

If the command returns EFI32 then it is IA32 (32-bit) EFI firmware. If
it returns EFI64 then it is x86_64 EFI firmware. Most of the Macs do not
have UEFI 2.x firmware as Apple's EFI implementation is not fully
compliant with UEFI 2.x Specification.

> Secure Boot

For an overview about Secure Boot in Linux see
http://www.rodsbooks.com/efi-bootloaders/secureboot.html. This section
focuses on how to set up Secure Boot in Arch Linux. For the time being,
this section is limited to explain the procedure of booting the archiso
with Secure Boot enabled. Booting the archiso with Secure Boot enabled
is possible since the efi applications PreLoader.efi and HashTool.efi
have been added to it. A message will show up that says Failed to Start
loader... I will now execute HashTool. To use HashTool for enrolling the
hash of loader.efi and vmlinuz.efi, follow these steps.

-   Select OK
-   In the HashTool main menu, select Enroll Hash, choose \loader.efi
    and confirm with Yes. Again, select Enroll Hash and archiso to enter
    the archiso directory, then select vmlinuz-efi and confirm with Yes.
    Then choose Exit to return to the boot device selection menu.
-   In the boot device selection menu choose
    Arch Linux archiso x86_64 UEFI CD

The archiso boots, and you are presented with a shell prompt,
automatically logged in as root. To check if the archiso was booted with
SecureBoot, use this command:

    $ od -An -t u1 /sys/firmware/efi/vars/SecureBoot-1234abcde-5678-/data

If yes, this command returns 1. The characters denoted by 1234 differ
from machine to machine. To help with this, you can use tab completion
or list the efi variables.

Linux Kernel Config options for UEFI
------------------------------------

The required Linux Kernel configuration options for UEFI systems are :

    CONFIG_RELOCATABLE=y
    CONFIG_EFI=y
    CONFIG_EFI_STUB=y
    CONFIG_FB_EFI=y
    CONFIG_FRAMEBUFFER_CONSOLE=y

UEFI Runtime Variables Support (efivarfs filesystem -
/sys/firmware/efi/efivars). This option is important as this is required
to manipulate UEFI Runtime Variables using tools like
/usr/bin/efibootmgr. The below config option has been added in kernel
3.10 and above.

    CONFIG_EFIVAR_FS=y

UEFI Runtime Variables Support (old efivars sysfs interface -
/sys/firmware/efi/vars). This option should be disabled.

    CONFIG_EFI_VARS=n

GUID Partition Table GPT config option - mandatory for UEFI support

    CONFIG_EFI_PARTITION=y

Note:All of the above options are required to boot Linux via UEFI, and
are enabled in Archlinux kernels in official repos.

Retrieved from
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/plain/Documentation/x86/x86_64/uefi.txt
.

UEFI Variables
--------------

UEFI defines variables through which an operating system can interact
with the firmware. UEFI Boot Variables are used by the boot-loader and
used by the OS only for early system start-up. UEFI Runtime Variables
allow an OS to manage certain settings of the firmware like the UEFI
Boot Manager or managing the keys for UEFI Secure Boot Protocol etc. You
can get the list using

    $ efivar -l

> UEFI Variables Support in Linux Kernel

Linux kernel exposes EFI variables data to userspace via 2 interfaces:

-   OLD sysfs-efivars interface (CONFIG_EFI_VARS) - populated by efivars
    kernel module at /sys/firmware/efi/vars - 1024 byte maximum
    per-variable data size limitation, no UEFI Secure Boot variables
    support (due to the size limitation) and not recommended by kernel
    upstream anymore. Still supported by kernel upstream but completely
    disabled in Arch's official kernels.

-   NEW efivarfs (EFI VARiable FileSystem) interface (CONFIG_EFIVAR_FS)
    - mounted using efivarfs kernel module at /sys/firmware/efi/efivars
    - replacement for the OLD sysfs-efivars interface, has no maximum
    per-variable size limitation, supports UEFI Secure Boot variables
    and recommended by kernel upstream. Introduced in kernel 3.8 and NEW
    efivarfs module split from OLD efivars kernel module in kernel 3.10
    .

Inconsistency between efivarfs and sysfs-efivars

Enabling both OLD sysfs-efivars and NEW efivarfs can cause data
inconsistency issues (see See https://lkml.org/lkml/2013/4/16/473 for
more info). Due to this OLD sysfs-efivars is completely disabled in
Arch's official kernels (since core/linux-3.11 and core/linux-lts-3.10)
and only NEW efivarfs is enabled/supported going forward. All the UEFI
Variables related tools and utilities in official repositories support
efivarfs as of 01 October 2013.

Note:As a side-effect of disabling OLD sysfs-efivars, efi_pstore module
is also disabled in the official Arch kernels as EFI pstore
functionality in the kernel depends of OLD sysfs-efivars support.

If you have both interfaces enabled, you need to disable one of them,
and disable and re-enable the other interface (to refresh the data, to
prevent inconsistencies) before accessing the EFI VAR data using any
userspace tool:

To disable sysfs-efivars and refresh efivarfs:

    # modprobe -r efivars

    # umount /sys/firmware/efi/efivars
    # modprobe -r efivarfs

    # modprobe efivarfs
    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars

To disable efivarfs and refresh sysfs-efivars:

    # umount /sys/firmware/efi/efivars
    # modprobe -r efivarfs

    # modprobe -r efivars
    # modprobe efivars

> Requirements for UEFI Variables support to work properly

1.  EFI Runtime Services support should be present in the kernel
    (CONFIG_EFI=y, check if present with
    zgrep CONFIG_EFI /proc/config.gz).
2.  Kernel processor bitness/arch and EFI processor bitness/arch should
    match
3.  Kernel should be booted in EFI mode (via EFISTUB or any EFI boot
    loader, not via BIOS/CSM or Apple's "bootcamp" which is also
    BIOS/CSM)
4.  EFI Runtime Services in the kernel SHOULD NOT be disabled via kernel
    cmdline, i.e. noefi kernel parameter SHOULD NOT be used
5.  efivarfs filesystem should be mounted at /sys/firmware/efi/efivars,
    otherwise follow #Mount efivarfs section below.
6.  efivar should list (option -l) the EFI Variables without any error.
    For sample output see #Sample_List_of_UEFI_Variables.

If EFI Variables support does not work even after the above conditions
are satisfied, try the below workarounds:

1.  If any userspace tool is unable to modify efi variables data, check
    for existence of /sys/firmware/efi/efivars/dump-* files. If they
    exist, delete them, reboot and retry again.
2.  If the above step does not fix the issue, try booting with
    efi_no_storage_paranoia kernel parameter to disable kernel efi
    variable storage space check that may prevent writing/modification
    of efi variables.

Note:efi_no_storage_paranoia should only be used when needed and should
not be left as a normal boot option. The effect of this kernel command
line parameter turns off a safeguard that was put in place to help avoid
the bricking of machines when the NVRAM gets too full.

Mount efivarfs

If efivarfs is not automatically mounted at /sys/firmware/efi/efivars by
systemd during boot, then you need to manually mount it to expose UEFI
Variable support to the userspace tools like efibootmgr etc.:

    # mount -t efivarfs efivarfs /sys/firmware/efi/efivars

Note:The above command should be run both OUTSIDE (BEFORE) and INSIDE
chroot, if any.

It is also a good idea to auto-mount efivarfs during boot via /etc/fstab
as follows:

    /etc/fstab

    efivarfs    /sys/firmware/efi/efivars    efivarfs    defaults    0    0

> Userspace Tools

There are few tools that can access/modify the UEFI variables, namely

1.  efivar - Library and Tool to manipulate UEFI Variables (used by
    vathpela's efibootmgr) - https://github.com/vathpela/efivar - efivar
    or efivar-git
2.  efibootmgr - Tool to manipulate UEFI Firmware Boot Manager Settings.
    Upstream (http://linux.dell.com/git/efibootmgr.git) efibootmgr code
    does not support efivarfs. A fork of efibootmgr by Fedora's Peter
    Jones (vathpela) supports both efivarfs and sysfs-efivars. It is
    currently used in official core/efibootmgr pkg and AUR pkg
    efibootmgr-pjones-git -
    https://github.com/vathpela/efibootmgr/tree/libefivars
3.  uefivars - Dumps list of EFI variables with some additional PCI
    related info (uses efibootmgr code internally) -
    https://github.com/fpmurphy/Various/tree/master/uefivars-2.0
    supports only efivarfs and
    https://github.com/fpmurphy/Various/tree/master/uefivars-1.0
    supports only sysfs-efivars . AUR package uefivars-git
4.  efitools - Tools to Create and Setup own UEFI Secure Boot
    Certificates, Keys and Signed Binaries (requires efivarfs) -
    efitools-git
5.  Ubuntu's Firmware Test Suite -
    https://wiki.ubuntu.com/FirmwareTestSuite/ - fwts (along with
    fwts-efi-runtime-dkms) or fwts-git

efibootmgr

> Warning:

-   Using efibootmgr in Apple Macs may brick the firmware and may need
    reflash of the motherboard ROM. There have been bug reports
    regarding this in Ubuntu/Launchpad bug tracker. Use bless command
    alone in case of Macs. Experimental "bless" utility for Linux by
    Fedora developers - mactel-boot.

> Note:

-   If efibootmgr completely fails to work in your system, you can
    reboot into UEFI Shell v2 and use bcfg command to create a boot
    entry for the bootloader.
-   If you are unable to use efibootmgr, some UEFI BIOSes allow users to
    directly manage uefi boot options from within the BIOS. For example,
    some ASUS BIOSes have a "Add New Boot Option" choice which enables
    you to select a local EFI System Partition and manually enter the
    EFI stub location. (for example \EFI\refind\refind_x64.efi).
-   The below commands use refind-efi boot-loader as example.

Assuming the boot-loader file to be launched is
/boot/efi/EFI/refind/refind_x64.efi, /boot/efi/EFI/refind/refind_x64.efi
can be split up as /boot/efi and /EFI/refind/refind_x64.efi, wherein
/boot/efi is the mountpoint of the EFI System Partition, which is
assumed to be /dev/sdXY (here X and Y are just placeholders for the
actual values - eg:- in /dev/sda1 , X==a Y==1).

To determine the actual device path for the EFI System Partition
(assuming mountpoint /boot/efi for example) (should be in the form
/dev/sdXY), try :

    # findmnt /boot/efi
    TARGET SOURCE  FSTYPE OPTIONS
    /boot/efi  /dev/sdXY  vfat         rw,flush,tz=UTC

Verify that uefi variables support in kernel is working properly by
running:

    # efivar -l

If efivar lists the uefi variables without any error, then you can
proceed. If not, check whether all the conditions in #Requirements for
UEFI Variables support to work properly are met.

Then create the boot entry using efibootmgr as follows:

    # efibootmgr -c -d /dev/sdX -p Y -l /EFI/refind/refind_x64.efi -L "rEFInd"

Note:UEFI uses backward slash \ as path separator (similar to Windows
paths), but the official efibootmgr pkg support passing unix-style paths
with forward-slash / as path-separator for the -l option. Efibootmgr
internally converts / to \ before encoding the loader path. The relevant
git commit that incorporated this feature in efibootmgr is
http://linux.dell.com/cgi-bin/cgit.cgi/efibootmgr.git/commit/?id=f38f4aaad1dfa677918e417c9faa6e3286411378
.

In the above command /boot/efi/EFI/refind/refind_x64.efi translates to
/boot/efi and /EFI/refind/refind_x64.efi which in turn translate to
drive /dev/sdX -> partition Y -> file /EFI/refind/refind_x64.efi.

The 'label' is the name of the menu entry shown in the UEFI boot menu.
This name is user's choice and does not affect the booting of the
system. More info can be obtained from efibootmgr GIT README .

FAT32 filesystem is case-insensitive since it does not use UTF-8
encoding by default. In that case the firmware uses capital 'EFI'
instead of small 'efi', therefore using \EFI\refind\refindx64.efi or
\efi\refind\refind_x64.efi does not matter (this will change if the
filesystem encoding is UTF-8).

EFI System Partition
--------------------

The EFI System Partition (also called ESP or EFISYS) is a FAT32
formatted physical partition (in the main partition table of the disk,
not LVM or software raid etc.) from where the UEFI firmware launches the
UEFI bootloader and application. It is a OS independent partition that
acts as the storage place for the EFI bootloaders and applications which
the firmware launches them. It is mandatory for UEFI boot. It should be
marked as EF00 or ef00 type code in gdisk, or boot flag in case of GNU
Parted (only for GPT disk). It is recommended to keep ESP size at 512
MiB although smaller/larger sizes are fine (smaller sizes provided it is
higher than the minimum FAT32 FS partition size limit (as mandated by
FAT32 specification from Microsoft). For more info visit link.

> Note:

-   It is recommended to use always GPT for UEFI boot as some UEFI
    firmwares do not allow UEFI-MBR boot.
-   In GNU Parted, boot flag (not to be confused with legacy_boot flag)
    has different effect in MBR and GPT disk. In MBR disk, it marks the
    partition as active. In GPT disk, it changes the type code of the
    partition to EFI System Partition type. Parted has no flag to mark a
    partition as ESP in MBR disk (this can be done using fdisk though).
-   Microsoft documentation noted the ESP size: For Advanced Format 4K
    Native drives (4-KB-per-sector) drives, the minimum size is 260 MB,
    due to a limitation of the FAT32 file format. The minimum partition
    size of FAT32 drives is calculated as sector size (4KB) x 65527 =
    256 MB. Advanced Format 512e drives are not affected by this
    limitation, because their emulated sector size is 512 bytes. 512
    bytes x 65527 = 32 MB, which is less than the 100 MB minimum size
    for this partition. From:
    http://technet.microsoft.com/en-us/library/hh824839.aspx#DiskPartitionRules
-   In case of EFISTUB, the kernels and initramfs files should be stored
    in the EFI System Partition. For sake of simplicity, you can also
    use the ESP as the /boot partition itself instead of a separate
    /boot partition, for EFISTUB booting.

> GPT partitioned disks

-   Create a partition with partition type ef00 or EF00 using gdisk
    (from gptfdisk pkg). Then format that partition as FAT32 using
    mkfs.fat -F32 /dev/<THAT_PARTITION>

(or)

-   Create a FAT32 partition and in GNU Parted set/activate the boot
    flag (not legacy_boot flag) on that partition

Note:If you get the message
WARNING: Not enough clusters for a 32 bit FAT!, reduce cluster size with
mkfs.fat -s2 -F32 ... or -s1, otherwise the partition may be unreadable
by UEFI.

> MBR partitioned disks

Create a partition with partition type 0xEF using fdisk (from util-linux
pkg). Then format that partition as FAT32 using
mkfs.fat -F32 /dev/<THAT_PARTITION>

UEFI Shell
----------

The UEFI Shell is a shell/terminal for the firmware which allows
launching uefi applications which include uefi bootloaders. Apart from
that, the shell can also be used to obtain various other information
about the system or the firmware like memory map (memmap), modifying
boot manager variables (bcfg), running partitioning programs (diskpart),
loading uefi drivers, editing text files (edit), hexedit etc.

> Obtaining UEFI Shell

You can download a BSD licensed UEFI Shell from Intel's Tianocore
UDK/EDK2 Sourceforge.net project.

-   AUR uefi-shell-svn pkg (recommended) - provides x86_64 Shell in
    x86_64 system and IA32 Shell in i686 system - compiled directly from
    latest Tianocore EDK2 SVN source
-   Precompiled x86_64 UEFI Shell v2 binary (may not be up-to-date)
-   Precompiled x86_64 UEFI Shell v1 binary (not updated anymore
    upstream)
-   Precompiled IA32 UEFI Shell v2 binary (may not be up-to-date)
-   Precompiled IA32 UEFI Shell v1 binary (not updated anymore upstream)

Shell v2 works best in UEFI 2.3+ systems and is recommended over Shell
v1 in those systems. Shell v1 should work in all UEFI systems
irrespective of the spec. version the firmware follows. More info at
ShellPkg and this mail

> Launching UEFI Shell

Few Asus and other AMI Aptio x86_64 UEFI firmware based motherboards
(from Sandy Bridge onwards) provide an option called
"Launch EFI Shell from filesystem device" . For those motherboards,
download the x86_64 UEFI Shell and copy it to your EFI System Partition
as <EFI_SYSTEM_PARTITION>/shellx64.efi (mostly /boot/efi/shellx64.efi) .

Systems with Phoenix SecureCore Tiano UEFI firmware are known to have
embedded UEFI Shell which can be launched using either F6, F11 or F12
key.

Note:If you are unable to launch UEFI Shell from the firmware directly
using any of the above mentioned methods, create a FAT32 USB pen drive
with Shell.efi copied as (USB)/efi/boot/bootx64.efi. This USB should
come up in the firmware boot menu. Launching this option will launch the
UEFI Shell for you.

> Important UEFI Shell Commands

UEFI Shell commands usually support -b option which makes output pause
after each page. map lists recognized filesystems (fs0, ...) and data
storage devices (blk0, ...). Run help -b to list available commands.

More info at
http://software.intel.com/en-us/articles/efi-shells-and-scripting/

bcfg

BCFG command is used to modify the UEFI NVRAM entries, which allow the
user to change the boot entries or driver options. This command is
described in detail in page 83 (Section 5.3) of "UEFI Shell
Specification 2.0" PDF document.

> Note:

-   Users are recommended to try bcfg only if efibootmgr fails to create
    working boot entries in their system.
-   UEFI Shell v1 official binary does not support bcfg command. You can
    download a modified UEFI Shell v2 binary which may work in UEFI
    pre-2.3 firmwares.

To dump a list of current boot entries:

    Shell> bcfg boot dump -v

To add a boot menu entry for rEFInd (for example) as 4th (numbering
starts from zero) option in the boot menu:

    Shell> bcfg boot add 3 fs0:\EFI\refind\refind_x64.efi "rEFInd"

where fs0: is the mapping corresponding to the EFI System Partition and
fs0:\EFI\refind\refind_x64.efi is the file to be launched.

To remove the 4th boot option:

    Shell> bcfg boot rm 3

To move the boot option #3 to #0 (i.e. 1st or the default entry in the
UEFI Boot menu):

    Shell> bcfg boot mv 3 0

For bcfg help text:

    Shell> help bcfg -v -b

or:

    Shell> bcfg -? -v -b

edit

EDIT command provides a basic text editor with an interface similar to
nano text editor, but slightly less functional. It handles UTF-8
encoding and takes care or LF vs CRLF line endings.

To edit, for example rEFInd's refind.conf in the EFI System Partition
(fs0: in the firmware)

    Shell> fs0:
    FS0:\> cd \EFI\arch\refind
    FS0:\EFI\arch\refind\> edit refind.conf

Type Ctrl-E for help.

UEFI Linux Hardware Compatibility
---------------------------------

See HCL/Firmwares/UEFI for the main article.

UEFI Bootable Media
-------------------

> Create UEFI bootable USB from ISO

Follow USB Flash Installation Media#BIOS and UEFI Bootable USB

> Remove UEFI boot support from Optical Media

Note:This section mentions removing UEFI boot support from a CD/DVD only
(Optical Media), not from a USB flash drive.

Most of the 32-bit EFI Macs and some 64-bit EFI Macs refuse to boot from
a UEFI(X64)+BIOS bootable CD/DVD. If one wishes to proceed with the
installation using optical media, it might be necessary to remove UEFI
support first.

-   Mount the official installation media and obtain the archisolabel as
    shown in the previous section.

    # mount -o loop input.iso /mnt/iso

-   Then rebuild the ISO, excluding the UEFI Optical Media booting
    support, using xorriso from libisoburn

    $ xorriso -as mkisofs -iso-level 3 \
        -full-iso9660-filenames\
        -volid "archisolabel" \
        -appid "Arch Linux CD" \
        -publisher "Arch Linux <https://www.archlinux.org>" \
        -preparer "prepared by $USER" \
        -eltorito-boot isolinux/isolinux.bin \
        -eltorito-catalog isolinux/boot.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        -isohybrid-mbr "/mnt/iso/isolinux/isohdpfx.bin" \
        -output output.iso /mnt/iso/

-   Burn output.iso to optical media and proceed with installation
    normally.

Testing UEFI in systems without native support
----------------------------------------------

> OVMF for Virtual Machines

OVMF [1] is a tianocore project to enable UEFI support for Virtual
Machines. OVMF contains a sample UEFI firmware for QEMU.

You can build OVMF (with Secure Boot support) from AUR ovmf-svn and run
it as follows:

    $ qemu-system-x86_64 -enable-kvm -net none -m 1024 -bios /usr/share/ovmf/x86_64/bios.bin 

> DUET for BIOS only systems

DUET is a tianocore project that enables chainloading a full UEFI
environment from a BIOS system, in a way similar to BIOS OS booting.
This method is being discussed extensively in
http://www.insanelymac.com/forum/topic/186440-linux-and-windows-uefi-boot-using-tianocore-duet-firmware/.
Pre-build DUET images can be downloaded from one of the repos at
https://gitorious.org/tianocore_uefi_duet_builds. Specific instructions
for setting up DUET is available at
https://gitorious.org/tianocore_uefi_duet_builds/tianocore_uefi_duet_installer/blobs/raw/master/Migle_BootDuet_INSTALL.txt.

You can also try http://sourceforge.net/projects/cloverefiboot/ which
provides modified DUET images that may contain some system specific
fixes and is more frequently updated compared to the gitorious repos.

Troubleshooting
---------------

> Windows 7 will not boot in UEFI Mode

If you have installed Windows to a different harddisk with GPT
partitioning and still have a MBR partitioned harddisk in your computer,
then it is possible that the UEFI BIOS is starting it's CSM support (for
booting MBR partitions) and therefor Windows will not boot. To solve
this merge your MBR harddisk to GPT partitioning or disable the SATA
port where the MBR harddisk is plugged in or unplug the SATA connector
from this harddisk.

Mainboards with this kind of problem:

Gigabyte Z77X-UD3H rev. 1.1 (UEFI BIOS version F19e)

- UEFI BIOS option for booting UEFI Only does not pretend the UEFI BIOS
from starting CSM

> USB media gets struck with black screen

-   This issue can occur either due to KMS issue. Try Disabling KMS
    while booting the USB.

-   If the issue is not due to KMS, then it may be due to bug in EFISTUB
    booting (see [2] and [3] for more information.). Both Official ISO
    (Archiso) and Archboot iso use EFISTUB (via Gummiboot Boot Manager
    for menu) for booting the kernel in UEFI mode. In such a case you
    have to use GRUB as the USB's UEFI bootloader by following the below
    section.

Using GRUB

-   Create USB Flash Installation drive as mentioned in link. After that
    follow the below steps to use GRUB instead of Gummiboot.

-   Backup <USB>/EFI/boot/loader.efi to <USB>/EFI/boot/gummiboot.efi

-   Create a GRUB standalone image and copy it to
    <USB>/EFI/boot/loader.efi

-   Create <USB>/EFI/boot/grub.cfg with the following contents:

    grub.cfg for Official ISO

    insmod part_gpt
    insmod part_msdos
    insmod fat

    insmod efi_gop
    insmod efi_uga
    insmod video_bochs
    insmod video_cirrus

    insmod font

    if loadfont "${prefix}/fonts/unicode.pf2" ; then
        insmod gfxterm
        set gfxmode="1024x768x32;auto"
        terminal_input console
        terminal_output gfxterm
    fi

    menuentry "Arch Linux archiso x86_64" {
        set gfxpayload=keep
        search --no-floppy --set=root --label ARCHISO_XXXXXX
        linux /arch/boot/x86_64/vmlinuz archisobasedir=arch archisolabel=ARCHISO_XXXXXX add_efi_memmap
        initrd /arch/boot/x86_64/archiso.img
    }

    menuentry "UEFI Shell x86_64 v2" {
        search --no-floppy --set=root --label ARCHISO_XXXXXX
        chainloader /EFI/shellx64_v2.efi
    }
        
    menuentry "UEFI Shell x86_64 v1" {
        search --no-floppy --set=root --label ARCHISO_XXXXXX
        chainloader /EFI/shellx64_v1.efi
    }

    grub.cfg for Archboot ISO

    insmod part_gpt
    insmod part_msdos
    insmod fat

    insmod efi_gop
    insmod efi_uga
    insmod video_bochs
    insmod video_cirrus

    insmod font

    if loadfont "${prefix}/fonts/unicode.pf2" ; then
        insmod gfxterm
        set gfxmode="1024x768x32;auto"
        terminal_input console
        terminal_output gfxterm
    fi

    menuentry "Arch Linux x86_64 Archboot" {
        set gfxpayload=keep
        search --no-floppy --set=root --file /boot/vmlinuz_x86_64
        linux /boot/vmlinuz_x86_64 cgroup_disable=memory loglevel=7 add_efi_memmap
        initrd /boot/initramfs_x86_64.img
    }

    menuentry "UEFI Shell x86_64 v2" {
        search --no-floppy --set=root --file /boot/vmlinuz_x86_64
        chainloader /EFI/tools/shellx64_v2.efi
    }
        
    menuentry "UEFI Shell x86_64 v1" {
        search --no-floppy --set=root --file /boot/vmlinuz_x86_64
        chainloader /EFI/tools/shellx64_v1.efi
    }

See also
--------

-   Wikipedia:UEFI
-   Wikipedia:EFI System partition
-   UEFI boot: how does that actually work, then? - A blog post by AdamW
-   Linux Kernel x86_64 UEFI Documentation
-   UEFI Forum - contains the official UEFI Specifications - GUID
    Partition Table is part of UEFI Specification
-   Intel's Tianocore Project for Open-Source UEFI firmware which
    includes DuetPkg for direct BIOS based booting and OvmfPkg used in
    QEMU and Oracle VirtualBox
-   Intel UEFI Community Resource Center
-   Intel's page on EFI
-   FGA: The EFI boot process
-   Microsoft's Windows and GPT FAQ - Contains info on Windows UEFI
    booting also
-   Convert Windows Vista SP1+ or 7 x86_64 boot from BIOS-MBR mode to
    UEFI-GPT mode without Reinstall
-   Create a Linux BIOS+UEFI and Windows x64 BIOS+UEFI bootable USB
    drive
-   Rod Smith - A BIOS to UEFI Transformation
-   UEFI Boot problems on some newer machines (LKML)
-   EFI Shells and Scripting - Intel Documentation
-   UEFI Shell - Intel Documentation
-   UEFI Shell - bcfg command info
-   UEFI Shell v2 binary with bcfg modified to work with UEFI pre-2.3
    firmware - from Clover efiboot
-   LPC 2012 Plumbing UEFI into Linux
-   LPC 2012 UEFI Tutorial : part 1
-   LPC 2012 UEFI Tutorial : part 2

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unified_Extensible_Firmware_Interface&oldid=295413"

Category:

-   Boot process

-   This page was last modified on 1 February 2014, at 22:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
