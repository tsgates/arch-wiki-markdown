Lenovo Ideapad s10-3t
=====================

Contents
--------

-   1 System Specification
-   2 Network
    -   2.1 Wired Ethernet
    -   2.2 Wireless
-   3 Graphics
-   4 TouchScreen
-   5 Sound
-   6 SD Card Reader
-   7 Webcam
-   8 Accelerometer

System Specification
====================

-   CPU: Intel Atom N450 (1.66 GHz) or N470?
-   Memory: 1GB DDR2 - can be upgraded to max of 2GB
-   Ethernet: Broadcom NetLink BCM57780 Gigabit
-   WiFi: Broadcom BCM4313 or Intel Corporation WiMAX/WiFi Link 6050
    Series
-   Hard-Drive: 160GB standard with larger sizes available
-   Optical Drive: None
-   Integrated Graphics: Intel Pineview Integrated graphics
-   Touchscreen: ??? (2081:0A01) or Cando TouchScreen (2087:0A01)
-   Sound: Conexant pebble high definition smartaudip (14F1:5066) or
    Intel Corporation 82801G (ICH7 Family) High Definition Audio
    Controller (8086:27d8)
-   Screen: 10" LCD (1024x600)
-   SD Card Reader
-   Webcam: Lenovo Easycam?
-   Bluetooth: USI Co., Ltd (10ab:0816)?

Network
=======

Wired Ethernet
--------------

Have to load module broadcom then tg3 in /etc/rc.conf

    MODULES=(broadcom tg3 ...)

or add to the end of /etc/modprobe.d/modprobe.conf

    install tg3 /sbin/modprobe broadcom; /sbin/modprobe --ignore-install tg3

Wireless
--------

The Broadcom BCM4313 card requires the broadcom-wl module which is
available in the AUR.

Intel Corporation WiMAX/WiFi Link 6050 Series works out of the box
(2.6.34).

For WiMAX requires the kernel 2.6.35, i2400m-firmware, libeap,
wimax-tools and wimax-network-service which is available in the AUR.

Graphics
========

-   This came from Lenovo ideapad s10 ...
-   So far I have not been able to get keyboard/touchpad to work with or
    without xorg.conf
-   use vga=866 for the kernel line in menu.lst

The xf86-video-intel driver works well with no xorg.conf. After
installing xorg,

    pacman -S xf86-video-intel

If you startx at this point, you may not have a working keyboard or
touchpad. Installing the keyboard and synaptics drivers should fix that.

    pacman -S xf86-input-keyboard xf86-input-synaptics

If you want to use an external mouse, you may also need

    pacman -S xf86-input-mouse

While you can run a full DE like KDE or GNOME, it will be a little
sluggish on the S10. If you only have 512 MB of RAM, you will use it up
quickly. XFCE runs with more acceptable speed. LXDE (or just Openbox)
feels even more responsive. Lighter is definitely better on this
machine, especially if you haven't installed more RAM.

TouchScreen
===========

Cando TouchScreen works out of the box from kernel 2.6.35. OneTouch.

Sound
=====

-   This came from Lenovo ideapad s10

To make the volume up/down and mute keys work in Openbox, insert this in
your ~/.config/openbox/rc.xml (preferably in the section with all the
other keybindings).

        <!-- Keybindings for volume control -->
        <keybind key="XF86AudioRaiseVolume">
          <action name="Execute">
            <execute>amixer sset Master 1+</execute>
          </action>
        </keybind>
        <keybind key="XF86AudioLowerVolume">
          <action name="Execute">
            <execute>amixer sset Master 1-</execute>
          </action>
        </keybind>
        <keybind key="XF86AudioMute">
         <action name="Execute">
           <command>amixer set Master toggle</command>
         </action>
        </keybind>

SD Card Reader
==============

Works right out of the box (in fact you can even install arch directly
on it with grub.)

Webcam
======

...

Accelerometer
=============

The IAPS driver works.

    cd /usr/src
    git clone git://gitorious.org/iaps/iaps.git
    cd iaps
    make
    sudo make install
    depmod -a
    modprobe iaps
    dmesg
    (you see something like input: iaps as /devices/virtual/input/input13)

lsinput (if you have input-utils installed) will give you something like
this

    /dev/input/event12
      bustype : BUS_ISA
      vendor  : 0x0
      product : 0x0
      version : 0
      name    : "iaps"
      phys    : "isa702/input0"
      bits ev : EV_SYN EV_ABS

and you can read events like this

    $ input-events 12
    waiting for events
    15:13:53.622930: EV_ABS ABS_X 555
    15:13:53.622958: EV_SYN code=0 value=0
    15:13:53.973886: EV_ABS ABS_X 541
    15:13:53.973916: EV_SYN code=0 value=0
    15:13:54.024218: EV_ABS ABS_X 556
    15:13:54.024240: EV_ABS ABS_Y 532
    15:13:54.024243: EV_SYN code=0 value=0
    15:13:54.073551: EV_ABS ABS_X 555
    ...

Here are some ideas what to do with it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Ideapad_s10-3t&oldid=267099"

Category:

-   Lenovo

-   This page was last modified on 19 July 2013, at 20:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
