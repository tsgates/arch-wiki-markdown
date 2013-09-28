ASUS Eee PC 1015PX
==================

  --------------- --------- ---------------
  Device          Status    Module
  Ethernet        Working   atl1c
  Wireless        Working   brcmsmac
  Video           Working   i915
  Audio           Working   snd-hda-intel
  Camera          Working   uvcvideo
  Card Reader     Working   N/A
  Function Keys   Partial   N/A
  --------------- --------- ---------------

This article is in reference too the Asus Eee PC 1015PX however
configuration will most likely be almost identical for its sister models
like the 1015PN and 1015PE.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Ethernet                                                           |
| -   3 Wireless                                                           |
| -   4 Video                                                              |
|     -   4.1 Xorg                                                         |
|     -   4.2 Brightness                                                   |
|                                                                          |
| -   5 Function Keys                                                      |
+--------------------------------------------------------------------------+

Installation
------------

The 1015PX does not have a CD Drive so the installation will have to be
performed using a USB Stick. To create an Arch Linux USB Installer
please see the article on installing from a USB. Once you have a
bootable USB insert it into the 1015PX and press the F2 key during
pre-boot to enter the boot menu and select which device to boot from.

Continue your installation as described in the Arch Install Guide and
ensure that you include the following packages in your install:

-   base-devel
-   bin86
-   ed
-   linux-headers

Finish the installation and Arch should boot up and run as expected,
except for network connectivity.

Ethernet
--------

The 1015PX makes use of the Atheros AR8152 v2.0 Ethernet Controller, if
you are following this guide using a similar Netbook then run lspci to
double check yours uses the same hardware.

atl1c module in included in the Arch Kernel and works without problem
since version 3.2.13-1. Y can go back to following the Arch Install
Guide to configure your network.

Wireless
--------

The 1015PX uses the Broadcom 4727 for wireless networking, configuring
the device should work fine by simply following the Wireless Setup Guide
and using the brcmsmac module.

Video
-----

The 1015PX uses an Intel GMA 3150 Graphics Processor, while such a
device may not be able to run graphically heavier Desktop Environments
like GNOME Shell and KDE 100% smoothly, more lightweight options such as
gnome-fallback, Xfce and Openbox run fantastically.

GNOME Shell and KDE will run within tolerable speeds, but speeds may not
be preferable to all. For the case of gnome, fallback mode maybe
preferred as it runs faster. Note that if gnome-shell is installed,
gnome-fallback will have to be forced, as GNOME loads into GNOME shell
by default: see "enabling fallback".

> Xorg

Installing X on the 1015PX is incredibly simple since X will run
straight out of the box. See Xorg.

> Brightness

With some Eee PC's, the brightness setting are either too low, or are
sometimes a little inconstant or arbitrary (inconsistent on each boot,
eg. high to low/completely off). If you have issues with this, issue
this command to fix it:

    # setpci -s 00:02.0 f4.b=80

The 80 represents the desired range for brightness in hexadecimal, where
FF allows to maximum brightness. 80 is about half and is generally ideal
but may need to be tweaked to suit one's need.

Note this is not permanent, so it should be added to rc.local:

    /etc/rc.d/rc.local

    #!/bin/sh

    ...

    setpci -s 00:02.0 f4.b=80

Function Keys
-------------

  -------------- --------------------- ------------------------------
  Key            Action                Working?
  F1             Sleep                 Yes
  F2             Toggle WiFi           Yes
  F3             Toggle Touchpad       Depends on WM
  F4             Select Resolution     Requires a hotkey and script
  F5             Decrease Brightness   Yes
  F6             Increase Brightness   Yes
  F7             Backlight Off         No
  F8             Toggle Monitor        Yes (unconfirmed)
  F9             Task Manager          Requires a hotkey
  F10            Mute                  Yes
  F11            Decrease Volume       Yes
  F12            Increase Volume       Yes
  Insert         Num Lock              Yes
  Delete         Scroll Lock           Yes
  Arrow: Up      Page Up               Yes
  Arrow: Down    Page Down             Yes
  Arrow: Left    Home                  Yes
  Arrow: Right   End                   Yes
  -------------- --------------------- ------------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1015PX&oldid=253583"

Category:

-   ASUS
