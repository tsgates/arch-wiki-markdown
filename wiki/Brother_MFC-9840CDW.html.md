Brother MFC-9840CDW
===================

  

Contents
--------

-   1 Printing
    -   1.1 Introduction
    -   1.2 Setup with PostScript + Brother's Official .ppd file
    -   1.3 Old Method
        -   1.3.1 Setup with PostScript + Foomatic
        -   1.3.2 Setup with PCL-6 and Gutenprint
-   2 Scanning

Printing
========

Introduction
------------

This is a small tutorial to make the printer Brother MFC-9840CDW work on
Arch, through a wired (ethernet cable) network connection.

Brother released an official .ppd (postscript printer description) file
on June 24, 2009. It is available from [1]. This .ppd file lets you
change essential printer settings such as color/mono in the
application's dialog box (such as Firefox), and is thus recommended over
the previous method of using generic printer drivers.

Setup with PostScript + Brother's Official .ppd file
----------------------------------------------------

TIP: You can add multiple versions of the MFC-9840CDW by repeating the
steps below, and then for each version, changing the printer settings
with the Set Printer Options button in CUPS. This way, you can quickly
set up default settings that you use often (e.g., color vs. greyscale),
and then print with these options by simply selecting the corresponding
printer in your application (instead of using the application-specific
printer dialog box each time you want to print using non-default
settings).

-   Install the cups package. Make sure it's working by going to
    http://localhost:631
-   Download Brother's official .ppd file from [2].
-   Make sure the printer is connected to your network router/switch. If
    your router is acting as a DHCP server, the MFC-9840CDW will
    automatically get an IP address assigned. Make note of this IP
    address. (You could also assign a static IP address to your printer,
    but that is outside the scope of this article).
-   Go to http://localhost:631 to open up the CUPS web interface.
-   Click on the Administration tab and then click on Add printer.
-   Select the "Internet Printing Protocol (http)" option for the
    Device.
-   For the Device URI, use:
    http://IPADDRESSOFPRINTER:631/POSTSCRIPT_P1. E.g.,
    http://192.168.0.102:631/POSTSCRIPT_P1
-   For the Make/Manufacturer, provide the official .ppd file that you
    downloaded.
-   Click on Add Printer to finish the wizard.

Make sure to modify the default settings, such as page size (change this
to letter, if you are not using A4 paper), auto/color/mono for color
settings, toner save on/off, as well as duplex mode (DuplexTumble is
short-edge duplex, and DuplexNoTumble is long-edge.)

Old Method
----------

Additionally, you can set it up with either the generic postscript
drivers, or PCL-6 drivers with gutenprint (as the MFC-9840CDW supports
PCL-6 emulation). The postscript driver has fewer settings, and is easy
to set up, whereas the PCL-6 driver has more options, although it is
more experimental (and doesn't support color). As of February 2009, the
postscript driver always has color on by default, whereas the PCL-6
driver is always set to greyscale -- so you may want to add two
printers, with one for each.

> Setup with PostScript + Foomatic

The MFC-9840CDW natively supports the postscript format, so for basic
printing functionality we'll be using the generic postscript driver that
comes with the foomatic packages. (Again, it is recommended to download
Brother's official .ppd file instead of using the generic ones as shown
below.)

-   Install the cups package. Make sure it's working by going to
    http://localhost:631
-   Install the foomatic-db, foomatic-db-engine, and foomatic-filters
    packages (to get the generic postscript driver that we need).
-   Make sure the printer is connected to your network router/switch. If
    your router is acting as a DHCP server, the MFC-9840CDW will
    automatically get an IP address assigned. Make note of this IP
    address. (You could also assign a static IP address to your printer,
    but that is outside the scope of this article).
-   Go to http://localhost:631 to open up the CUPS web interface.
-   Click on the Administration tab and then click on Add printer.
-   Select the "Internet Printing Protocol (http)" option for the
    Device.
-   For the Device URI, use:
    http://IPADDRESSOFPRINTER:631/POSTSCRIPT_P1. E.g.,
    http://192.168.0.102:631/POSTSCRIPT_P1
-   For the Make/Manufacturer, click on Generic, then Generic PostScript
    Printer Foomatic/Postscript (en) (do not choose the "Level 1"
    variant, as it is an older postcript driver for older printers)
-   Click on Add Printer to finish the wizard.

Print out a test page to see if everything works. The above
configuration allows you to change the duplex and resolution (dpi)
settings within CUPS, via the Set Printer Options button under the
Printers tab, but is missing the "Toner save" option. Of course, this
and all other settings are still accessible via the printer's own web
interface, which makes any changes the default settings of the printer
(see the official Brother documentation).

> Setup with PCL-6 and Gutenprint

The MFC-9840CDW also natively supports (via emulation) the PCL-6 format,
so we can take advantage of this feature. The procedure is essentially
identical as with the postscript configuration above, except for a
couple of things.

-   Install the gutenprint package.
-   Instead of postscript_p1 in the Device URI field, use pcl_p1 (the
    pcl has a lowercase 'L', not a numeral 'one').
-   Under For the Make/Manufacturer, click on Generic again, but instead
    choose the Generic PCL 6/PCL XL Printer - CUPS+Gutenprint v.5.2.3
    (en) option. (The Gutenprint version number is dependant, of course,
    on which version of gutenprint you have installed.)

Customize the default printer settings, to the extent that they are
controlled by CUPS, by clicking on the Set Printer Options button in the
CUPS web interface. You will notice that the Gutenprint driver has many
more options than the generic PostScript driver. You may want to repeat
the procedure above and add a second printer, and then customize this
second printer's settings to your liking (e.g., color instead of
greyscale).

Note: As there are many different PCL-6 drivers available, you may want
to experiment with using these different ones instead of the
CUPS+Gutenprint one. To change the driver, click on Modify Printer and
go through the wizard, just like when you were adding the printer from
the beginning.

Scanning
========

Brother has released its own SANE drivers, called brscan. For the
MFC-9840CDW, the brscan3 driver is needed, and is available on AUR.
Then, run the brsaneconfig3 tool (use the -h option for help) to add
your scanner. Also add yourself to the scanner group to scan as a normal
user. You can then download the xsane package with pacman, and launch
xsane.

You might want to disable the "Enable color management" option from
Xsane (under Preferences) if you do not care about embedded color
profiles (the brscan3 driver does not come with a color profile, and
Xsane will continually warn you with a pop-up if it cannot find a color
profile).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_MFC-9840CDW&oldid=196827"

Category:

-   Printers

-   This page was last modified on 23 April 2012, at 13:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
