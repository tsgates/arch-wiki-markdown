ASUS Eee PC 1001HA
==================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General Information                                                |
| -   2 Installing the Base System                                         |
| -   3 Configuring Xorg for Intel Graphics and Synaptics Touchpad         |
| -   4 Keyboard and Hotkeys                                               |
| -   5 Boot Booster                                                       |
| -   6 Control the VGA Output                                             |
+--------------------------------------------------------------------------+

General Information
-------------------

The ASUS Eee PC 1001HA is a netbook personal computer.

Hardware:

-   CPU: Intel Atom N270 @ 1.60 GHz
-   RAM: 1 GB DDR2 533 MHz SODIMM, one slot, can be upgraded to maximum
    2 GB
-   Graphics: Intel GMA950, integrated in the northbridge
-   Sound: Intel HD Audio, two integrated speakers, microphone,
    headphones out, microphone in
-   Chipset: Intel 945GSE northbridge, ICH7 southbridge
-   Hard disk: 160 GB, Seagate ST9160301AS, 5400 rpm
-   Display: 10.1", LED backlight, resolution: 1024x600
-   Wired network: Atheros AR8132 10/100 Fast Ethernet
-   Wireless: Ralink RT3090 802.11n, mini PCIe card

Since the processor doesn't support 64-bit software, you can install the
32-bit version of Arch Linux.

When you turn on the computer, to enter the BIOS settings menu, press
the F2 key repeatedly until the BIOS menu appears. To show the boot menu
so you may start the system from an external CD/DVD drive or an USB
flash drive, press the Escape key repeatedly until this menu appears.

Installing the Base System
--------------------------

Please refer to the Beginners' Guide for a detailed step-by-step guide
for installing Arch to your Eee PC. If you are more technically
inclined, refer to the short Installation Guide.

Configuring Xorg for Intel Graphics and Synaptics Touchpad
----------------------------------------------------------

The 1001HA has an Intel GMA950 integrated graphics located in the
northbridge and cooled by the netbook's fan. You use the Synaptics
touchpad to move the pointer on the screen.

If you plan to use a desktop environment or a window manager, you need
to install Xorg and the Intel and Synaptics drivers. Do this by
installing these packages as the root user:

    # pacman -S xorg-xserver xf86-video-intel xf86-input-evdev xf86-input-synaptics

The touchpad can be configured for two finger vertical scrolling and
more, refer to Touchpad Synaptics.

By default, you won't need a xorg.conf file, everything works
automatically. For configuring the Intel driver and acceleration
methods, refer to Intel.

If you want to use kernel modesetting, depending on your boot loader
(Grub 1/2, Syslinux), edit its configuration file and add
"i915.modeset=1" to the end of the appropriate kernel line. Then, add
"i915" to the MODULES="..." (first) section of the file
/etc/mkinitcpio.conf. Execute this as the root user:

    mkinitcpio -p linux

When you restart the computer, kernel modesetting will be enabled and
work properly.

Keyboard and Hotkeys
--------------------

To set the keyboard layouts and configure the keyboard, use the desktop
environment's control panel, or in case of an window manager, add an
option to its start-up configuration file, such as this:

    setxkbmap -layout us,rs -variant ,latin -option grp:alt_shift_toggle &

Make sure you have installed the xorg-setxkbmap package so this command
works properly.

Hotkeys allow the user to change volume, brightness, put the netbook to
sleep etc. They are activated by holding the Fn key and then pressing
one of the function keys (F1-F12) and Space.

By default, these keys work:

-   Fn F1: Suspend-to-RAM (puts the netbook to sleep, low power mode)
-   Fn F2: turns on/off the wireless card
-   Fn F5: lowers the backlight intensity
-   Fn F6: rises the backlight intensity

To configure the other keys, refer to the desktop environment's control
panel, or in case you use a window manager such as Openbox, edit its
configuration file. Please refer to Extra Keyboard Keys.

Boot Booster
------------

The Boot Booster allows your laptop to start instantly by skipping the
POST startup test and caching BIOS settings on the hard disk. If you
consider using this feature, create a primary partition at the end of
the hard disk that is 50 MB in size. It must be a primary partition and
it must be the last on the disk. Use a tool such as GParted or fdisk to
do this and set the partition type to 0xef (EFI FAT Partition) - use
fdisk for this (expert mode - be careful!).

First deactivate this option in the BIOS Boot settings, then turn off
your computer properly. Turn on the computer, enable the Boot Booster in
BIOS, turn off your computer properly and the Boot Booster will work
afterwards, when you turn on the computer next time.

Control the VGA Output
----------------------

You can use graphical tools such as lxrandr, arandr or a command line
tools, such as xrandr.

For example, to turn off the LCD screen and turn on the external screen:

    xrandr --output LVDS --off --output VGA --auto

To expand the desktop so the LCD screen is the left one and the external
screen is the right one:

    xrandr --output VGA1 --right-of LVDS1 --auto

To switch back to the netbook's LCD screen and turn the VGA output off:

    xrandr --output LVDS --auto --output VGA --off

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1001HA&oldid=221055"

Category:

-   ASUS
