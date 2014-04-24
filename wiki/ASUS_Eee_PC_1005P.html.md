ASUS Eee PC 1005P
=================

  --------------- --------- ---------------
  Device          Status    Modules
  Video           Working   i915
  Ethernet        Working   atl1c
  Wireless        Working   ath9k
  Audio           Working   snd_hda_intel
  Camera          Working   uvcvideo
  Card Reader     Working   
  Function Keys   Working   
  --------------- --------- ---------------

This article describes both the 1005P and the 1005PE, since the only
difference of the 1005PE is wlan n and a bigger harddrive.

Contents
--------

-   1 Installation
-   2 Kernel
-   3 Xorg
    -   3.1 Video Driver
    -   3.2 Device Autodetection
    -   3.3 Graphic Performance
    -   3.4 Touchpad
    -   3.5 xrandr
-   4 Powersaving and ACPI
    -   4.1 laptop-mode-tools
        -   4.1.1 Setup
        -   4.1.2 LCD brightness
        -   4.1.3 SHE
    -   4.2 Hotkeys
-   5 Hardware Info

Installation
------------

1.  Installing from USB: according to the article on installing from
    USB, the standard ISO images can be used for this (beginning with
    release 2010.05).
2.  Installing via PXE works well. It requires another computer to use
    as PXE host, and some configuration.

Kernel
------

Nothing to need to be done. If you have append acpi_osi=Linux to your
kernel parameters before, please remove it. Or the touchpad may not work
in KDE (although it works in KDM and Gnome) and the touchpad activation
key [Fn]-[F3] has no effect at all.

Xorg
----

> Video Driver

Install xf86-video-intel.

> Device Autodetection

Everything works out of the box.

> Graphic Performance

The default graphic performance is the best you can currently get. It is
not needed to add "optimizations" like "AccelMethod" "exa" to your
xorg.conf, because these will get ignored by the current version of the
Intel drivers anyway. The only thing you can add is XvMC Hardware
decoding support, which allows your Intel graphics adapter to decode
MPEG2 video material. To do this and set XvMC, here is a minimal
xorg.conf:

     Section "Device"
         Identifier "Card0"
         Driver "intel"
         Option "XvMC" "on"
     EndSection

More is not needed in your xorg.conf, since Xorg uses input hotplugging.

To let X know where the XvMC library is, run:

     # echo /usr/lib/libIntelXvMC.so > /etc/X11/XvMCConfig

> Touchpad

Install xf86-input-synaptics (see Touchpad Synaptics). To enable Two
Finger Scrolling and to disable Edge Scrolling, add this to your
/etc/X11/xorg.conf.d/10-synaptics.conf inside the InputClass Section:

     Option "VertTwoFingerScroll" "true"
     Option "HorizTwoFingerScroll" "true"
     Option "EmulateTwoFingerMinZ" "10"
     Option "EmulateTwoFingerMinW" "7"
     Option "VertEdgeScroll" "false"
     Option "HorizEdgeScroll" "false"

> xrandr

For a nice GUI tool, you can try lxrandr.

Switch to external monitor (VGA port):

    xrandr --output LVDS1 --off --output VGA1 --auto

Switch back to eeepc's LCD:

    xrandr --output LVDS1 --auto --output VGA1 --off

Powersaving and ACPI
--------------------

Your best bet is to disable all hardware you do not intend to use (to
access the BIOS settings, press F2 after rebooting).

See power saving for details.

> laptop-mode-tools

Laptop-mode-tools provides an easy way to setup most of the available
power saving options, which include spinning down the hard drive and
adjusting the power saving modes of the harddrive and CPU, as well as
autosuspending the USB-ports, setting screen brightness, configuring the
eee's own 'Super Hybrid Engine', etc.

Setup

    # pacman -S laptop-mode-tools

The main configuration file is /etc/laptop-mode/laptop-mode.conf, plus
there are several separate configuration files in
/etc/laptop-mode/conf.d/ for the various power saving modules managed by
laptop-mode-tools. The files are well commented, so it should be easy to
set everything up as needed. (For more information, see Laptop Mode
Tools)

To make the daemon start at boot, add laptop-mode to the DAEMONS array
in /etc/rc.conf.

LCD brightness

The relevant configuration file is
/etc/laptop-mode/conf.d/lcd-brightness.conf. Brightness values are
between 0 (darkest) and 15 (brightest). An example of usable settings:

    BATT_BRIGHTNESS_COMMAND="echo 1"
    LM_AC_BRIGHTNESS_COMMAND="echo 15"
    NOLM_AC_BRIGHTNESS_COMMAND="echo 15"
    BRIGHTNESS_OUTPUT="/sys/class/backlight/acpi_video0/brightness"

SHE

The eeepc's 'Super Hybrid Engine' has a significant effect on
powersaving. This underclocks the FSB for powersave/overclocks for
performance and can be controlled via the file
/sys/devices/platform/eeepc/cpufv which is provided by the module
eeepc_laptop. You can manage this with laptop-mode-tools. The relevant
config file is /etc/laptop-mode/conf.d/eee-superhe.conf.

> Hotkeys

Some work out of the box (see Asus Eee PC 1005HA#Hotkeys for more).

Hardware Info
-------------

lspci says:

    00:00.0 Host bridge: Intel Corporation Pineview DMI Bridge
    00:02.0 VGA compatible controller: Intel Corporation Pineview Integrated Graphics Controller
    00:02.1 Display controller: Intel Corporation Pineview Integrated Graphics Controller
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation Tigerpoint LPC Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA AHCI Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    01:00.0 Ethernet controller: Atheros Communications Atheros AR8132 / L1c Gigabit Ethernet Adapter (rev c0)
    02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1005P&oldid=304861"

Category:

-   ASUS

-   This page was last modified on 16 March 2014, at 08:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
