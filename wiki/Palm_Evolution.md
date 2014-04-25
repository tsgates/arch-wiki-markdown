Palm Evolution
==============

This document is written to help a new user set up a Palm Pilot in
Evolution. It has been tested with my Zire 71 (USB connection) and a
Palm T/X (Wifi connection), but should work with most Palm Pilot
devices.

Additions for anyone using different devices are appreciated. I have put
in what I think will work, but as I only have the one device I can't
test anything other than that device.

Contents
--------

-   1 Setting up Arch Linux
    -   1.1 Installing Evolution
    -   1.2 Installing the Gnome packages
-   2 Setting up the Hardware
    -   2.1 Serial Port
    -   2.2 USB Port
    -   2.3 Wireless Networking
    -   2.4 Checking the Hardware
-   3 Setting up Synchronisation
-   4 Setting up Conduits
-   5 Testing
-   6 Gnome Pilot Applet

Setting up Arch Linux
=====================

I am assuming that you have already installed Arch Linux, updated it,
and have a 'working' Gnome system. If not, see the Excellent Beginners
Guide

Installing Evolution
--------------------

Arch's Gnome metapackage does not install evolution by default. If you
haven't installed it, open a terminal, get into the super-user mode
(type su) and type

    pacman -S evolution

You can then run Evolution from the Applications/Office Gnome menu. When
you start it for the first time, it will ask for your email settings
using a "wizard". When this is complete the main Evolution display will
appear.

Installing the Gnome packages
-----------------------------

You now need to install the required Gnome component. Open a terminal
and get into the super-user mode (type su) and type

    pacman -S gnome-pilot gnome-pilot-conduits

Assuming you haven't done this previously, this will install three
packages ; gnome-pilot, gnome-pilot-conduits and pilot-link

Setting up the Hardware
=======================

Now plug in your Palm Pilot link. There are basic ways of connecting the
Palm Pilot to the computer

Serial Port
-----------

The older Palm Pilots (like my now broken Palm m100) connect using the
serial ports on the back of the computer.

USB Port
--------

The newer "low end" Palm Pilots (including my Zire 71) plug into the USB
ports.

Wireless Networking
-------------------

The newer and more expensive Palm Pilots have Wireless Networking and
can communicate with your computer either using a USB Link or over a
Wireless network, if you have one. These need to be set up on the Palms
themselves. The first thing to do is to set up the Wifi link on the
Palm.

You need to discover what your computers address is on the network ; you
can do this by typing

    # ip address show

Checking the Hardware
---------------------

If you have a USB connection you can test it by typing

    lsusb

into a terminal, which lists all the devices connected to the ports. If
your device is missing it may be one of those Palm Pilots (like the Zire
71) that only 'appears' on the system when it is actually transferring.
In this case, press the transfer button on the cradle or "Hotsync" from
the Palm Menus, type lsusb again, and you should get a display which
resembles this.

    [paulr@myhost aux]$ lsusb
    Bus 002 Device 001: ID 0000:0000  
    Bus 005 Device 001: ID 0000:0000  
    Bus 003 Device 003: ID 055f:0006 Mustek Systems, Inc. ScanExpress 1200 UB
    Bus 003 Device 002: ID 04e8:3242 Samsung Electronics Co., Ltd 
    Bus 003 Device 001: ID 0000:0000  
    Bus 004 Device 001: ID 0000:0000  
    Bus 001 Device 005: ID 0830:0060 Palm, Inc. Palm Tungsten T / Zire 71
    Bus 001 Device 004: ID 06d6:0025 Aashima Technology B.V. 
    Bus 001 Device 001: ID 0000:0000  

Then cancel the Hotsync on the Palm.

If you have a Serial Zire, it should be possible to test it by putting
the Palm into hotsync and typing

    cat </dev/ttyS0

which should display reams of gobbledegook.

To test the network link is difficult ; the simplest way is to see if
your Palm is talking to the same Wifi system as your computer.

Setting up Synchronisation
==========================

The next part involves setting up Evolution so it knows how to
communicate with the Palm Pilot. Start evolution from the menu
(Application/Internet) and choose Edit/Synchronisation Options from
Evolution's menu. This should bring up the Gnome-Pilot settings dialog.
Click the forward button.

-   Leave the name unchanged
-   Set the 'type' to Serial (plugs into the Serial Port), USB (plugs
    into USB port) or Network (wireless network connection)
-   Increase the timeout to '8'. I have in the past found this helps
    with difficult transfers.
-   Set the device to /dev/ttyUSB1 (USB connection) or /dev/ttyS0
    (Serial connection) ; it is greyed out for network connection.
-   Leave the speed unchanged

Click on 'Forward'. There are now two options, dependent on whether the
Palm has been 'synced' before. If you have synced it, it will get the
information from the Palm, if not, it will set it. Choose the
appropriate entry and click forward, then enter your name (if needed)
and press the Hotsync button or icon on the Palm.

You should now have set up the initial synchronisation. Clicking forward
brings up a dialog allowing you to select a working directory to store
PDA information in. Clicking Forward then Apply brings up the Settings
dialogue.

Setting up Conduits
===================

Click on the Conduits tab.

Conduits are the parts of the system that transfer information between
various parts of Evolution or Arch and the Palm Pilot. Enable those that
are appropriate for your machine. For almost all Palms this will usually
include :-

-   Backup : Backup the contents of your Palm
-   EAddress : Synchronise the Address book
-   ECalendar : Synchronise the Calendar
-   EMemos : Synchronise Memos
-   EToDo : Synchronise To Dos
-   MemoFile : Synchronise Memos
-   Time : Set the Palm Time from the Computer Clock

When you have done this click on "Close".

Testing
=======

Press the Hotsync button. You should be able to watch the transfer of
data on the Palm display.

Warning: Sometimes it requires two initial hotsyncs to set up the
Contacts in evolution, sometimes it only needs one. I have no idea why.

Gnome Pilot Applet
==================

If you wish you can have an Applet on the menu bar which allows you to
synchronise data without opening Evolution first. To do this, right
click the menu bar, select Add to Panel, scroll down to Pilot Applet and
select it, click 'Add' and then 'Close'. A little black circle with an
arrow on it should appear. Move it to where you want it.

Now Hotsyncing will give a progress dialog.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Palm_Evolution&oldid=298138"

Category:

-   Mobile devices

-   This page was last modified on 16 February 2014, at 07:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
