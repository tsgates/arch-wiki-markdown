Installation of printers with foo2lava driver
=============================================

This article will help you to install a printer supported by the
foo2lava driver.

Currently (December 2012) supported devices are:

-   Konica Minolta magicolor 2530 DL
-   Konica Minolta magicolor 2490 MF (printer only)
-   Konica Minolta magicolor 1600W
-   Oki C110

There are a few more printers which are marked as "Alpha quality;
PRINTER ONLY!":

-   Konica Minolta magicolor 1680MF
-   Konica Minolta magicolor 1690MF
-   Konica Minolta magicolor 2480 MF
-   Konica Minolta magicolor 4690MF
-   Xerox Phaser 6115MFP
-   Xerox Phaser 6121MFP

If you have one of these printers and none of the drivers listed in the
CUPS-article worked for you, installation still will be quite easy.

The foo2zjs package on AUR also provides support for foo2lava printers.

If you prefer to build the driver from source, then follow the
instructions below.

First, you've got to open a terminal. Then, type the following, line for
line:

    $ wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz
    $ tar zxf foo2zjs.tar.gz
    $ cd foo2zjs
    $ make

That's the first part of the installation process. Now, you need to
download a so called ".ICM files", which defines a color profile for
your printer. It is needed to print colors as correct as possible.
Depending on your printer choose one of the following lines:

    $ ./getweb 2530   # Get Konica Minolta magicolor 2530 DL .ICM files
    $ ./getweb 2490   # Get Konica Minolta magicolor 2490 MF .ICM files
    $ ./getweb 1600w  # Get Konica Minolta magicolor 1600W .ICM files
    $ ./getweb 110    # Get Oki C110 .ICM files

    $ ./getweb 1680   # Get Konica Minolta magicolor 1680MF .ICM files
    $ ./getweb 1690   # Get Konica Minolta magicolor 1690MF .ICM files
    $ ./getweb 2480   # Get Konica Minolta magicolor 2480 MF .ICM files
    $ ./getweb 4690   # Get Konica Minolta magicolor 4690MF .ICM files
    $ ./getweb 6115   # Get Xerox Phaser 6115MFP .ICM files
    $ ./getweb 6121   # Get Xerox Phaser 6121MFP.ICM files

So, for example, if you've got the Konica Minolta magicolor 2530DL, you
need to enter the following into the terminal:

    $ ./getweb 2530

The next step to complete the installation process is executing the
following command:

    $ make install

That's it already! There's nothing more to do. You can now choose your
printer in the GNOME/KDE/... printer configuration-tool or configure it
in an alternative way.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Installation_of_printers_with_foo2lava_driver&oldid=247697"

Category:

-   Printers
