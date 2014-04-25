Acer Aspire 7720
================

For 64-bit install, update BIOS first to fix ACPI and wireless problems.
If you use 32-bit there shouldn't be problems.

Hardware

Details

Status

HDD

WDC WD2500BEVS-22UST0 250GB

Works.

Screen/Graphics

Acer 17" (1440x900), Intel x3100

Works fully.

Wireless

Intel 3945

Works after you install the firmware. I used netcfg2 or wicd for
management of WLAN.

Ethernet

Broadcom BCM5787 (tg3 driver)

Works out of box.

Audio

Realtek ALC268

Working well. Recording from the internal microphone is flawed, however.

Card Reader

5-in-1 card reader supports optional MultiMediaCard™, Secure Digital
card, Memory Stick®, Memory Stick PRO™ or xD-Picture Card™

Works only for SD? MS is not recognized?

Webcam

Acer "Crystal Eye" Webcam

Works (uvcvideo)

Touchpad

ALPS PS/2

Works (with current X releases no need to configure).

Bluetooth

Broadcom "A-Link BlueUsbA2"

Works

Remote control sensor

Works: install LIRC, the driver is lirc_ene0100. I successfully command
MPD and MPlayer with it.

What doesn't work
-----------------

Hibernation (is still flaky). Suspend seems to work OK with kernel
2.6.35, xorg 1.9.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_7720&oldid=304875"

Category:

-   Acer

-   This page was last modified on 16 March 2014, at 08:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
