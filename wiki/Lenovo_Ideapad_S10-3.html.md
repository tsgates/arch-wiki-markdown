Lenovo Ideapad S10-3
====================

  

Contents
--------

-   1 System Specification
-   2 Wireless
    -   2.1 Free kernel driver for the Broadcom BCM4113 chipset
    -   2.2 Non-free alternative driver for the Broadcom BCM4113 chipset
    -   2.3 Free kernel driver for the Atheros AR9285 802.11b/g chipset
-   3 Graphics
-   4 Input
    -   4.1 Function Keys
-   5 Suspend & Hibernate
-   6 Card Reader
-   7 Web Cam

System Specification
====================

-   CPU: Intel Atom N450 (1.66 GHz, 512 MB L2 cache)
-   Memory: 1 GB DDR2 SDRAM - can be expanded to a maximum of 2GB (one
    RAM slot)
-   WiFi: Broadcom BCM4113
-   Hard-Drive: 250 GB 2,5" SATA, 5400 RPM
-   Optical Drive: None
-   Integrated Graphics: Intel GMA 3150
-   Sound: Intel HDA: Realtek ALC272
-   Screen: 10.1" LCD 1024x600 (WSVGA)
-   5 in 1 Card Reader
-   Webcam: Lenovo Easycam

Note:Some newer models have an Intel Atom N455 (same spec as 450) and
1GB of DDR3 memory.

Wireless
========

This laptop uses a Broadcom BCM4113 chipset for wireless networking.
Some revisions have an Atheros AR9285 802.11b/g chipset.

Free kernel driver for the Broadcom BCM4113 chipset
---------------------------------------------------

As of kernel version 2.6.37, there is now a Free driver in the kernel:
brcmsmac. This driver should be loaded out of the box. It does however
suffer from a resume issue in kernel 2.6.37 when the laptop resumes from
suspend. The Wi-Fi does not come back up unless it is reloaded.

Non-free alternative driver for the Broadcom BCM4113 chipset
------------------------------------------------------------

An alternative may be the 802.11 Linux STA driver, which can be
installed from the AUR: broadcom-wl

Free kernel driver for the Atheros AR9285 802.11b/g chipset
-----------------------------------------------------------

The ath9k module is detected by udev and loaded out of the box.

Some users report issues with the ath9k driver and this particular
chipset. In this case, use the ndiswrapper method. Also, add !ath9k and
ndiswrapper to the MODULES array in /etc/rc.conf.

Graphics
========

The Intel GMA 3150 requires the xf86-video-intel module. No xorg.conf
file is required.

Input
=====

The keyboard and touchpad work more or less without problems using the
xf86-input-keyboard and xf86-input-synaptics modules, respectively.
Right- and left-clicking works, as well as vertical edge scrolling and
right-click tapping. I have not managed to get two- and three-finger
taps to work, nor two-finger scroll.

Function Keys
-------------

The function keys only work for some extent, e.g. the keys for turning
off the LCD backlight works but not those for turning on and off Wi-Fi,
touchpad, etc. To make the volume keys work, map "XF86AudioRaiseVolume"
to "amixer set Master 5%+" and "XF86AudioLowerVolume" to "amixer set
Master 5%-"

The brightness keys do not work and do not appear to be recognized by
the system. To adjust brightness, I modified this script [1] and mapped
Super+Up and Super+Down to the up and down scripts, respectively.

Create a file called something like "brighness_up" in a directory of
your choice, e.g. /home/your_user_name/scripts/brightness_up

Paste the text below, and save the file.

    #!/bin/bash

    # these are the possible values:
    # 42 56 70 92 AF CC E5 FF
    # 30 40 50 60 70 80 90 100 %

    Current=`sudo setpci -s 00:02.0 F4.B`
    case $Current in
      42)
        sudo setpci -s 00:02.0 F4.B=56
      ;;
      56)
        sudo setpci -s 00:02.0 F4.B=70
      ;;
      70)
        sudo setpci -s 00:02.0 F4.B=92
      ;;
      92)
        sudo setpci -s 00:02.0 F4.B=af
      ;;
      af)
        sudo setpci -s 00:02.0 F4.B=cc
      ;;
      cc)
        sudo setpci -s 00:02.0 F4.B=e5
      ;;
      e5)
        sudo setpci -s 00:02.0 F4.B=ff
      ;;
    esac
    Current=`sudo setpci -s 00:02.0 F4.B`
    case $Current in
      42)
        notify-send "Brightness is at 30%"
      ;;
      56)
        notify-send "Brightness is at 40%"
      ;;
      70)
        notify-send "Brightness is at 50%"
      ;;
      92)
        notify-send "Brightness is at 60%"
      ;;
      af)
        notify-send "Brightness is at 70%"
      ;;
      cc)
        notify-send "Brightness is at 80%"
      ;;
      e5)
        notify-send "Brightness is at 90%"
      ;;
      ff)
        notify-send "Brightness is at 100%"
      ;;
    esac

And make the file executable, e.g

    chmod u+x ~/scripts/brightness_up

For lowering the screen brightness, make a script containing this:

    #!/bin/bash

    # these are the possible values:
    # 42 56 70 92 AF CC E5 FF
    # 30 40 50 60 70 80 90 100 %

    Current=`sudo setpci -s 00:02.0 F4.B`
    case $Current in
      ff)
        sudo setpci -s 00:02.0 F4.B=e5
      ;;
      e5)
        sudo setpci -s 00:02.0 F4.B=cc
      ;;
      cc)
        sudo setpci -s 00:02.0 F4.B=af
      ;;
      af)
        sudo setpci -s 00:02.0 F4.B=92
      ;;
      92)
        sudo setpci -s 00:02.0 F4.B=70
      ;;
      70)
        sudo setpci -s 00:02.0 F4.B=56
      ;;
      56)
        sudo setpci -s 00:02.0 F4.B=42
      ;;
    esac
    Current=`sudo setpci -s 00:02.0 F4.B`
    case $Current in
      42)
        notify-send "Brightness is at 30%"
      ;;
      56)
        notify-send "Brightness is at 40%"
      ;;
      70)
        notify-send "Brightness is at 50%"
      ;;
      92)
        notify-send "Brightness is at 60%"
      ;;
      af)
        notify-send "Brightness is at 70%"
      ;;
      cc)
        notify-send "Brightness is at 80%"
      ;;
      e5)
        notify-send "Brightness is at 90%"
      ;;
      ff)
        notify-send "Brightness is at 100%"
      ;;
    esac

Note: With Kernel 3.10.10-1 the function keys, including Wifi, touchpad,
volume, and brightness, work out of the box

Suspend & Hibernate
===================

acpid needs to be installed. This laptop has problems resuming correctly
from suspend. If your laptop screen does not come back on after
suspending and resuming, you need to add additional kernel boot options:

-   Kernel 2.6.x users should try:

intel_idle.max_cstate=0

-   Kernel 3.x users should try:

nohpet

or

hpet=disable highres=off nohz=off

Note: With Kernel 3.10.10-1 Suspend/Resume works out of the box

Card Reader
===========

Works out of the box.

Web Cam
=======

Works out of the box

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Ideapad_S10-3&oldid=274873"

Category:

-   Lenovo

-   This page was last modified on 9 September 2013, at 17:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
