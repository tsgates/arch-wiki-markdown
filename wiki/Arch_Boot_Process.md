Arch Boot Process
=================

> Summary

A chronological overview of the Arch boot process.

> Overview

In order to boot Arch Linux, a Linux-capable boot loader such as
GRUB(2), Syslinux, LILO or GRUB Legacy must be installed to the Master
Boot Record or the GUID Partition Table. The boot loader is responsible
for loading the kernel and initial ramdisk before initiating the boot
process.

> Related

fstab

Systemd

Autostarting

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Bootloader                                                         |
| -   2 Kernel                                                             |
| -   3 initramfs                                                          |
| -   4 Init process                                                       |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Bootloader
----------

After the system is powered-on and the POST is completed, the BIOS
locates the preferred boot medium and transfers control to the Master
Boot Record of this device. On a GNU/Linux machine, often a bootloader
such as GRUB or LILO is found and loaded from the MBR. The bootloader
presents the user with a range of options for boot, e.g. Arch Linux and
Windows on a dual-boot setup. Once Arch is selected, the bootloader
loads the kernel (vmlinuz-linux) and the initial root filesystem image
(initramfs-linux.img) into memory and then starts the kernel, passing in
the memory address of the image.

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
replacing the /init process.

In the past, Arch used SysVinit as the init process. Now on new
installs, Systemd is used by default. Existing SysVinit users are
recommended to switch to systemd.

See also
--------

-   Early Userspace in Arch Linux
-   Inside the Linux boot process
-   Boot with GRUB
-   Wikipedia:Linux startup process
-   Wikipedia:initrd
-   Boot Linux Grub Into Single User Mode

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Boot_Process&oldid=248720"

Categories:

-   Boot process
-   About Arch
