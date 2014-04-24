Logitech Unifying Receiver
==========================

The Logitech Unifying Receiver is a wireless receiver that can connect
up to six compatible wireless mice and keyboards to your computer. The
input device that comes with the receiver is already paired with it and
should work out of the box through plug and play. Logitech officially
supports pairing of additional devices just through their Windows and
Mac OS X software. Pairing on Linux is supported by a small program from
Benjamin Tissoires. That tool does not provide any feedback though.
Other developers have built more complete pairing tools that give
feedback and allow unpairing as well.

ltunify is a command-line C program that can perform pairing, unpairing
and listing of devices. Solaar is a graphical Python program that
integrates in your system tray and allows you to configure additional
features of your input device such as swapping the functionality of Fn
keys.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 ltunify
    -   2.2 Solaar
    -   2.3 pairingtool
-   3 Known Problems
    -   3.1 Wrong device (pairing tool only)
    -   3.2 Keyboard layout via xorg.conf

Installation
------------

Benjamin's program can directly be installed from AUR: pairingtool.

Solaar is also available from the AUR: solaar. At installation the
Solaar package is creating the group plugdev. After installation add you
user to the plugdev group (# gpasswd -a $USER plugdev) to use Solaar as
non-root user.

ltunify is now also available from the AUR: ltunify-git. Create the
plugdev group before installation and add yourself to it (to avoid the
need of running ltunify as root). After installation, you can edit the
file /etc/udev/rules.d/42-logitech-unify-permissions.rules to change the
device group (the default group is plugdev).

Usage
-----

pairingtool can only be used for pairing and does not provide feedback,
it also needs to know the device name for pairing. ltunify and Solaar
can detect the receiver automatically.

> ltunify

Examples on unpairing a device, pairing a new device and showing a list
of all devices:

    $ ltunify unpair mouse
    Device 0x01 Mouse successfully unpaired
    $ ltunify pair
    Please turn your wireless device off and on to start pairing.
    Found new device, id=0x01 Mouse
    $ ltunify list
    Devices count: 1
    Connected devices:
    idx=1   Mouse   M525

> Solaar

Solaar has a GUI and CLI. Example CLI pairing session:

    $ solaar-cli unpair mouse
    Unpaired 1: Wireless Mouse M525 [M525:DAFA335E]
    $ solaar-cli pair
    Pairing: turn your new device on (timing out in 20 seconds).
    Paired device 1: Wireless Mouse M525 [M525:DAFA335E]
    $ solaar-cli show
    -: Unifying Receiver [/dev/hidraw0:08D89AA6] with 1 devices
    1: Wireless Mouse M525 [M525:DAFA335E] 

> pairingtool

To find the device that the receiver has, therefore take a look at the
outputs of

    $ ls -l /sys/class/hidraw/hidraw*/device/driver | awk -F/ '/receiver/{print $5}'

This will show the names of your receiver, for example hidraw0.

Now switch off the device that you want to pair (if it was on) and
execute your compiled program with the appropriate device as argument:

    # ./pairing_tool /dev/hidraw0
    The receiver is ready to pair a new device.
    Switch your device on to pair it (you have thirty seconds to do so).

Now switch on the device you want to pair. After a few seconds your new
device should work properly.

Known Problems
--------------

> Wrong device (pairing tool only)

On some systems there is more than one device that has the same name. In
that case you will receive the following error message when the wrong
device is choosen:

    # pairing_tool /dev/hidraw1
    Error: 32
    write: Broken pipe

> Keyboard layout via xorg.conf

With kernel 3.2 the Unifying Receiver got its own kernel module
hid_logitech_dj which does not work flawlessly together with keyboard
layout setting set via xorg.conf. A temporary workaround is to use
xorg-setxkbmap and set the layout manually. For example for a German
layout with no deadkeys one has to execute:

    $ setxkbmap -layout de -variant nodeadkeys

To automate this process one could add this line to xinitrc.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Logitech_Unifying_Receiver&oldid=287904"

Category:

-   Input devices

-   This page was last modified on 14 December 2013, at 01:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
