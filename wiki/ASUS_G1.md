ASUS G1
=======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Hardware
-   2 Configuration
    -   2.1 CPU
    -   2.2 Video
        -   2.2.1 Xorg
    -   2.3 Audio
    -   2.4 Wi-Fi
    -   2.5 Webcam
    -   2.6 Bluetooth
    -   2.7 Pointer
    -   2.8 Leds & ACPI upgrade
    -   2.9 OLED Display
        -   2.9.1 Function Keys
    -   2.10 Utilities
        -   2.10.1 The Lapsus daemon & KDE applet

Hardware
--------

-   CPU: Intel Core 2 Duo T7200 (2.00GHz, 4MB cache L2, FSB 667MHz)
-   Chipset: Mobile Intel® 945 PM Express Chipset + ICH7M
-   RAM: 2048MB (2 x 1024MB) DDR2 SDRAM 667 Mhz
-   Hard Disk: SATA 160GB 5400 rpm - SATA 120GB 5400 rpm
-   DVD Burner: SUPER MULTI DOUBLE LAYER
-   Display:
    -   TFT 15.4" WXGA (1280x800) ColorShine TFT-LCD, Asus Splendid
        Video Intelligent Technology
    -   TFT 15.4" WSXGA+ (1680x1050) ColorShine TFT-LCD, Asus Splendid
        Video Intelligent Technology
-   Video: NVIDIA GeForce Go 7700 512MB
-   Audio: Scheda Intel High Definition Audio
-   Wi-Fi: 802.11a/b/g
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
    -   324mm * 284mm * 37.4 mm(W x D x H)
    -   3.1 Kg (8-cell)
-   Pointer: Touch pad

  

Configuration
-------------

> CPU

Works out of the box.

Follow this SpeedStep guide to enable speed-stepping.

> Video

Works with the proprietary Nvidia driver in full display resolution.

TV-Out/DVI currently untested, but the graphics driver finds the
interfaces, so they should be switchable with the nvidia-tools.

VGA-Out is working with nvidia-settings.

Console framebuffer is working in 1024x768 with the vga=0x317 kernel
boot option. With the vesafb-tng patch the native display resolution
should work, too.

Xorg

Follow this guide: NVIDIA

No problems detected.

> Audio

Works out of the box.

Follow the official documentation: ALSA

> Wi-Fi

To enable wireless follow the official guide: Wireless network
configuration

Please note that the Asus G1 needs the ipw3945 driver.

NetworkManager is also a cool option.

> Webcam

See Webcam Setup.

> Bluetooth

Internal bluetooth module is supported. Install bluez and bluez-utils
from the official repositories to get started.

For more information, go to:
https://wiki.archlinux.org/index.php/bluetooth

> Pointer

To enable the pointer follow this guide: Touchpad Synaptics

A really cool utility is gsynaptics (available in the [community] repo).

> Leds & ACPI upgrade

Note: With recent kernels, compiling acpi4asus is no longer necessary.
Skip to editing rc.conf below.

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

  
 You may simply want to display a digital clock with the date in the
asusoled area. To do this :

1.  install asus_oled-clock-svn from the AUR.
2.  add 'asusoled-clock' in the daemons array of your rc.conf

  
 There are also some interesting utilities available to control and
utilize the OLED display over here:
https://bitbucket.org/SysGhost/asus-oled-command-line-utility.git

Function Keys

WiP -- Use Lapsus

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
"https://wiki.archlinux.org/index.php?title=ASUS_G1&oldid=297813"

Category:

-   ASUS

-   This page was last modified on 15 February 2014, at 15:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
