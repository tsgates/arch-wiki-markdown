Acer Aspire v5-171
==================

Contents
--------

-   1 Introduction
-   2 Hardware
-   3 Networking
-   4 Xorg
-   5 Special keys

Introduction
------------

This netbook is well supported by arch.

  

Hardware
--------

       00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
       00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
       00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
       00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
       00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
       00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
       00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
       00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 (rev c4)
       00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 (rev c4)
       00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
       00:1f.0 ISA bridge: Intel Corporation HM77 Express Chipset LPC Controller (rev 04)
       00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
       00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
       03:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network Adapter (rev 01)
       04:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57785 Gigabit Ethernet PCIe (rev 10)
       04:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765 Memory Card Reader (rev 10)

  

Networking
----------

-   wifi and ethernet work perfectly.

Xorg
----

The touchpad works out of the box. However, you may want to uncomment
the line Option "AreaBottomEdge", in
/etc/X11/xorg.conf.d/50-synaptics.conf.

You may also want to lock the touchpad while typing. Run

       syndaemon -k -i 2 -d

  

Special keys
------------

-   Volume keys work once volumeicon is installed.
-   Brightness: In /etc/grub/default, add "acpi_osi=Linux
    acpi_backlight=vendor" in GRUB_CMDLINE_LINUX.
-   wifi: ok
-   touchpad lock: ok
-   turn on/off screen: ok.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_v5-171&oldid=277878"

Category:

-   Acer

-   This page was last modified on 6 October 2013, at 19:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
