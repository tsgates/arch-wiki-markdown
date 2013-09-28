XWiimote
========

This article is about the Nintendo Wii Remote Linux kernel driver. This
driver is part of upstream Linux since version 3.1. It is an easy to use
drop-in replacement for the older user-space drivers like cwiid. You can
use your Wii Remote for all purposes with this driver, for instance as
an X input device or joystick controller for your Linux games.

Note:The XWiimote tools are still experimental. Connecting and managing
your Wii Remote works well and there is a driver to use the Wii Remote
as X11 input, but extended features may still be missing.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Connect the Wii Remote                                             |
| -   3 Device Handling                                                    |
|     -   3.1 X.Org Input Driver                                           |
|     -   3.2 Infrared Sources                                             |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 The input mapping is very weird                              |
|     -   4.2 BlueZ does not include the wiimote plugin                    |
|     -   4.3 I cannot connect my wiimote                                  |
|     -   4.4 My Wii Remote is still not working                           |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Prerequisites
-------------

-   Bluetooth
-   xwiimote
-   xwiimote kernel driver
-   Wii Remote hardware

The most important piece required is Bluetooth, this must already be
configured and running without the help of this guide. This should be
simple enough with any guide found on the Internet. Most recent bluez
package in Arch Linux includes the wiimote plugin. See Troubleshooting
BlueZ to make BlueZ include the wiimote plugin.

The user-space utilities are available in the AUR. You need the xwiimote
package. There is also a git-package xwiimote-tools-git if you want the
most recent revision.

The kernel driver is part of upstream Linux since version 3.1. The
module is called hid-wiimote. If it is not available in your kernel, you
need to compile the module yourself. The Arch Linux kernel includes it
starting with version 3.1.

Lastly you will need a Wii Remote, this can include (although, are not
required) the Nunchuk and Classic Controller attachments.

If your kernel does not include the hid-wiimote module, you can enable
it with CONFIG_HID_WIIMOTE. The module needs CONFIG_INPUT_FF_MEMLESS,
CONFIG_LEDS_CLASS, CONFIG_POWER_SUPPLY and CONFIG_BT_HIDP embedded in
your kernel or as modules, previously loaded. Starting with kernel
version 3.3 there is an additional config option CONFIG_HID_WIIMOTE_EXT
which is enabled by default. It controls whether wiimote extensions like
Nunchuck and Classic Controller should be supported.

Connect the Wii Remote
----------------------

You can connect to your Wii Remote like any other Bluetooth device. See
the Bluetooth article about information on pairing Bluetooth devices.
The Wii Remote does not need special handling anymore. The BlueZ wiimote
plugin handles all peculiarities in the background for you.

The Wii Remote can be put into discoverable mode by pressing the red
sync-button behind the battery cover on the back. The Wii Remote will
stay in discoverable mode for 20s. You can also hold the 1+2 buttons to
put the Wii Remote into discoverable state. However, the first method
works more reliably!

If you are asked for PIN input while bonding the devices, then your
BlueZ bluetoothd daemon does not include the wiimote plugin. See
Troubleshooting BlueZ for more information. If this does not help, you
can still connect to your wiimote without pairing/bonding (i.e. not
using authentication with a PIN). This should work with any BlueZ
version. See Troubleshooting Pairing if you still cannot connect your
wiimote.

Device Handling
---------------

If your Wii Remote is connected, it will appear with several input
devices inside /dev/input/eventX. You can list all Wii Remotes with:

    $ ls /sys/bus/hid/devices

Then you can get additional device details with:

    $ ls /sys/bus/hid/devices/<devid>/

The default mapping for the input-keys of the Wii Remotes are not very
useful. User-space applications exist that re-map the Wii Remote input
to more useful keys/actions [1] - available in AUR xwiimote. If you
installed this package you can test your connected Wii Remotes with the
xwiishow tool:

This will list all connected Wii Remotes:

    $ xwiishow list

If this shows a path to a Wii Remote (lets say
/sys/bus/hid/devices/<did>) then you can test the device with:

    $ xwiishow /sys/bus/hid/devices/<did>

Or use the index of the listed device:

    $ xwiishow 1

This will display a picture of the Wii Remote and notify you if buttons
are pressed. You can use the 'r' key to enable/disable the rumble motor.
Press 'q' to quit the application. You might need to be root to use
these tools.

> X.Org Input Driver

There is an X.Org input driver [2] available in AUR xf86-input-xwiimote
which automatically provides an input device to your X clients. Install
it and read the related man-page for more information:

    $ man xorg-xwiimote

> Infrared Sources

The Wii Remote includes an infrared camera. To use this camera as a
pointer input device, you need an IR-rack as an infrared source.
Possible infrared sources are:

-   Nintendo Wii Sensor Bar
-   Wireless sensor bar - check eBay!
-   Small candles (should have about 30cm distance)
-   Home made sensor bar ([3])

There is currently no user-space application that enables
mouse-emulation with the IR-sensor. If you need that, you should
consider using the no longer supported cwiid approach. However, the
xwiimote tools are under heavy development and will soon support IR
mouse-emulation, too.

Troubleshooting
---------------

> The input mapping is very weird

The default mapping maps the Wii Remote keys to the the key-constants
which resemble the Wii Remote's buttons best. This mapping is quite
useless by default. To get better mappings, use the xwiimote userspace
tools.

> BlueZ does not include the wiimote plugin

Upstream BlueZ includes the optional wiimote plugin since version 4.96.
However, it must be enabled explicitely with --enable-wiimote during
compilation. The archlinux package includes the wiimote plugin since
bluez-4.96-3. If you are unsure whether your package includes the
wiimote plugin, use:

    grep wiimote $(which bluetoothd)

This should say:

    Binary file /usr/sbin/bluetoothd matches

You probably need to run this as root because the bluetoothd daemon
resides in /usr/sbin on archlinux or simply use:

    grep wiimote /usr/sbin/bluetoothd

If this matches, then your BlueZ includes the wiimote plugin and no more
user-interaction is needed. If this does not match, you need to enable
it yourself or work without it. If you do not want to compile your own
bluez package, then you can use the wiimote without this plugin by
connecting without pairing/bonding. For instance, when using blueman or
gnome-bluetooth you need to select "Proceed without pairing" when adding
a new device.

If you want to compile the module on your own, then add --enable-wiimote
to your configure flags and proceed as usual. See the bluez PKGBUILD for
further information.

> I cannot connect my wiimote

The BlueZ packages includes a special wiimote plugin since version 4.96
which handles all Wii Remote peculiarities for you. If you cannot pair
your Wii Remote like any other device, then you should try connecting
without pairing/bonding (i.e. not using authentication with a PIN). If
this still does not work, please report your issue to the upstream
developers at XWiimote@GitHub.

Please always use the red sync-button behind the battery cover on the
back of the Wii Remote for troubleshooting. This works more reliably
than holding the 1+2 buttons.

The Auto-Reconnect feature allows the Wii Remote to reconnect to its
last connected host when a key is pressed. This means you do not need to
connect your Wii Remote manually each time. However, the Auto-Reconnect
feature only works if you paired your Wii-Remote. Connecting without the
wiimote plugin will not enable Auto-Reconnect.

> My Wii Remote is still not working

The XWiimote software stack is actively developed. Please report your
problems at XWiimote@GitHub.

There are also other projects which provide Wii Remote support for
linux. See the Wii Remote article for the cwiid project.

See also
--------

-   Wiimote: Cwiid: An older software stack for linux which provides
    partial Wii Remote support
-   [4]: Developer blog about Wii Remotes

Retrieved from
"https://wiki.archlinux.org/index.php?title=XWiimote&oldid=207174"

Category:

-   Other hardware
