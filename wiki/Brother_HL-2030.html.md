Brother HL-2030
===============

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
-   2 Foomatic drivers
-   3 Driver from openprinting.org
-   4 Brother drivers
    -   4.1 Download drivers
    -   4.2 Extracting the RPM files
    -   4.3 Editing files to make them work with Arch Linux
    -   4.4 Installing the driver and printer
    -   4.5 Compatibility with Brother HL-2035
    -   4.6 Common Issues

Introduction
------------

This is a small tutorial to make the Brother HL-2030 printer work on
Arch Linux.

Foomatic drivers
----------------

This method also works with the Brother HL-2035 printer.

To install the required software and drivers, type:

    # pacman -S cups foomatic-{db,db-engine} a2ps

Now go to http://localhost:631

-   Go to Administration
-   Click 'Add Printer'
-   Choose 'Brother HL-2030 series' at 'Local Printers' (if the printer
    is connected and powered)
-   Select one of the drivers for your model and click 'continue'
-   Configure your printer

If the printer does not work now, try a different driver for your model
(the recommended 'Brother HL-2030 Foomatic/hl1250 (en)' worked fine for
me).

Driver from openprinting.org
----------------------------

For using a Brother HL-2030 printer with CUPS, and you are unsuccessful
using the foomatic drivers, you might consider using the recommended
Hl-2030 drivers from openprinting.org. These can be found here. Download
the hl1250 file and place it in e.g.

    # /usr/share/cups/model/

In order to use this driver you need to install the foomatic-filters
package

    # pacman -S foomatic-filters

Configure the CUPS server by the method of your choice and you should be
good to go.

Brother drivers
---------------

Brother supplies official Linux drivers for the HL-2030. These, however,
come in the form of RPM packages. They can be installed on Arch Linux in
two ways: either using the brother-hl2030 package from the AUR or
manually following these instructions. Please note that you may have to
blacklist the usblp module for these drivers as well (see above).

> Download drivers

First create a temporary directory. Then, you must download the official
LPR drivers from the Brother web site in that directory. Click here.
This is an RPM archive. You also have to download the cupswrapper file
from here. This script creates the filters and PPD file for CUPS
automatically. It is also an RPM archive.

> Extracting the RPM files

Now, you need a small script called rpmextract which allows you to get
the files included in the RPM you have just downloaded. As root, install
rpmextract from the official repositories:

    # pacman -S rpmextract

Extract both RPM files:

    $ rpmextract.sh brhl2030lpr-2.0.1-1.i386.rpm
    $ rpmextract.sh cupswrapperHL2030-2.0.1-1.i386.rpm

Note:rpmextract must be run as rpmextract.sh. Using rpmextract without
the .sh suffix will not work.

It should give you two directories: usr and var.

> Editing files to make them work with Arch Linux

Arch Linux uses its own file system organisation, so you have to edit
some files. Use your favorite text editor to open the file named
cupswrapperHL2030-2.0.1. If you created the temporary directory "tmp" in
your home directory, it must be in
/home/user/tmp/usr/local/Brother/cupswrapper. In this file, you must
replace all of the /etc/init.d/ occurrences with /etc/rc.d/.

Then you have to edit the file usr/local/Brother/inf/setupPrintcap, and
replace /etc/printcap.local with /etc/printcap.

When that is done, copy all of the files in their corresponding
directories:

    # cp -r /home/user/tmp/usr/* /usr
    # cp -r /home/user/tmp/var/* /var

> Installing the driver and printer

Go into /usr/local/Brother/cupswrapper/ and run the cupswrapper file:

    # cd /usr/local/Brother/cupswrapper/
    # ./cupswrapperHL2030-2.0.1

It will stop the cups daemon if it is running, and then restart it. Now,
go to the CUPS page - http://localhost:631/ - and in the
"Administartion" category, choose Manage printers. There you should see
a HL2030 printer automatically installed and configured. Click to print
the test page, and you can hear the sweet sound of your printer.

> Compatibility with Brother HL-2035

Brother does not (yet) provide specific drivers for the HL-2035, but the
HL-2030 drivers seem to work fine for this model as well. Use at your
own risk, though.

> Common Issues

If you have done all of the steps above, and the printer will either not
appear in your CUPS interface or if you want to print sth. the printer
will just warm up and then not print anything, the following is reported
to have helped:

1.  install the hal-cups-utils from the AUR
2.  visit your CUPS interface, and under "Administration" hit "find new
    printer". Surprisingly, it should be found. In the next step, choose
    the PPD file (found in /usr/share/cups/model/HL2030.ppd) and
    everything should work just fine ...
3.  make sure hal is running before the cups daemon is started

Note:HAL has been deprecated for some time now.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_HL-2030&oldid=305719"

Category:

-   Printers

-   This page was last modified on 20 March 2014, at 01:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
