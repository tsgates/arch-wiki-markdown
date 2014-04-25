Arch Boot Process
=================

Related articles

-   Boot Loaders
-   Master Boot Record
-   GUID Partition Table
-   Unified Extensible Firmware Interface
-   mkinitcpio
-   systemd
-   fstab
-   Autostarting

In order to boot Arch Linux, a Linux-capable boot loader such as GRUB or
Syslinux must be installed to the Master Boot Record or the GUID
Partition Table. The boot loader is responsible for loading the kernel
and initial ramdisk before initiating the boot process. The procedure is
quite different for BIOS and UEFI systems, the detailed description is
given on this or linked pages.

Contents
--------

-   1 Firmware types
    -   1.1 BIOS
    -   1.2 UEFI
-   2 Boot process
    -   2.1 Under BIOS
    -   2.2 Under UEFI
-   3 Kernel
-   4 initramfs
-   5 Init process
-   6 Getty
-   7 Display Manager
-   8 Login
-   9 Shell
-   10 xinit
-   11 See also

Firmware types
--------------

> BIOS

A BIOS or Basic Input-Output System is the very first program (firmware)
that is executed once the system is switched on. In most cases it is
stored in a flash memory in the motherboard itself and independent of
the system storage. BIOS launches the first 440 bytes (Master Boot
Record) of the first disk in the BIOS disk order. Since very little can
be achieved by a program that fits into the 440-byte boot code area,
usually a common boot loader like GRUB or Syslinux or LILO would be
loaded by the BIOS, and it would load an operating system by either
chain-loading or directly loading the kernel.

> UEFI

UEFI has support for reading both the partition table as well as
understanding filesystems. Hence it is not limited by 440 byte code
limitation (MBR boot code) as in BIOS systems. It does not use the MBR
boot code at all.

The commonly used UEFI firmwares support both MBR and GPT partition
table. EFI in Apple-Intel Macs are known to also support Apple Partition
Map besides MBR and GPT. Most UEFI firmwares have support for accessing
FAT12 (floppy disks), FAT16 and FAT32 filesystems in HDDs and ISO9660
(and UDF) in CD/DVDs. EFI in Intel Macs can also access HFS/HFS+
filesystems, in addition to the mentioned ones.

UEFI does not launch any boot code in the MBR whether it exists or not.
Instead it uses a special partition in the partition table called EFI
System Partition in which files required to be launched by the firmware
are stored. Each vendor can store its files under
<EFI SYSTEM PARTITION>/EFI/<VENDOR NAME>/ folder and can use the
firmware or its shell (UEFI shell) to launch the boot program. An EFI
System Partition is usually formatted as FAT32 or (less commonly) FAT16.

Under UEFI, every program whether it is an OS loader or a utility (e.g.
a memory testing app or recovery tool), should be a UEFI Application
corresponding to the EFI firmware bitness/architecture. The vast
majority of UEFI firmwares, including recent Apple Macs, use x86_64 EFI
firmware. The only known devices that use IA32 (32-bit) EFI are older
(pre 2008) Apple Macs, some Intel Cloverfield ultrabooks and some older
Intel Server boards are known to operate on Intel EFI 1.10 firmware.

An x86_64 EFI firmware does not include support for launching 32-bit EFI
apps (unlike x86_64 Linux and Windows versions which include such
support). Therefore the UEFI application must be compiled for that
specific firmware processor bitness/architecture.

Boot process
------------

> Under BIOS

1.  System switched on - Power-on self-test or POST process
2.  After POST, BIOS initializes the necessary system hardware for
    booting (disk, keyboard controllers etc.)
3.  BIOS launches the first 440 bytes (Master Boot Record) of the first
    disk in the BIOS disk order
4.  The MBR boot code then takes control from BIOS and launches its next
    stage code (if any) (mostly boot loader code)
5.  The launched (2nd stage) code (actual boot loader) then reads its
    support and config files
6.  Based on the data in its config files, the boot loader loads the
    kernel and initramfs into system memory (RAM) and launches the
    kernel

> Under UEFI

See the main page: Unified Extensible Firmware Interface#Boot Process
under UEFI.

Kernel
------

The kernel is the core of an operating system. It functions on a low
level (kernelspace) interacting between the hardware of the machine and
the programs which use the hardware to run. To make efficient use of the
CPU, the kernel uses a scheduler to arbitrate which tasks take priority
at any given moment, creating the illusion of many tasks being executed
simultaneously.

initramfs
---------

After the kernel is loaded, it unpacks the initramfs (initial RAM
filesystem), which becomes the initial root filesystem. The kernel then
executes /init as the first process. The early userspace starts.

The purpose of the initramfs is to bootstrap the system to the point
where it can access the root filesystem (see FHS for details). This
means that any modules that are required for devices like IDE, SCSI,
SATA, USB/FW (if booting from an external drive) must be loadable from
the initramfs if not built into the kernel; once the proper modules are
loaded (either explicitly via a program or script, or implicitly via
udev), the boot process continues. For this reason, the initramfs only
needs to contain the modules necessary to access the root filesystem; it
does not need to contain every module one would ever want to use. The
majority of modules will be loaded later on by udev, during the init
process.

Init process
------------

At the final stage of early userspace, the real root is mounted, and
then replaces the initial root filesystem. /sbin/init is executed,
replacing the /init process. Arch uses systemd as the init process.

Getty
-----

init calls getty once for each virtual terminal (typically six of them),
which initializes each tty and asks for a username and password. Once
the username and password are provided, getty checks them against
/etc/passwd, then calls login, which begins a session for the user, and
executes the user's shell according to /etc/passwd. Alternatively, getty
may start a display manager if one is present on the system.

Display Manager
---------------

If a display manager is installed, it will be executed on the configured
tty, replacing the getty login prompt. If there is no display manager,
getty will prompt the user for credentials by itself in a text-based
manner, and proceed to call login itself.

Login
-----

The login program begins a session for the user by setting environment
variables and starting the user's shell, based on /etc/passwd.

Shell
-----

Once the user's shell is started, it will typically run a runtime
configuration file, such as .bashrc, before presenting a prompt to the
user. If the account is configured to Start X at Login, the runtime
configuration file will call startx or xinit.

xinit
-----

xinit runs the user's .xinitrc runtime configuration file, which
normally starts a window manager. When the user is finished and exits
the window manager, xinit, startx, the shell, and login will terminate
in that order, returning to getty.

See also
--------

-   Early Userspace in Arch Linux
-   Inside the Linux boot process
-   Boot with GRUB
-   Wikipedia:Linux startup process
-   Wikipedia:initrd
-   Boot Linux Grub Into Single User Mode

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Boot_Process&oldid=292937"

Categories:

-   Boot process
-   About Arch

-   This page was last modified on 15 January 2014, at 01:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
