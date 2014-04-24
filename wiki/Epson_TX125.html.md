Epson TX125
===========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page provides instructions for installing the Epson TX125 printer
driver.

First, install cups from the official repositories and
epson-inkjet-printer-n10-nx127 from the AUR.

Create a new udev rule, /etc/udev/rules.d/10-usbprinter.rules, with the
following content.

    ATTR{idVendor}=="04b8", ATTR{idProduct}=="085c", MODE:="0666", GROUP:={"lp"}, E$

Verify idVendor and idProduct by running # lsusb -v.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Epson_TX125&oldid=287907"

Category:

-   Printers

-   This page was last modified on 14 December 2013, at 02:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
