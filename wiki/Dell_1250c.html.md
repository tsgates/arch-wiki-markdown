Dell 1250c
==========

  

Contents
--------

-   1 Introduction
-   2 Download Printer drivers
-   3 Extracting the RPM files
-   4 Installing the driver and printer
-   5 Troubleshooting
-   6 See also

Introduction
------------

This is a brief tutorial to make the Dell 1250c Colour Laser printer
work on Arch Linux.

Download Printer drivers
------------------------

The printer drivers are not part of any package, you you need to
download them and install them manually. There is no native driver, so
use the Xerox Phaser 6000B driver.

First create a temporary directory.

    $mkdir ~/tmp

Then you must download the official drivers from the Xerox website into
that directory. Click Driver Download (and agree to their terms). This
is an RPM archive.

Unzip the downloaded .zip file

    $ unzip 6000_6010_rpm_1.01_20110222.zip
    $ cd rpm_1.01_20110222

Extracting the RPM files
------------------------

Now you need a small script called rpmextract which allows you to get
the files included in the RPM you've just downloaded. Log in as root and
execute :

    # pacman -S rpmextract

Extract both RPM files :

    $ rpmextract.sh Xerox-Phaser_6000_6010-1.0-1.i686.rpm

It should give you a directory : usr

Copy all of the files to their corresponding directories in your file
system :

    # cp -r /home/user/tmp/usr/* /usr

Installing the driver and printer
---------------------------------

Now go to the CUPS page : http://localhost:631/   
  
 You should now be able to add the printer

Troubleshooting
---------------

For x86_64 installations, the cups 32bit client library is also needed

    # pacman -S lib32-libcups

See also
--------

-   Tutorial for installing Dell 1250c on Arch-Linux (german)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_1250c&oldid=286096"

Category:

-   Printers

-   This page was last modified on 3 December 2013, at 23:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
