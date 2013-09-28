Toshiba Satellite L300
======================

This document applies in particular to Arch Linux on a Toshiba Satellite
L300-OG1. It also applies to the entire L300 series on any modern Linux
distribution (which uses at least kernel 2.6.36), and dependent upon
what BIOS your system has.

If your laptop has a BIOS version older than v2.20 you probably will
have fan control problems and the "Fn" key and PC speaker probably will
not work. See below for a method to upgrade your BIOS.

Contact the author of this wiki with any problems or suggestions
(lagagnon at gmail.com) (English or Spanish).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specification                                                      |
| -   2 What Works Without Any Configuration?                              |
| -   3 What Works With Minimal Configuration?                             |
| -   4 What Does Not Work?                                                |
| -   5 Not Tested                                                         |
| -   6 Configurations                                                     |
| -   7 Upgrading your BIOS                                                |
+--------------------------------------------------------------------------+

Specification
-------------

This laptop has a dual core Pentium T3400 CPU, 2GB RAM, 15.4" WXGA
glossy LCD screen 1280x800, 250GB hard drive, DVD+ RW optical drive,
PCMCIA, wireless, ethernet, modem, SD card slot, 3 USB ports, VGA out
port, webcam, trackpad. Chip details from "lspci" are:

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
    00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express PCI Express Root Port (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
    00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
    03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)

What Works Without Any Configuration?
-------------------------------------

Ethernet, Wireless, Microphone, Synaptic TouchPad, WebCam, USB ports,
Card Reader, DVD optical drive, external video port (if booted with
video device attached), CPU frequency scaling.

What Works With Minimal Configuration?
--------------------------------------

Suspend, Hibernate, Fan speed, Video tweaks, Audio, Function Keys (see
below for configuring these)

What Does Not Work?
-------------------

The Fn key and fan control after suspend/hibernate if your BIOS version
is less than version 2.20. If you update your BIOS you will not have
these problems.

Not Tested
----------

PCMCIA, Modem.

Configurations
--------------

Video: Follow the Intel wiki entry for Intel video. Edit your
/boot/grub/menu.lst kernel boot line. See below. If these suggested
changes to /boot/grub/menu.lst and /etc/X11/xorg.conf are not made you
may not be able to resume from suspend, will get flickering video on
shutdown and other minor video faults, but your screen will generally
work OK. Here is a suggested /etc/X11/xorg.conf file for reference:

    Section "ServerLayout"
            Identifier     "X.org Configured"
            Screen      0  "Screen0" 0 0
            InputDevice    "Mouse0" "CorePointer"
            InputDevice    "Keyboard0" "CoreKeyboard"
    EndSection

    Section "Files"
            ModulePath   "/usr/lib/xorg/modules"
            FontPath     "/usr/share/fonts/misc"
            FontPath     "/usr/share/fonts/100dpi:unscaled"
            FontPath     "/usr/share/fonts/75dpi:unscaled"
            FontPath     "/usr/share/fonts/TTF"
            FontPath     "/usr/share/fonts/Type1"
    EndSection

    Section "Module"
            Load  "glx"
            Load  "dri2"
            Load  "dri"
            Load  "extmod"
            Load  "dbe"
    EndSection

    Section "InputDevice"
            Identifier  "Keyboard0"
            Driver      "kbd"
    EndSection

    Section "InputDevice"
            Identifier  "Mouse0"
            Driver      "mouse"
            Option      "Protocol" "auto"
            Option      "Device" "/dev/input/mice"
            Option      "ZAxisMapping" "4 5 6 7"
    EndSection

    Section "Monitor"
            Identifier   "Monitor0"
            VendorName   "Monitor Vendor"
            ModelName    "Monitor Model"
    EndSection

    Section "Device"
            Option      "DRI"                    "True"
            Option      "NoDDC"                  "True"
            #Option      "XAANoOffscreenPixmaps"  "True"
            Option      "EnablePageFlip"         "True"
            Option      "RenderAccel"            "True"
            Option      "AccelMethod"            "UXA"
            Option      "Tiling"                  "False"
            Identifier  "Card0"
            Driver      "intel"
            VendorName  "Intel Corporation"
            BoardName   "Mobile 4 Series Chipset Integrated Graphics Controller"
            BusID       "PCI:0:2:0"
    EndSection
    Section "Extensions"
       Option "Composite" "Enable"
    EndSection
    Section "Screen"
            Identifier "Screen0"
            Device     "Card0"
            Monitor    "Monitor0"
            SubSection "Display"
                    Viewport   0 0
                    Depth     1
            EndSubSection
            SubSection "Display"
                    Viewport   0 0
                    Depth     4
            EndSubSection
            SubSection "Display"
                    Viewport   0 0
                    Depth     8
            EndSubSection
            SubSection "Display"
                    Viewport   0 0
                    Depth     15
            EndSubSection
            SubSection "Display"
                    Viewport   0 0
                    Depth     16
            EndSubSection
            SubSection "Display"
                    Viewport   0 0
                    Depth     24
            EndSubSection
    EndSection

Warning:GRUB2 The fan will work properly assigning the parameter:

Note:GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_osi=Linux"

in /etc/default/grub.

kernel boot parameters (/boot/grub/menu.lst): Heed the Intel video
changes and boot manager kernel parameters should include:

 kernel /vmlinuz-linux root=/dev/disk/by-uuid/your_UUID_here acpi_osi="Linux" ro i915.modeset=1 resume=/dev/sda3

The important kernel parameters above are: acpi_osi="Linux" (fan will
not function correctly without), resume=/dev/sda3 (this is the swap
partition, without which hibernate will not work) and i915.modeset=1,
necessary for KMS video on the Intel graphics chip.

Suspend/Hibernate: The "pm-suspend" and "pm-hibernate" scripts from the
pm-utils package work but ACPI fan control after any suspend or
hibernate will only function properly with BIOS version 2.20 or higher.

Function Keys: To get the "Fn" key to work one may need to upgrade your
BIOS (see below). With a working Fn key the Num Lock key will function.
However, you will still have to bind the hardware function key
combinations to specific Linux facilities depending on what desktop
environment you use. For instance "Fn+F4" is the "hibernate" facility.
You have to bind the hibernate script that you specifically use to that
key combo. The same goes for screen brightness, suspend, etc. This is
not done automatically in Linux. The old "toshiba_acpi" and "fnfx"
modules do not work with the InsydeH2O BIOS, they only work with
Toshiba-written BIOSes.

For information on how to bind keycodes (e.g. Fn+F4) read Extra Keyboard
Keys. E.G.: bind these following key combinations to their keycodes and
then to the following scripts:

-   Fn+F1 - xscreensaver-command -lock
-   Fn+F2 - sleep 1 && xset dpms force off
-   Fn+F3 - sudo pm-suspend
-   Fn+F4 - sudo pm-hibernate
-   Fn+F6 - xbacklight -dec 80
-   Fn+F7 - xbacklight -inc 80
-   Fn+F9 - (see the "Software Toggle" here): Touchpad Synaptics

Audio: Should just work, but ensure by using "alsamixer", that the
"Front" mixer is set to max, or near max. By default it may be set at
zero. Read restoring alsa settings to find out how to store alsamixer
settings between reboots.

Bluetooth: This laptop does not have in-built Bluetooth, but works just
great with any bluetooth dongle via USB if you follow these Bluetooth
instructions.

Upgrading your BIOS
-------------------

It seems that most of the L300 and L305 series laptops come with the
InsydeH2O BIOS version 1.50. This BIOS is faulty with Linux and results
in a dead Fn key and an improperly controlled fan. It is vital to get
the fan working properly especially if you wish to use suspend and/or
hibernate. The dead Fn key problem however is not a show stopper. The
upgraded BIOS will also mean the PC speaker will start working! Toshiba
Canada has the latest BIOS version (v2.2 at January 2011) here:
http://support.toshiba.ca/support/Download/ln_byModel.asp . Ensure you
get the correct file for your specific model. This file is a
Windows-only executable - it does not contain anything usable under DOS.
Nor can this BIOS be flashed using the Linux "flashrom" application.
There are only two ways to flash the ROM with that file:

1.  Run the file as an executable under a Microsoft Windows environment
    that you are dual booting with Linux, or,
2.  Use the undocumented "brick" repair method (below) proposed by
    Toshiba

As the first method is straightforward it will not be discussed here.
Below is the alternate method outlined for Linux users (Note: you do
this at your own risk - if done improperly you may permanently "brick"
your laptop):

1.  the .exe file is a 7z compressed file. Use the command "7z e
    filename.exe" to extract. You may have to install a 7z package
    first.
2.  the only important file in the extract is the .fd file. Rename that
    file to "BIOS.fd"
3.  copy the BIOS.fd file onto the root directory of a USB flash drive
4.  remove any inserted CD, the power cord, the battery, and the hard
    drive from your laptop
5.  insert the USB flash drive into a USB port on your laptop
6.  simultaneously hold down the "Fn" and "F" keys
7.  plug in the power cord to the laptop while still holding Fn+F
8.  press Power On button of laptop while still holding Fn+F
9.  USB flash drive light should start to flash. You may now release the
    Fn+F keys after a few seconds
10. leave laptop for about 1 minute. The ROM is being flashed. Your
    laptop will eventually turn itself off and it may reboot.
11. you may turn off laptop now if it has rebooted successfully. If it
    just turned itself off then continue...
12. unplug power cord, remove USB flash drive, replace laptop hard drive
    and laptop battery. Replug power cord.
13. reboot laptop and enter the BIOS setup using "F2". You should see
    that it has successfully upgraded your BIOS.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_L300&oldid=218496"

Category:

-   Toshiba
