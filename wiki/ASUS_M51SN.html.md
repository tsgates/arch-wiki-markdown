ASUS M51SN
==========

Contents
--------

-   1 Configuration
    -   1.1 CPU
    -   1.2 Video
        -   1.2.1 Xorg
    -   1.3 Audio
    -   1.4 Wi-Fi
    -   1.5 Webcam
    -   1.6 Bluetooth
    -   1.7 Pointer

Configuration
-------------

> CPU

Works out of the box.

Follow this cpufrequtils guide to enable speed-stepping.

> Video

Video out works out of the box, and nvidia-settings detects the TV I
used with it.

Xorg

Works out of the box.

Follow this guide: NVIDIA

> Audio

Follow the official documentation: ALSA

Need to tweak the options for the snd-hda-intel driver a little bit
before it will work:

Add the following to /etc/modprobe.d/modprobe.conf from here:

     options snd-hda-intel model=lenovo

> Wi-Fi

Use the included iwl4965 driver.

To enable wireless follow the official guide: Wireless network
configuration

> Webcam

Works out of the box with the v4l2 driver.

> Bluetooth

Works out of the box.

> Pointer

Works out of the box.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_M51SN&oldid=297833"

Category:

-   ASUS

-   This page was last modified on 15 February 2014, at 15:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
