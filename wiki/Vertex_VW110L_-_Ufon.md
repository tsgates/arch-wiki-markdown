Vertex VW110L - Ufon
====================

This article details the configuration and use of the Vertex VW110L
modem for the U:Fon service.

Contents
--------

-   1 Getting modem device
-   2 Useful AT Commands
-   3 Pppd settings
-   4 vwmfdiag

Getting modem device
--------------------

-   Install usb_modeswitch and usbutils package.
-   Comment or remove line from
    /lib/udev/rules.d/61-option-modem-modeswitch.rules where idVendor is
    05c6 and idProduct is 1000 (keep eye on it after udev update)
-   reload udev rules - udevadm control --reload-rules and udevadm
    trigger
-   Plug Vertex modem in and wait for few second until red LED on the
    edge of modem change color to blue

Now you should be able to access /dev/ttyACM0 device.

Try screen or minicom to send AT commands to your modem.

Useful AT Commands
------------------

-   AT+CSQ - signal strength (first number) -
    http://www.gprsmodems.co.uk/images/csq1.pdf
-   ATI - modem info

Pppd settings
-------------

Create necessary files:

> /etc/ppp/ufon

    TIMEOUT 8
    ABORT BUSY
    ABORT "NO CARRIER"
    ABORT ERROR
    "" 'AT'
    OK ATD#777
    CONNECT \d\c

> /etc/ppp/peers/ufon

    connect "chat -v -f /etc/ppp/ufon"
    ttyACM0
    921600
    crtscts
    persist
    usepeerdns
    defaultroute
    name ufon
    ipparam ufon
    noauth

and manage connection with pon ufon for connecting and poff ufon for
disconnecting

vwmfdiag
--------

Provides diagnostic interface /dev/ttyUSB1.

Files in vwmfdiag zipfile from ufon website and from newer CDs seems to
be corrupted.

-   Download the old one
-   unzip and comment line nr 111 in file vwmfdiag.c

    //.shutdown =		vwmfdiag_shutdown,

-   compile module - make
-   cp ./vwmfdiag.ko /lib/modules/`uname -r`/misc/
-   update modules.dep and map files - depmod -a
-   Plug Vertex modem in and wait for few second until red LED on the
    edge of modem change color to blue

Try screen or minicom to get an informations from /dev/ttyUSB1.

* * * * *

If something doesn't work, see /var/log/messages for more information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vertex_VW110L_-_Ufon&oldid=206807"

Category:

-   Modems

-   This page was last modified on 13 June 2012, at 14:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
