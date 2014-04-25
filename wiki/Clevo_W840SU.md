Clevo W840SU
============

The W840SU is a device by the taiwanese OEM manufacturer Clevo. It is
sold as Schenker S403, Tuxedo Book UC1402 and Nexoc B401. A touch
version exists as W840SU-T or UT1402. The hardware is configurable and
includes an Intel Haswell Core i3/i5/i7, Intel HD 4400 graphics, a 7 mm
harddrive, a mSATA device (storage, 3g/LTE modem) and a HDMI output.

Contents
--------

-   1 Installation
    -   1.1 Airplane Mode
    -   1.2 Webcam
    -   1.3 Battery Monitoring
    -   1.4 Brightness Keys
-   2 Problems
    -   2.1 Suspend/Hibernate/Resume
    -   2.2 Brightness Keys

Installation
============

Installing Archlinux is straightforward and most of the hardware works
out of the box.

Airplane Mode
-------------

To make use of the flightmode button, install tuxedo-wmi from the AUR
and load the tuxedo-wmi module. Use xbindkeys to map the key 255
(NoSymbol) to some script that disables wifi and bluetooth and enables
the airplane mode LED.

    $ cat ~/.xbindkeysrc
    "sudo /home/user/bin/setAirplane.sh"
       m:0x0 + c:255
       NoSymbol

Enable the LED with:

    echo 1 > /sys/class/leds/tuxedo::airplane/brightness

Webcam
------

The webcam needs to be activated by pressing FN+F10, otherwise you do
not see the device.

    $ lsusb
    Bus 001 Device 002: ID 8087:8000 Intel Corp. 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 003 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 002 Device 003: ID 5986:0536 Acer, Inc 
    Bus 002 Device 002: ID 8087:07da Intel Corp. 
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Battery Monitoring
------------------

The battery does not report any discharge information.

    $ cat current_now 
    cat: current_now: No such device

Current monitoring is only possible by following the charge_now and
voltage_now, but this gives only a rough estimation.

Brightness Keys
---------------

Brightness keys are not recognized while booting and work magically once
KDE is started.

Problems
========

Suspend/Hibernate/Resume
------------------------

Resuming with an inserted SD stops after reading the image. This is most
likely a problem with the cardreader driver and is still investigated.

Brightness Keys
---------------

The brightness keys stop working after an external display was
connected. This may be due to the fact, that the device exposes two
brightness controls:

    $ ls /sys/class/backlight/
    acpi_video0  intel_backlight

Changing the brightness is still possible via the inte_backlight control
but not via ACPI, which is used by KDE.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Clevo_W840SU&oldid=305145"

Category:

-   Clevo

-   This page was last modified on 16 March 2014, at 16:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
