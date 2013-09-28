Bus pirate
==========

  Summary
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

First of all, you will need to find out the serial number of FTDI chip
on the bus pirate. This can be achieved by running the following,
assuming your device is plugged in and was assigned to /dev/ttyUSB0:

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
"https://wiki.archlinux.org/index.php?title=Bus_pirate&oldid=206742"

Category:

-   Hardware detection and troubleshooting
