Brother HL-2140
===============

The Brother HL-2140 is a greyscale laser printer. It is compatible with
CUPS on Arch Linux, using the hplip driver collection.

Contents
--------

-   1 Install packages
-   2 Download PPD
-   3 Start CUPS
-   4 Add printer

Install packages
----------------

Install cups and hplip. If you have previously installed
printing-related packages, you may want to remove them and any other
configurations or modifications you've applied.

Download PPD
------------

Download the necessary PPD from OpenPrinting's HL-2140 page (direct
link).

Start CUPS
----------

If it is not already running, start CUPS:

# systemctl start cups.service

If you want CUPS to be enabled on startup, enable it:

# systemctl enable cups.service

Add printer
-----------

If you haven't already, connect the printer to your computer. Next, get
the address of the printer:

# lpinfo -v

If you are using a direct USB connection, look for the line beginning
with direct usb://. Next add the printer. The name is up to you.

# lpadmin -p <name> -E -v <address> -P </path/to/ppd_file>

Check that the printer was added successfully:

$ lpstat  -p

Print a test file:

$ lpr -P <name> </path/to/file>

If you want, make the printer the default:

# lpoptions -d <name>

See the article on CUPS for more in-depth instructions.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-2140&oldid=293125"

Category:

-   Printers

-   This page was last modified on 16 January 2014, at 10:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
