Samsung R20P
============

Contents
--------

-   1 Hardware specification
-   2 Extra
-   3 Installation
-   4 Configuration
    -   4.1 Audio
        -   4.1.1 Troubleshooting
    -   4.2 Touchpad
    -   4.3 Wireless
-   5 VGA Out
-   6 Troubleshooting
    -   6.1 Yet untested
-   7 Resources
    -   7.1 Output of lscpi -nn

> Hardware specification

NP-R20Y

-   LCD - 14.1" WXGA Glare TFT screen
-   CPU - Intel Core Duo T2330 @ 1.60Ghz
-   RAM - 2GB DDR2 (2 slots)
-   VGA - ATi Radeon Xpress 1250
-   HDD - 160GB SATA Samsung HM160HIS
-   CD/DVD - TS-L632H DL DVD+-RW SuperMulti
-   Audio - Realtek ALC262
-   Battery - 2600mAh LION / ~1.5-2h battery life

> Extra

-   Audio In / Mic In
-   3 USB 2.0 Ports
-   Sony Memory Stick Reader
-   1 VGA Out port
-   1 RJ-45
-   1 RJ-11
-   1 Express Card slot

Installation
============

For installation I used both i686 and x86_64 2008.06 "Core" images.
Installation of the system was very smooth, but to have a plesant
experience with Arch Linux on this laptop I needed to tweak it a bit.

Configuration
=============

This laptop requires a bit tweaking to make it work without glitches on
Arch Linux.

-   CPU Frequency Scaling
-   Pm-utils - Suspend / Hibernation
-   ATI
-   Laptop
-   madwifi

Audio
-----

Note: Kernel 2.6.27 and Alsa 1.0.18 seems to be working without problems

> Troubleshooting

If you get hda-intel: Invalid position buffer, using LPIB read method
instead message from dmesg or /var/log/everything.log edit your
/etc/modprobe.d/modprobe.conf as root and write :

    options snd-hda-intel enable=1 index=0 position_fix=1

Touchpad
--------

See the Touchpad Synaptics page for instructions. Currently there are
some issues with the touchpad which causes enormus CPU usage, freezes
and lock-ups. To fix that open, again as root, /boot/grub/menu.lst and
in the end of kernel section write :

    i8042.nomux=1 hpet=disable

Wireless
--------

Note: Kernel 2.6.27 contains an updated ath5k driver, wireless works out
of the box. (wlan0)

VGA Out
=======

Proper resolution of the secondary monitor is detected after an X server
restart using open source (xf86-video-ati) driver.

Troubleshooting
===============

-   Suspend and Hibernation doesn't work with gnome-power-utils, but
    they work with pm-utils.

-   Fn keys currently do not work with radeonhd driver, but they work
    with fglrx , but not all of them.

  

Yet untested
------------

-   Modem
-   Express Card

Resources
=========

> Output of lscpi -nn

     00:00.0 Host bridge [0600]: ATI Technologies Inc Radeon Xpress 7930 Host Bridge [1002:7930]
     00:01.0 PCI bridge [0604]: ATI Technologies Inc RS7932 PCI Bridge [1002:7932]
     00:05.0 PCI bridge [0604]: ATI Technologies Inc Device [1002:7935]
     00:06.0 PCI bridge [0604]: ATI Technologies Inc RS7936 PCI Bridge [1002:7936]
     00:07.0 PCI bridge [0604]: ATI Technologies Inc Device [1002:7937]
     00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5 SATA [1002:4380]
     00:13.0 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI0) [1002:4387]
     00:13.1 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI1) [1002:4388]
     00:13.2 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI2) [1002:4389]
     00:13.3 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI3) [1002:438a]
     00:13.4 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI4) [1002:438b]
     00:13.5 USB Controller [0c03]: ATI Technologies Inc SB600 USB Controller (EHCI) [1002:4386]
     00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller [1002:4385] (rev 14)
     00:14.1 IDE interface [0101]: ATI Technologies Inc SB600 IDE [1002:438c]
     00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383]
     00:14.3 ISA bridge [0601]: ATI Technologies Inc SB600 PCI to LPC Bridge [1002:438d]
     00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI Bridge [1002:4384]
     01:05.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon Xpress 1250 [1002:7942]
     05:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)
     0b:05.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_R20P&oldid=249903"

Category:

-   Samsung

-   This page was last modified on 8 March 2013, at 09:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
