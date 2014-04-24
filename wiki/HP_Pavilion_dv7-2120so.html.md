HP Pavilion dv7-2120so
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
    -   2.7 Touchpad
    -   2.8 Card Reader
-   3 Troubleshooting
    -   3.1 QuickPlay buttons
    -   3.2 Untested Peripherals

Hardware Specifications
-----------------------

-   AMD Turion X2 Dual-Core Mobile Processor ZM-82 (2.2 GHz, 1MB L2
    Cache)
-   17.3" Diagonal WXGA+ High-Definition BrightView Widescreen Display
    (1440 x 900)
-   4GB DDR2 SDRAM (2 DIMM)
-   ATI Mobility Radeon HD 4530 (512 MB)
-   500GB 5400RPM SATA Hard Drive
-   Realtek RTL8111/8168B Gigabit LAN
-   Atheros AR9285 WLAN
-   DVD+/-R/RW SuperMulti (Lightscribe burner)
-   Webcam
-   JMicron SD,MS/Pro,MMC,XD Card Reader
-   4 USB 2.0, HDMI, eSATA ports

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

All necessary modules are automatically loaded. Requires the "ath9k"
module

> Webcam

All necessary modules are automatically loaded. Tested with Cheese
(GNOME webcam app)

> Touchpad

Works with "xf86-input-synaptics" driver.

> Card Reader

JMicron card reader not working. Further setup needed for this.

Troubleshooting
---------------

> QuickPlay buttons

-   Mute button not working
-   Volume control not working
-   Rewind, play, fast forward and stop buttons not tested
-   Wireless button not tested

  

> Untested Peripherals

-   LightScribe
-   FireWire
-   PCMCIA Socket
-   eSATA Port

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_dv7-2120so&oldid=288867"

Category:

-   HP

-   This page was last modified on 16 December 2013, at 17:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
