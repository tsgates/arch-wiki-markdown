FujiXerox DocuPrint 203A
========================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Summary                                                            |
| -   2 Prerequisites                                                      |
| -   3 Download FujiXerox DocuPrint 203A drivers                          |
| -   4 Extracting the RPM files                                           |
| -   5 Editing files to make them work with Arch                          |
| -   6 Installing the driver and printer                                  |
| -   7 Regional Settings                                                  |
| -   8 Alternate Method using pacman                                      |
|     -   8.1 Install the CUPS                                             |
|     -   8.2 Install the foomatic printer library                         |
|     -   8.3 Install the hplip library                                    |
|     -   8.4 Start the CUPS printing system                               |
+--------------------------------------------------------------------------+

Summary
=======

This guide explains how to install a FujiXerox DocuPrint 203A laserjet
printer using CUPS.

Note: If you already attempted (and failed) to install the driver in
CUPS, remove it before proceeding with this tutorial.

Prerequisites
=============

This tutorial assumes you have already configured the CUPS printer
server. There is plenty of existing information to get this working.

Download FujiXerox DocuPrint 203A drivers
=========================================

Download the driver(HERE). The driver is a zip file which contains 2
parts: the LPR Driver and the CUPS wrapper. Save the file to
/home/username and decompress the file using the following command:

    $ unzip dp203a_linux_cc25.zip

Enter the directory:

    $ cd dp203a_linux/rpm

Extracting the RPM files
========================

You'll need to grab a script to extract the files from the RPM packages,
so log in as root and execute:

    # pacman -S rpmextract

Then extract both RPM files:

    $ rpmextract.sh DocuPrint_203_A-lpr-1.1.2-4.i386.rpm
    $ rpmextract.sh cupswrapperDocuPrint_203_A-1.0.2-2.i386.rpm

You should now have two sub-directories: usr and var

Editing files to make them work with Arch
=========================================

Arch Linux uses its own filesystem hierarchy, so you must edit some
files to match it. Use your favorite text editor (i.e. vim, emacs or
nano) and open

    /home/username/dp203a_linux/rpm/usr/local/Brother/cupswrapper/cupswrapperDocuPrint_A-1.0.2

Replace all instances of /etc/init.d/ with /etc/rc.d/ Save and close

Next, edit:

    /home/username/dp203a_linux/rpm/usr/local/Brother/inf/setupPrintcap

Replace all instances of /etc/printcap.local with /etc/printcap Save and
close

Now we're ready to copy the files to their respective places on our
system (you'll need to be root for this)

    # cp -r /home/username/dp203a_linux/rpm/usr/* /usr
    # cp -r /home/username/dp203a_linux/rpm/var/* /var

Installing the driver and printer
=================================

Now let's run the installation script (again, as root):

    # cd /usr/local/Brother/cupswrapper/
    # ./cupswrapperDocuPrint_203_A-1.0.2

Upon completion the script will attempt to restart the CUPS daemon if it
was running. Now browse to the CUPS server : http://localhost:631/

Under the Administration category, choose Manage printers. You should
now see your DocuPrint 203A printer automatically installed and
configured.

Print a test page and configure the printer settings to your liking.

Regional Settings
=================

Make sure to set your printer preferences to match your region. For
example, if you live in North America (Canada, US, Mexico) your paper
size should be changed from the Default "A4" to "Letter". Sometimes this
will be done automatically by your Desktop Environment (e.g. KDE) but
it's worthwhile to check it yourself or the text on your pages won't
align properly.

Alternate Method using pacman
=============================

Install the CUPS
----------------

    # pacman -S cups

Install the foomatic printer library
------------------------------------

    # pacman -S foomatic-db foomatic-db-engine foomatic-filters foomatic-db-ppd

Install the hplip library
-------------------------

    # pacman -S hplip

Start the CUPS printing system
------------------------------

    # /etc/rc.d/cupsd start

Enter the configuration page by entering following URL :
http://localhost:631/ in Firefox. Do it step by step. In the driver
setting, choose the DocuPrint P8e(hpijs) driver.

DONE#

Retrieved from
"https://wiki.archlinux.org/index.php?title=FujiXerox_DocuPrint_203A&oldid=196837"

Category:

-   Printers
