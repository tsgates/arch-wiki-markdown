ASUS UL30A
==========

Contents
--------

-   1 About the laptop
-   2 Compatibility
    -   2.1 Webcam Flipping
-   3 Powersaving
-   4 Fun
-   5 lspci
-   6 lsusb

About the laptop
----------------

-   13.3" LED Screen 1366 x 768.
-   4GB DDR3
-   1.3Ghz Dual core.
-   320GB HDD.
-   8-cell battery 84wh.
-   HDMI

Compatibility
-------------

Everything in this laptop is Linux compatible, therefore you will not
have any issues installing Linux. I recommend Xbindkeys for sound
buttons. Every other fn-X button works. Suspend, wifi, brightness works.
The video out button does not work, use xrandr instead. HDMI works as
well. The battery is properly read. Use laptop-mode-tools for power
saving. You can run xorg without config file. xf86-video-intel is the
package you need. I could not run x with vesa on this chipset, it just
froze completely. HDMI and VGA out works, but not via fn-F8. You can use
lxrandr, GUI for xrandr for setting up video out. You can make fn-f8
work by configuring Acpid.

> Webcam Flipping

Written by MessedUpHare

Some models supposedly have their webcams mounted upside down (not
confirmed) causing the image to display upside down, this at least
affects Skype and Google Hangout.

Google Hangout in Chromium on x86_64

    $ LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so /opt/google/talkplugin/GoogleTalkPlugin & chromium

the above solution requires lib32-v4l-utils from multilib, I have also
installed google-talkplugin from AUR

Powersaving
-----------

See power saving.

Written by lswest (please contact me via my forum profile if you have
any questions or problems with this description).

If you can't get laptop-mode-tools adjusting power the way you'd like
(I've had many problems with it), you can get the same functionality
using pm-powersave, acpi, and acpi-support. Install these packages
(acpi-support can be found in the AUR), and rename the file
/etc/acpi/sleep.sh to sleep.sh.bak, or move it do a different directory.
If you leave it, I've found that my laptop tends to suspend, resume, and
suspend, then get stuck. If you find suspend doesn't work without it,
feel free to add that information to this section. Also, add acpi and
acpi-support to the DAEMONS array, and asus-laptop to your MODULES array
of your rc.conf.

As for custom powersaving scripts, you just need to create a bash script
within the /etc/pm/power.d/ directory, using a bash case statement with
true for on battery, and false for on AC, and then your settings. Make
sure they're executable. Below I have a list of files (and their
contents) located in my /etc/pm/power.d/ directory, which should cover
all basic functionality of laptop-mode-tools (I get between 10 and 12
hours using these scripts depending on my usage).

Note: You will need to double-check any file paths to ensure they're
correct for your system before using these scripts. They were written
for a German Asus UL30A, with a slightly different set of hardware from
a UL30Vt.

> Bluetooth

    #!/bin/sh
    case "$1" in
         true)
             hciconfig hci0 down;
             /etc/rc.d/bluetooth stop;
             rmmod hci_usb;
         ;;
         false)
               modprobe hci_usb;
               hciconfig hci0 up;
               /etc/rc.d/bluetooth start;
         ;;
    esac
    exit 0

> Brightness

    #!/bin/sh
    case "$1" in
        true)
            echo 2 >> /sys/devices/platform/asus_laptop/backlight/asus_laptop/brightness
        ;;
        false)
            echo 15 >> /sys/devices/platform/asus_laptop/backlight/asus_laptop/brightness
        ;;
    esac
    exit 0

Add acpi_backlight=vendor into your bootloader in kernel parameters.

> Ethernet

    #!/bin/bash
    case "$1" in
          true)
               ip link set dev eth0 down
          ;;
          false)
               ip link set dev eth0 up
          ;;
    esac
    exit 0

You can find out a bit more about pm-powersave in the Pm-utils section.

Fun
---

This computer has an extra power button on the left, you can configure
this with Xbindkeys and run something useful. Like I use it for
switching songs. The extra button is originally for powering up with
Asus Express gate.

lspci
-----

    [brain@Brain_NoteBook ~]$ lspci
    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
    00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
    00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03)
    00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation 82801IBM/IEM (ICH9M/ICH9M-E) 4 port SATA Controller [AHCI mode] (rev 03)
    02:00.0 Network controller: Intel Corporation WiMAX/WiFi Link 5150
    03:00.0 Ethernet controller: Atheros Communications Inc. AR8132 Fast Ethernet (rev c0)

lsusb
-----

    [brain@Brain_NoteBook ~]$ lsusb
    Bus 001 Device 003: ID 064e:a136 Suyin Corp. Asus Integrated Webcam [CN031B]
    Bus 001 Device 004: ID 8086:0180 Intel Corp. WiMAX Connection 2400m
    Bus 002 Device 002: ID 0b05:1751 ASUSTek Computer, Inc. BT-253 Bluetooth Adapter
    Bus 005 Device 002: ID 0458:00b5 KYE Systems Corp. (Mouse Systems) 
    Bus 008 Device 003: ID 058f:6366 Alcor Micro Corp. Multi Flash Reader
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 008 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_UL30A&oldid=253549"

Category:

-   ASUS

-   This page was last modified on 10 April 2013, at 06:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
