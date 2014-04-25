Lenovo ThinkPad S440
====================

  
 This article was written to assist you with getting archlinux run on
the Lenovo ThinkPad S440. It is meant to be help you with some tricky
points aside to the Beginners' guide: A guide through the whole process
of installing and configuring Arch Linux; written for new or
inexperienced users.

Contents
--------

-   1 Prerequisites
    -   1.1 Creating an installation medium
    -   1.2 Enable Legacy Boot
-   2 Installation
    -   2.1 LAN
    -   2.2 WLAN
    -   2.3 Audio
    -   2.4 Video
    -   2.5 Touchpad
    -   2.6 Frequency scaling
    -   2.7 Webcam
    -   2.8 Keyboard backlight
    -   2.9 Fingerprint scanner
    -   2.10 Suspend
    -   2.11 Power consumption
        -   2.11.1 Automatic brightness control

Prerequisites
-------------

> Creating an installation medium

To create a bootable USB-Stick with the archlinux*.iso you downloaded,
simply:

     dd bs=4M if=archlinux*.iso of=/dev/sdX && sync

which will/should behave like a regular bootable CD-Rom in addition to a
capable BIOS and the correct bootsequence! In doubt or in case of
problems see Install from a USB flash drive for more detailed
instructions.

> Enable Legacy Boot

On boot press F12 to enter the BIOS menu and choose your USB-Stick to
boot from. If you like, you can disable UEFI boot completely in the BIOS
settings too.

Installation
------------

After that it is recommended to follow the usual installation procedure
described in the Beginners' guide.

> LAN

Works out of the box with module r8169.

If you use Lenovo's Thinkpad OneLink Dock you need asix-ax88179-dkms for
it's ThinkPad OneLink GigaLAN adapter. The module ax88179_178a delivered
with the stock kernel doesn't work.

> WLAN

Works out of the box with module iwlwifi.

> Audio

Works out of the box with module snd-hda-intel.

> Video

The S440 comes with ati intel hybrid graphics. Currently the best
implementation for i915/ fglrx hybrids is found in the unofficial
catalyst repository.

     pacman -S catalyst-hook catalyst-utils-pxp xf86-video-intel intel-dri

You can switch between the two drivers with on of the following
commands:

     # intel
     aticonfig --px-igpu

     # ati
     aticonfig --px-dgpu

If you encounter tearing in video playback when using Intel graphics
(some S440 variants come without dedicated ATI chip), try enabling the
Intel drivers' "TearFree" option.

> Touchpad

A synaptics touchpad with two-finger scrolling. Install
xf86-input-synaptics to get it running with multi-touch gestures.

> Frequency scaling

Work well with cpupower as described in CPU Frequency Scaling. Be aware,
that the ondemand governer doesn't work with i7 4500M atm. I choose
powersave as default.

> Webcam

Works out of the box with uvcvideo.

> Keyboard backlight

Currently the thinkpad_acpi module does not support to turn the keyboard
backlight on. But you can turn it off with:

     echo 0 > /sys/devices/platform/thinkpad_acpi/leds/tpacpi::thinklight/brightness

> Fingerprint scanner

To get that working you need fprintd and libfprint-vfs5011-git. Follow
the Fprint guide for the rest.

> Suspend

Works flawlessly with with pm-utils or any DE integration.

> Power consumption

With cpupower, laptop-mode-utils and acpid installed and graphics
switched to intel gpu, I get over 9 hours battery life.

Automatic brightness control

If you want to change the brightness on ac-adaper plug-on/off, add the
following in /etc/acpi/handler.sh:

     ac_adapter)
         case "$2" in
             AC|ACAD|ADP0|ACPI0003:00)
                 case "$4" in
                     00000000)
                         logger 'AC unpluged'
                         echo "20" > /sys/class/backlight/acpi_video0/brightness
                         ;;
                     00000001)
                         logger 'AC pluged'
                         echo "50" > /sys/class/backlight/acpi_video0/brightness
                         ;;
                 esac
                 ;;

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_S440&oldid=298116"

Category:

-   Lenovo

-   This page was last modified on 16 February 2014, at 07:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
