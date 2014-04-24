Fujitsu-Siemens Amilo Pro V3205
===============================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 System Specifications
-   2 Installation
    -   2.1 Video
    -   2.2 Wireless Network
    -   2.3 Suspend
    -   2.4 Power management
-   3 Keyboard
-   4 External Links

System Specifications
=====================

-   Intel Core 2 Duo 1.66 GHz
-   Intel 945GM Chipset
-   1024 MB DDR2
-   120GB SATA HDD
-   NEC DL DVD-RW
-   Intel GMA 950 graphics with shared memory
-   12.1" WXGA - 1280x800
-   Intel 80281G High Definitio Audio soundcard
-   Ricoh Co Ltd R5C822 4in1 card reader
-   IEEE1394 port
-   4 USB 2.0 ports
-   Intel ProWireless 3945 wireless card
-   Intel Pro/100 VE ethernet controller
-   Bluetooth v2
-   DVI output
-   S-Video out

Installation
============

A hub error message is printed repeatedly:

    hub 1-0:1.0: connect-debounce failed, port 6 disabled

A workaround is to disable the laptop's wi-fi device in BIOS.

Video
-----

See Intel Graphics.

Wireless Network
----------------

See Wireless#iwl3945, iwl4965 and iwl5000-series wiki article.

Suspend
-------

See Suspend and Hibernate.

Power management
----------------

See Power management.

Keyboard
========

To setup windows keys (useful for fluxbox keybindings) as well as
multimedia keys (accessed with Fn + the function keys) recognition in X,
edit ~/.Xmodmap

    keycode 115 = XF86ApplicationLeft 
    add mod4 = XF86ApplicationLeft 
    keycode 116 = XF86ApplicationRight
    add mod4 = XF86ApplicationRight
    keycode 117 = XF86MenuKB
    keycode 162 = XF86AudioPlay
    keycode 164 = XF86AudioStop
    keycode 144 = XF86AudioPrev
    keycode 153 = XF86AudioNext
    keycode 223 = XF86Sleep
    keycode 160 = XF86AudioMute
    keycode 176 = XF86AudioRaiseVolume
    keycode 174 = XF86AudioLowerVolume

If you have amarok, configure the global shortcuts, setting the
multimedia keys as "alternate".

External Links
==============

-   This report is listed at the Gentoo wiki and Lubos Vrbka's homepage.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fujitsu-Siemens_Amilo_Pro_V3205&oldid=299471"

Category:

-   Fujitsu

-   This page was last modified on 21 February 2014, at 22:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
