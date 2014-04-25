Hpfall
======

hpfall is a simple daemon providing HDD shock protection for HP laptops
supporting the feature officially called "HP Mobile Data Protection
System 3D" or "HP 3D DriveGuard".

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Service
-   3 Testing
    -   3.1 Testing Shock protection

Installation
------------

You can install hpfall, which is available in the AUR.

Configuration
-------------

You need to set your HDD in /etc/conf.d/hpfall.

If your HDD is /dev/sda, your config file should look like this:

    /etc/conf.d/hpfall

    #
    # Parameters to be passed to hpfall
    #
    DEVICE=/dev/sda

> Service

You can now start hpfall daemon:

    # systemctl start hpfall.service

To start hpfall at boot time::

    # systemctl enable hpfall.service

Testing
-------

After reboot with new kernel, check if hp_accel driver was initialised
correctly:

    # dmesg | grep hp_accel

> Testing Shock protection

Warning:Be careful while performing this test and keep your laptop above
something soft. Simulating free fall over the desk is bad idea.

Find your HDD's unload_heads file:

    # find /sys -name unload_heads

Go to it's directory and run:

    # watch --difference=permanent cat unload_heads

Lift you laptop into free space and simulate free fall while holding it
firmly with your hands. About 10 cm should be enough. If the disk
protection works then you should hear your HDD making "click" sound, see
one of your laptop's LEDs flashing and the watch value's background
should permanently turn black.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hpfall&oldid=281967"

Category:

-   Laptops

-   This page was last modified on 8 November 2013, at 12:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
