Dell Latitude E7440
===================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Need more users   
                           of this model to extend  
                           this page to make it fit 
                           more configurations.     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The Dell Latitude E7440 is a business Ultrabook™. Generally speaking, it
has nice support of (Arch) Linux.

Contents
--------

-   1 Hardware Overview
-   2 Installation
-   3 What drivers to get
-   4 What does not work
-   5 What are not tested
-   6 Troubleshooting
    -   6.1 "Invalid partition table!" when booting
-   7 References

Hardware Overview
-----------------

I have a December 2013 model, configured with Intel Core i5-4300U,
integrated Intel HD4400 graphics adapter, Intel Ethernet and wireless
network adapter and a 1080p screen. Your configuration may differ from
mine.

Output from lspci:

    00:00.0 Host bridge: Intel Corporation Haswell-ULT DRAM Controller (rev 0b)
    00:02.0 VGA compatible controller: Intel Corporation Haswell-ULT Integrated Graphics Controller (rev 0b)
    00:03.0 Audio device: Intel Corporation Device 0a0c (rev 0b)
    00:14.0 USB controller: Intel Corporation Lynx Point-LP USB xHCI HC (rev 04)
    00:16.0 Communication controller: Intel Corporation Lynx Point-LP HECI #0 (rev 04)
    00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I218-LM (rev 04)
    00:1b.0 Audio device: Intel Corporation Lynx Point-LP HD Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 1 (rev e4)
    00:1c.3 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 4 (rev e4)
    00:1c.4 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 5 (rev e4)
    00:1d.0 USB controller: Intel Corporation Lynx Point-LP USB EHCI #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation Lynx Point-LP LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation Lynx Point-LP SATA Controller 1 [AHCI mode] (rev 04)
    00:1f.3 SMBus: Intel Corporation Lynx Point-LP SMBus Controller (rev 04)
    02:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)
    03:00.0 SD Host controller: O2 Micro, Inc. Device 8520 (rev 01)

Output from lsusb:

    Bus 001 Device 002: ID 8087:8000 Intel Corp. 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 002 Device 003: ID 1bcf:2985 Sunplus Innovation Technology Inc. 
    Bus 002 Device 002: ID 8087:07dc Intel Corp. 
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Installation
------------

You can follow the Installation guide to get yourself up and running. I
simply transfered a 7mm SSD drive on my previous laptop to this one and
the Arch Linux on it boots without errors.

What drivers to get
-------------------

-   Intel Graphics for HD4400 graphics card. ===> MAJOR PERFORMANCE
    IMPACT:

After a very long research and several tens of reboots I came up with
the conclusion that if you power on the laptop without having AC
connected the overall GPU performance will be WAY worse than if you did
with the AC connected. It does not matter whatsoever if you connect AC
afterwards - GPU/OpenGL/drawing _IS_ going to be slow once you've
started it without AC.

As a benchmark I've used the redraw time of pidgin GTK windows and the
mouse moving speed of maps.google.com. Google maps should be very
responsive and not laggy at all.

Tested on: i3-git, mesa-full-i965 and xf86-video-intel-git 2.99.911-1
but this was reproducing on the stable versions of mesa and i915 driver.

Laptop bios version A05. Meanwhile I've upgraded to bios version A08 and
this issue seems to have been fixed.

  

-   Wireless#iwlwifi for Intel 7260 wifi card.
-   Synaptics for Touchpad

What does not work
------------------

-   The O2 Micro SD-card reader does not work as of 2014-01-18, Linux
    3.12.7-1-ARCH. Output from dmesg:

    [    2.441999] sdhci: Secure Digital Host Controller Interface driver
    [    2.442001] sdhci: Copyright(c) Pierre Ossman
    [    2.442172] sdhci-pci 0000:03:00.0: SDHCI controller found [1217:8520] (rev 1)
    [    2.442262] mmc0: Unknown controller version (3). You may experience problems.
    [    2.442967] mmc0: Hardware doesn't specify timeout clock frequency.

-   It seems that bluetooth on Intel 7260 is not working out of the box,
    but I don't know how to test it further. Tested and seems to be
    working. Bluetooth is usable with "gnome-control-center bluetooth".

-   Webcam does not work with Virtualbox (as of community/virtualbox
    4.3.6-1), but it works with native programs such as skype.

What are not tested
-------------------

-   I don't have fingerprint reader or smartcard reader installed in my
    configuration, so they are not tested.

Troubleshooting
---------------

> "Invalid partition table!" when booting

If you use BIOS+MBR boot method and msdos partition table, the BIOS may
show this error message before entering Syslinux or other boot loaders.
To prevent it, put the "boot" label on a primary partition (instead of a
logical partition). You may refer to the wiki page of your boot loader
to see how this works. It may be a "kindly reminder" to Windows users,
since Windows can only boot on primary partitions.

References
----------

Dell Latitude E7440 | Post-installation et optimisation (French)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_E7440&oldid=306147"

Category:

-   Dell

-   This page was last modified on 20 March 2014, at 18:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
