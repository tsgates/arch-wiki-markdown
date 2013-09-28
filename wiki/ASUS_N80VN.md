ASUS N80VN
==========

Works really good under Arch Linux. Overall excellent laptop, once you
get rid of Vista and other crapware.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Sound card                                                         |
| -   2 Bluetooth                                                          |
| -   3 Fingerprint scanner                                                |
| -   4 Webcam                                                             |
+--------------------------------------------------------------------------+

Sound card
----------

You must set the right sound card model in modprobe.d in order to make
it work correctly with headphones.

in /etc/modprobe.d/alsa-base:

    options snd-hda-intel model=g71v

No model or position_fix needed. Remove any options snd-hda-intel in
/etc/modprobe.d/modprobe.conf and /etc/modprobe.d/sound if required.

Bluetooth
---------

Can't bother trying bluetooth as I do not have a bluetooth device.
However, I do not see why it would not work, as it seems to use pretty
standard, non-brain dead drivers under Windows. --Sebleblanc 17:12, 18
April 2009 (EDT)

Fingerprint scanner
-------------------

Don't bother using the fingerprint scanner right now, because of buggy
drivers.

Webcam
------

There's a /dev/video0 device present, it gets detected properly.
However, when opening the v4l stream in VLC, it seems to be using an
incompatible codec (YUY2 or something).

Apparently, from the USB ID of the camera, it's a Syntek USB 2.0 UVC PC
Camera ([1]) and should be supported. However, I can't make it work.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_N80VN&oldid=208342"

Category:

-   ASUS
