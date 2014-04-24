ASUS UX301LA
============

This page contains information specific to the ASUS Zenbook UX301LA.
Some of it may also be applicable to similar models, depending on the
specific configuration. You might also want to look at ASUS Zenbook
Prime UX31A.

Contents
--------

-   1 Installation
    -   1.1 Booting from USB
    -   1.2 Partitioning
    -   1.3 Installing Arch
-   2 Function Keys
-   3 Intel Graphics
-   4 Battery Issues
-   5 Hardware
-   6 Helpful Links

Installation
------------

The UX301LA and similar models come with Windows 8 pre-installed, using
UEFI and a GUID Partition Table scheme.

> Booting from USB

Boot the machine with the USB medium plugged in. You can try pressing
Escape to get a boot menu and select your USB device. If it's not
showing, then try booting while pressing F2. You will be booted into a
BIOS menu. Go to Boot > Create a boot device and select your USB medium.
You'll have to choose a specific .efi file - for an Arch bootable USB
it's /EFI/boot/bootx64.efi. Then under the Boot tab, change the boot
device you just made to be higher priority than Windows Boot Manager.
Make sure to save your changes on exit, and the system should reboot
into the device.

  

> Partitioning

Whatever partition scheme you desire, make sure to use parted if you
want to keep any of the other existing partitions since fdisk does not
support the GPT scheme already on the machine. If you want to use a
GParted live CD/USB, you will need to run
kpartx -a /dev/mapper/xxx_ASUS_OS as root where the xxx_ASUS_OS is the
node in /dev/mapper other than control before you start the GParted
application.

Note:In Arch, if you have RAID 0 your hard drive device will look
something like /dev/md126 and the partitions will look like
/dev/md126p1.

> Installing Arch

See Installation guide.

If your machine comes with RAID 0 then add mdadm_udev to your HOOKS in
mkinitcpio.conf and rerun mkinitcpio -p linux.

When you install GRUB, follow the instructions for UEFI Systems. Your
ESP (EFI System Partition) should be the first partition in your scheme.

Function Keys
-------------

All function keys except the backlight seem to work out of the box (as
of Arch default kernel 3.12.7) except for backlight. To fix the
backlight keys, add acpi_osi= as a kernel parameter. Example line from
/etc/default/grub:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi_osi="

Intel Graphics
--------------

If you're using GNOME and have issues with screen tearing, check out
GNOME#Tear-free_video_with_Intel_HD_Graphics.

Battery Issues
--------------

Many have been experiencing an issue with the battery not properly
charging under linux. There is a thread about this on the Ubuntu Forums.
Holding down the power button to do a clean reboot seems to be a
workaround, but the issue hasn't been resolved yet, and those who have
sent their laptops in for repair have reported that it didn't resolve
the issue.

Hardware
--------

lsusb: (from UX301LA-DH71T)

    * 1bcf:2987 Sunplus Innovation Technology Inc. (Webcam)
    * 058f:6366 Alcor Micro Corp. Multi Flash Reader
    * 8087:07dc Intel Corp. (Bluetooth)
    * 03eb:8a0c Atmel Corp. (maxTouch Digitizer)

lspci: (from UX301LA-DH71T)

    * 00:00.0 Host bridge [0600]: Intel Corporation Haswell-ULT DRAM Controller [8086:0a04] (rev 09)
    * 00:02.0 VGA compatible controller [0300]: Intel Corporation Device [8086:0a2e] (rev 09)
    * 00:03.0 Audio device [0403]: Intel Corporation Device [8086:0a0c] (rev 09)
    * 00:04.0 Signal processing controller [1180]: Intel Corporation Device [8086:0a03] (rev 09)
    * 00:14.0 USB controller [0c03]: Intel Corporation Lynx Point-LP USB xHCI HC [8086:9c31] (rev 04)
    * 00:16.0 Communication controller [0780]: Intel Corporation Lynx Point-LP HECI #0 [8086:9c3a] (rev 04)
    * 00:1b.0 Audio device [0403]: Intel Corporation Lynx Point-LP HD Audio Controller [8086:9c20] (rev 04)
    * 00:1c.0 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 1 [8086:9c10] (rev e4)
    * 00:1c.3 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 4 [8086:9c16] (rev e4)
    * 00:1f.0 ISA bridge [0601]: Intel Corporation Lynx Point-LP LPC Controller [8086:9c43] (rev 04)
    * 00:1f.2 SATA controller [0106]: Intel Corporation Lynx Point-LP SATA Controller 1 [AHCI mode] [8086:9c03] (rev 04)
    * 00:1f.3 SMBus [0c05]: Intel Corporation Lynx Point-LP SMBus Controller [8086:9c22] (rev 04)
    * 00:1f.6 Signal processing controller [1180]: Intel Corporation Lynx Point-LP Thermal [8086:9c24] (rev 04)
    * 02:00.0 Network controller [0280]: Intel Corporation Wireless 7260 [8086:08b1] (rev 6b)

Helpful Links
-------------

-   ASUS Zenbook Prime UX31A
-   RAID
-   TLP (Pre-configured power saving)
-   Ubuntu UX302 Page
-   Ubuntu Forums UX302 thread
-   InsanelyMac(OSX86) thread with hardware info, etc.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_UX301LA&oldid=303675"

Category:

-   ASUS

-   This page was last modified on 9 March 2014, at 00:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
