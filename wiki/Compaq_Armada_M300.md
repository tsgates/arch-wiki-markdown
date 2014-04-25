Compaq Armada M300
==================

This article describes the additional configuration needed on a brand
new Arch Linux installation to get the most of a Compaq Armada M300
laptop.

This laptop is very old but with Arch Linux and the following setup it
is still useful for browsing, skyping and even "light open officing".

Contents
--------

-   1 Hardware identification
-   2 Hardware setup
    -   2.1 Video
    -   2.2 CPU scaling
    -   2.3 Wireless
-   3 Additional configuration
    -   3.1 Restore values at boot
    -   3.2 Hotkey configuration
        -   3.2.1 LCD brightness
        -   3.2.2 LCD / VGA switch
        -   3.2.3 Volume up, down and mute
-   4 Problems and not tested issues
    -   4.1 Dual monitor

Hardware identification
-----------------------

After installing Arch Linux i686, please check that:

    # lscpu

    Architecture:          i686
    CPU(s):                1
    Thread(s) per core:    1
    Core(s) per socket:    1
    CPU socket(s):         1
    Vendor ID:             GenuineIntel
    CPU family:            6
    Model:                 8
    Stepping:              6
    CPU MHz:               600.000

and

    # lspci

    00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) (rev 03)
    00:04.0 CardBus bridge: Texas Instruments PCI1211
    00:05.0 VGA compatible controller: ATI Technologies Inc 3D Rage LT Pro (rev dc)
    00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
    00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
    00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
    00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
    00:08.0 Multimedia audio controller: ESS Technology ES1978 Maestro 2E (rev 10)
    00:09.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 09)
    00:09.1 Serial controller: Agere Systems LT WinModem

corresponds to your hardware.

Hardware setup
--------------

Lets get the features of the laptop correctly working in order to get
the most of it.

> Video

Necessary driver packages:

-   xf86-input-synaptics
-   xf86-video-mach64

> Note:

-   For additional information, see the Xorg page.
-   Update: Oct, 24, 2010: The AUR package mach64drm should bring back
    3D rendering for current kernel versions.

> CPU scaling

See CPU Frequency Scaling.

Note:If you are unable to switch frequencies, please check the BIOS
settings for SpeedStep support

> Wireless

Even though the M300 has no default wireless support, you might have a
PCMCIA card. For it to work, you must first install iproute2, then bring
it up:

    # ip link set wlp2s0 up

Note:Your card may be given a name other than wlp2s0. Check by issueing
the command iwconfig

and watch the neighborhood:

    # iwlist scan

Note:If you run into troubles with your wireless card, check the
Wireless network configuration article

Additional configuration
------------------------

> Restore values at boot

In order to have the mixer to always get back to the presetted values,
install alsa-utils and add the following to a script

    # mixer settings
    amixer set Master on 31
    amixer set PCM on 25
    amixer set Mic cap
    amixer set Capture on 8

Then call it from a systemd unit. Enable that unit.

For you to get your clock always updated, install ntp, add to the
previous script:

    # set the time
    sleep 20        # give sometime for the network to connect
    if (($(ip route| wc -l) > 3)); then
            ntpdate pool.ntp.org
    fi

Note:You might need this if your CMOS battery is gone

> Hotkey configuration

LCD brightness

Add the following to /usr/local/bin/backlight_control:

    /usr/local/bin/backlight_control

    dec}"
    esac

LCD / VGA switch

Create /usr/local/bin/switch_display and add the following:

    /usr/local/bin/switch_display

Volume up, down and mute

Create a script called /usr/local/bin/volume_control:

    /usr/local/bin/volume_control

     tail -n 1 

Problems and not tested issues
------------------------------

> Dual monitor

You'd probably have to do it by hand. Add this to the beginning of your
~/.xinitrc:

    # set multiple monitors
    xrandr --verbose --output LVDS1 --mode 1024x768 --primary
    xrandr --verbose --output VGA1 --mode 1024x768 -r 75.1 --right-of LVDS1

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compaq_Armada_M300&oldid=297863"

Category:

-   HP

-   This page was last modified on 15 February 2014, at 15:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
