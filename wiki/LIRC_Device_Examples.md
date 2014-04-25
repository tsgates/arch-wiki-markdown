LIRC Device Examples
====================

Related articles

-   LIRC

This article includes device specific examples of LIRC function
configurations.

Contents
--------

-   1 Asus DH Deluxe series motherboard
-   2 ASRock ION series (Nuvoton) quickstart
-   3 Logitech Wireless Presenter R400
-   4 Serial Port "Home Brew" IR Receiver
-   5 Streamzap PC Remote (USB)
-   6 X10

Asus DH Deluxe series motherboard
---------------------------------

Check the output of:

    $ cat /dev/usb/hiddevX

where X is 0,1 or bigger, and press some buttons on remote. If
characters result, then the device is working, follow steps:  

1. In file /etc/conf.d/lircd.conf add:  

    LIRC_DRIVER="dvico"

2. Reload LIRC:

    # systemctl restart lirc

ASRock ION series (Nuvoton) quickstart
--------------------------------------

    $ ln -s /usr/share/lirc/remotes/lirc_wb677/lircd.conf.wb677 /etc/lirc/lircd.conf
    # systemctl restart lirc

Logitech Wireless Presenter R400
--------------------------------

The R400 Presenter can be used with default configuration from devinput.
Follow the following steps to be able to use the following buttons:
KEY_PAGEDOWN KEY_PAGEUP KEY_DISPLAYTOGGLE KEY_PRESENTATION.

1. Create the the systemd service file to start the lirc configuration
for your presenter whenever you want to transform it into a remote
control:

    /etc/systemd/system/lirc-logitech-r400.service

    [Service]
    ExecStart=/usr/bin/lircd --nodaemon --driver=devinput --device=/dev/input/event17

2. Copy the default devinput configuration which should work out of the
box for the R400:

    # cp /usr/share/lirc/devinput/lircd.conf.devinput /etc/lirc/lircd.conf

3. Use systemctl start lirc-logitech-r400.service to start lirc and irw
to test whether your keys are recognised:

    $ irw
    000000008001006d 00 KEY_PAGEDOWN devinput
    0000000080010068 00 KEY_PAGEUP devinput
    00000000800101af 00 KEY_DISPLAYTOGGLE devinput
    00000000800101a9 00 KEY_PRESENTATION devinput

4. Create your program-specific configurations as described here.

Serial Port "Home Brew" IR Receiver
-----------------------------------

1. Create a udev rule to give non-privleged users read/write access to
the serial port. In this example, ttyS0 is used.

    /etc/udev/rules.d/z98-serial.rules

    # For serial port ttyS0 and LIRC
    KERNEL=="ttyS0",SUBSYSTEM=="tty",DRIVERS=="serial",MODE="0666"

2. Create the needed modprobe configs

    /etc/modules-load.d/lirc_serial.conf

    lirc_serial

    /etc/modprobe.d/lirc_serial.conf

    install lirc_serial /usr/bin/setserial /dev/ttyS0 uart none && /sbin/modprobe --first-time --ignore-install lirc_serial
    options lirc_serial type=0
    remove lirc_serial /sbin/modprobe -r --first-time --ignore-remove lirc_serial && /sbin/modprobe -r lirc_dev

Note:Using udev rules to run the setserial command does not work in my
experience because lirc_serial gets loaded before the serial port rules
are applied.

3. Install a custom systemd service file.

    /etc/systemd/system/lirc.service

    [Unit]
    Description=Linux Infrared Remote Control
    After=network.target

    [Service]
    Type=simple
    PIDFile=/run/lirc/lircd.pid
    ExecStartPre=/bin/rm -f /dev/lirc /dev/lircd /var/run/lirc/lircd
    ExecStart=/usr/sbin/lircd -n -r -P /run/lirc/lircd.pid -d /dev/lirc0 -o /run/lirc/lircd
    ExecStartPost=/usr/bin/ln -sf /run/lirc/lircd /dev/lircd
    ExecStartPost=/usr/bin/ln -sf /dev/lirc0 /dev/lirc
    ExecReload=/bin/kill -SIGHUP $MAINPID

    [Install]
    WantedBy=multi-user.target

4. We still need the default tmpfiles to be created, so copy that config
file to /etc/tmpfiles.d/lirc.conf.

    # cp -a /usr/lib/tmpfiles.d/lirc.conf /etc/tmpfiles.d/lirc.conf

5. Create a ~/.lircrc or a /etc/lirc/lircrc file for system wide use.

6. Have the service start at boot and then test with a reboot

    # systemctl enable lirc.service
    # systemctl reboot

or load the module and start the lirc.service.

    # modprobe lirc_serial
    # systemctl start lirc.service

Streamzap PC Remote (USB)
-------------------------

This particular remote is known to not function with the lirc-utils
package included lirc.service. Flyspray #37958 has been created. Until
it is acted upon, users can create a custom service file that does work:

    /etc/systemd/system/my-lirc.service

    [Unit]
    Description=LIRC Daemon
    After=network.target

    [Service]
    Type=forking
    PIDFile=/run/lirc/lircd.pid
    ExecStartPre=/bin/mkdir -p /run/lirc
    ExecStartPre=/bin/rm -f /dev/lircd
    ExecStartPre=/bin/rm -f /run/lirc/lircd
    ExecStartPre=/bin/ln -s /run/lirc/lircd /dev/lircd
    ExecStart=/usr/bin/lircd -d /dev/lirc0 -P /run/lirc/lircd.pid
    ExecStopPost=/bin/rm -f /dev/lircd
    ExecStopPost=/bin/rm -fR /run/lirc

    [Install]
    WantedBy=multi-user.target

Note:When the batteries in this remote are low, it may stop working even
though the red LED on the received still flashes upon receiving signals!

X10
---

There is a dedicated wiki page with information about X10

Retrieved from
"https://wiki.archlinux.org/index.php?title=LIRC_Device_Examples&oldid=306198"

Categories:

-   Other hardware
-   Audio/Video

-   This page was last modified on 21 March 2014, at 06:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
