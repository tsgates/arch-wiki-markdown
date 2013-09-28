ASUS A6Ja
=========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
| -   2 Configuration                                                      |
|     -   2.1 CPU                                                          |
|     -   2.2 Video                                                        |
|         -   2.2.1 Xorg                                                   |
|                                                                          |
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
|         -   2.10.1 The Lapsus daemon                                     |
+--------------------------------------------------------------------------+

Hardware
--------

-   CPU: Intel Core Duo T2400 (1.83GHz, 2MB cache L2, FSB 667MHz)
-   Chipset: Mobile Intel® 945 PM Express Chipset
-   RAM: 1024MB (1 x 1024MB) DDR2 SDRAM 667 Mhz
-   Hard Disk: SATA 100GB 4200 rpm
-   DVD Burner: TSS-CORP TS-632d
-   Display:
    -   TFT 15.4" WXGA (1280x800) ColorShine TFT-LCD, Asus Splendid
        Video Intelligent Technology

-   Video: ATI Mobility Radeon X1600 256MB
-   Audio: Scheda Intel High Definition Audio
-   Wi-Fi: Intel PRO/Wireless 3945ABG 802.11a/b/g
-   Bluetooth: 2.0+EDR
-   Webcam: 1.3 Mpixel
-   Modem: 56 Kbps V.90
-   LAN Gigabit Ethernet: 10/100/1000
-   Connectors:
    -   1 x Microphone-in jack
    -   1 x Headphone-out jack (S/PDIF)
    -   1 x TypeII PCMCIA slot
    -   1 x Line-in jack
    -   1 x VGA port
    -   1 x DVI-D port
    -   4 x USB 2.0 ports
    -   1 x IEEE 1394 port
    -   1 x RJ11 Modem jack for phone line
    -   1 x RJ45 LAN Jack for LAN insert
    -   1 x TV-out(S-Video)

-   Card Reader: MMC, SD, MS, MS-Pro
-   Dimension and Weight:
    -   354mm * 284mm * 35 mm(W x D x H)
    -   2.7 Kg (8-cell)

-   Pointer: Touch pad

Configuration
-------------

> CPU

Works out of the box.

Follow this SpeedStep guide to enable speed-stepping.

> Video

Works with the proprietary ATI driver in full display resolution.

TV-Out/DVI currently untested

VGA-Out is working with catalyst-control-center

Xorg

Follow this guide: ATI

No problems detected.

> Audio

Works out of the box.

Follow the official documentation: ALSA

> Wi-Fi

To enable wireless follow the official guide: Wireless Setup

NetworkManager is also a cool option.

> Webcam

Currently untested

> Bluetooth

To enable bluetooth support, go here: Bluetooth

> Pointer

To enable the pointer follow this guide: Touchpad Synaptics

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

Follow one of the guides in Extra Funtion Keys

> Utilities

Here are some useful utilities:

The Lapsus daemon

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_A6Ja&oldid=208347"

Category:

-   ASUS
