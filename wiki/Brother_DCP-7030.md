Brother DCP-7030
================

  

Contents
--------

-   1 Introduction
-   2 Printer
    -   2.1 CUPS
    -   2.2 Usblp
    -   2.3 Drivers
        -   2.3.1 Original
        -   2.3.2 Using PPD from hl1250
    -   2.4 Udev
    -   2.5 Installation
-   3 Scanner
    -   3.1 SANE
    -   3.2 Drivers
-   4 Troubleshooting

Introduction
============

This is a brief tutorial how to setup the Brother DCP-7030 (multi
function laser copier printer) on i686 Arch.

Printer
=======

CUPS
----

Install CUPS (see CUPS page).

Usblp
-----

It may be necessary to blacklist Usblp module to get AUR driver working.
To do that, you may add "!usblp" at the end of your rc.conf MODULES
list.

Drivers
-------

> Original

There is the brother-dcp7030 in AUR. It contains driver from Brother.

Install drivers:

    % yaourt -S brother-dcp7030

Run

    # /usr/local/Brother/cupswrapper/cupswrapperDCP7030-2.0.2

Now go to the CUPS page: http://localhost:631/

Under the Printers tab you should see a DCP7030 printer automatically
installed and configured.

> Using PPD from hl1250

Unfortunately original driver did not work with DCP-7030 on my PC.

I got this PPD. I replaced all DCP-7020 by DCP-7030. After this I add a
new printer manually using this PPD.

Udev
----

It may be nesessary to add a rule to your udev:

    # nano /etc/udev/rules.d/10-usbprinter.rules

    ATTR{idVendor}=="04f9", ATTR{idProduct}=="01ea", MODE:="0664", GROUP:="lp", ENV{libsane_matched}:="yes"

Installation
------------

Go to http://localhost:631 page in your browser and install printer. All
settings there is very simple, the main thing you must check - paper
size set to "A4".

Scanner
=======

SANE
----

Install SANE:

    # pacman -S sane

Add your user to scanner group:

    # gpasswd -a username scanner

Note:You need to logout/login for this to take effect.

Drivers
-------

There is the brscan3 in AUR.

Install drivers:

    % yaourt -S brscan3

After installing add line brother3 in the /etc/sane.d/dll.conf.

Now you can try to see if SANE recognizes your scanner

    $ scanimage -L

For more info see SANE page.

If your scanning software can't use the scanner even with correct
scanimage, check your printer usb location with

    $ lsusb

and give writing permission for that device to all users. For example,
for:

    Bus 008 Device 004: ID 04f9:01ea Brother Industries, Ltd DCP-7030

use:

    # sudo chmod a+w /dev/bus/usb/002/004

Troubleshooting
===============

If you can print a test page from http://localhost:631, but can't print
anything from LibreOffice, try to install a2ps.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_DCP-7030&oldid=274336"

Categories:

-   Printers
-   Imaging

-   This page was last modified on 4 September 2013, at 10:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
