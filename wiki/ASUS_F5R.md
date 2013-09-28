ASUS F5R
========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Configuration                                                      |
|     -   2.1 CPU                                                          |
|     -   2.2 Video                                                        |
|     -   2.3 Audio                                                        |
|     -   2.4 Wi-Fi                                                        |
|     -   2.5 Webcam                                                       |
|     -   2.6 Bluetooth                                                    |
|     -   2.7 Pointer                                                      |
|     -   2.8 Leds & ACPI upgrade                                          |
|     -   2.9 OLED Display                                                 |
|         -   2.9.1 Function Keys                                          |
|                                                                          |
|     -   2.10 Utilities                                                   |
|         -   2.10.1 The Lapsus daemon & KDE applet                        |
+--------------------------------------------------------------------------+

Hardware
--------

-   CPU:
    -   Intel(R) Celeron(R), M 520 (1.6GHz), 533MHz FSB, 1MB L2 Cache
    -   Intel(R) Core Duo(R), T 2130 (1.86GHz), 533MHz FSB, 1MB L2 Cache

-   Chipset: ATI Radeon Xpress 1100
-   RAM: 1024MB (1 x 1024MB) SO-DIMM DDR2 533MHz, max 2048 MB
-   Hard Disk: SATA 120GB 5400 rpm
-   DVD Burner: DVD-RW Super Multi DualLayer
-   Display: TFT 15.4" WXGA (1280x800)ColorShine TFT-LCD, Asus Splendid
    Video Intelligent Technology
-   Video: ATI® Xpress™ Radeon™ X1100 128MB HyperMemory
-   Audio: Intel High Definition Audio
-   Wi-Fi: 802.11g
-   Bluetooth: 2.0+EDR
-   Webcam: 1.3 Mpixel
-   Modem: 56 Kbps V.90
-   LAN:10/100 Mbps Ethernet
-   Connectors:
    -   1 x Microphone-in jack
    -   1 x Headphone-out jack (S/PDIF)
    -   1 x TypeII PCMCIA slot'
    -   1 x VGA port
    -   4 x USB 2.0 ports
    -   1 x RJ11 Modem jack for phone line
    -   1 x RJ45 LAN Jack for LAN insert

-   Card Reader: MMC, SD, MS, MS-Pro
-   Dimension and Weight:
    -   362mm * 262mm * 27mm(W x D x H)
    -   2,6 Kg (6-cell)

-   Pointer: Touch pad

Configuration
-------------

> CPU

Works out of the box.

Follow this SpeedStep guide to enable speed-stepping.

> Video

Works with the ATI Catalyst proprietary driver.

Follow this guide: ATI#ATI_Catalyst_proprietary_driver

Console framebuffer is working in 1024x768 with the vga=0x317 kernel
boot option. With the vesafb-tng patch the native display resolution
should work, too.

> Audio

Works out of the box.

Follow the official documentation: ALSA

> Wi-Fi

To enable wireless follow the official guide: Wireless_Setup#ndiswrapper

Please note that the Asus F5R needs the bcmwl5.inf driver.

Other way is to use b43 driver: Wireless_Setup#b43

NetworkManager is also a cool option.

> Webcam

Since there is no official support for the Asus Webcam, you need to
install separate drivers from the AUR.

> Bluetooth

Works out of the box.

> Pointer

To enable the pointer follow this guide: Touchpad Synaptics

A really cool utility is gsynaptics (available in the [community] repo).

> Leds & ACPI upgrade

To enable every led (the ones on the LCD too) the first thing needed is
upgrading the acpi module with the one provided by acpi4asus.

It's really easy, follow these steps:

    mkdir sources
    cvs -d:pserver:anonymous@acpi4asus.cvs.sourceforge.net:/cvsroot/acpi4asus login
    cvs -z3 -d:pserver:anonymous@acpi4asus.cvs.sourceforge.net:/cvsroot/acpi4asus co -P acpi4asus
    cd acpi4asus/driver
    make
    make install

Now the new driver is installed. To use it and prevent udev from using
the old one, edit your /etc/rc.conf and:

1.  Add to "MOD_BLACKLIST": asus_acpi
2.  Add to "MODULES": asus_laptop

Right now you can reboot or execute:

    modprobe -r asus_acpi
    modprobe asus_laptop

Everything done!

You'll find the leds in "/sys/class/leds/".

To enable a led write "1" in the "brightness" file in the right
directory. To disable a led write "0" in the "brightness" file in the
right directory.

Try this:

    echo 1 > /sys/class/leds/asus:gaming/brightness 

Enjoy your leds!

> OLED Display

There is a package in AUR named asusoled.

kernel < 2.6.23: It needs turning off usbhid (rmmod usbhid) or patching
the kernel: asus-lcm.diff

kernel >= 2.6.23: works out of a box

  
 There is also a separate kernel driver based on asusoled: Asus_OLED. It
works without patching usbhid or removing asus_laptop. Just load it
before the usbhid module gets loaded and it will work (< 2.6.23, in new
kernels works out of a box). It contains a small Qt utility, which can
be used as a drop-in replacement for asusoled, and has some additional
features.

Function Keys

WiP

> Utilities

Here are some useful utilities:

The Lapsus daemon & KDE applet

Lapsus is a set of programs created to help manage additional laptop
features such as:

       * All the LEDs (on/off)
       * LCD Backlight
       * Wireless radio switch
       * Bluetooth adapter switch
       * Alsa mixer (volume control, mute/unmute)
       * Synaptics touchpad (on/off)
       * Volume/Mute hotkeys
       * Touchpad hotkey
       * Backlight hotkey
       * LightSensor switch and sensitivity level (svn version only)

Prerequisites: acpi4asus from CVS (at least a version > 0.41). In your
rc.conf, blacklist the 'acpi_asus' module and add the 'asus_laptop' one
in the MODULES array.

Install the latest lapsus package from aur. Now start the lapsusd
daemon: /etc/rc.d/lapsusd start. You can add it into DAEMONS array in
/etc/rc.conf.

Finally add the lapsus applet to KDE kicker.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_F5R&oldid=208435"

Category:

-   ASUS
