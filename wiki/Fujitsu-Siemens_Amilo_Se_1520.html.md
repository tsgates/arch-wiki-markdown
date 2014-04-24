Fujitsu-Siemens Amilo Se 1520
=============================

This info may be helpful in addition to the Arch Linux Installation
guide.

Contents
--------

-   1 LAPTOP SPECS
-   2 ETHERNET
-   3 XORG CONFIGURATION
-   4 SOUND
-   5 TOUCHPAD
-   6 WIRELESS LAN
-   7 ACPI
-   8 S-OUT
-   9 Bluetooth
-   10 HOTKEYS, SPECIAL BUTTONS
-   11 CARD SLOTS
-   12 External Links

LAPTOP SPECS
------------

-   CPU: Intel Core 2 Duo 1800Mhz, 1024MB ram, 60Gb SATA HD,
    CD-RW/DVD-RW (QSI).
-   Video: Intel Mobile 945GM/PM/GMS/940GML
-   Touchpad: Synaptics Mouse
-   wifi: ipw3945
-   Audio: HDA Intel
-   Broadcom 440x 10/100 and Intel PRO/Wireless 2200GB.
-   4 USB ports
-   Firewire
-   Bluetooth
-   1 card slots.

ETHERNET
--------

Works, perfectly

XORG CONFIGURATION
------------------

See Intel Graphics.

SOUND
-----

Works poorly in Linux. Alsa is able to determine driver, but SPDIF
doesn't work and external microphone too. Luckily internal microphone
(above LCD) works good, though you can't change its' volume or disable
it in alsamixer.

TOUCHPAD
--------

Install the synaptics driver with

        pacman -S synaptics

In xorg.conf

    Section "ServerLayout"
    	Identifier     "Layout0"
    	Screen         0 "Screen_local" 0 0
    	InputDevice    "Keyboard0" "CoreKeyboard"
    	InputDevice    "TouchPad" "CorePointer"
    	InputDevice    "ExtMouse" "SendCoreEvents"
    EndSection

    Section "InputDevice"
    	Identifier  "TouchPad"
    	Driver      "synaptics"
    	Option	    "Protocol" "Auto"
    	Option	    "Emulate3Buttons"
    	Option	    "Device" "/dev/input/mouse0"
    	Option	    "VertEdgeScroll" "true"
    	Option	    "HorizEdgeScroll" "true"
    	Option	    "SHMConfig" "true"
    EndSection

    Section "InputDevice"
    	Identifier  "ExtMouse"
    	Driver      "mouse"
    	Option	    "Protocol" "Auto"
    	Option	    "Device" "/dev/input/mice"
    EndSection

If you just change Driver to synaptics, external mouse will not work at
all. This way you will have external mouse working and horizontal scrool
on touch pad.

Also, I would recommend you to add following in ~/.xinitrc:

    syndaemon -i 0.5 -d

It will disable touch pad, while you typing.

WIRELESS LAN
------------

Fortunately, we have Linux native driver ipw3945, just install it and
use wifi-radar

ACPI
----

You will need to install powersave and add "powersaved" into
/etc/rc.conf.

S-OUT
-----

not tested

Bluetooth
---------

not tested

HOTKEYS, SPECIAL BUTTONS
------------------------

Alt+Function key commands work ok, but the special buttons on the left
side of the keyboard do not work out of the box.

CARD SLOTS
----------

not tested

External Links
==============

-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: Fujitsu-Siemens - FSC.
-   See my personal page about, feel free a help

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fujitsu-Siemens_Amilo_Se_1520&oldid=249598"

Category:

-   Fujitsu

-   This page was last modified on 6 March 2013, at 05:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
