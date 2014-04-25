Brother HL-2170W
================

This is a short tutorial on installing the Brother HL-2170W (and the
HL-2140) printer with CUPS on Arch Linux. This printer will work a few
different ways: with Foomatic, with the HP PCL6 driver, or with
cupswrapper. For further info on cupswrapper please see the Brother
MFC-440CN guide.

Note:As of July 2011, The foomatic/ljet4 driver using IPP has been shown
to be really successful on most Arch setups, please attempt that first.

Contents
--------

-   1 Setup printer and CUPS
    -   1.1 Using IPP (recommended method)
    -   1.2 Using the HP PCL6 driver (alternative method)
-   2 Troubleshooting

Setup printer and CUPS
----------------------

This printer has a web-based interface. To avoid some extra Google
queries, the HL-2170w web interface default username is 'admin' and the
default password is 'access'.

It is recommended to configure the HL-2170W to have a static IP so that
CUPS will always work with it (steps not detailed in this article).

The needed pdd/drivers are available from this device from the
OpenPrinting Database. There is no need to directly browse to this page
or download ppd files directly; it has been given for reference only.

1.  Install CUPS and Foomatic:

        # pacman -S cups foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters ghostscript

2.  Start the cups socket

        systemctl start cups.socket

3.  Optionally, enable the socket to load a system boot time:

        systemctl enable cups.socket

4.  Open a web browser to http://localhost:631/
5.  Click the Add Printer button on the Administration tab.

Continue to one of the following subsections:

> Using IPP (recommended method)

1.  Select IPP from the list.
2.  In the 'Connection' field, type

        ipp://THE_PRINTER_IP/ipp/port1

3.  In the next form, give the printer a unique name (no spaces and the
    name be must unique from any identical printers), and select
    "Brother" from the printer make field.
4.  Select "Brother HL-2170W Foomatic/hl1250" from the list of drivers.
5.  The defaults options should be configured to the user's liking.

> Using the HP PCL6 driver (alternative method)

This driver is not ideal, but it works.

1.  Click the Add Printer Button (fill out the form) (click Continue)
2.  Select Internet Printing Protocol (IPP) from the drop down menu
    (click Continue)
3.  In the Device URI field add the following line:

        http://printer:631/ipp/port1

    Where printer is the IP address or DNS name of the printer (click
    Continue)

4.  Select "HP" from the printer make field.
5.  Select "HP LaserJet Series PCL 6 CUPS (en)" from the list of
    drivers.

Troubleshooting
---------------

Some simple reminders

1.  Some users have reported problems characterized by error message
    like, "spool not ready" or "ipp backend failed." One solution is to
    resume the printer by selecting the Maintenance drop down and
    selecting Resume Printer.

1.  If you notice that the printer margins are off, try installing
    brother-hl2170w and select that driver in CUPS, then edit the file
    at /usr/share/Brother/inf/brHL2170Wrc and change "PaperType" to
    "Letter". See this post for more information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-2170W&oldid=296547"

Category:

-   Printers

-   This page was last modified on 8 February 2014, at 08:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
