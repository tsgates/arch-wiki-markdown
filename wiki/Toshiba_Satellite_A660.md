Toshiba Satellite A660
======================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 ACPI and Power Saving                                              |
| -   2 Networking                                                         |
| -   3 Wireless                                                           |
| -   4 Audio                                                              |
| -   5 Graphics                                                           |
| -   6 Framebuffer                                                        |
| -   7 Modem                                                              |
| -   8 Touchpad                                                           |
| -   9 SD card reader                                                     |
| -   10 DVD-RW                                                            |
+--------------------------------------------------------------------------+

ACPI and Power Saving
---------------------

Power-saving untested.

Networking
----------

Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast
Ethernet controller (rev 05). Works fine, as would be expected.

Wireless
--------

Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev
01). Does not work with b43, broadcom-wl, or ndiswrapper. Works with
brcm80211 (interface shows up and scanning is possible) but is subject
to the kernel panic bug with more than one CPU core.

Audio
-----

Intel Corporation 5 Series/3400 Series Chipset High Definition Audio
(rev 05)

nVidia Corporation High Definition Audio Controller (rev a1)

The Intel chip works well. The NVIDIA controller (really just the
integrated GPU processing the audio) is untested, but is technically
capable of HDMI and S/PDIF out.

Graphics
--------

nVidia Corporation Device 0a75 (rev a2)

GPU is a GeForce 310M (16 CUDA cores, 512MB memory, 64-bit memory
interface, 2500 PCI-E max link speed. Works well with the proprietary
nvidia drivers, untested with nouveau.

Framebuffer
-----------

Works fine at 1366x768.

Modem
-----

Not tested.

Touchpad
--------

Works fine out of the box.

SD card reader
--------------

Untested.

DVD-RW
------

Untested.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_A660&oldid=196744"

Category:

-   Toshiba
