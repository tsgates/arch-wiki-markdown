Bus pirate
==========

  Summary help replacing me
  -------------------------------------------------------------------------
  This article covers the installation and basic usage of the Bus Pirate.

The Bus Pirate is a versatile tool for communicating with various
hardware.

Interfacing a new microchip can be a hassle. Breadboarding a circuit,
writing code, hauling out the programmer, or maybe even prototyping a
PCB. We never seem to get it right on the first try.

The ‘Bus Pirate’ is a universal bus interface that talks to most chips
from a PC serial terminal, eliminating a ton of early prototyping effort
when working with new or unknown chips. Many serial protocols are
supported at 0-5.5volts, more can be added. See more at the google code
site for the Bus Pirate.

Contents
--------

-   1 Installation
    -   1.1 udev
    -   1.2 Product/Vendor ID
    -   1.3 Serial Number
-   2 Communication

Installation
------------

Note:All scripts will assume that there is a '/dev/buspirate'.

The drivers for the FTDI chip is included in the kernel, so it should be
detected as soon as it's plugged in, and assigned to device
/dev/ttyUSB[0-9]. To check where it got assigned, run:

    # dmesg | tail

The output will contain a line that looks something like this:

    # usb 1-4.4: FTDI USB Serial Device converter now attached to ttyUSB0

> udev

It can be annoying to have to look up what /dev/ttyUSB[0-9] the device
gets assigned, so it's a good idea to add a simple udev rule that
creates the symlink '/dev/buspirate -> /dev/ttyUSB*' when it is plugged
in.

> Product/Vendor ID

There are several ways to do this, the way I personally prefer is to use
it by vender/product ID so the bus pirate can be replaced without
needing to modify the line. To use this method, add the following line
to /etc/udev/rules.d/98-buspirate

    /etc/udev/rules.d/98-buspirate.rules

    # Bus pirate v3
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", GROUP="users", MODE="0666", SYMLINK+="buspirate"
    # Bus pirate v4
    SUBSYSTEM=="tty", ATTRS{idVendor}=="04d8", ATTRS{idProduct}=="fb00", GROUP="users", MODE="0666", SYMLINK+="buspirate"

> Serial Number

You can also do it by serial number, to do this, you will need to find
out the serial number of FTDI chip on the bus pirate. This can be
achieved by running the following, assuming your device is plugged in
and was assigned to /dev/ttyUSB0:

    # udevadm info --attribute-walk -n /dev/ttyUSB0  | sed -n '/FTDI/,/serial/p'

Now add/create the following file:

    /etc/udev/rules.d/98-buspirate.rules

    SUBSYSTEM=="tty", ATTRS{serial}=="XXXXXXXX", GROUP="users", MODE="0660", SYMLINK+="buspirate"

Change 'ATTRS{serial}=="XXXXXXXX"' to the serial on your device and
force udev to load the new rule:

    # udevadm control --reload-rules

At this point, whenever you plug in the device, the symlink should be
created.

Communication
-------------

To communicate with the device, you can use any of the following, to
name a few:

-   minicom

    # minicom -b 115200 -8 -D /dev/buspirate

-   screen

    # screen /dev/buspirate 115200 8N1

-   picocom

    # picocom -b 115200 -p n -d 8 /dev/buspirate

Type '?' and press enter and the device should reply with a list of
possible commands.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bus_pirate&oldid=297554"

Category:

-   Hardware detection and troubleshooting

-   This page was last modified on 15 February 2014, at 00:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
