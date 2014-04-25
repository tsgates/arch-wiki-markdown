IBM ThinkPad T43p
=================

The Thinkpad laptops are known for their durability and build quality.
However, one must tweak a bit his linux to unleash the real potential of
this square box hardware. This one will not be a guide to get a fancy
eyecandy-full machine, but fast (considering the hardware) geeky
machine, which does the job efficiently.

Contents
--------

-   1 System specs
-   2 The installation
    -   2.1 Config Files (found int /etc/ dir)
-   3 Powersaving and ACPI
-   4 Programs that ease CLI life
-   5 X.org and friends
    -   5.1 Desktop Manager
    -   5.2 awesomewm and desktop interaction stuff

System specs
------------

-   Intel Pentium M (Dothan) 2.13GHz CPU
-   ATI Mobility FireGL V3200 with 128MB
-   14.1" TFT display with 1400x1050 resolution
-   2GB PC2-4200 RAM
-   80GB 7.2k rpm HDD

  

-   Broadcom Gigabit Ethernet (10/100/1000)
-   MiniPCI slot with Intel PRO/Wireless 2915ABG Mini-PCI Adapter
-   IBM Integrated Bluetooth IV with 56K Modem (BMDC-3)

  

-   Intel AC'97 Audio with a AD1981B codec
-   UltraBay Slim with DVD±RW
-   CardBus slot (Type 2)
-   ExpressCard/54 slot
-   IBM Embedded Security Subsystem 2.0
-   IBM Active Protection System
-   Integrated Fingerprint Reader on select systems
-   UltraNav (TrackPoint / Touchpad combo)

The installation
----------------

Well the basic installation can be found in the Beginners' guide.
However, there was done a lot of customization to suit my need and here
I will try to list them.

Basically what I did was to do several optimizations shown in HDAPS
article as well as in tp_smapi article. What is more hdd spindown tweaks
were applied in order to solve the problem of hd failures due to
numerous times when it might get spined down.

> Config Files (found int /etc/ dir)

The contents of /etc/rc.local can be found here.

Powersaving and ACPI
--------------------

My handler.sh can be found here.

Programs that ease CLI life
---------------------------

The list of programs which I usually use for my everyday life:

-   VTE - urxvt{c,d}
-   Shell - zsh
-   Editor - vim (used together with latexsuite)
-   RSS Reader - canto
-   MPD Client - ncmpcpp
-   Versioning system - git
-   File Manager - ranger
-   Network Manager - wicd-curses
-   IRC client - weechat

X.org and friends
-----------------

> Desktop Manager

In the beginning I have been using SLiM, but the switch to CDM. The
latter is simpler, faster and far more stable. What is more it might be
the case that is more customizable as well.

> awesomewm and desktop interaction stuff

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_T43p&oldid=298124"

Category:

-   IBM

-   This page was last modified on 16 February 2014, at 07:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
