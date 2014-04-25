HP Mini 210-4120sa
==================

  

Contents
--------

-   1 Specifications
    -   1.1 lspci
-   2 Notes
-   3 Hardware
    -   3.1 CPU
    -   3.2 Audio
    -   3.3 Video
    -   3.4 Webcam
    -   3.5 Networking
        -   3.5.1 Wireless
        -   3.5.2 Wired
        -   3.5.3 Bluetooth
    -   3.6 Touchpad
    -   3.7 Card Reader
-   4 Resources

Specifications
--------------

For full specifications see the HP 210-4120sa cnet specifications page.

Device

HP Mini 210-4120sa

Processor

Intel Atom N2800 @ 1.86GHz - (1MB L2 cache, Dual core with
Hyper-Threading, Cedarview)

Architecture

x86

Graphics

Intel Graphics Media Accelerator 3650 (Integrated)

Screen

LED Backlit 10.1" (1024x600)

RAM

Up to 2GB (Possibly 4GB?)

HDD

320GB 5400RPM HDD (SATA II/SATA-300)

Optical Drive

None

Ethernet

Realtek RTL8101E/RTL8102E PCI Express Fast Ethernet controller

Wireless

Atheros AR9485 802.11a/b/g/n

Audio

Onboard with Beats Audio

> lspci

     00:00.0 Host bridge: Intel Corporation Atom Processor D2xxx/N2xxx DRAM Controller (rev 03)
     00:02.0 VGA compatible controller: Intel Corporation Atom Processor D2xxx/N2xxx Integrated Graphics Controller (rev 09)
     00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition Audio Controller (rev 02)
     00:1c.0 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 1 (rev 02)
     00:1c.1 PCI bridge: Intel Corporation NM10/ICH7 Family PCI Express Port 2 (rev 02)
     00:1d.0 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #1 (rev 02)
     00:1d.1 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #2 (rev 02)
     00:1d.2 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #3 (rev 02)
     00:1d.3 USB controller: Intel Corporation NM10/ICH7 Family USB UHCI Controller #4 (rev 02)
     00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI Controller (rev 02)
     00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
     00:1f.0 ISA bridge: Intel Corporation NM10 Family LPC Controller (rev 02)
     00:1f.2 SATA controller: Intel Corporation NM10/ICH7 Family SATA Controller [AHCI mode] (rev 02)
     00:1f.3 SMBus: Intel Corporation NM10/ICH7 Family SMBus Controller (rev 02)
     01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 05)
     02:00.0 Network controller: Atheros Communications Inc. AR9485 Wireless Network Adapter (rev 01)

Notes
-----

Although the processor supports x86_64, the BIOS does not. You will only
be able to use x86 on this netbook.

This wiki article was written based on a slightly modified 4120sa.
Featuring a 64GB SSD and 2GB of DDR3 RAM. Most things should be okay to
follow though, but be warned.

Hardware
--------

> CPU

The CPU clock frequency should automatically adjust based on usage,
varying from 798MHz to 1.86GHz.

> Audio

Audio is supported through ALSA with virtually no configuration.
Following the ALSA article should cover all that is needed. Note that
the Mute LED seems to be non-functional.

> Video

Kernel module gma500_gfx should be automatically loaded as of Kernel
3.3rc1, see: Poulsbo

> Webcam

The webcam should be supported through the uvcvideo module by default,
if not:

    # modprobe uvcvideo

> Networking

Wireless

The Atheros AR9485 (rev 01) works out of the box with ath9k module
present in kernels v2.6.27 and newer.

Wired

The Realtek RTL8101E/RTL8102E (rev 05) works out of the box with the
r8169 module present in kernels 2.26.31 and newer.

Bluetooth

Bluetooth works out of the box, just follow instructions at Bluetooth.

> Touchpad

The Synaptics driver can be installed as described here. Vertical and
horizontal two finger scrolling work, as well as palm detection, and can
be enabled in the synaptics .conf file:

    /etc/X11/xorg.conf.d/10-synaptics.conf

     Section "InputClass"
           Identifier "touchpad"
           Driver "synaptics"
           MatchIsTouchpad "on"
                  Option "TapButton1" "1"
                  Option "TapButton2" "2"
                  Option "TapButton3" "3"
                  Option "VertTwoFingerScroll" "on"
    	      Option "HorizTwoFingerScroll" "on"
    	      Option "PalmDetect" "on"
                  ...
     EndSection

> Card Reader

The multi-card reader is working automatically.

Resources
---------

-   HP Mini 210-4120sa at HP Support - BIOS upgrades can be found here

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Mini_210-4120sa&oldid=304993"

Category:

-   HP

-   This page was last modified on 16 March 2014, at 10:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
