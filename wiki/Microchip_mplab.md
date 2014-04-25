Microchip mplab
===============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page is a placeholder, I will expand it shortly

Contents
--------

-   1 MPLABX vs MPLAB
-   2 Installation
    -   2.1 install wine
    -   2.2 install winetrics
    -   2.3 install needed dll's
    -   2.4 install MPLAB
-   3 Starting MPLAB
-   4 known problems / troubleshooting

MPLABX vs MPLAB
---------------

MPLAB is the windows-only version of MPLAB. MPLABX is the version that
is multi platform, and also works under linux. MPLAB however is mature,
and MPLABX is beta at this moment. The simulator of MPLABX is not yet as
good as the simulator of MPLAB.

Installation
------------

> install wine

    # pacman -S wine
    # pacman -S wine_gecko

> install winetrics

    # pacman -S winetrics 

> install needed dll's

    $ winetricks vcrun6

> install MPLAB

Download mplab from the following site: [www.microchip.com [1]]. Scroll
to the bottom of the page, and download MPLAB IDE

unzip mplab:

    $ unzip MPLAB_IDE_8_83.zip
    $ wine setup.exe

MPLAB is installed in the following location: .wine/drive_c/Program
Files (x86)/Microchip/MPLAB IDE/Core

Starting MPLAB
--------------

    $ cd .wine/drive_c/Program Files (x86)/Microchip/MPLAB IDE/Core
    $ wine MPLAB.exe

known problems / troubleshooting
--------------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Microchip_mplab&oldid=207235"

Category:

-   Wine

-   This page was last modified on 13 June 2012, at 15:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
