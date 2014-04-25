Netgear Fwg114p as Print Server
===============================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Mark out of date 
                           long time ago. Useful    
                           information already      
                           covered in CUPS.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

There are a lot of routers that have an included printserver. They
usually only delivers with windows-information and no support is given
to linux.

The problem when printing to those printservers is that there are no
documentation of what port should be used. I do not know if this
particular port works on other similar printservers.

Netgear fwg114p is a router, firewall, vpn-server and printserver with
usb-port. This guide also works for the Netgear PS101 a parallel print
server.

Set it up
---------

1.  Download the packets needed (i.e. the printing-system and the
    filters needed. In my case hpijs and foomatic. That depends on what
    printer you have.)
    -   # pacman -Syu cups, hpijs, foomatic

2.  Make sure your printer could be connected through this kind of
    printserver.
    -   (Look in list of compatible printers and/or check by using a
        windowsmachine that can use the software normally delivered with
        the box)
    -   Connect the printer to the print-server-box

3.  Start CUPS
    -   (See CUPS setup for details on cups start and downloading,
        filters, etc)

4.  Connect to CUPS-server through web-interface http://localhost:631
    -   Choose 'Add printer' and name it whatever you like
    -   Choose 'LPD/LPR' socket
    -   Write 'lpd://192.168.0.45/p1/' if your print-server-box have an
        ip-adress of 192.168.0.45 (note that it wouldn't work for me
        until I added the trailing '/')
    -   Choose your printer from the list.
        -   (The list will change when one downloads packages so if your
            printer is not in the list - just stop and check at
            www.archlinux.org what package to get in order to get the
            appropriate filters for your printer)

5.  Print a test-page and see that everything works fine!

Problems
--------

I have had problems to get cups work properly the last half year, and
each time I had to reinstall perl to get it to work. When it once worked
there were no problems.

Many usb-printers are slightly more than a shell (GID-printers) and
those might not be possible to connect to a print-server since they need
software-installation from the computer each start-up. Some of them can
be used in linux but none can be used connected to a print-server of
this kind (It doesn't matter if one uses windows or linux)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netgear_Fwg114p_as_Print_Server&oldid=302838"

Category:

-   Printers

-   This page was last modified on 2 March 2014, at 06:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
