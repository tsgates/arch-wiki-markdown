Dell Latitude D810
==================

This section will describe the installation and configuration process of
Arch Voodoo 0.8 with Gnome on a Dell Latitude D810 laptop. No dual boot
here.

So far Arch is working very well on this laptop.

Contents
--------

-   1 Hardware
-   2 Partioning
-   3 Base install
    -   3.1 Connect to the network
    -   3.2 Installing packages
        -   3.2.1 Synchronize pacman
        -   3.2.2 Wireless adapter
        -   3.2.3 Sound
        -   3.2.4 DSLR Camera (Canon EOS Rebel XTI)
        -   3.2.5 Multimdedia
-   4 Working
-   5 Need Fixing / Polishing
-   6 External links

Hardware
========

-   Audio: SIGMATEL STAC 975X AC97
-   CPU: Intel Pentium M 750 (1.86Ghz)
-   LCD: 15.4" WUXGA (1900x1200)
-   Network: Broadcom Corporation NetXtreme BCM5751 Gigabit Ethernet
-   Wireless: Intel Corporation PRO/Wireless 2200BG
-   Video: ATI Mobility Radeon X600 128MB

Partioning
==========

By default, if you use automatic partitioning, Arch will divide your
drive in 4 partitions.

-   /boot
-   SWAP
-   /
-   /home

I decided to use my entire 80GB drive and use 3 partitions.

-   /boot (EXT2 30 megs)
-   SWAP (1GB)
-   / (EXT3 entire drive)

Base install
============

I downloaded the Arch Voodoo 0.8 beta version then decided to install
only the base system for you can build your system without all the clump
other distributions have to offer. The install process was super fast
and I did not encounter any problem.

I will try to document and add screens it as much as I can during the
next couple of days.

Connect to the network
----------------------

The network card worked out of the box. It uses the tg3 driver.

Unless you've changed the settings in your rc.conf, you will need to
call the dhcp daemon to get an IP from your router or whatever.

Code:

    # dhcpcd eth0

Installing packages
-------------------

Once you're connected to the network, you will want to update your
pacman database.

> Synchronize pacman

Code:

    # pacman --Syu

> Wireless adapter

Code:

    # pacman -S ipw2200-fw

> Sound

Code:

    # pacman -S alsa-utils

Once the sound is setup, you can use alsamixer to configure your sound
card. Some channels will be muted by defaut (your microphone for
example). Use the m key to mute and unmute channels, tab to go to the
next screen and escape to exit.

Add alsa to your daemons in /etc/rc.conf

    # -----------------------------------------------------------------------
    # DAEMONS
    # -----------------------------------------------------------------------
    #
    # Daemons to start at boot-up (in this order)
    #   - prefix a daemon with a ! to disable it
    #   - prefix a daemon with a @ to start it up in the background
    #
    DAEMONS=(syslog-ng network netfs crond alsa)

> DSLR Camera (Canon EOS Rebel XTI)

In order to get my camera working, libgphoto2 was needed. To organise
them, I will use F-Spot.

Code:

    # pacman -S libgphoto2
    # pacman -S f-spot

Now that the proper applications are installed, I need to add my user to
the camera group.

Code:

    # gpasswd -a userfoo camera

Note: you need to log off after you've added your user to a group!!!

> Multimdedia

-   gstreamer0.10-mpeg2dec
-   gstreamer0.10-dvdread
-   gstreamer0.10-dts (for sound)
-   gstreamer0.10-a52dec (for AC3 sound)
-   gstreamer0.10-mad (for MP3 sound)

Working
=======

-   Audio (ALSA)
-   Video (xf86-video-ati)
-   Wireless (ipw2200-fw)
-   Network (tg3)
-   Divx (Mplayer)
-   MP3s (Banshee)
-   Torrents (Azureus)
-   Canon EOS Rebel XTI (libgphoto2)
-   Ekiga (SIP softphone)

Need Fixing / Polishing
=======================

-   Fonts are super ugly.
-   Fonts are too small.
-   Colors are not nice.
-   Special keys.
-   Wireless led.
-   Need to compile a custom kernel.
-   Need to write a custom perl script for wireless.
-   Where is the xorg.conf?

External links
==============

-   This document is listed at the TuxMobil Linux laptop and notebook
    installation guides survey (DELL).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_D810&oldid=196578"

Category:

-   Dell

-   This page was last modified on 23 April 2012, at 12:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
