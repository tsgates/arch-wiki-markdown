Dell Latitude D410
==================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page describes the installation of Arch Linux on a Dell Latitude
D410 Laptop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specifications                                                     |
|     -   1.1 Working                                                      |
|     -   1.2 Unknown                                                      |
|     -   1.3 Not working                                                  |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 /etc/rc.conf                                                 |
|     -   2.2 ACPI                                                         |
|     -   2.3 Xorg                                                         |
|         -   2.3.1 Touchpad & Mouse                                       |
|                                                                          |
|     -   2.4 Sound                                                        |
|     -   2.5 Network                                                      |
|                                                                          |
| -   3 Links                                                              |
+--------------------------------------------------------------------------+

Specifications
--------------

From Dell specs:

-   Intel Pentium M processor : 730 (1.6 GHz), 750 (1.86 GHz) & 760 (2.0
    GHz)
-   up to 2GB DDR2 RAM, 400-533MHz
-   12.1" XGA screen (1024x768)
-   Intel Graphics Media Accelerator 900 (up to 128MB shared memory)
-   Hard drive (SATA) 30GB, 40GB, 60GB, 80GB
-   Pointing : Touch Pad - PS/2 Compatible; Track Stick - PS/2
    Compatible
-   Audio : AC97 (Soft Audio); Integrated Speaker
-   Wired networking : 56K3 v.92 Internal Modem; 10/100/1000 Gigabit4
    Ethernet LAN
-   Wireless - WLAN : Intel® Pro Wireless 2200 802.11b/g and Intel® Pro
    Wireless 2915 802.11a/b/g
-   Bluetooth : Dell Wireless 350 Bluetooth Internal Card (optional)
-   Extension slot : PC Card, One Type I or Type II
-   I/O Ports : Video, Audio (HP & Mic), USB 2.0 x 3, IrDA, Modem
    (RJ-11), Ethernet (RJ-45), Docking Connector
-   Dimensions : 31.9mm/1.25" (h) x 278mm/11.0" (w) x 238mm/9.4" (d)
-   Weight : Starting at 3.83lbs/1.74kg

Note: [ Plut0nium ] On my D410, I replaced the original Intel
PRO/Wireless 2200 mini-PCI card by an Atheros-Based Wireless mini-PCI
card. Because I am more comfortable with Madwifi driver. This leads the
Wifi LED on the laptop to stay always ON, even if I push the Fn+F2 keys.
However in one position, the card seems only able to receive wifi
packets, but not sending them, thus making the computer unable to
connect to Wireless networks (passive monitoring works though). Pushing
1 time the Fn+F2 keys corrects this. I must then rely on the Bluetooth
LED, which is activated by the same key combination to know the status
of the WiFi card.

> Working

-   Everything seems working (except listed under)

> Unknown

(not tested yet)

-   Modem

> Not working

-   Nothing right now, except the WiFi status LED but that's because I
    replaced the WiFi mini-PCI card (see note above)

Configuration
-------------

> /etc/rc.conf

As I did not have the time to recompile my own kernel, I am still using
the standard Arch kernel and enabled modules autoloading in rc.conf. I
blacklisted the tsdev module, because it was messing my X configuration
and as the D410 does not have any touchscreen it was not useful to load
it (it was however loaded automaticaly).

    # -----------------------------------------------------------------------
    # HARDWARE
    # -----------------------------------------------------------------------
    #
    # Scan hardware and load required modules at bootup
    MOD_AUTOLOAD="yes"
    # Module Blacklist - modules in this list will never be loaded by udev
    MOD_BLACKLIST=(tsdev)
    #
    # Modules to load at boot-up (in this order)
    #   - prefix a module with a ! to blacklist it
    #
    MODULES=()
    # Scan for LVM volume groups at startup, required if you use LVM
    USELVM="no"

> ACPI

> Xorg

Touchpad & Mouse

The D410 has a touchpad and a trackpoint, and I also often use an
external USB mouse. I got them all to work under X, with side-scrolling
on the touchpad and the scrollwheel for my external USB mouse.

The touchpad and trackpoint are recognised as different pointing
devices, respectively ALPS Glidepoint, and "classical" PS/2 device. It
allows the use of the Xorg synaptics driver for the touchpad (although
it is called synaptics, it also works with ALPS devices).

I use the classical mouse driver for everything else.

(X.org config to come)

> Sound

Working with ALSA, using intel8x0 driver.

> Network

I am currently using networkmanager with my laptop. I am not fully
satisfied, but it offers a simple gui-based way for managing network
connections as I move quite often.

Links
-----

-   TuxMobil: Linux Laptop & Notebook Installation Guides and especially
    the DELL page
-   Gentoo Wiki page about the DELL Latitude D410

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_D410&oldid=196574"

Category:

-   Dell
