HP Pavilion dv7-1232nr
======================

Contents
--------

-   1 Hardware Specifications
-   2 Configuration
    -   2.1 Processor
    -   2.2 Video
    -   2.3 Audio
    -   2.4 LAN
    -   2.5 WLAN
    -   2.6 Webcam
    -   2.7 Card Reader
-   3 Troubleshooting
    -   3.1 QuickPlay buttons

Hardware Specifications
-----------------------

-   AMD Turion X2 Dual-Core Mobile Processor RM-74 (2.2 GHz, 1MB L2
    Cache)
-   17.0" Diagonal WXGA+ High-Definition BrightView Widescreen Display
    (1440 x 900)
-   4GB DDR2 SDRAM (2 DIMM)
-   ATI Radeon HD 3200 Graphics (256 MB)
-   320GB 5400RPM SATA Hard Drive
-   Realtek RTL8101E/RTL8102E LAN
-   Atheros AR5001 802.11b/g WLAN
-   SuperMulti 8x DVD+/-R/RW drive with Double Layer Support
-   Webcam
-   JMicron SD,MS/Pro,MMC,XD Card Reader
-   3 USB 2.0, HDMI, eSATA ports

Configuration
-------------

> Processor

Frequency scaling works with cpufrequtils using the "powernow-k8"
module. Available frequencies are 2.20 GHz, 1.10 GHz, and 550 MHz

> Video

Using "xf86-video-ati" driver for the ATI card. No xorg.conf file
needed. Seems to function properly with and without KMS enabled. Display
supports 1440x900 @ 60 Hz. HDMI output not tested.

> Audio

All necessary modules are automatically loaded.

> LAN

All necessary modules are automatically loaded. Requires the "r8169"
module

> WLAN

All necessary modules are automatically loaded. Requires the "ath5k"
module

> Webcam

All necessary modules are automatically loaded. Tested with Cheese
(GNOME webcam app)

> Card Reader

All necessary modules are automatically loaded.

Troubleshooting
---------------

> QuickPlay buttons

-   Mute button works as expected
-   Volume control works as expected
-   Rewind, play, fast forward and stop buttons not tested
-   Wireless button does not appear to enable/disable wireless, further
    setup may be needed for this

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv7-1232nr&oldid=196642"

Category:

-   HP

-   This page was last modified on 23 April 2012, at 12:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
