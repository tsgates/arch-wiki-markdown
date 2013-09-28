MSI Wind U210
=============

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Technical specifications of MSI U210                               |
|     -   1.1 lspci output                                                 |
|                                                                          |
| -   2 Network                                                            |
|     -   2.1 Wifi                                                         |
|     -   2.2 Ethernet                                                     |
|                                                                          |
| -   3 Sound                                                              |
| -   4 Function Keys                                                      |
| -   5 Webcam                                                             |
| -   6 Installation                                                       |
| -   7 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Technical specifications of MSI U210
------------------------------------

-   Display: 12.1"WXGA (Glare Type)
-   Processor: AMD Althon Neo MV-40 (1,6GHz)
-   Hard Disc: SATA 250 GB
-   Memory: DDRII 2GB*1
-   Communication: 802.11b/b/n
-   Battery: 6 cells

> lspci output

Hardware components as reported by lspci:

    00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
    00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx)
    00:04.0 PCI bridge: ATI Technologies Inc Device 7914
    00:05.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 1)
    00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
    00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
    00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
    00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
    00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
    00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
    00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
    00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
    00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
    00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
    00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
    00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
    00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
    01:05.0 VGA compatible controller: ATI Technologies Inc RS690M [Radeon X1200 Series]
    01:05.2 Audio device: ATI Technologies Inc Radeon X1200 Series Audio Controller
    02:00.0 Network controller: RaLink RT3090 Wireless 802.11n 1T/1R PCIe
    03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)

Network
-------

> Wifi

For kind wifi using you need:

put in your rc.conf:

    MODULES=(...!rt2800pci, rt2860sta...)

and default wifi settings from
https://wiki.archlinux.org/index.php/Wifi.

> Ethernet

Sound
-----

Function Keys
-------------

Webcam
------

Installation
------------

    # pacman -S xf86-video-radeonhd libgl ati-dri

Troubleshooting
---------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=MSI_Wind_U210&oldid=225357"

Category:

-   MSI
