Acer Aspire 3624 WXMi
=====================

Article based on Acer Aspire 1652 ZWLMi, which in turn was based on Acer
Aspire 1691 WLMi.

This notebook was a very economic solution, at about $500 two years ago
that still works like a charm. The combination of a economic processor
such as the Celeron M 380 and a lightweight Linux distribution such as
Arch Linux with a minimalist usability focus like using the fluxbox
window manager, all of that makes a great deal of this laptop, currently
used for programming in many environments and paradigms, music
listening, video watching and the all-time classic web surfing and mail
checking.

Currently using a custom mainline kernel with no modules other than the
additional madwifi Atheros drivers, expecting to use the ath5k drivers
in the 2.6.25 kernel. Also, the hard disk uses three partitions, a root
partition, an encrypted home partition and the swap.

Battery life currently tops 2 hours when just coding or writing with
WiFi enabled and about 1:20 while watching h.264 video files.

The modem and PCMCIA slot have never been used.

Contents
--------

-   1 Specifications
    -   1.1 Components
    -   1.2 lspci
-   2 Installing Arch Linux
-   3 Kernel
-   4 Power Management
-   5 Xorg
    -   5.1 DPMS screen shutdown

Specifications
==============

Components
----------

-   Processor: Intel Celeron M 380 1.6Ghz, 1MB L2 Cache (Differences
    with a Pentium M: No SpeedStep frequency scaling and half the L2
    cache).
-   Memory: Hynix 2x256MB 400Mhz DDR2 SO-DIMM in Dual Data Rate
    configuration
    -   Upgraded to 2x1GB Corsair Value Select 1GB 533Mhz DDR2 SO-DIMM
        (VS1GSDS533D2).
-   Hard Disk Drive: Hitachi 80GB (HTS421280H9AT00) UDMA/100, PATA
    -   It seems that the biggest PATA 2.5" hard disk drive widely
        available is the 250GB Western Digital WD2500BEVE.
-   Optical Drive: Pioneer DVD-RW (DVR-K16RA) UDMA/33, PATA
-   Wireless NIC: Atheros AR2413 (It is installed as a Mini PCI card,
    supposedly can be upgraded to 802.11n in the future).
-   Ethernet NIC: Realtek 8139
-   Screen: 14.1" glossy surface 1280x800 native resolution.
-   Touchpad: Synaptics
-   Bluetooth: No. But it has a nice front unused button for it.

lspci
-----

    00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to DRAM Controller (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)
    00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 03)
    00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
    00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
    00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Modem Controller (rev 03)
    00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) IDE Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller (rev 03)
    06:05.0 Ethernet controller: Atheros Communications, Inc. AR2413 802.11bg NIC (rev 01)
    06:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
    06:09.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 01)

Installing Arch Linux
=====================

Installed two times with the standard CD, about two years ago (2006) and
a fresh reinstall in November 2007, the upgraded the system with pacman
-Syu and added all my favorite packages.

Kernel
======

Currently using a customized configuration 2.6.23.1 kernel with support
only for the included hardware and some extra USB stuff.

Power Management
================

Turning it off when not used and DPMS screen shutdown in the xorg.conf
file. Have not used suspend to disk, boot time is very fast, about 20
seconds from button press to login.

Xorg
====

The intel driver doesn't like to set the DPI according to forced
physical dimensions, so there is a trick to get the desired DPI (81x81).
In the user's ~/.bashrc the following line was added:

    alias xinit='xinit -- -dpi 81'

So that when issuing the xinit command, it will always use that DPI
resolution.

DPMS screen shutdown
--------------------

The following /etc/X11/xorg.conf snippet adds a DPMS screen shutdown
after 5 minutes of no activity.

    Section "Monitor"
        ...
        Option "DPMS" "true"
        ...
    EndSection

    Section "ServerLayout"
        ...
        Option "OffTime" "5" 
        ...
    EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_3624_WXMi&oldid=196467"

Category:

-   Acer

-   This page was last modified on 23 April 2012, at 12:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
