Brother MFC-9320CW
==================

  

Contents
--------

-   1 Introduction
-   2 Required packages
-   3 Download Brother drivers
-   4 Extracting the RPM files
-   5 Editing files to make them work with Arch
-   6 Installing the driver and printer

> Introduction

This is largely a copy of the Brother MFC-440CN tutorial with changes
made to fit this specific printer.

> Required packages

Install rpmextract, ghostscript, gsfonts, foomatic-filters and a2ps from
Official repositories.

Note:If you use x86_64, you must also install lib32-libcups (from the
multilibs repository) for this printer driver to work! When
lib32-libcups is not installed, the printer refuses to print, but no
error message is given

> Download Brother drivers

First create a temporary directory. Download the lpr driver and
cupswrapper driver rpm files from Brother's website. The full list of
brother linux drivers can be found here and these instructions can be
followed for other printers as well as the MFC-9320CW.

> Extracting the RPM files

Now you use a small script called rpmextract which allows you to get the
files included in the RPM you've just downloaded. Extract both RPM
files :

    # rpmextract.sh mfc9320cwlpr-1.1.1-4.i386.rpm
    # rpmextract.sh mfc9320cwcupswrapper-1.1.1-4.i386.rpm

It should give you a usr directory with two sub-directories: bin and
local.

> Editing files to make them work with Arch

Arch Linux uses its own file system organization, so you have to modify
some files before copying them into place.

    # /bin/sed -i 's|/etc/init.d|/etc/rc.d|' usr/local/Brother/Printer/mfc9320cw/cupswrapper/cupswrappermfc9320cw
    # /bin/cp -r usr/* /usr

> Installing the driver and printer

Last step ! Run the cupswrapper file:

    # /usr/local/Brother/Printer/mfc9320cw/cupswrapper/cupswrappermfc9320cw

It will stop the cups daemon if it's running, and restart it. Now go to
the CUPS page : http://localhost:631/ In the Administration category,
choose Manage printers. There you should see a MFC-9320CW printer
automatically installed and configured. It is intially configured to use
the USB port. If the printer is used as a network printer you need to
modify the printer configuration. Choose Modify printer, and select
Brother MFC-9320CW in the device list. If it doesn't exist choose
LPD/LPR Host or Printer instead. Then in Device URI you enter the
printer IP, e.g lpd://10.0.0.10. You will find the IP address in the LAN
configuration on the printer itself. The rest of the configuration is
preset, so just choose continue. Click to print the test page, and you
can hear the sweet sound of your printer. If not, try to restart your
printer, and make sure the printer's state is Idle, accepting jobs.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_MFC-9320CW&oldid=301603"

Category:

-   Printers

-   This page was last modified on 24 February 2014, at 11:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
