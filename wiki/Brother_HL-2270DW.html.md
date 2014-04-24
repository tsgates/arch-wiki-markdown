Brother HL-2270DW
=================

This is a short tutorial on installing the Brother HL-2270DW printer
with CUPS on Arch Linux.

Contents
--------

-   1 Installing printer driver
-   2 Setup printer and CUPS
    -   2.1 Using IPP
-   3 Troubleshooting
    -   3.1 Margins are off
    -   3.2 Some simple reminders

Installing printer driver
-------------------------

Install the brother-hl2270dw package from the AUR.

Setup printer and CUPS
----------------------

Note:This article details how to setup you printer over a LAN or WLAN
connection.

This printer has a web-based interface. To avoid some extra Google
queries, the HL-2270DW web interface default username is 'admin' and the
default password is 'access'.

It is recommended that you configure the HL-2270DW to have a static IP
so that CUPS will always work with it (steps not detailed in this
article).

1.  Install CUPS and Foomatic:

        # pacman -S cups a2ps

2.  Start the cups daemon:

        # systemctl start cups

3.  Open a web browser to http://localhost:631/
4.  Click the Administration tab then click the Add Printer button.

> Using IPP

1.  Select IPP from the list.
2.  In the 'Connection' field, type

        ipp://THE_PRINTER_IP/ipp/port1

3.  In the next form, give the printer a unique name (no spaces and the
    name be must unique from any identical printers), and select
    "Brother" from the printer make field.
4.  Select "Brother HL2270DW for CUPS (en)" from the list of drivers (it
    is not in numerical order and is toward the bottom of the list).
5.  Configure the default options on the next page to your liking
    1.  Set Duplex to DuplexNoTumble for double-side printing
    2.  Set TonerSave to on to enable toner saving

Troubleshooting
---------------

> Margins are off

If your margins do not fit the page selected, check to see if the the
Brother HL-2170W (Postscript Printer Description) PPD will fix the
problem.

1.  Click the 'directly download PPD' link for the Brother HL-2170W
2.  Install hplip
3.  Go to CUPS->Administration->Manage Printers. Select your printer
    under 'Queue Name'.
4.  In the 'Administration' drop-down, select 'Modify Printer'; your IP
    address will be selected, click 'Continue' button; your current
    printer information will be shown with other options.
5.  Click on the "Select Another Make/Manufacturer"; click "Choose File"
    button.
6.  Navigate to the file you downloaded
    "Brother-HL-2170W-hpijs-pcl5e.ppd"
7.  Click 'Modify Printer'.
8.  Click on the 'Maintenance' drop-down and select 'Print Test Page'.
    Check margins for conformance to the page size selected.

> Some simple reminders

1.  Sometimes if you get simple errors like "spool not ready" or "ipp
    backend failed", there is a good chance you have to resume the
    printer by selecting the Maintenance drop down and selecting Resume
    Printer.
2.  To set default printer for printing in a console:

    $ lpoptions -d <PRINTER_NAME>.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-2270DW&oldid=303574"

Category:

-   Printers

-   This page was last modified on 8 March 2014, at 08:01.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
