CUPS printer-specific problems
==============================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Mentions         
                           packages that don't      
                           exist anymore, like      
                           foomatic-db-ppd.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary help replacing me

Dealing with printer-specific problems

> Related

CUPS

Printer-specific problems and their solutions.

Contents
--------

-   1 Brother
    -   1.1 DCP 7020
    -   1.2 Other Brother Printers
-   2 Canon
    -   2.1 MF 4150
    -   2.2 Pixma MP540/MP5**
-   3 Epson
    -   3.1 Utility functions
        -   3.1.1 escputil
        -   3.1.2 mtink
        -   3.1.3 Stylus-toolbox
    -   3.2 AcuLaser CX11(NF)
    -   3.3 Stylus SX125
    -   3.4 LP-S5000
-   4 FX
    -   4.1 C1110 (not model B)
-   5 HP
    -   5.1 Deskjet 700 Series
        -   5.1.1 Printing does not work
    -   5.2 HP LaserJet 1010
    -   5.3 LaserJet 1020
        -   5.3.1 Installation from AUR
        -   5.3.2 Manual installation
            -   5.3.2.1 Packages
            -   5.3.2.2 Configuration
    -   5.4 Firmware for HPLIP
-   6 Printer connected to an Airport Express Station

Brother
-------

> DCP 7020

See: Brother DCP-7020

> Other Brother Printers

It appears that newer versions of the "file" package break the ability
of many Brother printers to print from GUI applications. The solution
seems to be to ensure that the "a2ps" package is installed.

Canon
-----

> MF 4150

This is required as some Canon printers apparently do not declare their
specification correctly for kernel and libusb to recognize them

-   Do NOT blacklist usblp module.

-   Connect the printer

The printer should now be recognized by the CUPS Add printer dialog. If
still having problems, try restarting CUPS.

-   Install UFRII driver (ufr2 from the AUR and complete the printer
    installation.

> Pixma MP540/MP5**

To get the printer working you need to:

-   Blacklist usblp module and reboot.

-   Install cnijfilter-common and cnijfilter-mp540 (or whichever package
    corresponds to your MP5** model) from the AUR.

-   Those with an MP560 should download lib32-cnijfilter-mp560 for
    x86_64 or cnijfilter-mp560 for i686.

If it's still not working execute the following command as root:

    # ln -s /usr/bin/cifmp540 /usr/local/bin/cifmp540

Epson
-----

> Utility functions

escputil

This section explains how to perform some of the utility functions (such
as nozzle cleaning) on Epson printers, by using the escputil utility,
part of the gutenprint package.

With newer printers (like the CX3600/CX3650 or D88) you must first
"modprobe usblp" to get escputil working. This creates the
"/dev/usb/lp0" node (see the "--raw-device" flag below). Afterwards you
have to "rmmod usblp", else the printer won't be recognized by CUPS
(version 1.4.x). More here:
https://bbs.archlinux.org/viewtopic.php?pid=682455#p682455

There is a escputil's man-page provides basic information, but it does
not touch on how to identify the printer. There are two parameters that
can be used to do so:

-   One is --printer: it expects the name used to identify the printer
    when is was configured.

-   The other is --raw-device: this option expects a path beginning with
    "/dev". If the printer is the only serial printer on the system,
    "/dev/lp0" should be its device node. For USB printers, it is
    "/dev/usb/lp0". If having more than one printer, they will have
    names ending in "lp1", "lp2", etc.

On to the maintenance options:

-   To clean the printer heads:

    $ escputil -u --clean-head

-   To print the nozzle-check pattern (allows verifying that the
    previous head cleaning worked, and determining the heads need
    cleaning):

    $ escputil -u --nozzle-check

If wanting to perform an operation that requires two-way communication
with a printer, use the "--raw-device" specification and the user must
be root or be a member of the group "lp".

-   The following is an example of getting the printer's internal
    identification:

    $ sudo escputil --raw-device=/dev/usb/lp0 --identify

-   To print out the ink levels of the printer:

    $ sudo escputil --raw-device=/dev/usb/lp0 --ink-level

mtink

This is a printer status monitor which enables to get the remaining ink
quantity, to print test patterns, to reset printer and to clean nozzle.
It use an intuitive graphical user interface. Package can be downloaded
from AUR.

Stylus-toolbox

This is a GUI using escputil and cups drivers. It supports nearly all
USB printer of Epson and displays ink quantity, can clean and align
print heads and print test patterns. It can be downloaded from AUR

> AcuLaser CX11(NF)

Install Epson-ALCX11-filter from the AUR. Restart CUPS and add the
printer using the driver "EPSON AL-CX11, ESC/PageS Filter".

Both connections, USB and network, should work as expected.

> Stylus SX125

Simply install gutenprint,

    $ sudo pacman -S gutenprint

restart cups,

    & sudo /etc/rc.d/cupsd restart

add the printer via the cups-webinterface and select the Epson Stylus
SX115 Foomatic/gutenprint-ijs.5.2 driver. This should work fine.

> LP-S5000

Warning:This section involves installing packages without pacman. These
directions should ideally be automated with a PKGBUILD.

"Source" code of the driver is available on avasys website, in Japanese,
however it includes a 32 bit binary which will cause problem on 64 bit
system. To install the printer:

-   Install the libstdc++5 ,on 32bit system, or the lib32-listdc++5
    package (available in the multilib repository), on 64bit.

    # pacman -S libstdc++5

or

    # pacman -S lib32-libstdc++5

-   Install some dependencies

    # pacman -S psutils bc

-   Download the source code of the driver (tar.gz) from avasys website
    and unpack it.
-   Compile and install the driver.

    $ ./configure --prefix=/usr
    $ make
    # make install

-   Edit the path of pstops in /usr/bin/pstolps5000.sh according to
    this:

    $ diff pstolps5000.sh.orig /usr/bin/pstolps5000.sh 
    212c212
    < rotator="" && test "$useRotator" = "on" && rotator="| pstops -q $pstops1 $pstops2"
    ---
    > rotator="" && test "$useRotator" = "on" && rotator="| /usr/bin/pstops -q $pstops1 $pstops2"

-   Restart cups

    # /etc/rc.d/cupsd restart

-   Install the printer through cups web interface, the printer was
    detected as a socket://XXX.XXX.XXX.XXX

-   Select the Esc Pages driver LP-S5000 (the one installed).

-   Print test page: OK

If you have any problems on a 64 system, some other lib32 libraries may
be required. These instruction may be useful for other printer working
with driver from avasys website.

FX
--

> C1110 (not model B)

Keep in mind that these directions assume that the printer is connected
and listening on the network.

-   Install cpio and rpmunpack to later unpack the package:

    # pacman -S cpio rpmunpack cups ghostscript gsfonts

-   Get the FX GNU/Linux driver here.

-   Unzip fxlinuxprint-1.0.1-1.i386.zip to /var/tmp (the directory is
    not important):

    $ unzip fxlinuxprint-1.0.1-1.i386.zip -d /var/tmp

-   Continue extracting the file:

    $ cd /var/tmp
    $ rpmunpack fxlinuxprint-1.0.1-1.i386.rpm
    $ gunzip fxlinuxprint-1.0.1-1.cpio.gz

-   Move the cpio DST file (for convenience):

    $ mkdir /var/tmp/DST
    $ mv fxlinuxprint-1.0.1-1.cpio /var/tmp/DST

-   Extract it:

    $ cd /var/tmp/DST
    $ cpio -id < fxlinuxprint-1.0.1-1.cpio

-   Filter the relevant files:

    $ cd /var/tmp
    $ find /var/tmp/DST -type f |cat -n
        1	/var/tmp/DST/etc/cups/mimefx.convs
        2	/var/tmp/DST/etc/cups/mimefx.types
        3	/var/tmp/DST/usr/lib/cups/filter/pdftopjlfx
        4	/var/tmp/DST/usr/lib/cups/filter/pstopdffx
        5	/var/tmp/DST/usr/lib/cups/filter/pdftopdffx
        6	/var/tmp/DST/usr/share/cups/model/FujiXerox/en/fxlinuxprint.ppd

-   Copy the files found in the previous step to /

Note:For the PPD use /usr/share/cups/model/fxlinuxprint.ppd

-   Access http://localhost:631/ and add the lpd://f.q.d.n/queue
    printer, aunthenticating as root.

-   Go through "Manage Printer" and "Set Printer Options".

-   Print a test page (substitue color103 with the assigned printer
    name):

    $ lpq -P color103
    color103 is ready
    no entries

HP
--

> Deskjet 700 Series

Printing does not work

The solution is to install the AUR package pnm2ppa, which provides a
printer filter of the same name for the HP Deskjet 700 series. Without
this, the print jobs will be aborted by the system.

> HP LaserJet 1010

A solution to make LaserJet 1010 work with CUPS may be to compile a
newer version of GhostScript:

    $ pacman -Qs cups a2ps psutils foo ghost
    local/cups 1.1.23-3
        The CUPS Printing System
    local/a2ps 4.13b-3
        a2ps is an Any to PostScript filter
    local/psutils p17-3
        A set of postscript utilities.
    local/foomatic-db 3.0.2-1
        Foomatic is a system for using free software printer drivers with common
        spoolers on Unix
    local/foomatic-db-engine 3.0.2-1
        Foomatic is a system for using free software printer drivers with common
        spoolers on Unix
    local/foomatic-db-ppd 3.0.2-1
        Foomatic is a system for using free software printer drivers with common
        spoolers on Unix
    local/foomatic-filters 3.0.2-1
        Foomatic is a system for using free software printer drivers with common
        spoolers on Unix
    local/espgs 8.15.1-1
        ESP Ghostscript

Setting LogLevel may also need to be set in /etc/cups/cupsd.conf to
debug2, this way the logs will show how to circumvent minor issues, such
as missing fonts. Search Google for n019003l filetype:pfb

The debug solution might work if getting errors similar to 'Unsupport
PCL', etc. See: OpenPrinting database - Printer: HP LaserJet 1010

> LaserJet 1020

Installation from AUR

Install the package foo2zjs from the AUR and modify the PKGBUILD. Change
the line:

    ./getweb all

to

    ./getweb 1020

If getting errors with incorrect md5sums, the md5sum of foo2zjs.tar.gz
in the PKGBUILD should be changed to match the downloaded driver.

As a last step, add and configure the printer in the CUPS manager. The
printer should be recognized automatically, and function for both root
and regular users.

Manual installation

This section details the setup of the HP Laserjet 1020 by manually
downloading and compiling the foo2zjs driver.

Warning:This section involves installing packages without pacman. These
directions should ideally be automated with a PKGBUILD.

Packages

Only CUPS and GhostScript are needed to set up the HP Laserjet 1020.

    # pacman -S cups ghostscript

The OpenPrinting database - Printer: HP LaserJet 1020 page outlines the
support for this printer.

The foo2zjs driver will be installed as outlined on the project page:
foo2zjs: a linux printer driver for ZjStream protocol.

Firstly, download the driver:

    $ wget -O foo2zjs.tar.gz http://foo2zjs.rkkda.com/foo2zjs.tar.gz

And unpack it:

    $ tar zxf foo2zjs.tar.gz
    $ cd foo2zjs

The driver is now compiled:

    $ make
    $ ./getweb 1020
    # make install
    # make install-hotplug
    # make cups

Configuration

The usblp module is needed to upload the firmware to the printer, but
the module must then be removed to allow printing or adding the printer
to the system.

Ensure that the CUPS daemon is running and added to the /etc/rc.conf
file:

    # /etc/rc.d/cupsd start

    /etc/rc.conf

    DAEMONS=(... cupsd crond ...)

Now plug in the USB printer and turn it on. The printer will whirl,
pause, then whirl once more as the firmware is uploaded. Now remove the
usblp module:

    # rmmod usblp

The printer can be added to the system with CUPS http://localhost:631/

Note:The usblp module must be removed after the firmware is loaded to
the printer, and before any printing job is submitted.

The reason for this has been explained on the forum.

> Firmware for HPLIP

Some printers may appear to have been correctly installed by CUPS, but
fail to print. It may be that the necessary firmware needs to be
downloaded by running:

    # hp-setup -i

as root. This situation has been encountered with the LaserJet 1000 and
LaserJet 1005.

Printer connected to an Airport Express Station
-----------------------------------------------

The first step is to scan the Airport Express station. It seems that
there are different addresses depending on the model:

    [root@somostation somos]# nmap 192.168.0.4

    Starting Nmap 4.20 ( http://insecure.org ) at 2007-06-26 00:50 CEST
    Interesting ports on 192.168.0.4:
    Not shown: 1694 closed ports
    PORT      STATE SERVICE
    5000/tcp  open  UPnP
    9100/tcp  open  jetdirect
    10000/tcp open  snet-sensor-mgmt
    MAC Address: 00:14:51:70:D5:66 (Apple Computer)

    Nmap finished: 1 IP address (1 host up) scanned in 25.815 seconds

The Airport station is accessed like an HP JetDirect printer. Note the
port of the jetdirect service, and edit printer.conf. The DeviceURI
entry should be socket://, followed by your station IP address, a colon,
and the jetdirect port number.

    /etc/cups/printer.conf

    # Printer configuration file for CUPS v1.2.11
    # Written by cupsd on 2007-06-26 00:44
    <Printer LaserSim>
    Info SAMSUNG ML-1510 gdi
    Location SomoStation
    DeviceURI socket://192.168.0.4:9100
    State Idle
    StateTime 1182811465
    Accepting Yes
    Shared Yes
    JobSheets none none
    QuotaPeriod 0
    PageLimit 0
    KLimit 0
    OpPolicy default
    ErrorPolicy stop-printer
    </Printer>

Problems may be resolved by removing foomatic and installing
foomatic-db, foomatic-db-engine, foomatic-db-ppd instead.

Retrieved from
"https://wiki.archlinux.org/index.php?title=CUPS_printer-specific_problems&oldid=277482"

Category:

-   Printers

-   This page was last modified on 3 October 2013, at 22:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
