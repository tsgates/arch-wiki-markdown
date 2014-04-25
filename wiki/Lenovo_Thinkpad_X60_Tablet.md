Lenovo Thinkpad X60 Tablet
==========================

Related articles

-   IBM ThinkPad X60
-   IBM ThinkPad X60s

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: numerous         
                           references to            
                           initscripts and HAL      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Installation instructions for the Lenovo Thinkpad X60 Tablet.

Contents
--------

-   1 Pre installation notes
-   2 Accessing the recovery partition with GRUB
-   3 Configuration
    -   3.1 Sound
    -   3.2 Ethernet
    -   3.3 WiFi
    -   3.4 Firewire
    -   3.5 USB
    -   3.6 Bluetooth
    -   3.7 SD-card reader
    -   3.8 Graphics card
    -   3.9 Stylus
    -   3.10 Automatic rotation
    -   3.11 Trackpoint
    -   3.12 ThinkFinger
    -   3.13 Backlight
-   4 Hardware info
    -   4.1 Specifications
    -   4.2 lspci
    -   4.3 lsusb

Pre installation notes
======================

Remember to back up the restore partition if you plan to restore to
Microsoft Windows, or even leave it.

As the laptop does not have a built-in CD/DVD drive you might have to
use a USB stick or similar device. Look in this how to install from USB
stick for more information.

Follow the Installation guide

Accessing the recovery partition with GRUB
==========================================

Edit your /boot/grub/menu.lst file and add the following:

    # booting "Rescue and Recovery" partition from Lenovo
    title Thinkpad Maintenance
    unhide (hd0,0)
    rootnoverify (hd0,0)
    chainloader +1

Configuration
=============

Sound
-----

Sound works out of the box. All modules are loaded upon boot.

Refer to following guides to set it up:

OSS

ALSA

PulseAudio

There might be others. Personally I use ALSA and Pulseaudio, but some
say that OSS has better sound, try for yourself.

Ethernet
--------

Works out of the box.

Modules used:

-   e1000e

WiFi
----

Works out of the box, no extra firmware needs to be installed.

    # pacman -S wireless_tools

Then please refer to Wireless management

Firewire
--------

Works out of the box.

USB
---

Works out of the box.

Following modules are used:

-   uhci_hcd
-   ehci_hcd
-   usbhid

Bluetooth
---------

Works out of the box.

Following modules are used:

-   bluetooth
-   btusb
-   l2cap
-   rfcomm
-   hci_usb
-   ehci-hcd
-   uhci-hcd

SD-card reader
--------------

Works out of the box.

Following modules are used:

-   usb-storage
-   sdhci
-   sdhci_pci

Graphics card
-------------

Works install xf86-video-intel

    pacman -S xf86-video-intel

Configure xorg with:

    X -configure

You can get my Xorg.conf here Lenovo Thinkpad X60 Tablet SXGA+ xorg.conf

Stylus
------

You can get the stylus to work by installing linuxwacom. Find the latest
in AUR

Add the following sections to your xorg.conf to make it work:

    Section "ServerLayout"
    ...
        InputDevice    "Cursor" "SendCoreEvents"
        InputDevice    "Stylus" "SendCoreEvents"
        InputDevice    "Eraser" "SendCoreEvents"
    ...
    EndSection

    Section "InputDevice"
        Identifier  "Cursor"
        Driver      "wacom"
        Option      "Device" "/dev/ttyS0"
        Option      "Type" "cursor"
        Option      "ForceDevice" "ISDV4"
        Option      "KeepShape" "on"
        Option      "Mode" "Absolute"
        Option      "BottomY" "18432"
        Option      "BottomX" "24576"
    EndSection

    Section "InputDevice"
        Identifier  "Stylus"
        Driver      "wacom"
        Option      "Device" "/dev/ttyS0"
        Option      "Type" "stylus"
        Option      "ForceDevice" "ISDV4"
        Option      "KeepShape" "on"
        Option      "TPCButton" "off"
        Option      "BottomY" "18432"
        Option      "BottomX" "24576"
        Option      "Mode" "Absolute"
    EndSection

    Section "InputDevice"
        Identifier  "Eraser"
        Driver      "wacom"
        Option      "Device" "/dev/ttyS0"
        Option      "Type" "eraser"
        Option      "ForceDevice" "ISDV4"
        Option      "KeepShape" "on"
        Option      "BottomY" "18432"
        Option      "BottomX" "24576"
    EndSection

Also add the following if X -configure does not do it:

    Section "Monitor"
        DisplaySize     245 18
    ...
    EndSection

Automatic rotation
------------------

Refer to Acpi Hotkeys on how to edit handler.sh.

I've written a set of small scripts to help rotating the screen if the
screen is swiveled down, up and when the rotate button is pressed.

Automatic rotation needs acpi daemon in order to work. Install it:

    pacman -S acpid

Now start the daemon and put it in your /etc/rc.conf under daemons.

    /etc/rc.d/acpid start

Now you should be able to grab events with acpi_listen. My tablet
creates the following events when swivelling it down:

    ibm/hotkey HKEY 00000080 00005009

When swiveling up:

    ibm/hotkey HKEY 00000080 0000500a

Now we can edit our /etc/acpi/handler.sh to grab these events when they
occur. Add the following under case "$1" somewhere:

    ibm/hotkey)
                    case "$2" in
                            HKEY)
                                    case "$4" in
                                            00005009)
                                                    #Swiveling down
                                                    /bin/sh /etc/acpi/actions/swivel-down
                                            ;;
                                            0000500a)
                                                    #Swiveling up
                                                    /bin/sh /etc/acpi/actions/swivel-up
                                            ;;
                                    esac
                                    ;;
                    esac
                    ;;

If you're using HAL for configuring your Xorg you'll need to get the
device names used by xsetwacom. If you're using the xorg.conf from above
you can leave the device names as they are.

    xsetwacom --list dev

Will give you something like this:

    PnP Device (WACf008) eraser ERASER    
    PnP Device (WACf008) touch TOUCH     
    PnP Device (WACf008) STYLUS

You'll just need to cut off the all caps identifier at the end. So the
device name for the eraser in the example above would be:

    PnP Device (WACf008) eraser

Now create the files specified in handler.sh.

/etc/acpi/actions/swivel-down:

    #!/bin/bash
    /usr/bin/xrandr -o inverted
    xsetwacom set "Stylus" Rotate half
    xsetwacom set "Cursor" Rotate half
    xsetwacom set "Eraser" Rotate half

/etc/acpi/actions/swivel-up:

    #!/bin/bash
    /usr/bin/xrandr -o normal
    xsetwacom set "Stylus" Rotate none
    xsetwacom set "Cursor" Rotate none
    xsetwacom set "Eraser" Rotate none

Make them executable:

    chmod +x /etc/acpi/actions/swivel*

Now we only need to set up the rotate button, which can be done by
finding out what X event it creates when it is pressed. You can use xev
to find out:

    xev | grep keycode

Now press the rotate button a couple of times and it should give you a
keycode. The one for mine was 199.

    state 0x0, keycode 199 (keysym 0x0, NoSymbol), same_screen YES

Create a file in your home directory called .Xmodmap, this file should
contain:

    keycode 199 = F19

Before we go any further we have to put the following rotate script
somewhere, it could be in your home directory, or maybe in
/usr/local/bin/:

    #!/bin/bash
    # This is a script that toggles rotation of the screen through xrandr,
    # and also toggles rotation of the stylus, eraser and cursor through xsetwacom

    # Check orientation
    orientation=`xrandr --verbose -q | grep LVDS | awk '{print $5}'`
    # Rotate the screen and stylus, eraser and cursor, according to your preferences.
    if [ "$orientation" = "normal" ]; then
    	/usr/bin/xrandr -o right
    	xsetwacom set "Stylus" Rotate cw
    	xsetwacom set "Cursor" Rotate cw
    	xsetwacom set "Eraser" Rotate cw
    elif [ "$orientation" = "inverted" ]; then
    	/usr/bin/xrandr -o left
    	xsetwacom set "Stylus" Rotate ccw
    	xsetwacom set "Cursor" Rotate ccw
    	xsetwacom set "Eraser" Rotate ccw
    elif [ "$orientation" = "right" ]; then
    	/usr/bin/xrandr -o inverted
    	xsetwacom set "Stylus" Rotate half
    	xsetwacom set "Cursor" Rotate half
    	xsetwacom set "Eraser" Rotate half
    elif [ "$orientation" = "left" ]; then
    	/usr/bin/xrandr -o normal
    	xsetwacom set "Stylus" Rotate none
    	xsetwacom set "Cursor" Rotate none
    	xsetwacom set "Eraser" Rotate none
    fi

Make the file executable with chmod +x and create a .xbindkeysrc file in
your home directory, with the following content:

    	"/path/to/rotatescript"
    	F19

Run:

    xmodmap ~/.Xmodmap
    xbindkeys
    /etc/rc.d/acpid restart

Now rotate button and when you swivel the screen down and up it should
rotate.

Note:You have to run:

    xmodmap ~/.Xmodmap
    xbindkeys

Every time you start Xorg.

You might also want to take a look at this rotate script written by Luke

Trackpoint
----------

Works, if you want to scroll while holding the middle mouse button down
you can add the following to an .fdi file:

/etc/hal/fdi/policy/11-trackpoint-mw.fdi:

    <match key="info.product" contains="TrackPoint">
     <merge key="input.x11_options.EmulateWheel" type="string">true</merge>
     <merge key="input.x11_options.EmulateWheelButton" type="string">2</merge>
     <merge key="input.x11_options.ZAxisMapping" type="string">4 5</merge>
     <merge key="input.x11_options.Emulate3Buttons" type="string">true</merge>
    </match

What it does is that it sets emulates wheel on button two, which is
middle button and maps in what directions it will emulate the scroll
wheel, it will at the same time emulate 3 mouse buttons.

You can read more about the new Xorg input hotplugging here

ThinkFinger
-----------

Works, read ThinkFinger for reference and examples.

Backlight
---------

To make backlight buttons turn the backlight turn up and down you can do
the following.

First edit /etc/modprobe.d/modprobe.conf to make the thinkpad_acpi
module load with some special options:

/etc/modprobe.d/modprobe.conf:

    options thinkpad_acpi brightness_enable=1 hotkey=enable,0xffffff

Restart acpid and grab the events they key combinations make with
acpi_listen:

    /etc/rc.d/acpid restart
    acpi_listen

The backlight down button on my machine creates:

    ibm/hotkey HKEY 00000080 00001010

backlight up button creates:

    ibm/hotkey HKEY 00000080 00001011

Edit /etc/acpi/handler.sh:

    ibm/hotkey)
                    case "$2" in
                            HKEY)
                                    case "$4" in
                                            00001010)
                                                    # backlight down
                                                    # Check current state
                                                    typeset -i state=`cat /sys/class/backlight/thinkpad_screen/brightness`
                                                    # Subtract one from the current state and echo it to the file
                                                    down=$((state-=1))
                                                    echo "$down" > /sys/class/backlight/thinkpad_screen/brightness
                                            ;;
                                            00001011)
                                                    # backlight up
                                                    # Check current state
                                                    typeset -i state=`cat /sys/class/backlight/thinkpad_screen/brightness`
                                                    # Add one to the current state and echo it to the file
                                                    state+=1
                                                    echo "$state" > /sys/class/backlight/thinkpad_screen/brightness
                                            ;;

Restart acpid:

    /etc/rc.d/acpid restart

Hardware info
=============

Specifications
--------------

Specifications can be found here on ThinkWiki

lspci
-----

    00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
    00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
    00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
    00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
    00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
    00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
    00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
    00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
    00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
    00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
    00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
    00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
    00:1f.2 SATA controller: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA AHCI Controller (rev 02)
    00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
    02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
    03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
    15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b4)
    15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 09)
    15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 18)

lsusb
-----

    Bus 005 Device 003: ID 0a5c:2110 Broadcom Corp. 
    Bus 005 Device 002: ID 0483:2016 SGS Thomson Microelectronics Fingerprint Reader
    Bus 005 Device 001: ID 1d6b:0001  
    Bus 004 Device 001: ID 1d6b:0001  
    Bus 003 Device 001: ID 1d6b:0001  
    Bus 002 Device 001: ID 1d6b:0001  
    Bus 001 Device 001: ID 1d6b:0002

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Thinkpad_X60_Tablet&oldid=303182"

Category:

-   Lenovo

-   This page was last modified on 4 March 2014, at 22:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
