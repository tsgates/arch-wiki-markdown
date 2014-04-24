Brother HL-5140
===============

This is a small tutorial to make the Brother HL-5140 printer work on
Arch Linux. If you previously tried to install the printer in CUPS,
remove it.

Gutenprint drivers
------------------

Install cups, gutenprint and ghostscript.

Next configure cups to allow access to the web interface for relevent
users:

A user-name and password will be required when administering the printer
in the web interface, such as: adding or removing printers, stopping
print tasks, etc. The default user-name is the one assigned in the sys
group, or root (change this by editing /etc/cups/cupsd.conf in the line
of SystemGroup). (Source)

Then blacklist the usblp kernel module. See Kernel_modules#Blacklisting
for instructions.

Now turn on and plug in the printer. Then start the cups daemon.

Now go to http://localhost:631

-   Go to Administration
-   Click 'Add Printer'
-   Select the printer (which should be listed under 'Local Printers')
    and click 'Continue'
-   Configure the name, description, location and sharing.
-   Select 'Brother' as the printer make
-   Select 'Brother HL-5140 - CUPS+Gutenprint vX.X.X (xx)' and then
    click 'Add Printer'
-   Finish by configuring any settings

The printer should work fine now.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-5140&oldid=207306"

Category:

-   Printers

-   This page was last modified on 13 June 2012, at 16:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
