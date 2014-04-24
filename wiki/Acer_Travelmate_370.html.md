Acer Travelmate 370
===================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Doesnt work
-   2 Unknown
-   3 Works Poorly
-   4 Works

Doesnt work
-----------

-   Nothing

Unknown
-------

-   Infrared
-   Modem

Works Poorly
------------

-   SD card reader
    -   Driver is new and somewhat unstable. sdricoh_cs [1]
-   Hotkeys
    -   Driver is unmaintained. acerhk [2]

Works
-----

-   Wireless
    -   ipw2100. Needs firmware pacman -S ipw2100-fw
-   Audio
    -   snd-intel8x0, blacklist snd-intel8x0m
-   Suspend To Ram (s2ram)
    -   acpi_sleep=s3_bios on kernel boot arguments
    -   Option "VBERestore" "on" in xorg.conf (using i830 xorg driver)
    -   Occasionally needs to run "vbetool post" when the mouse cursor
        dissappears on resume. may be fixed by using SWCursor instead?
-   Touchpad
    -   Touchpad Synaptics
-   Everything not listed

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Travelmate_370&oldid=196490"

Category:

-   Acer

-   This page was last modified on 23 April 2012, at 12:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
