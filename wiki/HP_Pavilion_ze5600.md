HP Pavilion ze5600
==================

This document applies in particular to ArchLinux on an HP Pavilion
ze5615CA laptop. It also applies to the entire ze5600 series on any
modern Linux distribution that uses kernel 2.6.39 or later. Feel free to
contact the author with problems or suggestions (lagagnon at gmail.com ,
English or Spanish).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specifications                                                     |
| -   2 What Works Without Configuration?                                  |
| -   3 What Requires Configuration?                                       |
| -   4 What Does Not Work?                                                |
| -   5 Not Tested                                                         |
| -   6 Configurations                                                     |
| -   7 Considerations                                                     |
| -   8 BIOS Flashing Concerns                                             |
+--------------------------------------------------------------------------+

Specifications
--------------

The ze5600 has as standard an Intel Celeron 2800MHz CPU, 512MB RAM (of
which 446MB are available due to video chip RAM sharing), 40GB IDE hard
drive, wireless, modem, DVD ROM optical drive, 2 PCMCIA ports, touchpad,
multimedia keys, 15" LCD screen, 3 USB ports, S-video and VGA out ports,
parallel port, PS/2 port, IR sensor. Chip details from lspci:

    00:00.0 Host bridge: ATI Technologies Inc RS200/RS200M AGP Bridge [IGP 340M] (rev 02)
    00:01.0 PCI bridge: ATI Technologies Inc PCI Bridge [IGP 340M]
    00:06.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link Controller Audio Device (rev 02)
    00:07.0 ISA bridge: ALi Corporation M1533/M1535/M1543 PCI to ISA Bridge [Aladdin IV/V/V+]
    00:08.0 Modem: ALi Corporation M5457 AC'97 Modem Controller
    00:09.0 Network controller: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller (rev 02)
    00:0a.0 CardBus bridge: O2 Micro, Inc. OZ601/6912/711E0 CardBus/SmartCardBus Controller
    00:0b.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 50)
    00:0b.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 50)
    00:0b.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 51)
    00:10.0 IDE interface: ALi Corporation M5229 IDE (rev c4)
    00:11.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
    00:12.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
    01:05.0 VGA compatible controller: ATI Technologies Inc Radeon IGP 330M/340M/350M

What Works Without Configuration?
---------------------------------

Ethernet, video, audio, microphone, touchpad, USB ports, optical drive,
external video port (if booted with video device attached), CPU
frequency scaling, screen brightness keys.

What Requires Configuration?
----------------------------

Wireless

What Does Not Work?
-------------------

Three of the upper multimedia keys (2nd, 4th and 5th from left), fn+f12,
wireless off switch at front right of laptop and audio mute switch at
right front side of laptop. The IR port also probably does not work as
it is not detected by "lspci" nor by "lshw".

Not Tested
----------

PCMCIA, Modem, IR Port, S-Video port, parallel port.

Configurations
--------------

Wireless: The older Broadcom wireless chip in this laptop requires the
b43legacy module to function properly. Also, you must specifically
follow the instructions on how to install the firmware - this is
explained here:
https://wiki.archlinux.org/index.php/Broadcom_wireless#b43.2Fb43legacy .
The wireless off hardware switch at right front of laptop does not work
but you can do almost the equivalent with:
sudo iwconfig wlan0 txpower off

Video: The older ATI IGP 330M video chip in this laptop requires the
xf86-video-ati radeon open-source driver. Apparently the latest
"catalyst" drivers from ATI do not work with this chip, but have not
been tested. The radeon driver, however, works well, but runs a bit hot
(see below).

Kernel boot parameters: It might make some difference to your power
consumption if you add the following kernel parameters to the "kernel"
line of your boot manager configuration file (for those using grub this
is /boot/grub/menu.lst):

acpi_enforce_resources=lax pcie_aspm=force

Suspend/Hibernate: The "pm-suspend" and "pm-hibernate" scripts from the
pm-utils package work well but you need to bind keyboard shortcuts (see
Extra Keyboard Keys ) to access these scripts because fn+f12 has no
scancode.

Function Keys: Only two of the upper keyboard silver multimedia keys
have scancodes. For information on how to bind keycodes please read
Extra Keyboard Keys.

CPU Temperature: The Lm sensors package utility "sensors-detect" does
not find any sensor chips. Instead, read the file:

/sys/devices/LNXSYSTM:00/device:13/LNXTHERM:00/thermal_zone/temp

in order to get the CPU temperature. Using ArchLinux with kernel 2.6.39
I find that this laptop runs quite hot. It starts at about 32degC and
then continues to climb to 47deg C, with the fan on past 47degC, even at
idle, with less than 2% CPU activity. Energy saving tools as per Laptop
have been used, but to little avail. The laptop consumes about 25 watts
at idle with the screen on at about mid brightness. It is possible that
some of the heat may be generated by the video chip as the "radeon"
module apparently can run the video chip hotter than necessary. The
author had no success getting energy saving features of this video chip
activated as per
https://wiki.archlinux.org/index.php/Ati#With_KMS_enabled because those
particular systems files are not present, which suggest that this older
ATI chip does not have these features. The author would be interested to
learn if other owners have success in dropping the power usage and
temperature level of this laptop.

Considerations
--------------

The ze5600 is now older hardware. Out of the box it has only 446MB RAM
available. It is suggested that if you wish to use either the Gnome or
KDE desktop environments that you install a further 512MB RAM memory
chip, otherwise you will be using your swap partition and you can
therefore expect sluggishness. The author uses the Fluxbox window
manager so 446MB of RAM is plenty and the ArchLinux system boots from
cold button press to a ready desktop in just 35 seconds, including a
SLiM graphical login page. It shuts down in about 7 seconds and resumes
from suspend in about 2 seconds. Immediately after desktop ready and
with one urxvt terminal open it has used just 47MB, excluding buffers
and cache! The Opera browser launches from cold within 9 seconds. Some
modern laptops running Windows 7 perform much worse than this. Have fun
with it, it is still an incredibly usable laptop with the right
operating system and a lightweight window manager installed.

Also, many owners have commented how annoying all those bright blue
multimedia key LED lights are, being as they are located immediately
beneath the screen. Place black electrical tape over them and then with
a razor knife cut around the tape to form the tape to the grill edges
and reading the screen will be much easier on the eyes.

Any of the upper multimedia keys can be used as an on/off switch and a
resume from suspend/hibernate key. This is useful because the default
on/off button for this laptop is poorly designed and often fails or
requires significant pressure to work properly.

On the laptop base there are 4 L-shaped rubber feet. These often go
astray on older poorly-treated laptops. They are essential for keeping
the laptop cool as they allow free air flow into the fans which suck
from the bottom. You can replace them with an appropriate length of
black mouse cord and contact cement if necessary.

As these are now old laptops it is likely the battery can no longer be
charged to default capacity. Reasonable quality Li-Ion batteries for
this laptop can be purchased from China, including shipping, for about
$USD34 (eBay).

The age of these laptops is approaching 9 years. The CPU heat sink
compound had deteriorated on the author's laptop. Renewing the heat sink
compound (thermal grease) reduced CPU temperature quite significantly
and also reduced the amount of time and the speed at which the fans run.
If you wish to do this to your laptop you need the service manual, a
link to which can be found here:
http://archlinux.me/kcirick/category/systems/ze5600/ .

BIOS Flashing Concerns
----------------------

It is possible that a BIOS upgrade may fix some of the missing key
scancodes and missing hardware control function as listed above. But
probably not ;-). Nonetheless if you wish to upgrade your BIOS this is
how to do it in Linux. The BIOS upgrade download at the HP support
website ( http://tinyurl.com/629wd38 ) is a Windows only executable file
and is designed to create a bootable floppy disk. This is about as
useless as tits on a bull because this laptop has no floppy drive! To
get it to flash under Linux you need to:

1.  Run the Windows BIOS upgrade file as an executable using any
    computer running MS Windows
2.  Rather than inserting a floppy when requested to do so use Windows
    Explorer to navigate to the directory where the extracted image file
    (rom.img) was stored.
3.  Copy the rom.img file to a USB thumb drive and then copy that file
    from the thumb drive into your Linux system
4.  Using "unetbootin" ( http://unetbootin.sourceforge.net ) create a
    bootable FreeDOS USB thumb drive with that image file
5.  Set the BIOS to boot first from a USB device
6.  Boot your laptop from the USB thumb drive
7.  The BIOS flashing software (Phoenix Phlash) should start
    automatically

This procedure should be foolproof yet did not work for the author. The
Phlash software started up but hangs at reading the .bin file. It is
possible that "Phlash" balks at reading data from USB. Someone needs to
test this with an external floppy drive device and see if a BIOS flash
upgrade really does work on this laptop.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Pavilion_ze5600&oldid=196651"

Category:

-   HP
