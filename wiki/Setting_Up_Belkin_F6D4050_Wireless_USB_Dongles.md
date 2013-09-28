Setting Up Belkin F6D4050 Wireless USB Dongles
==============================================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Note                                                               |
| -   2 Overview                                                           |
| -   3 The Solution                                                       |
| -   4 802.11n                                                            |
+--------------------------------------------------------------------------+

Note
----

This page is now out of date; the Belkin F6D4050 V1 works with the
RT2800USB driver in the kernel (needs testing with V2). It is possible
that the RT3070 driver available here is needed for wireless N support,
but so far compilation attempts for current kernels have been
unsuccessful.

Overview
--------

You may find that your Belkin F6D4050 (v1 or v2) wireless usb dongle
just won't work! Well here's the solution.

The Solution
------------

Note:You need the rt2870 driver which is already included with kernel
2.6.29 and up.

First, use lsusb to check that the device ID number is 050d:935a or
050d:935b (v1 or v2, respectively):

    [sdenne@marsrover ~]$ lsusb
    Bus 002 Device 003: ID 050d:935b Belkin Components

Now create these two files:

    /etc/udev/rules.d/network_drivers.rules
    /etc/modprobe.d/network_drivers.conf

Now add the following to /etc/udev/rules.d/network_drivers.rules (that
first file you just created):

    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="050d", ATTR{idProduct}=="935a", RUN+="/sbin/modprobe -qba rt2870sta"

Then add the following to /etc/modprobe.d/network_drivers.conf (the
second file you created):

    install rt2870sta /sbin/modprobe --ignore-install rt2870sta $CMDLINE_OPTS; /bin/echo "050d 935a" > /sys/bus/usb/drivers/rt2870/new_id

Pay close attention to any occurrence of 935a in the lines you've just
added. If your device ID is F6D4050 v1, leave occurrences of 935a as-is
with the letter a at the end. If your device ID is F6D4050 v2, change
the last letter of 935a to b. The letter must match with the output that
you see when you use lsusb.

That's it! Now reboot and you'll have wireless capabilities! woo hoo!

Note:to undo everything that you've just done, simply delete the two
files you've created.

802.11n
-------

The Belkin F6D4050 V1(000) device supports 802.11n (I'm not sure about
the V2 device), however using the rt2870sta driver I was only able to
connect using 802.11g. The solution to get this working is that you need
the RT3572STA driver. As of 2.6.36 this isn't included in the Arch
kernel distribution, but you can download it from Ralink's website
(e-mail address required) and compile it yourself.

Before compiling, you need to set some options in os/linux/config.mk:

     HAS_WPA_SUPPLICANT=y
     HAS_NATIVE_WPA_SUPPLICANT_SUPPORT=y

Then compile as usual:

     make && sudo make install

To set it up just follow the instructions about, but substitute
rt2870sta for rt3572sta. I was able to use exactly the same netcfg
configuration, just replacing wlan0 with ra0.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Setting_Up_Belkin_F6D4050_Wireless_USB_Dongles&oldid=217696"

Category:

-   Wireless Networking
