Brother MFC-465CN
=================

The Brother MFC-465CN is a network capable multi-function printer, first
produced in 2007. Brother provides Linux printer and scanner drivers for
all its machines, however these are not normally distributed with the
usual series of Linux distribution printer driver packages (e.g hplip).
Before continuing the user should read the CUPS wiki.

Contents
--------

-   1 Installation
-   2 Run the "cupswrapper" script
-   3 Configure the Printer on the CUPS Server
-   4 Scanning
-   5 See also

Installation
------------

Install cups, cups-filters, ghostscript, gsfonts, foomatic-filters and
a2ps from Official repositories.

Install MFC-465CN Cupswrapper and MFC-465CN line printer filters from
the AUR

Note:If you use x86_64 (Arch 64 bit), you must also install
lib32-libcups (from the multilibs repository). If not, the printer job
queue appears to have been printed successfully, but the printer does
nothing and the CUPS logs contain no definitive error messages. (You may
need to uncomment the "Multilibs" line in your /etc/pacman.conf file to
enable this repository).

Run the "cupswrapper" script
----------------------------

As root run the script:

    # /usr/local/brother/Printer/mfc465cn/cupswrapper/cupswrappermfc465cn

This script will stop the cups daemon if it's running, attempt to find
and configure your printer, install the drivers and restart CUPS.

Configure the Printer on the CUPS Server
----------------------------------------

Using your browser navigate to the CUPS server. In the Administration
category, choose Manage printers. There you should see a MFC-465CN
printer automatically installed and configured. It is usually configured
to use the USB port. If the printer is used as a network printer you
need to modify the printer configuration. Select Brother MFC-465CN in
the device list. Then run through these steps: Administration, Modify
Printer, Other Network Printing, AppSocket/HP Direct, Connection: . Then
enter your IP address, example:

    socket://192.168.0.104:9100

Your IP address will be different - find it in the LAN configuration on
the MFC printer menu. Click to print a test page. If no printing,
double-check all packages and steps above have been completed properly,
restart CUPS ( #systemctl restart cups.service), restart the printer and
ensure the printer's state is Idle, accepting jobs. If still no printing
visit the CUPS wiki, Troubleshooting section.

Scanning
--------

To scan with the MFC-465CN your must install the brscan2 and brscan-skey
packages from the AUR. Install brscan2 and brscan-skey from the AUR.

Then follow these instructions: brother scanning.

See also
--------

-   Brother Linux website

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_MFC-465CN&oldid=301716"

Category:

-   Printers

-   This page was last modified on 24 February 2014, at 12:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
