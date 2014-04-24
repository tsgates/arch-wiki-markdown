Sony Vaio VPCF13
================

Contents
--------

-   1 Introduction
-   2 Xorg video issues
-   3 Display backlight regulation
-   4 Suspend to RAM
-   5 Sources

Introduction
------------

This is a mini guide to configure a Sony Vaio VPCF13Z1E/B on Arch Linux.

Processor - Intel Core i7-740QM

Motherboard chipset - Intel HM55

Memory - 8 GB RAM DDR3 1333 MHz

Graphics chipset - Nvidia GeForce GT 425M

Graphics card RAM - 1.00GB


    $ lspci
    00:00.0 Host bridge: Intel Corporation Core Processor DMI (rev 11)
    00:03.0 PCI bridge: Intel Corporation Core Processor PCI Express Root Port 1 (rev 11)
    00:08.0 System peripheral: Intel Corporation Core Processor System Management Registers (rev 11)
    00:08.1 System peripheral: Intel Corporation Core Processor Semaphore and Scratchpad Registers (rev 11)
    00:08.2 System peripheral: Intel Corporation Core Processor System Control and Status Registers (rev 11)
    00:08.3 System peripheral: Intel Corporation Core Processor Miscellaneous Registers (rev 11)
    00:10.0 System peripheral: Intel Corporation Core Processor QPI Link (rev 11)
    00:10.1 System peripheral: Intel Corporation Core Processor QPI Routing and Protocol Registers (rev 11)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 05)
    00:1c.2 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 3 (rev 05)
    00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 05)
    00:1c.6 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 7 (rev 05)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 05)
    00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    01:00.0 VGA compatible controller: nVidia Corporation Device 0df0 (rev a1)
    01:00.1 Audio device: nVidia Corporation GF108 High Definition Audio Controller (rev a1)
    02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6200 (rev 35)
    03:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller
    03:00.1 System peripheral: Ricoh Co Ltd Memory Stick Host Controller
    03:00.3 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller
    03:00.4 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller
    04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8057 PCI-E Gigabit Ethernet Controller (rev 10)
    05:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
    3f:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-Core Registers (rev 04)
    3f:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 04)
    3f:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 04)
    3f:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 04)
    3f:03.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller (rev 04)
    3f:03.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Target Address Decoder (rev 04)
    3f:03.4 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Test Registers (rev 04)
    3f:04.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Control Registers (rev 04)
    3f:04.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Address Registers (rev 04)
    3f:04.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Rank Registers (rev 04)
    3f:04.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 0 Thermal Control Registers (rev 04)
    3f:05.0 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Control Registers (rev 04)
    3f:05.1 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Address Registers (rev 04)
    3f:05.2 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Rank Registers (rev 04)
    3f:05.3 Host bridge: Intel Corporation Core Processor Integrated Memory Controller Channel 1 Thermal Control Registers (rev 04)

Xorg video issues
-----------------

X server didn't start properly with Nvidia drivers installed by pacman.
I use one downloaded fron Nvidia web. Then I installed them by running
downloaded script. After thet, the Xserver runs just fine.

Display backlight regulation
----------------------------

I found this solution -
http://code.google.com/p/vaio-f11-linux/wiki/NVIDIASetup. It's for Vaio
F11, but it works for my F13 too.

I've added this line in section "Device" in /etc/X11/xorg.conf :

    Option    "RegistryDwords"    "EnableBrightnessControl=1;PowerMizerEnable=0x1;PerfLevelSrc=0x3333;PowerMizerLevel=0x3;PowerMizerDefault=0x3;PowerMizerDefaultAC=0x3"

Plus I use module sony_laptop .. MODULES=(sony_laptop) in /etc/rc.conf

The patched kernel is available in the AUR: linux-sony

The sony-acpid daemon is also available in the AUR: sony-acpid-git

Suspend to RAM
--------------

While using KDE, suspending uses pm-utils. Because of USB-3 ports it's
necessary to unload module xhci_hcd before suspend. This can be done by
following steps.

    # cp /usr/lib/pm-utils/defaults /etc/pm/config.d/defaults  

Then edit the file in /etc/pm/config.d/defaults with
SUSPEND_MODULES="xhci_hcd"

  

Sources
-------

https://help.ubuntu.com/community/Laptop/Sony/Vaio/FSeries/Maverick

http://superuser.com/questions/208217/looking-for-ubuntu-10-10-driver-for-geforce-gt-425m-gpu

http://code.google.com/p/vaio-f11-linux/wiki/AutoDimmingBacklightDaemon

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_VPCF13&oldid=196732"

Category:

-   Sony

-   This page was last modified on 23 April 2012, at 13:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
