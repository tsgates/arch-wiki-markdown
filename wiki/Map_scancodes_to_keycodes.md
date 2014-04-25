Map scancodes to keycodes
=========================

Note:This page assumes that you have read Extra Keyboard Keys, which
provides wider context to the problem.

Mapping scancodes to keycodes is universal and not specific to Linux
console or Xorg, which means that changes to this mapping will be
effective in both.

There are two ways of mapping scancodes to keycodes:

-   Using udev
-   Using setkeycodes

The preferred method is to use udev because it uses hardware information
(which is a quite reliable source) to choose the keyboard model in a
database. It means that if your keyboard model has been found in the
database, your keys are recognized out of the box.

Identifying scancodes
---------------------

You need to know the scancodes of keys you wish to remap. See Extra
Keyboard Keys#Scancodes for details.

Using udev
----------

udev provides a builtin function called hwdb to maintain the hardware
database index in /etc/udev/hwdb.bin. The database is compiled from
files with .hwdb extension located in directories /usr/lib/udev/hwdb.d/,
/run/udev/hwdb.d/ and /etc/udev/hwdb.d/. The default
scancodes-to-keycodes mapping file is
/usr/lib/udev/hwdb.d/60-keyboard.hwdb. See man udev for details.

The .hwdb file can contain multiple blocks of mappings for different
keyboards, or one block can be applied to multiple keyboards. The
keyboard: prefix is used to match a block against a hardware, the
following hardware matches are supported:

-   USB keyboards identified by the usb kernel modalias:

        keyboard:usb:v<vendor_id>p<product_id>*

    where <vendor_id> and <product_id> are the 4-digit hex uppercase
    vendor and product IDs (you can find those by running the lsusb
    command).

-   AT keyboard DMI data matches:

        keyboard:dmi:bvn*:bvr*:bd*:svn<vendor>:pn<product>:pvr*

    where <vendor> and <product> are the firmware-provided strings
    exported by the kernel DMI modalias.

-   Platform driver device name and DMI data match:

        keyboard:name:<input_device_name>:dmi:bvn*:bvr*:bd*:svn<vendor>:pn*

    where <input_device_name> is the name device specified by the driver
    and <vendor> is the firmware-provided string exported by the kernel
    DMI modalias.

The format of each line in the block body is
KEYBOARD_KEY_<scancode>=<keycode>. The value of <scancode> is
hexadecimal, but without the leading 0x (i.e. specify a0 instead of
0xa0), whereas the value of <keycode> is the lower-case keycode name
string as listed in /usr/include/linux/input.h (see the KEY_<KEYCODE>
variables), a sorted list is available at [1]. It is not possible to
specify decimal value in <keycode>.

Here is an example to match all USB and AT keyboards:

    /etc/udev/hwdb.d/90-custom-keyboard.hwdb

    keyboard:usb:v*p*
    keyboard:dmi:bvn*:bvr*:bd*:svn*:pn*:pvr*
     KEYBOARD_KEY_10=suspend
     KEYBOARD_KEY_a0=search

After changing the configuration files, the hardware database index
needs to be rebuilt. This is done on reboot, or manually using the
following command:

    # udevadm hwdb --update

Using setkeycodes
-----------------

setkeycodes is a tool to load scancodes-to-keycodes mapping table into
Linux kernel. Its usage is:

    # setkeycodes scancode keycode ...

It is possible to specify multiple pairs at once. Scancodes are given in
hexadecimal, keycodes in decimal.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Map_scancodes_to_keycodes&oldid=283620"

Category:

-   Keyboards

-   This page was last modified on 18 November 2013, at 20:39.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
