Logitech Unifying Receiver
==========================

The Logitech Unifying Receiver is a wireless receiver that can connect
up to six compatible wireless mice and keyboards to your computer. The
input device that comes with the receiver is already paired with it and
should work out of the box through plug and play. Logitech officially
supports pairing of additional devices just through their Windows
software. Pairing on Linux is supported by a small program from Benjamin
Tissoires. That tool does not provide any feedback though. Other
developers have built more complete pairing tools that give feedback and
allow unpairing as well.

ltunify is a command-line C program that can perform pairing, unpairing
and listing of devices. Solaar is a graphical Python program that
integrates in your system tray and allows you to configure additional
features of your input device such as swapping the functionality of Fn
keys.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 From AUR                                                     |
|     -   1.2 ltunify (manual)                                             |
|     -   1.3 pairingtool (manual)                                         |
|                                                                          |
| -   2 Usage                                                              |
|     -   2.1 ltunify                                                      |
|     -   2.2 Solaar                                                       |
|     -   2.3 pairingtool                                                  |
|                                                                          |
| -   3 Known Problems                                                     |
|     -   3.1 Wrong device (pairing tool only)                             |
|     -   3.2 Keyboard Layout via xorg.conf                                |
+--------------------------------------------------------------------------+

Installation
------------

> From AUR

Benjamin's program can directly be installed from AUR: pairingtool.

Solaar is also available from the AUR: solaar. Create the plugdev group
before installation and add yourself to it to avoid the need to run the
program as root.

> ltunify (manual)

There is currently no AUR package available. ltunify is just a single
binary with an optional udev rule to avoid running the program as root.

    # pacman -S gcc
    $ git clone https://git.lekensteyn.nl/ltunify.git && cd ltunify
    $ make ltunify
    $ make install-home

The last step will copy the ltunify program to $HOME/bin/ltunify. You
can skip that step and install it to /usr/local/bin if you prefer that.

To avoid running the program as root, copy
udev/42-logitech-unify-permissions.rules to /etc/udev/rules.d/ and
adjust the group inside the file if necessary.

> pairingtool (manual)

If you want, you can also compile the source-code manually.

At first make sure that a C compiler is installed on your system:

    # pacman -S gcc 

Afterwards copy and paste the following code to a local file, for
example pairing_tool.c:

    /*
    * Copyright 2011 Benjamin Tissoires 
    *
    * This program is free software: you can redistribute it and/or modify
    * it under the terms of the GNU General Public License as published by
    * the Free Software Foundation, either version 3 of the License, or
    * (at your option) any later version.
    *
    * This program is distributed in the hope that it will be useful,
    * but WITHOUT ANY WARRANTY; without even the implied warranty of
    * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    * GNU General Public License for more details.
    *
    * You should have received a copy of the GNU General Public License
    * along with this program.  If not, see .
    */

    #include <linux/input.h>
    #include <linux/hidraw.h>
    #include <sys/ioctl.h>
    #include <fcntl.h>
    #include <unistd.h>
    #include <stdio.h>
    #include <errno.h>

    #define USB_VENDOR_ID_LOGITECH                  (__u32)0x046d
    #define USB_DEVICE_ID_UNIFYING_RECEIVER         (__s16)0xc52b
    #define USB_DEVICE_ID_UNIFYING_RECEIVER_2       (__s16)0xc532

    int main(int argc, char **argv)
    {
           int fd;
           int res;
           struct hidraw_devinfo info;
           char magic_sequence[] = {0x10, 0xFF, 0x80, 0xB2, 0x01, 0x00, 0x00};

           if (argc == 1) {
                   errno = EINVAL;
                   perror("No hidraw device given");
                   return 1;
           }

           /* Open the Device with non-blocking reads. */
           fd = open(argv[1], O_RDWR|O_NONBLOCK);

           if (fd < 0) {
                   perror("Unable to open device");
                   return 1;
           }

           /* Get Raw Info */
           res = ioctl(fd, HIDIOCGRAWINFO, &info);
           if (res < 0) {
                   perror("error while getting info from device");
           } else {
                   if (info.bustype != BUS_USB ||
                       info.vendor != USB_VENDOR_ID_LOGITECH ||
                       (info.product != USB_DEVICE_ID_UNIFYING_RECEIVER &&
                        info.product != USB_DEVICE_ID_UNIFYING_RECEIVER_2)) {
                           errno = EPERM;
                           perror("The given device is not a Logitech "
                                   "Unifying Receiver");
                           return 1;
                   }
           }

           /* Send the magic sequence to the Device */
           res = write(fd, magic_sequence, sizeof(magic_sequence));
           if (res < 0) {
                   printf("Error: %d\n", errno);
                   perror("write");
           } else if (res == sizeof(magic_sequence)) {
                   printf("The receiver is ready to pair a new device.\n"
                   "Switch your device on to pair it.\n");
           } else {
                   errno = ENOMEM;
                   printf("write: %d were written instead of %ld.\n", res,
                           sizeof(magic_sequence));
                   perror("write");
           }
           close(fd);
           return 0;
    }

Afterwards the code has to be compiled into the executable file
pairing_tool:

    $ gcc -o pairing_tool pairing_tool.c

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

> Keyboard Layout via xorg.conf

With kernel 3.2 the Unifying Receiver got its own kernel module
hid_logitech_dj which does not work flawlessly together with keyboard
layout setting set via xorg.conf. A temporary workaround is to use
xorg-setxkbmap and set the layout manually. For example for a German
layout with no deadkeys one has to execute:

    $ setxkbmap -layout de -variant nodeadkeys

To automate this process one could add this line to xinitrc.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Logitech_Unifying_Receiver&oldid=255348"

Category:

-   Input devices
