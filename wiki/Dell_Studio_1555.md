Dell Studio 1555
================

Contents
--------

-   1 About this laptop
-   2 Foreword
-   3 Video
-   4 Webcam
-   5 Sound
-   6 Microphone
-   7 Ports and drives
-   8 Power management
-   9 Input devices
-   10 Networking

About this laptop
-----------------

lspci:

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
    00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
    00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    01:00.0 VGA compatible controller: ATI Technologies Inc M92 [Mobility Radeon HD 4500 Series]
    01:00.1 Audio device: ATI Technologies Inc R700 Audio Device [Radeon HD 4000 Series]
    04:00.0 Network controller: Intel Corporation PRO/Wireless 5300 AGN [Shiloh] Network Connection
    08:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5784M Gigabit Ethernet PCIe (rev 10)
    09:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
    09:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
    09:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
    09:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
    09:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)

lsusb:

    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 004: ID 413c:8158 Dell Computer Corp. 
    Bus 002 Device 003: ID 413c:8157 Dell Computer Corp. 
    Bus 002 Device 002: ID 0a5c:4500 Broadcom Corp. 
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 003: ID 0c45:63eb Microdia 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

  
 Kernel used at the moment: Linux laptop 2.6.30-ARCH #1 SMP PREEMPT Fri
Jun 19 21:25:17 UTC 2009 i686 Intel(R) Core(TM)2 Duo CPU P8600 @ 2.40GHz
GenuineIntel GNU/Linux

Foreword
--------

The laptop works mostly out of the box with a few configurations.

Video
-----

This laptop has a "ATI Mobility HD Radeon 4570" card as you could see on
the lspci. Use xf86-video-ati or proprietary catalyst driver. Guides can
be found in the ATI article in this wiki.

Webcam
------

It also has 2 MP webcam, it's listed on lsusb:

    Bus 001 Device 003: ID 0c45:63eb Microdia 

Works perfectly with the uvcvideo module. Works using cheese.

Sound
-----

Works out of the box.

Microphone
----------

To set up microphone:

    # amixer sset 'Mic Mixer' 85% cap
    # amixer sset 'Capture' 85% cap
    # amixer sset 'Digital' 85%

If you want to use the internal microphone (embedded next to the webcam)
run:

    # amixer sset 'Digital Input Source' 'Digital Mic 1'

If you want to use an external microphone using the jack run:

    # amixer sset 'Digital Input Source'  'Analog Inputs'

Ports and drives
----------------

CD/DVD drive worked out of the box.

Power management
----------------

Works out of the box.

Input devices
-------------

Keyboard works out of the box. For touchpad read the Synaptics guide.

Networking
----------

Ethernet works out of the box. Wireless may work out of the box
depending on your wifi card. If you have a Broadcom BCM43XX card, you
will need to install the broadcom-wl driver from the AUR. Read Broadcom
BCM43XX guide for details. b43 driver from latest kernel can work as
well, if supplied with proper firmware.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Studio_1555&oldid=255722"

Category:

-   Dell

-   This page was last modified on 30 April 2013, at 09:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
