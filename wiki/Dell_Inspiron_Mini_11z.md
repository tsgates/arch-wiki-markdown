Dell Inspiron Mini 11z
======================

The Dell Inspiron Mini 11z is a netbook from Dell.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Installing                                                         |
| -   3 Xorg                                                               |
| -   4 Sound                                                              |
| -   5 Extras                                                             |
|     -   5.1 Webcam                                                       |
+--------------------------------------------------------------------------+

Hardware
--------

    $ lspci

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    02:00.0 Ethernet controller: Atheros Communications Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0)
    08:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev 01)

Normally, all should work out of the box, except the Broadcom_BCM4312
which needs some tweaking.

Installing
----------

Because the netbook has no CD-ROM drive you need to boot from a USB. See
the guide Install_from_USB_stick.

Xorg
----

Setting up Xorg is easy on the Mini 11z. Just follow the guide for Xorg.

Kernel Mode Setting (KMS) and fast VT switching works well on the 11z.
See "Early Start" section in Intel for more details.

Sound
-----

"Just works" with OSS, or ALSA

Extras
------

> Webcam

UVC 1.00 compatible - should work out of the box, with the latest kernel
(remember to add user to video group). You may use the cheese package to
test it.

If you encounter an error about a missing gstreamer plugin (vp8enc),
install the metapackage "gstreamer0.10-plugins", which will include
"gstreamer0.10-bad-plugins", containing the plugin in question

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_Mini_11z&oldid=250563"

Category:

-   Dell
