Toshiba Satellite A100-386
==========================

Contents
--------

-   1 ACPI and Power Saving
-   2 Networking
-   3 Wireless
-   4 Audio
-   5 Graphics
-   6 Framebuffer
-   7 Modem
-   8 Touchpad
-   9 SD card reader
-   10 FireWire
-   11 DVD burner

ACPI and Power Saving
---------------------

Unlike older Toshiba laptops, this one has a PhoenixBIOS and will NOT
work with the toshiba_acpi module nor utilities which make use of
toshiba_acpi. The Omnibook project doesn't support this laptop just yet,
as no documentation has been released by Toshiba. Anyway, there's a
PKGBUILD for omnibook-svn in AUR. As a result, the FN hotkeys are
unusable at the moment. But you can use the ACPI video module to control
the brightness of the LCD screen:

    $ modprobe video
    $ cat /proc/acpi/video/GFX0/LCD/brightness #get the available brightness levels
    $ echo 10 > /proc/acpi/video/GFX0/LCD/brightness # set the LCD brightness

The EasyGuard hard disk protection also has no Linux driver at the
moment.

You can use one of powersave, powernowd, cpudyn, cpufreqd or similar
utilities to control CPU frequency scaling with the speedstep_centrino
module.

Networking
----------

Intel Corp. Ethernet Controller. Use the e100 module.

Wireless
--------

Intel Corporation|PRO/Wireless 3945ABG. Install the driver for your
kernel(s), daemon and microcode (and accept the license of the
software):

    $ pacman -S ipw3945 ipw3945d ipw3945-ucode

Add ipw3945d to your daemons array (you might want to start it before
network though).

Audio
-----

The latest alsa patch included in the ARCH kernel adds the definitions
for Toshiba integrated sound cards. But I get really low volume with
this one so I prefer to force the model to 3stack instead:

Add this line to /etc/modprobe.d/modprobe.conf:

    options snd-hda-intel model=3stack

Graphics
--------

NVIDIA GeForce Go 7300. Use the nvidia module if you want Direct
Rendering or xf86-video-nv if you do not care/want to install
proprietary drivers.

    $ pacman -S nvidia
    or
    $ pacman -S xf86-video-nv

Framebuffer
-----------

The Video BIOS doesn't have the 1280x800 resolution although X11 can use
it without problems. So, no 1280x800 framebuffer for you. Sorry !

Modem
-----

Working with the slmodem driver and ALSA.

Touchpad
--------

It's a standard Synaptics touchpad. Just install the driver and follow
the instructions.

    pacman -S synaptics

SD card reader
--------------

Texas Instruments Card Reader. Use the tifm_sd module. Untested.

FireWire
--------

Untested but should work.

DVD burner
----------

Works fine out-of-the-box.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_A100-386&oldid=196740"

Category:

-   Toshiba

-   This page was last modified on 23 April 2012, at 13:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
