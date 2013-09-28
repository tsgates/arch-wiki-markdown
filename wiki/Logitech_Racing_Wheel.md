Logitech Racing Wheel
=====================

  
 This article describes how to set up a Logitech Formula Force GP Racing
Wheel with Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
|     -   1.1 Identifying                                                  |
|     -   1.2 Testing                                                      |
|                                                                          |
| -   2 Configuration                                                      |
| -   3 References                                                         |
+--------------------------------------------------------------------------+

Installing
==========

Identifying
-----------

When the wheel is plugged in, the following commands can be used to
identify the wheel:

    $dmesg
    usb 5-2: new low speed USB device using uhci_hcd and address 6

    $lsusb
    Bus 005 Device 006: ID 046d:c293 Logitech, Inc. WingMan Formula Force GP

    $ cat /proc/bus/input/devices
    I: Bus=0003 Vendor=046d Product=c293 Version=0100
    N: Name="Logitech Inc. WingMan Formula Force GP"
    P: Phys=usb-0000:00:1a.2-2/input0
    S: Sysfs=/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input30
    U: Uniq=
    H: Handlers=event15 js0 
    B: EV=20001b
    B: KEY=3f 0 0 0 0 0 0 0 0 0
    B: ABS=3
    B: MSC=10
    B: FF=1 40000 0 0

Testing
-------

Testing can be done with the Linux Force Feedback Library. This package
can be found in aur: https://aur.archlinux.org/packages.php?ID=50236

Now the wheel can be tested. To find the right device use evtest
/dev/input/eventX. The correct number can be found in
/proc/bus/input/devices. In this case event15 is the correct device.
evtest shows the events coming from the wheel:

    $ evtest /dev/input/event15
    Input driver version is 1.0.0
    Input device ID: bus 0x3 vendor 0x46d product 0xc293 version 0x100
    Input device name: "Logitech Inc. WingMan Formula Force GP"
    Supported events:
     Event type 0 (Reset)
       Event code 0 (Reset)
       Event code 1 (Key)
       Event code 3 (Absolute)
       Event code 4 (?)
       Event code 21 (ForceFeedback)
     Event type 1 (Key)
       Event code 288 (Trigger)
       Event code 289 (ThumbBtn)
       Event code 290 (ThumbBtn2)
       Event code 291 (TopBtn)
       Event code 292 (TopBtn2)
       Event code 293 (PinkieBtn)
     Event type 3 (Absolute)
       Event code 0 (X)
         Value    438
         Min        0
         Max     1023
         Fuzz       3
         Flat      63
       Event code 1 (Y)
         Value    124
         Min        0
         Max      255
         Flat      15
     Event type 4 (?)
       Event code 4 (?)
     Event type 21 (ForceFeedback)
       Event code 82 (?)
       Event code 96 (?)
    Testing ... (interrupt to exit)
    Event: time 1295173625.476950, type 3 (Absolute), code 0 (X), value 439
    Event: time 1295173625.476983, type 0 (Reset), code 0 (Reset), value 0
    Event: time 1295173625.484827, type 3 (Absolute), code 0 (X), value 428

ffcfstress can be used to test the force feedback. The wheel should
start to oscillate:

    # ffcfstress -d /dev/input/event15

            position                   center                     force
    <-----------|****+------> <-----------|*******----> <-----------|**+-------->^C

Configuration
=============

The Wheel works without any wine configuration in flatout2. Just the
following in-game configuration is needed:

-   Force Feedback: On
-   Force level: 100%
-   Sensitivity: 100%
-   Deadzone: 0%
-   Controller: Logitech Inc...

-   Throttle: Y-Axis left
-   Brake: Y-Axis right
-   Steer left: X-axis left
-   Steer right"X-axis right

References
==========

Sourceforge wiki: CheckForceFeedback

Retrieved from
"https://wiki.archlinux.org/index.php?title=Logitech_Racing_Wheel&oldid=207009"

Categories:

-   Input devices
-   Gaming
