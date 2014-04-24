Dell Inspiron 1521
==================

The following is what I have found while using Arch on my Inspiron 1521.
User experience may vary.

Contents
--------

-   1 Hardware Specifications
    -   1.1 lspci Output
    -   1.2 lsusb Output
-   2 Installation
-   3 Kernel
-   4 Networking
    -   4.1 Wired
    -   4.2 Wireless
        -   4.2.1 Broadcom Corporation BCM4311
    -   4.3 Modem

Hardware Specifications
-----------------------

> lspci Output

    00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
    00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx)
    00:05.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 1)
    00:07.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 3)
    00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
    00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
    00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
    00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
    00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
    00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
    00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
    00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
    00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
    00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
    00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
    00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
    00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
    00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
    01:05.0 VGA compatible controller: ATI Technologies Inc RS690M [Radeon X1200 Series]
    03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
    03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
    03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
    03:01.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
    03:01.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)
    0b:00.0 Network controller: Broadcom Corporation BCM4311 802.11b/g WLAN (rev 01)

> lsusb Output

    Bus 006 Device 001: ID 1d6b:0002  
    Bus 003 Device 001: ID 1d6b:0001  
    Bus 001 Device 001: ID 1d6b:0001  
    Bus 002 Device 001: ID 1d6b:0001  
    Bus 005 Device 001: ID 1d6b:0001  
    Bus 004 Device 001: ID 1d6b:0001 

Installation
------------

I worked through this HowTo: Beginners' guide

Kernel
------

The stock Arch kernel works just fine.

Networking
----------

My Network was extremely slow. This was caused by an IPv6 problem. After
adding the following line in the /etc/modprobe.d/modprobe.conf
everything was ok.

    alias net-pf-10 off

> Wired

Works out of the box.

> Wireless

Broadcom Corporation BCM4311

Install broadcom-wl from AUR.

For getting the network up automatically, I copied the file
/etc/network.d/examples/wpa.example (take the example file for your use
case) into the directory /etc/network.d/ and renamed it (e.g.
wlan_profile) and edited it. Then I added the following line to
/etc/rc.conf:

    NETWORKS=(wlan_profile)

And added the following daemon in the /etc/rc.conf:

    DAEMONS=( ... net-profiles ... )

> Modem

I have not tried the modem to see if it works.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_1521&oldid=298149"

Category:

-   Dell

-   This page was last modified on 16 February 2014, at 07:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
