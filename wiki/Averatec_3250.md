Averatec 3250
=============

This page documents troubleshooting and configuration specific to the
Averatec 3250.

See the Beginners' Guide for installation instructions.

Specifications
--------------

Averatec 3250

-   AMD Athlon XP-M 2200+ (1.67 GHz)
-   12.1 inch 1024 x 768 XGA LCD; S3 Unichrome display controller with
    shared video memory
-   CD +/- Burner
-   60 GB 4200 RPM
-   512 MB PC2700 (333 MHz) DDR RAM
-   Wireless RaLink RT2500 802.11g
-   3 USB 2.0 ports
-   Dimensions(WxDxH): 10.9" x 9.6" x 1.0"
-   Weight: 4.4 lbs
-   Battery life: Minimal

    # lspci
    00:00.0 Host bridge: VIA Technologies, Inc. VT8378 [KM400/A] Chipset Host Bridge
    00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
    00:09.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
    00:0a.0 CardBus bridge: O2 Micro, Inc. OZ601/6912/711E0 CardBus/SmartCardBus Controller
    00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
    00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
    00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
    00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
    00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
    00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
    00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
    00:11.6 Communication controller: VIA Technologies, Inc. AC'97 Modem Controller (rev 80)
    00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 74)
    01:00.0 VGA compatible controller: VIA Technologies, Inc. VT8378 [S3 UniChrome] Integrated Video (rev 01)

> CPU

    % lshwd
    00:00.0 Class 0600: VIA Technologies Inc.|KM400 Bridge (via-agp)
    00:01.0 Class 0604: VIA Technologies Inc.|PCI-to-PCI Bridge (AGP 2.0/3.0) (via-agp)
    00:09.0 Class 0280: RaLink|Ralink RT2500 802.11 Cardbus Reference Card (rt2500)
    00:0a.0 Class 0607: O2Micro Inc.|OZ6912 CardBus Controller (yenta_socket)
    00:10.0 Class 0c03: VIA Technologies Inc.|VT82C586B USB (uhci_hcd)
    00:10.1 Class 0c03: VIA Technologies Inc.|VT82C586B USB (uhci_hcd)
    00:10.2 Class 0c03: VIA Technologies Inc.|VT82C586B USB (uhci_hcd)
    00:10.3 Class 0c03: VIA Technologies Inc.|VT8235 USB Enhanced Controller (ehci-hcd)
    00:11.0 Class 0601: VIA Technologies Inc.|VT8233A PCI to ISA Bridge (via-ircc)
    00:11.1 Class 0101: VIA Technologies Inc.|VT82C586 IDE [Apollo] (snd_via82xx)
    00:11.5 Class 0401: VIA Technologies Inc.|L7VTA v1.0 Motherboard (KT400-8235) (snd-via82xx)
    00:11.6 Class 0780: VIA Technologies Inc.|VT82C686 [Apollo Super AC97/Modem] (slamr)
    00:12.0 Class 0200: VIA Technologies Inc.|VT6102 [Rhine II 10/100] (via-rhine)
    01:00.0 Class 0300: VIA Technologies Inc.|KM400 Graphics Adapter (via)

Wireless
--------

I very quickly realized that setting up a WPA encrypted wireless
connection was just to much for me and would be something I would maybe
try and tackle later.

I initially tried following wireless quickstart instructions via the
Beginner's Guide, but found that I needed to set the access point of
your router:

    # iwconfig wlan0 ap 00:16:01:4B:A6:9D

Retrieved from
"https://wiki.archlinux.org/index.php?title=Averatec_3250&oldid=250478"

Category:

-   Averatec
