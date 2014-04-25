Huawei E173s
============

This page describes how to set up Huawei E173s 3G USB modem on Arch
Linux. It involves switching the USB stick from CD-ROM mode to modem
mode using usb_modeswitch, making a connection to the network with
sakis3g and setting it up to run at system startup.

Contents
--------

-   1 Activating the SIM
-   2 Checking modem
-   3 Set up usb_modeswitch
-   4 Check if the modem is switched
-   5 Connecting
-   6 Connecting at system startup
    -   6.1 Creating a configuration file
    -   6.2 Running sakis3g at system startup
-   7 External links

Activating the SIM
------------------

Before using a brand new SIM (or a USB stick with SIM included) for the
first time in Linux it may need to be activated first by using the
Windows-only software on the stick, otherwise it won't connect no matter
how many times you try (was true in my case).

Checking modem
--------------

Install usbutils (base) if not installed:

    pacman -S usbutils

Plug in the modem and run lsusb:

    lsusb | grep Huawei

The output should be something like this:

    Bus 003 Device 003: ID 12d1:1c0b Huawei Technologies Co., Ltd.

The ID 12d1:1c0b refers to vendor id and product id. If you get
different values, it means your modem is not Huawei E173s (of course,
you can always open the USB stick to double check).

Set up usb_modeswitch
---------------------

Install usb_modeswitch (community) if not installed:

    pacman -S usb_modeswitch

At this point, if you remove your modem and re-insert it udev should
switch to modem mode automatically but sometimes it just doesn't work
(on my system for example) so you have to do it manually as root:

    usb_modeswitch -c /usr/share/usb_modeswitch/12d1\:1c0b -v 12d1 -p 1c0b

Check if the modem is switched
------------------------------

    lsusb | grep Huawei

The output should be something like this:

    Bus 003 Device 003: ID 12d1:1c05 Huawei Technologies Co., Ltd.

Note that the product ID has changed from 1c0b to 1c05. It means that
the USB stick can now be used as a modem. Also note that it can take
some time (probably not more than 15 seconds) for the modem to switch if
you removed and re-inserted it instead of running usb_modeswitch
manually.

Connecting
----------

The easiest way to connect is with sakis3g. Install ppp (base) and
net-tools (core) if not installed:

    pacman -S ppp net-tools

Download and install sakis3g from http://www.sakis3g.org/ (it's also
available from AUR):

    wget http://www.sakis3g.org/versions/latest/i386/sakis3g.gz
    gunzip sakis3g.gz
    mv sakis3g /usr/bin

Run sakis3g:

    sakis3g --interactive

You will have to provide your APN, username and password, assuming
everything goes right you should be connected by now. Note while sakis3g
should detect your modem, sometimes it just doesn't (it's the case on my
system). If that's the case you have to specify CUSTOM_TTY, for example
/dev/ttyUSB0.

Connecting at system startup
----------------------------

> Creating a configuration file

    nano /etc/sakis3g.conf

Add the following lines (CUSTOM_APN, APN_USER and APN_PASS refer to your
APN, username and password respectively, you may have to adjust them):

    OTHER=CUSTOM_TTY
    CUSTOM_TTY="/dev/ttyUSB0"
    APN=CUSTOM_APN
    CUSTOM_APN="general.t-mobile.uk"
    APN_USER="t-mobile"
    APN_PASS="tm"

This configuration file works very well on my system but you may have to
adjust CUSTOM_TTY as well if you have more than one USB modem. Note that
it's also modem-independent - if you start using a different modem you
shouldn't have to change anything.

> Running sakis3g at system startup

What you need to do is to run sakis3g connect at system startup. The
easiest way to do this is to add these lines to /etc/rc.local (it
doesn't always work, I don't know why):

    sakis3g connect --console
    sleep 3

The second line gives you time to examine the output of sakis3g at
system startup to see if everything is working as it should, if it is,
you can just remove it later. Another option, if you are using X but not
using a login manager like GDM, is to put it in your .xinitrc (see the
first line):

    sudo sakis3g connect &
    exec gnome-session

Although if you are using GNOME, you should add it in
gnome-session-properties instead:

    Name: sakis3g
    Command: sudo sakis3g connect

For both of these to work you need to add the following line to
/etc/sudoers:

    <username> ALL=(ALL) NOPASSWD:/usr/bin/sakis3g

Replace <username> with your username.

External links
--------------

-   http://wiki.sakis3g.org/wiki/index.php?title=Mode_switch

Retrieved from
"https://wiki.archlinux.org/index.php?title=Huawei_E173s&oldid=231213"

Category:

-   Modems

-   This page was last modified on 24 October 2012, at 16:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
