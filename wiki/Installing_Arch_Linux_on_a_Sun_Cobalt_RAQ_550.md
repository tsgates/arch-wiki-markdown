Installing Arch Linux on a Sun Cobalt RAQ 550
=============================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This document explains how you can install Arch Linux on a Sun Cobalt
RAQ 550 machine.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 About the RAQ 550                                                  |
|     -   1.1 About the processor                                          |
|     -   1.2 Jumpers on the RaQ 550                                       |
|                                                                          |
| -   2 Terminology                                                        |
| -   3 Requirements                                                       |
| -   4 Setting up your serial port                                        |
| -   5 How the RAQ 550 boots                                              |
|     -   5.1 Booting from hard disk                                       |
|     -   5.2 Booting from network                                         |
|                                                                          |
| -   6 Important note about drive assignements                            |
| -   7 Installing without RAID                                            |
|     -   7.1 Moving the RAQ 550 hard drive                                |
|     -   7.2 Installing the base system                                   |
|         -   7.2.1 Partitioning                                           |
|         -   7.2.2 Installation, continued                                |
|         -   7.2.3 System configuration                                   |
|                                                                          |
|     -   7.3 Install the linux-raq550 kernel                              |
|     -   7.4 Configure the serial port for terminal access                |
|     -   7.5 Put the RAQ 550 harddrive back                               |
|     -   7.6 Configuring the firmware                                     |
|                                                                          |
| -   8 Notes                                                              |
|     -   8.1 What about the LCD/Front panel?                              |
|     -   8.2 What about earlier RAQ servers, like the RAQ 4?              |
|     -   8.3 Post-install cleanup                                         |
|     -   8.4 Using your own kernel                                        |
|                                                                          |
| -   9 Resources                                                          |
+--------------------------------------------------------------------------+

About the RAQ 550
-----------------

The Sun Cobalt RAQ 550 is actually just standard PC hardware with
customized firmware and board layout. It contains a ServerWorks CSB5
dual channel IDE controller. It has no VGA adaptor, although there is a
PCI slot where you could install one (and you would be able to use it).
A RAQ 550 comes with the following specifications:

-   Processor: Intel Pentium 3 1 Ghz (256 kB Cache) or 1,26 Ghz (512 kB
    Cache). (That last one is pretty rare because of Intel's limited
    production of Tuatulatin cores)
-   Memory: Supports up to 2 GB of registered ECC PC133 SDRAM. It will
    not take non-ECC modules, I've tried.
-   Disks: Supports 2 LBA24 IDE disks (LBA24 means it only uses 24 bits
    for addressing, thus it only supports a maximum of ~137 GB. This is
    a hardware limitation)
-   Expansion: 1 x PCI 33 Mhz, 64 Bit (266 mB/s)
-   Network: 2 x National Semiconductor DP83815 Fast Ethernet (linux
    module natsemi)

You can get them second hand for a good price these days.

> About the processor

The original RAQ 550 came shipped with a Pentium 3 1 Ghz (Coppermine) or
a Pentium 3 1,26 Ghz (Tuatulatin). However, there's no reason why you
can't replace the processor with something else. I tested a celeron 1,2
Ghz (Tuatulatin) and it works. The celeron only has 100 Mhz FSB, and I
haven't found a way yet to force the FSB to be 133 Mhz. I believe
anything that's Coppermine or Tuatulatin should work.

> Jumpers on the RaQ 550

The RaQ 550 has two jumpers that are soldered, JP1 and JP8.

-   JP1: On: Sets the FSB to 100 Mhz, Off: Sets the FSB to AUTO
-   JP8: Doesn't seem to do anything on and off

Terminology
-----------

Keep these things in mind, they can be confusing:

-   boot kernel/firmware: This is the software loaded on the system's
    EEPROM. This is basically a modified linux kernel.
-   load kernel: This is the kernel that the firmware will try to load.
    You can use your own kernel here.

Requirements
------------

-   One Sun Cobalt RAQ 550
-   One hard drive
-   One Arch Linux installer CD
-   Another computer
-   One crazy admin

Firmware requirements: I haven't tested this with the original firmware
that normally ships with the RAQ 550, because mine already came with
updated (unofficial) firmware. Updating the firmware is beyond the scope
of this document. BIG FAT WARNING: If the firmware update process goes
wrong and you reboot your system, you just have turned your RAQ 550 into
a piece of junk. The only way to fix it would be to desolder the flash
chip and have it flashed again with correct firmware. If your firmware
works for you, I recommend not touching it.

Setting up your serial port
---------------------------

The RAQ 550 has two serial ports, which the first one (marked with a
single dot) serves as console access. Configure your terminal
application to use 115200 baudrate, 8 bits, no parity and 1 stop bit
(115200 8N1). Use screen: screen /dev/ttyS0 115200. This serial port
setting is hardcoded and cannot be changed.

How the RAQ 550 boots
---------------------

Booting from hard disk

The firmware is actually a modified linux kernel, serving as a
bootloader. It will search for

-   vmlinux.gz
-   vmlinux.bz2
-   /boot/vmlinux.gz
-   /boot/vmlinux.bz2

on the first partition of the first disk, so this means the boot kernel
needs to be able to read the filesystem where your load kernel resides.
This limits the filesystems you can use where the load kernel resides to
the filesystems that the firmware supports. Customized firmware may
support other filesystems, cobalt's official software only supports
ext2. Use ext2. If you have a seperate /boot, you can use whatever
filesystem for / that the load kernel supports.

Booting from network

As you might have noticed, the RAQ 550 supports "netbooting". But it's
not the netbooting you would expect, it doesn't use PXE. It uses its
firmware kernel and tries to set it up with an NFS (Network File System)
root.

Important note about drive assignements
---------------------------------------

The firmware's kernel uses the "old" style harddisk notation, for
example hda2. The linux-raq550 kernel uses the newer libata drivers,
causing the harddrive assignements to become for example sda2. Keep this
in mind when you're configuring the firmware and fstab.

Installing without RAID
-----------------------

> Moving the RAQ 550 hard drive

The easiest way for installing Arch Linux is to take out the hard drive,
put it in another computer and install Arch Linux from there. If you
know what you're doing you can install it any way you want, this article
only covers installation via the Arch Linux installer CD. Put the hard
drive in the other computer and start the install CD.

> Installing the base system

Select your method of installation (I always use FTP installs) and
proceed with the installation as usual.

Partitioning

When it's time to partition your harddrive, the partition where the
kernel resides must be supported by the firmware (see #How the RAQ 550
boots). Unless you're running modified firmware, the built in firmware
only supports ext2 (ext3 is backwards compatible). The kernel must also
be located on the first partition.

-   Load kernel must be located on the first partition
-   Filesystem of the first partition must be supported by the firmware
-   Kernel must have a specific name (see "How the RAQ 550 boots")

Installation, continued

Skip the install kernel and install bootloader step. You do not need a
bootloader (the firmware is the bootloader) and the stock arch kernel
doesn't work because the firmware doesn't support initial ramdisks.

System configuration

Important: Check your fstab file to have the correct harddrive notation.
See #Important note about drive assignements!

> Install the linux-raq550 kernel

Exit the installation and chroot to your new system. Configure pacman's
mirrorlist and run

    # chroot /mnt /bin/bash
    # nano -w /etc/pacman.d/mirrorlist
    # pacman -Sy

After that, add the redshift repository to your pacman.conf file:

    [redshift]
    Server = http://archserver.be/packages/redshift/i686

Then install the linux-raq550 package:

    # pacman -S linux-raq550

> Configure the serial port for terminal access

We're not done yet. We need to configure init to spawn a terminal on the
serial port. Add this to your /etc/inittab:

    s0:0123456:respawn:/sbin/agetty -8 -L 115200 ttyS0 vt100

That will spawn agetty vt100 on the first serial port with a linespeed
of 115200 bits/s and assume the line is 8 bit clean. You can comment out
the virtual consoles (the vc/n) ones if you do not intend on using them.

Notice that you won't be able to log in as root on the serial. In order
to allow root to login from the serial add that serial port to
/etc/securetty

It's useful to already setup sshd. Don't forget to set a password for
root (sshd denies passwordless logins by default), and do not forget
about hosts.deny.

> Put the RAQ 550 harddrive back

Put the RAQ 550 harddrive back in its place, connect the serial cable
and power up the system.

> Configuring the firmware

Now you'll need to configure the firmware and set your root device. Pay
close attention to the startup messages and press the space bar to enter
the system rom menu mode. Type boot and then set_root_dev to set the
root device. For example:

    Press spacebar to enter ROM mode

    Cobalt:Main Menu> boot
    Cobalt:Boot Menu> set_boot_dev sda3
    Cobalt:Boot Menu> reboot

After this your system should boot up, ready for use.

Notes
-----

What about the LCD/Front panel?

Yes, you can make use of the front panel! The kernel is patched to make
the Sun Cobalt specific hardware work. Install the cobalt-panel-utils to
control the front panel. You can find the cobalt-panels-utils in the
redshift repository. The binaries start with lcd-. See their respective
manpages

What about earlier RAQ servers, like the RAQ 4?

The RAQ 4 and 3 have an AMD K6-2 processor, which do not support the
full i686 instruction set. RAQ 2 and 1 use MIPS processors. Therefore
you cannot use Arch Linux on these RAQ servers.

Post-install cleanup

Because of the customized kernel without an initial ramdisk, you can get
rid of the following packages:

-   linux
-   mkinitcpio
-   klibc-udev
-   klibc-module-init-tools
-   klibc-extras
-   klibc
-   gen-init-cpio
-   grub
-   cpio
-   lilo

And obviously packages like pcmcia-utils.

Using your own kernel

You can use your own compiled kernel, but the compressed size of the
vmlinux file may not be larger than ~1,8 megabytes. Using bzip2 results
in a slightly better compression than gzip. The configuration of the
linux-raq550 kernel is a good starting point, you can find it in
/proc/config.gz

Resources
---------

Unfortunatly, information about the Cobalt RAQ servers is sparse and
scattered. Most documentation insists on using CentOS. Here are some
interesting links:

-   Sun's Cobalt site [1]: Contains the original documentation for the
    raq 550 server.
-   CobaltFAQs [2]
-   Sourceforge Cobalt ROM [3]: New ROM images for your RAQ and flash
    utilities
-   Depopo.net [4]: FAQ site for Cobalt RAQ servers
-   My homepage [5]: Some usefull stuff

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installing_Arch_Linux_on_a_Sun_Cobalt_RAQ_550&oldid=225306"

Category:

-   Getting and installing Arch
