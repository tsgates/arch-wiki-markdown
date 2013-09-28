Dell Vostro 1500
================

Test Configuration: 1.4Ghz Core 2 Duo; 2G RAM, Intel integrated Graphics
card, Bluetooth, no webcam

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 Problems                                                     |
|                                                                          |
| -   2 Installation                                                       |
| -   3 Xorg                                                               |
|     -   3.1 Xorg 7.4                                                     |
|         -   3.1.1 Touchpad                                               |
|                                                                          |
| -   4 Wireless                                                           |
|     -   4.1 Intel PRO/Wireless 3945                                      |
|     -   4.2 Wicd                                                         |
|                                                                          |
| -   5 Suspend/Hibernate                                                  |
| -   6 Adjust Brightness                                                  |
| -   7 Modem                                                              |
| -   8 Webcam                                                             |
| -   9 USB, SD card slot, Ethernet, Firewire, VGA, S-video                |
| -   10 Mediakeys                                                         |
| -   11 SD Card Reader                                                    |
| -   12 References                                                        |
+--------------------------------------------------------------------------+

Hardware
========

  ------------------------------------ ---------- ------------------
  Device                               Status     Modules
  Intel GM965/GL960 Onboard Graphics   Working    xf86-video-intel
  NVIDIA GeForce 8400M GS              Working    Nouveau
  Ethernet                             Working    b44
  Wireless                             Working    iwl3945
  Audio                                Working    snd_hda_intel
  Modem                                Untested   
  Card Reader                          Working    
  ------------------------------------ ---------- ------------------

Problems
--------

No problems noted after a few days of use.

Installation
============

1.  Use the standard Arch installation disc (I used
    archlinux-2009.02-core-i686.iso). Note that the FULL install disk
    (with "core" in the name instead of "ftp", approx. 320MB) has the
    necessary drivers to install wireless networking for the Intel
    PRO/Wireless 3945 card. You can use the "ftp" install disc if you
    will be installing the base system over wired ethernet.)
2.  Follow the Beginners_Guide

Xorg
====

Xorg 7.4
--------

1.  Install xorg

        pacman -S xorg

2.  Install Synaptic Mouse Driver

        pacman -S xf86-input-synaptics

The new xorg auto-configuration (starting without an xorg.conf file)
worked fine for me. In fact, none of the recommended methods of
generating a usable starting xorg.conf file worked for me. So try the
easy route and just "startx." Note that CTRL-ALT-BACKSPACE is disabled
by default in the latest Xorg, so if you do not have a window manager
installed, you might need to use CTRL-ALT-F1 to get back to a console to
CTRL-C kill Xorg manually.

> Touchpad

The default synaptics configuration is set up for two finger vertical
scroll and one-tap click, which works well for me. See
Touchpad_Synaptics for more info.

Wireless
========

Intel PRO/Wireless 3945
-----------------------

One source of helpful information about your hardware is the Arch
package 'hwd' Install with:

     pacman -S hwd

If your hwd -s shows this:

     Network    : PRO/Wireless 3945ABG [Golan] Network Connection module: iwl3945

You are required to get iwlwifi-3945-ucode out of [core].

    # pacman -S iwlwifi-3945-ucode

This package is also available [core-devel] on the 2009.02 installer CD.

Then add iwl3945 to your MODULES array in /etc/rc.conf

    MODULES=( ... iwl3945 ... )

If your hwd -s shows another wireless card, search the Arch wiki for
information or see the Wireless Startup Guide.

Wicd
----

Wicd is a network manager which allows you to connect to wireless
networks very easily, you can follow this wiki page Wicd

Suspend/Hibernate
=================

Still untested, but the following is pasted in from a page about the
Dell Inspirion 1521:

-   Suspend and Hibernate works with pm-utils
-   Also works by issuing

        echo mem > /sys/power/state

Adjust Brightness
=================

Adjust normally with the FN Keys if your using the kernel 2.6.24 or
greater

Modem
=====

Untested for me, but this may work for you: You need hsfmodem package
from AUR in order to get modem working. After you install that package
you need to:

1.  Run hsfconfig as root to build the module and initialise the modem.
    A reboot is required before the modem can be initialised. Run
    hsfconfig again after reboot.
2.  The modules are automatically loaded and a /dev/modem symlink is
    setup for use with the modem. Now use wvdial or other dialer
    programs to connect to the internet.

I didn't test dialing, however I could see the modem device in /dev.

Webcam
======

I do not have one, but you may need the uvcvideo module (someone confirm
this)

    # modprobe uvcvideo

Add it to your /etc/rc.conf modules line. More information can be found
in Webcam_Setup wiki entry.

For more information see the Webcam_Setup page.

USB, SD card slot, Ethernet, Firewire, VGA, S-video
===================================================

All work out of the box.

Mediakeys
=========

Get xbindkeys from [extra]:

    # pacman -S xbindkeys

Add 'xbindkeys &' in $HOME/.xinitrc right before your window manager is
executed.

Create $HOME/.xbindkeysrc file with:

    "amixer set Master 5+ unmute"
     XF86AudioRaiseVolume

    "amixer set Master 5- unmute"
     XF86AudioLowerVolume

    "amixer set 'Master' toggle"
     XF86AudioMute

    #"audioplayer -next"
    # XF86AudioNext

    #"audioplayer -pause"
    # XF86AudioPlay

    #"audioplayer -stop"
    # XF86AudioStop

    #"audioplayer -previous"
    # XF86AudioPrev

SD Card Reader
==============

Works out of the box. I do this to mount:

     sudo mkdir /mnt/scard
     sudo mount -t vfat /dev/mmcblk0p1 /mnt/sdcard

References
==========

Audio:

-   ALSA
-   OSS
-   for "model=stack3" in /etc/modprobe.d/modprobe.conf - OpenSuse Forum
-   for "model=dell-bios" in /etc/modprobe.d/modprobe.conf - Gentoo Wiki

Video:

-   Xorg
-   Xorg input hotplugging
-   Dell laptop displays with 1280×800 as WXGA
-   for Xorg.conf without autodetect
-   GRUB: Framebuffer Resolution

Keyboard & Synaptics:

-   Touchpad Synaptics
-   Dell Mousepad Settings
-   HAL policy file
-   Changing keyboard layout

Wireless:

-   Intel PRO wireless 3945abg
-   Broadcom BCM4312

Webcam:

-   Webcam Setup

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Vostro_1500&oldid=196592"

Category:

-   Dell
