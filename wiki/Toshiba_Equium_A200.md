Toshiba Equium A200
===================

This document will cover experiences and configuration of Arch Linux
running on Toshiba Equium A200.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specification                                                      |
| -   2 Graphics                                                           |
| -   3 CompizFusion                                                       |
| -   4 Ethernet                                                           |
| -   5 Wireless                                                           |
| -   6 Sound                                                              |
| -   7 Battery                                                            |
| -   8 Summary                                                            |
+--------------------------------------------------------------------------+

Specification
-------------

Intel Pentium Dual CPU (T2310) @ 1.46Ghz  
 2GB RAM  
 120GB HDD  
 Intel 965GM Chipset  

lspci output:

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
Controller Hub (rev 03)  
 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 03)  
 00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 03)  
 00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #4 (rev 03)  
 00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #5 (rev 03)  
 00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #2 (rev 03)  
 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 03)  
 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 03)  
 00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 2 (rev 03)  
 00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 3 (rev 03)  
 00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 4 (rev 03)  
 00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 5 (rev 03)  
 00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #1 (rev 03)  
 00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #2 (rev 03)  
 00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #3 (rev 03)  
 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #1 (rev 03)  
 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev
f3)  
 00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
Controller (rev 03)  
 00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
IDE Controller (rev 03)  
 00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
SATA AHCI Controller (rev 03)  
 00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller
(rev 03)  
 02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8039
PCI-E Fast Ethernet Controller (rev 14)  

  
 lsusb output (Wireless card is there)

Bus 006 Device 003: ID 0bda:8197 Realtek Semiconductor Corp.

Graphics
--------

Includes an Intel 965GM chipset, Which works well with the
xf86-video-intel driver. TV-Out works.

CompizFusion
------------

Works without any apparent problems.

Ethernet
--------

Works.

Wireless
--------

Contains a nasty hardware hack: an internal USB WLAN interface. The
chipset is rtl8187b, which seemingly is almost supported by the rtl8187
driver, but it does not associate correctly.

Running the wlan through ndiswrapper might or might not work.

If you need WLAN, this laptop is *not* recommended. Not only because
Linux support is limited, but because the technical decision of having
an internal USB device is very questionable.

Edit:

This wireless card, rtl8187b, has now got native support in kernel
2.6.27 and upwards. It works out-of-the-box! (rtl8187 driver)

No need for ndiswrapper but If you would like it for older kernels etc,
look here: (might not work tho)

[1]

Sound
-----

Works.

Battery
-------

The machine has lousy battery performance, and it seems to drain battery
even after being shut down. Some reports have indicated that this does
not happen when the machine is shut down from Vista. Needs
investigation.

Edit:

This has been fixed with a kernel update (2.6.24) not 100% which kernel
fixed it.

Summary
-------

Overall, its a nice laptop to run Linux on. There are no problems with
hardware.

All hardware works out of the box on Ubuntu 8.10, Arch Linux (once set
up) and others.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Equium_A200&oldid=196736"

Category:

-   Toshiba
