Acer Aspire 5745g
=================

Contents
--------

-   1 Introduction
-   2 Hardware
-   3 Networking
    -   3.1 Wireless
-   4 Power Management
    -   4.1 CPU frequency scaling
        -   4.1.1 The laptop-mode-tools way
        -   4.1.2 Another method
-   5 Xorg
-   6 Touchpad
-   7 Hotkeys

Introduction
============

General info about the Acer Aspire 5745G. There is also updated info
concerning the much-alike laptop Acer Aspire 5745PG.

Hardware
========

Processor: Intel Core i5-450M 2.4GHz

Video: Intel Integrated Graphics and NVIDIA GeForce GT 330M switchable
(Second Generation)

Audio: Intel Corporation 5 Series/3400 Series Chipset High Definition
Audio (rev 05)

Wired NIC: Atheros Communications AR8151 v1.0 Gigabit Ethernet (rev c0)

Wireless NIC: Broadcom Corporation BCM43225 802.11b/g/n (rev 01)

  

    $ lspci -nn
    00:00.0 Host bridge [0600]: Intel Corporation Core Processor DRAM Controller [8086:0044] (rev 18)
    00:01.0 PCI bridge [0604]: Intel Corporation Core Processor PCI Express x16 Root Port [8086:0045] (rev 18)
    00:16.0 Communication controller [0780]: Intel Corporation 5 Series/3400 Series Chipset HECI Controller [8086:3b64] (rev 06)
    00:1a.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 05)
    00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56] (rev 05)
    00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 [8086:3b42] (rev 05)
    00:1c.5 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 [8086:3b4c] (rev 05)
    00:1d.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 05)
    00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev a5)
    00:1f.0 ISA bridge [0601]: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller [8086:3b09] (rev 05)
    00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller [8086:3b29] (rev 05)
    00:1f.3 SMBus [0c05]: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller [8086:3b30] (rev 05)
    00:1f.6 Signal processing controller [1180]: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem [8086:3b32] (rev 05)
    01:00.0 VGA compatible controller [0300]: nVidia Corporation GT216 [GeForce GT 330M] [10de:0a29] (rev a2)
    01:00.1 Audio device [0403]: nVidia Corporation High Definition Audio Controller [10de:0be2] (rev a1)
    02:00.0 Ethernet controller [0200]: Atheros Communications AR8151 v1.0 Gigabit Ethernet [1969:1073] (rev c0)
    03:00.0 Network controller [0280]: Broadcom Corporation BCM43225 802.11b/g/n [14e4:4357] (rev 01)
    3f:00.0 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers [8086:2c62] (rev 05)
    3f:00.1 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture System Address Decoder [8086:2d01] (rev 05)
    3f:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI Link 0 [8086:2d10] (rev 05)
    3f:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI Physical 0 [8086:2d11] (rev 05)
    3f:02.2 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d12] (rev 05)
    3f:02.3 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d13] (rev 05)

Networking
==========

The current livecd release 2010.05 doesn't support either the ethernet
or the wireless, which can put you in a rather uncomfortable spot,
especially if you were hoping to netinstall.

The older kernel in the 2010 build doesn't support either, though newer
versions of the kernel do. Use a more recent iso from the testiso to do
your install and it should find both cards just fine (for reference, I
used 2011.04.10, which is no longer avaliable, see the latest and hope
that it works!)

Wireless
--------

The brcm80211 driver is included in the kernel since 2.6.37. No further
action is necessary on the part of the user. See Wireless network
configuration if you have problems.

You can manage your wireless connections with NetworkManager or Wicd.

Power Management
================

CPU frequency scaling
---------------------

> The laptop-mode-tools way

You probably want to use laptop-mode-tools with acpi.

    pacman -S laptop-mode-tools acpi

> Another method

In /etc/rc.conf, add the following modules :

    [...]

    MODULES=( ... acpi-cpufreq cpufreq_ondemand)

    [...]

And put the following lines in /etc/rc.local :

    [...]

    echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo "ondemand" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
    echo "ondemand" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    echo "ondemand" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

Xorg
====

To get the video card to behave, I went into BIOS and set the graphics
card mode to Discrete instead of Switching

You will want to install the Nvidia drivers

    $ sudo pacman -S nvidia nvidia-utils

If you are already running xorg with vesa or nouveau (which works btw)
you will need to restart for nouveau to be blacklisted.

Then you should be able to

    $ sudo nvidia-xconfig
    $ startx

See nvidia.

Touchpad
========

You should install xf86-input-synaptics, worked out of the box for me
with xorg.

If you want to use your mouse without xorg, you can use GPM

    $ sudo gpm /dev/input/mouse0 -t ps2

Hotkeys
=======

Volume up/down & mute can be mapped with xbindkeys.

    $ pacman -S xbindkeys alsa-utils

and then edit ~/.xbindkeysrc and add:

    # Increase volume
    "amixer set Master playback 1+"
        m:0x10 + c:123
        Mod2 + XF86AudioRaiseVolume 
    # Decrease volume
    "amixer set Master playback 1-"
        m:0x10 + c:122
        Mod2 + XF86AudioLowerVolume
    # Toggle mute
    "amixer set Master toggle"
        m:0x10 + c:121
        Mod2 + XF86AudioMute

then edit your ~/.xinitrc file and add

    xbindkeys &

somewhere before your exec line.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_5745g&oldid=297877"

Category:

-   Acer

-   This page was last modified on 15 February 2014, at 15:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
