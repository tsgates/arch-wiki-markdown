Dell Latitude D630
==================

The Dell Latitude D630 is a business line laptop made for corporate
users who have a need for durability. This article will tell you how to
get the basic components of the laptop running with Arch.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Installation                                                       |
| -   3 Wireless Networking                                                |
|     -   3.1 Intel 3945                                                   |
|     -   3.2 Broadcom BCM4312                                             |
|                                                                          |
| -   4 Xorg Configuration                                                 |
| -   5 Recommendations                                                    |
|     -   5.1 PC Speaker                                                   |
|     -   5.2 Other Recommendations                                        |
+--------------------------------------------------------------------------+

Hardware
--------

A late-July 2008 model, output from lspci:

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express Root Port (rev 0c)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 02)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 02)
    00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02) 
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 02)
    00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA IDE Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
    01:00.0 VGA compatible controller: nVidia Corporation Quadro NVS 135M (rev a1)
    03:01.0 CardBus bridge: O2 Micro, Inc. Cardbus bridge (rev 21)
    03:01.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02)
    09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755M Gigabit Ethernet PCI Express (rev 02)
    0c:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 01)

Installation
------------

You can follow the Official Arch Linux Install Guide to get yourself up
and running. I did a pretty standard install, keeping the XP partition
that came with the laptop as my company requires all work computers to
have Windows on them.

Wireless Networking
-------------------

> Intel 3945

The new installers will detect the Intel 3945 card and give you the
option of installing the drivers and module for it but I didn't have any
success doing that. It's good to have a wired connection to begin with
just to make sure you get everything up and running.

To ensure that the Intel 3945 wireless card will work post-installation
you'll need to install the linux-firmware package.

> Broadcom BCM4312

I got this to work using the proprietary Broadcom drivers in AUR. The
package is broadcom-wl.

Xorg Configuration
------------------

Xorg configuration is relatively straightforward. If you have the nVidia
Quadro card, you'll want to install the nvidia or Nouveau drivers.

Recommendations
---------------

> PC Speaker

To silence GTK+ apps that love to spew out system beeps for the most
mundane of occurrences, you may then have to go into the ALSA settings
and specifically mute the PC speaker channel. Then you should no longer
hear any sound from it.

> Other Recommendations

Many of the recommendations for the Dell Latitude D620#Recommendations
apply here too.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_D630&oldid=196577"

Category:

-   Dell
