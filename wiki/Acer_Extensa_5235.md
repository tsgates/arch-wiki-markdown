Acer Extensa 5235
=================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware                                                           |
|     -   1.1 lspci output                                                 |
|                                                                          |
| -   2 Kernel                                                             |
| -   3 Graphics                                                           |
| -   4 Touchpad                                                           |
| -   5 Card Reader                                                        |
| -   6 Sound                                                              |
| -   7 Networking                                                         |
|     -   7.1 LAN                                                          |
|     -   7.2 WLAN                                                         |
|                                                                          |
| -   8 Suspend to RAM                                                     |
| -   9 External VGA                                                       |
| -   10 Controlling Screen Brightness                                     |
| -   11 Controlling the fan                                               |
+--------------------------------------------------------------------------+

Hardware
========

-   Processor: Intel® Celeron™ M 900 (2.2GHz, 1MB cache)
-   RAM: 1GB DDR3
-   Display: 15.4” WXGA widescreen TFT LCD display 1366 x 768
-   Graphics: Intel GM45
-   HDD: 160GB SATA 5400RPM hard disk drive,
-   Card Reader: 5-in-1 for MMC, SD, MS, MS Pro, xD
-   DVD: DVD-SuperMulti (Double Layer)
-   Battery: Lithium Ion 6-cell
-   LAN/WLAN: Atheros Chipset
-   Sound: Intel/Conexant

3x USB2.0, 1x VGA, Audio Headphone, Line In/Mic

lspci output
------------

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
    00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    07:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
    09:00.0 Ethernet controller: Atheros Communications Device 1063 (rev c0)

Kernel
======

The default i686 kernel runs fine. x86_64 was not tested.

Update: Due to a change in the ACPI code, version 2.6.34.2 or later can
crash upon boot. The LTS-Kernel (currently 2.6.32) works fine; after
installation, you can still upgrade to 2.6.34.1; the package is
available from the Arch Rollback Machine (see
Downgrade_packages#Finding_Your_Older_Version ). This issue has been
reported to the linux-acpi developers, so hopefully it will get fixed.

Graphics
========

Works fine with xf86-video-intel

    # pacman -S xf86-video-intel

Only problem is adjusting the screen brightness. See below for further
instructions.

Touchpad
========

Works using the synaptics driver

    # pacman -S synaptics

Can be configured in xorg.conf or through synclient. The hardware
apparently only supports one-finger operations though, so
two-finger-scrolling/tapping will not work.

Card Reader
===========

Works fine, but only tested with SD cards.

Sound
=====

Works out of the box, using snd-hda-intel and snd_hda_codec_conexant. No
special options necessary.

Networking
==========

LAN
---

Works out of the box.

WLAN
----

Works out of the box, using ath9k module.

Suspend to RAM
==============

Works without problems using pm-utils

    # pacman -S pm-utils
    # pm-suspend 

Use acpid or some power manager to enable on lid-closing or similar.
Sleep button has no effect, though. Does not seem to emit an ACPI
signal, but is detected by Xorg as XF86Sleep.

External VGA
============

Works without problems, can be accessed e.g. using xrandr.

Controlling Screen Brightness
=============================

The only real problem when using this notebook. It seems the new intel
driver with mandatory kernel modesetting does not natively support
adjusting screen brightness yet. 'xrandr --props' is showing a backlight
property, but changing it has no effect; same goes for xbacklight or
directly writing into /sys. Currently, the only solution seems to be
using setpci:

    # setpci -s 00:02.0 F4.B=XX

with XX ranging from 00 to ff. Note that 00 will completely turn off
your backlight!

You can use the backlight-setting script from
Samsung_N140#Backlight_Brightness. You'll have to adjust the setpci
command to use the above address.

The brightness function keys are detected by Xorg as
XF86MonBrightnessUp/Down, so you can bind them in your window manager
(you need root permissions to use setpci, so you'll have to use sudo).
Alternatively, if you also want to change brightness in the console: the
keys also emit ACPI signals, so you can insert the following in
/etc/acpi/handler.sh:

    video)
           if [ "$2" = "DD02" ]; then
           	case "$3" in
           		00000087) /usr/local/sbin/backlight.sh down > /dev/null ;;
           		00000086) /usr/local/sbin/backlight.sh up > /dev/null ;;
           	esac
           fi
      ;;

This assumes that you saved the backlight-setting script in
/usr/local/sbin/backlight.sh. This also has the advantage that you do
not need sudo for this to work.

Controlling the fan
===================

Another annoyance is the poor fan control of this notebook. The fan is
not accessible using PWM, so fancontrol or similar will not work.
Instead, you can change the fan speed by writing in some EC register.
This is a bit dangerous though, since this can also depend on the BIOS
version. I think it's well worth the effort if you'd like to have a
quiet notebook; see http://www.randomsample.de/dru5/node/85 for details
and a script.

You'll need to setup lm-sensors for this, which is working fine using
the coretemp module.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Extensa_5235&oldid=196487"

Category:

-   Acer
