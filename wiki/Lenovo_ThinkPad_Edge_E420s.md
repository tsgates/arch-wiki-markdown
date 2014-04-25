Lenovo ThinkPad Edge E420s
==========================

  Summary help replacing me
  ---------------------------------------------------------------------------------------
  This article covers the Arch Linux support for the Lenovo ThinkPad Edge E420s laptop.

Contents
--------

-   1 Installation
-   2 Hardware
    -   2.1 lspci
    -   2.2 lsusb
-   3 Configuration
    -   3.1 Clickpad
    -   3.2 Video
        -   3.2.1 Dual Monitors
    -   3.3 Ethernet
    -   3.4 Wireless
        -   3.4.1 Intel Centrino Wireless-N 1000
    -   3.5 Sound
    -   3.6 Webcam
    -   3.7 Power
-   4 Troubleshooting
    -   4.1 Delay with Space Bar
    -   4.2 Trackpoint is NOT detected or is detected after X minutes

Installation
------------

Since 2010.05 is old, install using the testisos. If there is a newer
official install release use that instead!

Hardware
--------

Using kernel 2.6.38.3

  Device                                      Works
  ------------------------------------------- ------------
  Video                                       Yes
  Ethernet                                    Yes
  Wireless (Intel Centrino Wireless-N 1000)   Yes
  Bluetooth                                   Not Tested
  Audio                                       Yes
  Camera                                      Yes
  Finger Print Reader                         Not Tested
  Card Reader                                 Not Tested

> lspci

    00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
    00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
    00:16.0 Communication controller: Intel Corporation 6 Series Chipset Family MEI Controller #1 (rev 04)
    00:1a.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
    00:1b.0 Audio device: Intel Corporation 6 Series Chipset Family High Definition Audio Controller (rev 04)
    00:1c.0 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 1 (rev b4)
    00:1c.1 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 2 (rev b4)
    00:1c.2 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 3 (rev b4)
    00:1c.3 PCI bridge: Intel Corporation 6 Series Chipset Family PCI Express Root Port 4 (rev b4)
    00:1d.0 USB Controller: Intel Corporation 6 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
    00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC Controller (rev 04)
    00:1f.2 SATA controller: Intel Corporation 6 Series Chipset Family 6 port SATA AHCI Controller (rev 04)
    00:1f.3 SMBus: Intel Corporation 6 Series Chipset Family SMBus Controller (rev 04)
    07:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
    0c:00.0 System peripheral: JMicron Technology Corp. SD/MMC Host Controller (rev 30)
    0c:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller (rev 30)
    11:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)

> lsusb

    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
    Bus 001 Device 003: ID 147e:1002 Upek 
    Bus 002 Device 004: ID 064e:c219 Suyin Corp

Configuration
-------------

> Clickpad

The clickpad works with the xf86-input-synaptic driver from extra, but
the left/right click buttons at the bottom of the clickpad do not work.

Install xf86-input-synaptics-clickpad from the AUR.

> Video

In order to use the builtin intel graphics adapter you will have to
install the corresponding drivers:

    # pacman -S xf86-video-intel

Dual Monitors

> Clone:

    xrandr --output LVDS1 --auto --output HDMI1 --auto --same-as LVDS1

> Extended:

    xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1

Disable Second Monitor

    xrandr --output LVDS1 --output HDMI1 --off

Check out the xrandr man page for more info

> Ethernet

1.  Use the r8168 module in the Official repositories
2.  Blacklist r8169 (follow pacman install message)
3.  Add r8168 to rc.conf

There are some issues with the r8169 module:

-   Kernel 3.1.5: Does not work
-   Kernel >= 3.1.4: Mileage may vary, typically can't reconnect

> Wireless

Intel Centrino Wireless-N 1000

Works out of the box. Module: iwlagn

> Sound

Works out of the box. Module: snd-hda-intel

> Webcam

Works out of the box. Tested using Skype

> Power

Suspend and Hibernation both work using pm-utils Note: Hibernation did
not work on 2.6.38.2 (works with 2.6.38.3)

Troubleshooting
---------------

> Delay with Space Bar

Solution: Update BIOS (at least 1.08)

> Trackpoint is NOT detected or is detected after X minutes

This appears to be a kernel bug. See:
https://bugzilla.kernel.org/show_bug.cgi?id=33292

A workaround is passing proto=bare to the psmouse module. However this
disable scrolling with the clickpad and the two finger middle click.

    modprobe psmouse proto=bare

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_Edge_E420s&oldid=304814"

Category:

-   Lenovo

-   This page was last modified on 16 March 2014, at 07:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
