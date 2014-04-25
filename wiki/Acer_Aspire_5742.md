Acer Aspire 5742
================

Contents
--------

-   1 Introduction
-   2 Hardware
-   3 Networking
    -   3.1 Wired Ethernet
    -   3.2 Wireless
-   4 Power Management
    -   4.1 CPU frequency scaling
        -   4.1.1 The laptop-mode-utils way
-   5 Xorg
-   6 Issues

Introduction
============

General info about the Acer Aspire 5742

Hardware
========

Processor: Intel Core i3-370M or 380M

Video: Intel Corporation Core Processor Integrated Graphics Controller
(rev 02)

Audio: Intel Corporation 5 Series/3400 Series Chipset High Definition
Audio (rev 05)

Wired NIC: Broadcom Corporation NetLink BCM57780 Gigabit Ethernet PCIe
(rev 01)

Wireless NIC: Atheros Communications Inc. AR9287 Wireless Network
Adapter (rev 01)

    # 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
    # 00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02)
    # 00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
    # 00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    # 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    # 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    # 00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 05)
    # 00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    # 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5) 
    # 00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    # 00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller (rev 05)
    # 00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 05)
    # 00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 05)
    # 01:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57780 Gigabit Ethernet PCIe (rev 01)
    # 02:00.0 Network controller: Atheros Communications Inc. AR9287 Wireless Network Adapter (rev 01)
    # ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
    # ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
    # ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
    # ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
    # ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
    # ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

Networking
==========

Wired Ethernet
--------------

If you are running into problems to get ethernet working on install you
will have to reload tg3 module.

     modprobe -r tg3

     modprobe tg3

     dhcpcd <name of your ethernet interface>

  
 If you have problems with the Ethernet card, you'll have to load the
modules broadcom then tg3. Add to the end of
/etc/modprobe.d/modprobe.conf:

     softdep tg3 pre: broadcom

Wireless
--------

The Atheros WLAN chip is fully supported by ath9k, which is
automatically loaded at boot with no need to add it in /etc/rc.conf.

You can manage your wireless connections with NetworkManager or Wicd.

Power Management
================

CPU frequency scaling
---------------------

> The laptop-mode-utils way

You probably want to use laptop-mode-utils with acpi.

    # pacman -S laptop-mode-utils acpi

Xorg
====

You'll want xf86-video-intel

You'll get a really jumpy touchpad if you do not install
xf86-input-synaptics

Issues
======

Adjusting the backlight requires additions to the kernel boot options.

Add acpi_osi=Linux acpi_brightness=vendor to kernel parameters.

The Fn + Left/Right Arrow keyboard combinations will now
decrease/increase the backlight.

Adding

     echo 450 > /sys/class/backlight/intel_backlight/brightness

to /etc/rc.local will adjust the backlight brightness down during boot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_5742&oldid=259777"

Category:

-   Acer

-   This page was last modified on 31 May 2013, at 11:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
