Unified Extensible Firmware Interface
=====================================

Summary

An overview of the Unified Extensible Firmware Interface.

Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

Related

GUID Partition Table

Master Boot Record

Arch Boot Process

Unified Extensible Firmware Interface (or UEFI for short) is a new type
of firmware that was initially designed by Intel (known as EFI then)
mainly for its Itanium based systems. It introduces new ways of booting
an OS that is distinct from the commonly used "MBR boot code" method
followed for BIOS systems. It started as Intel's EFI in versions 1.x and
then a group of companies called the UEFI Forum took over its
development from which it was called Unified EFI starting with version
2.0 . As of 23 May 2012, UEFI Specification 2.3.1 is the most recent
version.

Note:Unless specified as EFI 1.x , EFI and UEFI terms are used
interchangeably to denote UEFI 2.x firmware. Also unless stated
explicitely, these instructions are general and not Mac specific. Some
of them may not work or may be different in Macs. Apple's EFI
implementation is neither a EFI 1.x version nor UEFI 2.x version but
mixes up both. This kind of firmware does not fall under any one UEFI
Specification version and therefore it is not a standard UEFI firmware.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Booting an OS using BIOS                                           |
|     -   1.1 Multiboot on BIOS                                            |
|                                                                          |
| -   2 Booting an OS using UEFI                                           |
|     -   2.1 Multibooting on UEFI                                         |
|         -   2.1.1 Multibooting Windows and Linux                         |
|                                                                          |
| -   3 Boot Process under UEFI                                            |
| -   4 Detecting UEFI Firmware Arch                                       |
| -   5 UEFI Support in Linux Kernel                                       |
|     -   5.1 Linux Kernel config options for UEFI                         |
|                                                                          |
| -   6 UEFI Variables Support                                             |
|     -   6.1 Userspace Tools                                              |
|     -   6.2 Non-Mac UEFI systems                                         |
|         -   6.2.1 efibootmgr                                             |
|                                                                          |
| -   7 Linux Bootloaders for UEFI                                         |
| -   8 EFI System Partition                                               |
|     -   8.1 For GPT partitioned disks                                    |
|     -   8.2 For MBR partitioned disks                                    |
|                                                                          |
| -   9 UEFI Shell                                                         |
|     -   9.1 UEFI Shell download links                                    |
|     -   9.2 Launching UEFI Shell                                         |
|     -   9.3 Important UEFI Shell Commands                                |
|         -   9.3.1 bcfg                                                   |
|         -   9.3.2 edit                                                   |
|                                                                          |
| -   10 Hardware Compatibility                                            |
| -   11 Create UEFI bootable USB from ISO                                 |
|     -   11.1 Fixing errors                                               |
|                                                                          |
| -   12 Remove UEFI boot support from ISO                                 |
| -   13 QEMU with OVMF                                                    |
| -   14 See also                                                          |
+--------------------------------------------------------------------------+

Booting an OS using BIOS
------------------------

A BIOS or Basic Input-Output System is the very first program that is
executed once the system is switched on. After all the hardware has been
initialized and the POST operation has completed, the BIOS executes the
first boot code in the first device in the device booting list.

If the list starts with a CD/DVD drive, then the El-Torito entry in the
CD/DVD is executed. This is how bootable CD/DVD works. If the list
starts with a HDD, then BIOS executes the very first 440 bytes MBR boot
code. The boot code then chainloads or bootstraps a much larger and
complex bootloader which then loads the OS.

Basically, the BIOS does not know how to read a partition table or
filesystem. All it does is initialize the hardware, then load and run
the 440-byte boot code.

> Multiboot on BIOS

Since very little can be achieved by a program that fits into the
440-byte boot code area, multi-booting using BIOS requires a multi-boot
capable bootloader (multi-boot refers to booting multiple operating
systems, not to booting a kernel in the Multiboot format specified by
the GRUB developers). So usually a common bootloader like GRUB or
Syslinux or LILO would be loaded by the BIOS, and it would load an
operating system by either chain-loading or directly loading the kernel.

Booting an OS using UEFI
------------------------

UEFI firmware does not support booting through the above mentioned
method which is the only way supported by BIOS. UEFI has support for
reading both the partition table as well as understanding filesystems.

The commonly used UEFI firmwares support both MBR and GPT partition
table. EFI in Apple-Intel Macs are known to also support Apple Partition
Map besides MBR and GPT. Most UEFI firmwares have support for accessing
FAT12 (floppy disks), FAT16 and FAT32 filesystems in HDDs and ISO9660
(and UDF) in CD/DVDs. EFI in Apple-Intel Macs can access HFS/HFS+
filesystems also apart from the mentioned ones.

UEFI does not launch any boot code in the MBR whether it exists or not.
Instead it uses a special partition in the partition table called EFI
SYSTEM PARTITION in which files required to be launched by the firmware
are stored. Each vendor can store its files under
<EFI SYSTEM PARTITION>/EFI/<VENDOR NAME>/ folder and can use the
firmware or its shell (UEFI shell) to launch the boot program. An EFI
System Partition is usually formatted as FAT32.

Note:On some UEFI systems the only possible way to launch UEFI
application on boot (if it doesn't have custom entry in UEFI boot menu)
is to put it in this fixed location:
<EFI SYSTEM PARTITION>/EFI/boot/bootx64.efi (for 64-bit x86 system)

Under UEFI, every program whether it is an OS loader or an utility (e.g.
a memory testing app or recovery tool), should be an UEFI Application
corresponding to the EFI firmware architecture. The vast majority of
UEFI firmwares, including recent Apple Macs, use x86_64 EFI firmware.
The only known devices that use i386 EFI are older (pre 2008) Apple
Macs.

Note:Some older Intel Server boards are known to operate on Intel EFI
1.10 firmware, and require i386 EFI applications.

A x86_64 EFI firmware does not include support for launching 32-bit EFI
apps unlike x86_64 Linux and Windows versions which include such
support. Therefore the bootloader must be compiled for that specific
architecture.

> Multibooting on UEFI

Since each OS or vendor can maintain its own files within the EFI SYSTEM
PARTITION without affecting the other, multi-booting using UEFI is just
a matter of launching a different UEFI application corresponding to the
particular OS's bootloader. This removes the need for relying on
chainloading mechanisms of one bootloader to load another to switch
OSes.

Multibooting Windows and Linux

64-bit Windows Vista (SP1+), Windows 7 and Windows 8 versions support
booting using UEFI firmware. These Windows versions support either
UEFI-GPT booting or BIOS-MBR booting. 32-bit Windows versions only
support BIOS-MBR booting. See http://support.microsoft.com/kb/2581408
for more info.

This limitation does not exist in Linux Kernel but rather depends on the
bootloader used. For the sake of Windows UEFI booting, the Linux
bootloader used should also be installed in UEFI-GPT mode if booting
from the same disk.

Boot Process under UEFI
-----------------------

1.  System switched on - Power On Self Test, or POST process.
2.  UEFI firmware is loaded.
3.  Firmware reads its Boot Manager to determine which UEFI application
    to be launched and from where (ie. from which disk and partition).
4.  Firmware launches the UEFI application from the FAT32 formatted
    UEFISYS partition as defined in the boot entry in the firmware's
    boot manager.
5.  UEFI application may launch another application (in case of UEFI
    Shell or a boot manager like rEFInd) or the kernel and initramfs (in
    case of a bootloader like GRUB) depending on how the UEFI
    application was configured.

Detecting UEFI Firmware Arch
----------------------------

If you have a non-Mac UEFI system, then you most likely have a x86_64
(aka 64-bit) UEFI 2.x firmware. A few known x86_64 UEFI 2.x firmwares
are Phoenix SecureCore Tiano, AMI Aptio and Insyde H2O.

Pre-2008 Macs mostly have i386-efi firmware while >=2008 Macs have
mostly x86_64-efi. All Macs capable of running Mac OS X Snow Leopard
64-bit Kernel have x86_64 EFI 1.x firmware.

To find out the arch of the efi firmware in a Mac, type the following
into the terminal:

    ioreg -l -p IODeviceTree | grep firmware-abi

If the command returns EFI32 then it is i386 EFI 1.x firmware. If it
returns EFI64 then it is x86_64 EFI 1.x firmware. Macs do not have UEFI
2.x firmware as Apple's EFI implementation is not fully compliant with
UEFI Specification.

UEFI Support in Linux Kernel
----------------------------

> Linux Kernel config options for UEFI

The required Linux Kernel configuration options for UEFI systems are :

    CONFIG_EFI=y
    CONFIG_EFI_STUB=y
    CONFIG_RELOCATABLE=y
    CONFIG_FB_EFI=y
    CONFIG_FRAMEBUFFER_CONSOLE=y

UEFI Runtime Variables/Services Support - 'efivars' kernel module . This
option is important as this is required to manipulate UEFI Runtime
Variables using tools like efibootmgr.

    CONFIG_EFI_VARS=y

Note: This option is compiled built-in into the Arch core/testing
kernel.

Note:For Linux to access UEFI Runtime Services, the UEFI Firmware
processor architecture and the Linux kernel processor architecture must
match. This is independent of the bootloader used.

Note:If the UEFI Firmware arch and Linux Kernel arch are different, then
the "noefi" kernel parameter must be used to avoid the kernel panic and
boot successfully. The "noefi" option instructs the kernel not to access
the UEFI Runtime Services.

GUID Partition Table GPT config option - mandatory for UEFI support

    CONFIG_EFI_PARTITION=y

Note:All of the above options are required to boot Linux via UEFI, and
are enabled in Archlinux kernels in official repos.

Retrieved from
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob_plain;f=Documentation/x86/x86_64/uefi.txt;hb=HEAD
.

UEFI Variables Support
----------------------

UEFI defines variables through which an operating system can interact
with the firmware. UEFI Boot Variables are used by the boot-loader and
used by the OS only for early system start-up. UEFI Runtime Variables
allow an OS to manage certain settings of the firmware like the UEFI
Boot Manager or managing the keys for UEFI Secure Boot Protocol etc.

Note:The below steps will not work if the system has been booted in BIOS
mode and will not work if the UEFI processor architecture does not match
the kernel one, i.e. x86_64 UEFI + x86 32-bit Kernel and vice-versa
config will not work. This is true only for efivars kernel module and
efibootmgr step. The other steps (ie. upto setting up
<UEFISYS>/EFI/arch/refind/{refindx64.efi,refind.conf} ) can be done even
in BIOS/Legacy boot mode.

Access to UEFI Runtime services is provided by "efivars" kernel module
which is enabled through the CONFIG_EFI_VARS=y kernel config option.
This module exposes the variables under the directory
/sys/firmware/efi/vars (for kernels >=3.8 through
/sys/firmware/efi/efivars). One way to check whether the system has
booted in UEFI boot mode is to check for the existence of
/sys/firmware/efi/vars (and in kernels >=3.8 for
/sys/firmware/efi/efivars)directory with contents similar to :

    Sample output (x86_64-UEFI 2.3.1 in x86_64 Kernel):

    # ls -1 /sys/firmware/efi/vars/
    Boot0000-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    BootCurrent-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    BootOptionSupport-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    BootOrder-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    ConIn-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    ConInDev-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    ConOut-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    ConOutDev-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    ErrOutDev-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    Lang-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    LangCodes-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    MTC-eb704011-1402-11d3-8e77-00a0c969723b/
    MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa/
    PlatformLang-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    PlatformLangCodes-8be4df61-93ca-11d2-aa0d-00e098032b8c/
    RTC-378d7b65-8da9-4773-b6e4-a47826a833e1/
    del_var
    new_var

The UEFI Runtime Variables will not be exposed to the OS if you have
used "noefi" kernel parameter in the boot-loader menu. This parameter
instructs the kernel to completely ignore UEFI Runtime Services.

> Userspace Tools

There are few tools that can access/modify the UEFI variables, namely

1.  efibootmgr - Used to create/modify boot entries in the UEFI Boot
    Manager - efibootmgr or efibootmgr-git
2.  uefivars - simply dumps the variables - uefivars-git - uses
    efibootmgr library
3.  Ubuntu's Firmware Test Suite - fwts - fwts-git - uefidump command -
    fwts uefidump

> Non-Mac UEFI systems

efibootmgr

Warning:Using efibootmgr in Apple Macs will brick the firmware and may
need reflash of the motherboard ROM. There have been bug reports
regarding this in Ubuntu/Launchpad bug tracker. Use bless command alone
in case of Macs. Experimental "bless" utility for Linux by Fedora
developers - mactel-boot.

Note:efibootmgr command will work only if you have booted the system in
UEFI mode itself, since it requires access to UEFI Runtime Variables
which are available only in UEFI boot mode (with "noefi" kernel
parameter NOT being used). Otherwise the message
Fatal: Couldn't open either sysfs or procfs directories for accessing EFI variables
is shown.

Note: If you are unable to use efibootmgr, some UEFI BIOSes allow users
to directly manage uefi boot options from within the BIOS. For example,
some ASUS BIOSes have a "Add New Boot Option" choice which enables you
to select a local EFI system partition and manually enter the EFI stub
location. (for example '\EFI\refind\refind_x64.efi')

Initially the user may be required to manually launch the boot-loader
from the firmware itself (using maybe the UEFI Shell) if the UEFI
boot-loader was installed when the system is booted in BIOS mode. Then
efibootmgr should be run to make the UEFI boot-loader entry as the
default entry in the UEFI Boot Manager.

To use efibootmgr, first load the 'efivars' kernel module (if compiled
as a external module):

    # modprobe efivars

If you get no such device found error for this command, that means you
have not booted in UEFI mode or due to some reason the kernel is unable
to access UEFI Runtime Variables (noefi?).

Verify whether there are files in /sys/firmware/efi/vars/ (and
/sys/firmware/efi/efivars/ for kernel >=3.8) directory. This directory
and its contents are created by "efivars" kernel module and it will
exist only if you have booted in UEFI mode, without the "noefi" kernel
parameter.

If /sys/firmware/efi/vars/ directory is empty or does not exist, then
efibootmgr command will not work. If you are unable to make the
ISO/CD/DVD/USB boot in UEFI mode try #Create_UEFI_bootable_USB_from_ISO.

Note: The below commands use gummiboot boot-loader as example.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Gummiboot has    
                           its own installer now,   
                           therefore the following  
                           instructions should not  
                           be used to install       
                           gummiboot. This example  
                           should be changed to use 
                           something else.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Assume the boot-loader file to be launched is
/boot/efi/EFI/gummiboot/gummibootx64.efi.
/boot/efi/EFI/gummiboot/gummibootx64.efi can be split up as /boot/efi
and /EFI/gummiboot/gummibootx64.efi, wherein /boot/efi is the mountpoint
of the UEFI System Partition, which is assumed to be /dev/sdXY (here X
and Y are just placeholders for the actual values - eg:- in /dev/sda1 ,
X=a Y=1).

To determine the actual device path for the UEFI System Partition
(should be in the form /dev/sdXY), try :

    # findmnt /boot/efi
    TARGET SOURCE  FSTYPE OPTIONS
    /boot/efi  /dev/sdXY  vfat         rw,flush,tz=UTC

Then create the boot entry using efibootmgr as follows :

    # efibootmgr -c -g -d /dev/sdX -p Y -w -L "Gummiboot" -l '\EFI\gummiboot\gummibootx64.efi'

In the above command /boot/efi/EFI/gummiboot/gummibootx64.efi translates
to /boot/efi and /EFI/gummiboot/gummibootx64.efi which in turn translate
to drive /dev/sdX -> partition Y -> file
/EFI/gummiboot/gummibootx64.efi.

UEFI uses backward slash as path separator (similar to Windows paths).

The 'label' is the name of the menu entry shown in the UEFI boot menu.
This name is user's choice and does not affect the booting of the
system. More info can be obtained from efibootmgr GIT README .

FAT32 filesystem is case-insensitive since it does not use UTF-8
encoding by default. In that case the firmware uses capital 'EFI'
instead of small 'efi', therefore using \EFI\gummiboot\gummibootx64.efi
or \efi\gummiboot\gummibootx64.efi does not matter (this will change if
the filesystem encoding is UTF-8).

Linux Bootloaders for UEFI
--------------------------

See UEFI Bootloaders.

EFI System Partition
--------------------

Note:UEFI System Partition and EFI System Partition (ESP) are same, the
terminologies are used interchangeably in some places.

Note:The EFI System Partition can be of any size supported by FAT32
filesystem. According to Microsoft Documentation, the minimum
partition/volume size for FAT32 is 512 MiB. However ESP with size >=100
MiB but formatted as FAT32 are also allowed by many Linux distros and by
Microsoft Windows, hence smaller partitions are fine. However >=512 MiB
size for ESP is recommended for most compatibility. Non-FAT filesystems
like ext2/3/4, reiserfs, NTFS, UDF etc. are not supported for ESP.

Note:The ESP should be accessible by the UEFI firmware, which cannot
read LVM and software RAID systems.

Note:If you are using Linux EFISTUB booting, then you need to make sure
there is adequate space available for keeping the Kernel and Initramfs
files in the ESP.

Note:Setting "boot" flag in parted in a MBR partition marks that
partition as active, while the same "boot" flag in a GPT partition marks
that partition as "UEFI System Partition".

> For GPT partitioned disks

Two choices:

-   Using GNU Parted/GParted: Create a FAT32 partition. Set "boot" flag
    on for that partition.
-   Using GPT fdisk (aka gdisk): Create a partition with partition type
    EF00. Then format that partition as FAT32 using
    mkfs.vfat -F32 /dev/<THAT_PARTITION>

> For MBR partitioned disks

Note:It is recommended to use always GPT for UEFI boot as some UEFI
firmwares do not allow UEFI-MBR boot.

Two choices:

-   Using GNU Parted/GParted: Create FAT32 partition. Change the type
    code of that partition to 0xEF using fdisk, cfdisk or sfdisk.
-   Using fdisk: Create a partition with partition type 0xEF. Then
    format that partition as FAT32 using
    mkfs.vfat -F32 /dev/<THAT_PARTITION>

UEFI Shell
----------

The UEFI Shell is a shell/terminal for the firmware which allows
launching uefi applications which include uefi bootloaders. Apart from
that, the shell can also be used to obtain various other information
about the system or the firmware like memory map (memmap), modifying
boot manager variables (bcfg), running partitioning programs (diskpart),
loading uefi drivers, editing text files (edit), hexedit etc.

> UEFI Shell download links

You can download a BSD licensed UEFI Shell from Intel's Tianocore
UDK/EDK2 Sourceforge.net project.

-   x86_64 UEFI Shell 2.0 (Beta) - Alternate download link (compiled
    from SVN repo, try this link if the file downloaded from previous
    link does not work in your system)

-   x86_64 UEFI Shell 1.0 (Old)
-   i386 UEFI Shell 2.0 (Beta)
-   i386 UEFI Shell 1.0 (Old)

Shell 2.0 works only in UEFI 2.3+ systems and is recommended over Shell
1.0 in those systems. Shell 1.0 should work in all UEFI systems
irrespective of the spec. version the firmware follows. More info at
ShellPkg and this mail

> Launching UEFI Shell

Few Asus and other AMI Aptio x86_64 UEFI firmware based motherboards
(from Sandy Bridge onwards) provide an option called
"Launch EFI Shell from filesystem device" . For those motherboards,
download the x86_64 UEFI Shell and copy it to your UEFI SYSTEM PARTITION
as <UEFI_SYSTEM_PARTITION>/shellx64.efi (mostly /boot/efi/shellx64.efi)
.

Systems with Phoenix SecureCore Tiano UEFI firmware are known to have
embedded UEFI Shell which can be launched using either F6, F11 or F12
key.

Note:If you are unable to launch UEFI Shell from the firmware directly
using any of the above mentioned methods, create a FAT32 USB pen drive
with Shell.efi copied as (USB)/efi/boot/bootx64.efi . This USB should
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
Specification 2.0" pdf document.

Note: Users are recommended to try bcfg only if efibootmgr fails to
create working boot entries in their system.

Note: UEFI Shell 1.0 does not support bcfg command.

To dump a list of current boot entries -

    Shell> bcfg boot dump -v

To add a boot menu entry for rEFInd (for example) as 4th (numbering
starts from zero) option in the boot menu

    Shell> bcfg boot add 3 fs0:\EFI\refind\refind_x64.efi "rEFInd"

where fs0: is the mapping corresponding to the UEFI System Partition and
fs0:\EFI\refind\refind_x64.efi is the file to be launched.

To remove the 4th boot option

    Shell> bcfg boot rm 3

To move the boot option #3 to #0 (i.e. 1st or the default entry in the
UEFI Boot menu)

    Shell> bcfg boot mv 3 0

For bcfg help text

    Shell> help bcfg -v -b

or

    Shell> bcfg -? -v -b

edit

EDIT command provides a basic text editor with an interface similar to
nano text editor, but slightly less functional. It handles UTF-8
encoding and takes care or LF vs CRLF line endings.

To edit, for example rEFInd's refind.conf in the UEFI System Partition
(fs0: in the firmware)

    Shell> fs0:
    FS0:\> cd \EFI\arch\refind
    FS0:\EFI\arch\refind\> edit refind.conf

Type Ctrl-E for help.

Hardware Compatibility
----------------------

Main page HCL/Firmwares/UEFI

Create UEFI bootable USB from ISO
---------------------------------

Note:The instructions below are specifically for Archiso/official media;
Archboot preparation is identical, with this refind.conf instead of the
one mentioned below (which is for Archiso) and without the filesystem
label requirement.

Note:The USB can use either MBR or GPT partition table (so it is fine to
use an already partitioned USB). The filesystem should be either FAT32
(recommended) or FAT16. FAT12 is designed for floppy drives and
therefore not recommended for USB drives.

First create a partition table and at most one partition in the USB.
Mount the ISO image from the Arch Linux download page.

    # mkdir -p /mnt/{usb,iso}
    # mount -o loop archlinux-2012.12.01-dual.iso /mnt/iso

Then create a FAT32 filesystem in the partition on the USB (unmount
before if necessary) with LABEL as used in the Archiso configuration.
Obtain the label from /mnt/iso/loader/entries/archiso-x86_64.conf; this
is used by the archiso hook in initramfs to identify the udev path to
the installation media. mkfs.vfat is part of package dosfstools.

    # awk 'BEGIN {FS="="} /archisolabel/ {print $3}' /mnt/iso/loader/entries/archiso-x86_64.conf | xargs mkfs.vfat -F32 /dev/sdXY -n

Mount the newly created FAT32 USB partition, and copy the contents of
the installation media to the USB media.

    # mount /dev/sdXY /mnt/usb
    # cp -a /mnt/iso/* /mnt/usb
    # sync
    # umount /mnt/{usb,iso}

  

> Fixing errors

If you find the error: "No loader found. Configuration files in
/loader/entries/*.conf are needed." A possible fix is to use a different
uefi bootloader to the included one, gummiboot.

Download refind-efi pkg and extract the file
/usr/lib/refind/refind_x64.efi from within the package to
(USB)/EFI/boot/bootx64.efi (overwrite or rename any existing
(USB)/EFI/boot/bootx64.efi file).

Then copy this text to EFI/boot/refind.conf. Take care that the label in
the Arch menu section (ARCH_201304 here) matches that of your usb's.

    refind.conf

    timeout 5
    textonly

    showtools about,reboot,shutdown,exit
    # scan_driver_dirs EFI/tools/drivers_x64
    scanfor manual,internal,external,optical

    scan_delay 1
    dont_scan_dirs EFI/boot

    max_tags 0
    default_selection "Arch Linux Archiso x86_64 UEFI USB"

    menuentry "Arch Linux Archiso x86_64 UEFI USB" {
      loader /arch/boot/x86_64/vmlinuz
      initrd /arch/boot/x86_64/archiso.img
      ostype Linux
      graphics off
      options "archisobasedir=arch archisolabel=ARCH_201304 add_efi_memmap"
    }

    menuentry "UEFI x86_64 Shell v2" {
      loader /EFI/shellx64_v2.efi
      graphics off
    }

    menuentry "UEFI x86_64 Shell v1" {
      loader /EFI/shellx64_v1.efi
      graphics off
    }

You should now be able to successfully boot, and you can choose which
EFI you'd like to load.

Remove UEFI boot support from ISO
---------------------------------

Warning:In the event that UEFI+isohybrid El Torito/MBR really causes
problems, it would be better to just UEFI boot using the USB stick
instructions in the previous section

Most of the 32-bit EFI Macs and some 64-bit EFI Macs refuse to boot from
a UEFI(X64)+BIOS bootable CD/DVD. If one wishes to proceed with the
installation using optical media, it might be necessary to remove UEFI
support first.

Mount the official installation media and obtain the archisolabel as
shown in the previous section.

Rebuild the ISO using xorriso from libisoburn:

    $ xorriso -as mkisofs -iso-level 3 \
        -full-iso9660-filenames\
        -volid "ARCH_201212" \
        -appid "Arch Linux CD" \
        -publisher "Arch Linux <https://www.archlinux.org>" \
        -preparer "prepared like a BAWSE" \
        -eltorito-boot isolinux/isolinux.bin \
        -eltorito-catalog isolinux/boot.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        -isohybrid-mbr "/mnt/iso/isolinux/isohdpfx.bin" \
        -output "~/archiso.iso" "/mnt/iso/"

Burn ~/archiso.iso to optical media and proceed with installation
normally.

QEMU with OVMF
--------------

OVMF [1] is a project to enable UEFI support for Virtual Machines. OVMF
contains a sample UEFI firmware for QEMU and KVM.

You can build OVMF from AUR [2] and use it like this:

    qemu-system-x86_64 -bios /usr/share/ovmf/bios.bin ...

See also
--------

-   Wikipedia's page on UEFI
-   Wikipedia's page on UEFI SYSTEM Partition
-   Linux Kernel UEFI Documentation
-   UEFI Forum - contains the official UEFI Specifications - GUID
    Partition Table is part of UEFI Specification
-   Intel's Tianocore Project for Open-Source UEFI firmware which
    includes DuetPkg for direct BIOS based booting and OvmfPkg used in
    QEMU and Oracle VirtualBox
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
-   Some useful 32-bit UEFI Shell utilities
-   LPC 2012 Plumbing UEFI into Linux
-   LPC 2012 UEFI Tutorial : part 1
-   LPC 2012 UEFI Tutorial : part 2

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unified_Extensible_Firmware_Interface&oldid=255009"

Category:

-   Boot process
