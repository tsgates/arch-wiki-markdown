Brother HL-2040
===============

  

Contents
--------

-   1 Summary
-   2 Prerequisites
-   3 Download Brother HL-2040 drivers
-   4 Extracting the RPM files
-   5 Editing files to make them work with Arch
-   6 Installing the driver and printer
    -   6.1 Enable cups daemon
-   7 Regional Settings
-   8 Alternate Method (foomatic)
    -   8.1 Install Required Packages
    -   8.2 Enable cups daemon
    -   8.3 Start Cups
        -   8.3.1 Finish Installation from the KDE menu (Optional)

Summary
=======

This guide explains how to install a Brother HL-2040 laserjet printer
using CUPS.

Note: If you already attempted (and failed) to install the driver in
CUPS, remove it before proceeding with this tutorial.

Prerequisites
=============

This tutorial assumes you have already configured the CUPS printer
server. There is plenty of existing information to get this working.

Download Brother HL-2040 drivers
================================

Create a temp directory such as /home/username/brother

Download the RPM packages of the LPR driver (HERE) and the CUPS wrapper
(HERE) and place them into your newly created temp dir

  
 You may also download a ppd for HL-2040 from here. This one has the
margins problem fixed.

Extracting the RPM files
========================

You'll need to grab a script to extract the files from the RPM packages,
so log in as root and execute:

    # pacman -S rpmextract

Then extract both RPM files:

    $ rpmextract.sh brhl2040lpr-2.0.1-1.i386.rpm
    $ rpmextract.sh cupswrapperHL2040-2.0.1-1.i386.rpm

You should now have two sub-directories: usr and var

Editing files to make them work with Arch
=========================================

Arch Linux uses its own filesystem hierarchy, so you must edit some
files to match it. We'll assume you created the temp directory brother
in your home directory as mentioned earlier. Use your favorite text
editor (i.e. kate, gedit, or vi) and open

    /home/username/brother/usr/local/Brother/cupswrapper/cupswrapperHL2040-2.0.1

Replace all instances of /etc/init.d/ with /etc/rc.d/ Save and close

Next, edit:

    /home/username/brother/usr/local/Brother/inf/setupPrintcap

Replace all instances of /etc/printcap.local with /etc/printcap Save and
close

Now we're ready to copy the files to their respective places on our
system (you'll need to be root for this)

    # cp -r /home/username/brother/usr/* /usr
    # cp -r /home/username/brother/var/* /var

Installing the driver and printer
=================================

Now let's run the installation script (again, as root):

    # cd /usr/local/Brother/cupswrapper/
    # ./cupswrapperHL2040-2.0.1

Upon completion the script will attempt to restart the CUPS daemon if it
was running. Now browse to the CUPS server : http://localhost:631/

Under the Administration category, choose Manage printers. You should
now see your HL2040 printer automatically installed and configured.

Print a test page and configure the printer settings to your liking.

Enable cups daemon
------------------

Enable cups daemon to start cups on every reboot:

    systemctl enable cups.service

Regional Settings
=================

Make sure to set your printer preferences to match your region. For
example, if you live in North America (Canada, US, Mexico) your paper
size should be changed from the Default "A4" to "Letter". Sometimes this
will be done automatically by your Desktop Environment (e.g. KDE) but
it's worthwhile to check it yourself or the text on your pages won't
align properly.

Alternate Method (foomatic)
===========================

NOTE: If you are having alignment issues using the standard HL 2040
driver, try this method or using the standard CUPS setup to select the
'Brother HL-2400CeN Foomatic/hl1250' driver.

Install Required Packages
-------------------------

    pacman -S cups foomatic-db foomatic-db-engine foomatic-db-nonfree foomatic-filters

Enable cups daemon
------------------

Enable cups daemon to start cups on every reboot:

    systemctl enable cups.service

Start Cups
----------

    systemctl start cups.service

> Finish Installation from the KDE menu (Optional)

This assumes that you are:

1.  Using KDE
2.  Your printer is connected on LPT1 - parallel port.

    Go to K menu -> settings -> printers
    Click administrator mode
    Enter root password
    Click "add printer"
    Click next
    Choose local (top one)
    Click next...the port should be lpt1
    Click it... then next
    .......builds database
    Choose brother

    Then the hlwerfjefja one we all know and love HL-2400CeN hl1250
    Click next then test
    Set dpi to 600, test again.
    no banners... no quota... denied users... 
    Give it a name
    Click next
    You should be done

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-2040&oldid=234767"

Category:

-   Printers

-   This page was last modified on 10 November 2012, at 22:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
