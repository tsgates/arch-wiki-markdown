Lenovo Thinkpad Helix
=====================

Contents
--------

-   1 Model description
-   2 Installation method
    -   2.1 Legacy-BIOS
    -   2.2 UEFI
-   3 Hardware
    -   3.1 Wacom
    -   3.2 Bluetooth
    -   3.3 Trackpad
    -   3.4 Screen Rotation
    -   3.5 Screen brightness and ambient light sensor

Model description
-----------------

Lenovo ThinkPad Helix, 3rd Generation Core i5/i7 This model comes
without optical drive,. Has UEFI BIOS with BIOS-legacy fallback mode.
Has Windows 8 pre-installed.

Installation method
-------------------

Note:If you'd like to create Windows recovery flash drive, do it before
Arch installation with the help of autorun located at recovery
partition, from your installed Windows system.

Due to the fact that there is no optical drive, you need to install Arch
from USB stick.

> Legacy-BIOS

This procedure is far less involved then UEFI and works perfectly.

In order to turn off UEFI booting you will need to boot into your BIOS
and change the boot mode to Legacy. Afterward, follow the Beginners'
guide for standard installation instructions.

> UEFI

Installation from UEFI bootable USB works with the default bootloader,
so rEFInd is unnecessary. In the BIOS under Startup, set "UEFI/Legacy
Boot" to UEFI only. The default partition table (and Windows
installation) uses MBR. For UEFI, reformat the disk as GPT.

Booting using an efibootmgr entry works well. The warnings about
incompatibility and embedding arguments to do not apply.

Hardware
--------

Almost everything works out of the box except for bluetooth, and the
wacom screen due to the digitizer; the helix uses the Atmel Atmel
maXTouch Digitizer. although this isn't a wacom digitizer it does work
with the wacom drivers, you just have to tell it to.

Make sure to install xf86-input-wacom

> Wacom

Make sure you check that the screen does in fact use the Atmel digitizer
with xinput or lsusb then update the xorg configuration:

    /etc/X11/xorg.conf.d/50-wacom.conf

    Section "InputClass"
        Identifier "Wacom class"
        MatchProduct "Wacom|WACOM|Hanwang|PTK-540WL|Atmel"
        MatchDevicePath "/dev/input/event*"
        Driver "wacom"
    EndSection

    Section "InputClass"
        Identifier "Wacom serial class"
        MatchProduct "Serial Wacom Tablet"
        Driver "wacom"
    EndSection

    Section "InputClass"
        Identifier "Wacom serial class identifiers"
        MatchProduct "WACf|FUJ02e5|FUJ02e7|FUJ02e9"
        Driver "wacom"
    EndSection

    # Waltop tablets
    Section "InputClass"
        Identifier "Waltop class"
        MatchProduct "WALTOP"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "wacom"
    EndSection

    # N-Trig Duosense Electromagnetic Digitizer
    Section "InputClass"
        Identifier "Wacom N-Trig class"
        MatchProduct "HID 1b96:0001|N-Trig Pen"
        MatchDevicePath "/dev/input/event*"
        Driver "wacom"
        Option "Button2" "3"
    EndSection

    Section "InputDevice"
        Driver "wacom"
        Identifier "stylus"
        Option "USB" "on"
        Option "Device" "/dev/input/wacom"
        Option "Type" "stylus"
        Option "Threshold" "5"
        Option        "Mode"         "Relative"
    EndSection

    Section "InputDevice"
        Driver        "wacom"
        Identifier    "eraser"
    Option "USB" "on"
        Option        "Device"       "/dev/input/wacom"  
        Option        "Type"         "eraser"
        Option        "Mode"         "Relative"
        Option        "Threshold"    "5"  
    EndSection

    Section "InputDevice"
        Driver        "wacom"
        Identifier    "cursor"
        Option "USB" "on"
        Option        "Device"       "/dev/input/wacom"  
        Option        "Type"         "cursor"
        Option        "Mode"         "Relative"
    EndSection

Notice that I added Atmel to the MatchProduct entry in the first
section. Also notice the three input devices at the bottom stylus,
eraser, and cursor.

After a reboot if listing wacom devices comes up empty, refer to Wacom
Tablet to manually confugure. Upon rebooting I had a soft link to the
proper input in /dev/input/ if setting up manually make sure your device
option in the above config points to the proper event.

To list wacom devices run:

    xsetwacom --list devices

Once you have that set up and your devices are being listed you should
have full wacom functionality including pressure sensitivty. I tested
this with xournal for note taking, and mypaint/gimp.

> Bluetooth

If there is no HCI device, it's because you need to turn it on first:

    echo 1 > /sys/devices/platform/thinkpad_acpi/bluetooth_enable

but that's a deprecated interface; another way is

    echo 1 > /sys/devices/platform/thinkpad_acpi/rfkill/rfkill0/state

> Trackpad

If you cannot get the synaptics driver to recognize a 3-finger click,
this bug is probably the culprit:
https://bugs.freedesktop.org/show_bug.cgi?id=55365 You can fix it by
commenting out the call to clickpad_guess_clickfingers in the synaptics
driver:

    fixing synaptics manually

    git clone git://anongit.freedesktop.org/xorg/driver/xf86-input-synaptics 
    vi src/synaptics.c
    ./autogen.sh
    make
    sudo make install

It will be installed in /usr/local/lib/xorg/modules/input by default,
though.

> Screen Rotation

The next issue was how to rotate the screen when in tablet modes. Well
there are two ways to do this, the first is Magick Rotate an originally
Ubuntu based auto rotation utility. It does setup automatic rotation
based on events and detaching the screen triggered the rotation.

If you don't want the screen to automatically rotate, you can manually
do it through side buttons or an icon using this script:

    Screen rotation script

    #!/bin/sh

    #Gets the current mode of the screen
    mode="$(xrandr -q --verbose | grep 'connected' | egrep -o '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

    case "$mode" in
      normal)
      #toggle rotate to the left
      xrandr -o left
      xsetwacom set "Atmel Atmel maXTouch Digitizer touch" Rotate ccw
      xsetwacom set "Wacom ISDv4 EC Pen stylus" Rotate ccw
      xsetwacom set "Wacom ISDv4 EC Pen eraser" Rotate ccw
      ;;
      left)
      #toggle rotate to normal
      xrandr -o normal
      xsetwacom set "Atmel Atmel maXTouch Digitizer touch" Rotate none
      xsetwacom set "Wacom ISDv4 EC Pen stylus" Rotate none
      xsetwacom set "Wacom ISDv4 EC Pen eraser" Rotate none
      ;;
    esac

First it grabs the current rotation, and will then toggle the state
between left and normal states. Feel free to add to this for inverted or
right rotations as well.

Using xsetwacom --list devices rename the wacom devices in the script.

> Screen brightness and ambient light sensor

This machine has an ambient light sensor, but it's not showing up as an
ACPI device yet. Calise is one alternative for managing the screen
brightness using the camera to detect ambient light.

You can control the brightness by writing various numbers into
/sys/class/backlight/acpi_video0/brightness, however the firmware seems
to ignore values which are not multiples of 5. It's probably for the
same reason that when using the Fn+F5/F6 keys to decrement/increment the
brightness, it takes some time for the key repeat to hit one of the
values that triggers a brightness change.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Thinkpad_Helix&oldid=298132"

Category:

-   Lenovo

-   This page was last modified on 16 February 2014, at 07:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
