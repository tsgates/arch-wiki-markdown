Lenovo Thinkpad X300
====================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: All information  
                           are already covered by   
                           Beginners' guide,Laptop  
                           and other general pages. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Introduction
    -   1.1 My system
-   2 First boot
    -   2.1 Things that do work
    -   2.2 Things that do not work
    -   2.3 Untested/unknown
-   3 Fixes
    -   3.1 Graphic card
    -   3.2 WiFi
    -   3.3 Sound
    -   3.4 Touchpad
    -   3.5 Backlight
    -   3.6 Webcam
    -   3.7 Bluetooth
    -   3.8 Fingerprint Reader
    -   3.9 Suspend / Hibernate
-   4 Configuration
    -   4.1 Language
    -   4.2 xorg
    -   4.3 FluxBox

Introduction
------------

I bought a new Lenovo Thinkpad X300 with the vision to use just Arch
Linux on it. First thing i did, was to boot up from my Arch CD and
started the setup. The computer was preinstalled with Windows Vista
Business and I didn't plan to keep it.

> My system

    Arch ver:	2.6.27-ARCH

    Model: 	Lenovo X300 6478-14G
    Processor:	Intel® Core™ 2 Duo processor LV7100 (1.2 GHz), 4-MB L2 cache
    Chipset:	Intel Mobile 965GS Express
    Memory:	DDR II SDRAM - 667MHz - PC2-5300 - 2x1GB (4GB maximun)
    Harddrive:	SSD (solid state) 64 GB, 8 mm high, SATA interface
    Screen:	13.3" WXGA+ LED backlight, maximun 1440 x 900 bp
    Graphic:	Intel GS965/GMA X3100, up to 256 MB
    Optical drive:	DVD-RAM/RW drive, 7 mm high
    Bluetooth:	ThinkPad Bluetooth with Enhanced Data Rate (BDC-2) v.2.0+EDR
    Network:	10/100/1000 Mbps
    WiFi:		Intel Wireless WiFi Link 4965AGN 802.11a/g/n
    USB ports:	3
    Webbcam	Yes
    Fingerprintr.	Yes
    Battery:	Lithium Polymer in 3 cell or Lithium Ion in 6 cell configurations (~4 hours)
    Dimensions:	318 (width) x 231 (dept) x 18.6-23.4 (height) mm
    Weight:	1.51 kg

Output of lspci:

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
    00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
    00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
    03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)

First boot
----------

The installation went smoothly and no problems occurred.

> Things that do work

-   LAN (eth0)
-   Graphic card (VESA)
-   DVD-reader
-   USB
-   Keyboard
-   USB-mouse
-   Touchpad + joystick
-   Keyboard-light (Fn+PgUp)
-   Music controls (needs ALSA: Sound)
-   Webcam
-   Fingerprint Reader
-   SpeedStep (powersave, performance, etc. cpu scaling)

> Things that do not work

-   Sound/volume controls = FIXED
-   WiFi (wlan0) = FIXED
-   Backlight/Brightness control (Fn+Home/End) = FIXED

> Untested/unknown

-   Bluetooth
-   Suspend/Hibernate = FIXED
-   Microphone
-   External VGA

Fixes
-----

> Graphic card

Model: Intel Corporation Mobile GM965

Driver used: xf86-video-intel 2.3.2-1

Problem: VESA-driver is used as standard driver for X.

To install driver:

    pacman -S xf86-video-intel

Set driver for X, change the driver from "VESA" to "intel" in
/etc/X11/xorg.conf:

    Driver "intel"

Then reboot your laptop.

Reference: Video Cards

> WiFi

Model: Intel Wireless 4965 AG

Reference: Wireless Setup

> Sound

Model: Intel Corporation 82801H

Problem: Sound doesn't work.

To install driver:

    pacman -S alsa-lib alsa-utils

To disable muting of the output:

    alsamixer			(00 on master and pcm)
    alsactl store			(to create '/etc/asound.state')

After this is done, the volume controls (volume up/down/mute) also
works!

Reference: ALSA

> Touchpad

Model: AlpsPS/2 ALPS DualPoint TouchPad

Driver used: synaptics 0.14.6.99-2 / xf86-input-synaptics 0.99.1-1
(since xorg-server 1.5.3-2, see xorg)

The touchpad works from scratch in xorg, but if you would like to
install the drivers to enable more options, this will work (with both
scrolling and tap):

    pacman -S synaptics

or (depending on the xorg-server version)...

    pacman -S xf86-input-synaptics

And then add following to /etx/X11/xorg.conf (note that this is for
xf86-input-synaptics(!) and I have removed everything not related to the
touchpad):

    Section "ServerLayout"
    	InputDevice	"Touchpad" "SendCoreEvents"
    EndSection

    Section "Module"
    	Load	"synaptics"
    EndSection

    Section "InputDevice"
    	Identifier	"Touchpad"
    	Driver		"synaptics"
    	Option		"Device" "/dev/input/event10"
    	Option		"Protocol" "auto-dev"
    	Option		"AlwaysCore" "true"
    #	Option		"TouchpadOff" "1"
    	Option		"SHMConfig" "on"
    	Option		"LeftEdge" "130"
    	Option		"RightEdge" "840"
    	Option		"TopEdge" "130"
    	Option		"BottomEdge" "640"
    	Option		"FingerLow" "7"
    	Option		"FingerHigh" "8"
    	Option		"MaxTapTime" "180"
    	Option		"MaxTapMove" "110"
    	Option		"EmulateMidButtonTime" "75"
    	Option		"VertEdgeScroll" "true"
    	Option		"HorizEdgeScroll" "true"
    	Option		"CornerCoasting" "true"
    	Option		"CoastingSpeed" "0.30"
    	Option		"VertScrollDelta" "20"
    	Option		"HorizScrollDelta" "20"
    	Option		"MinSpeed" "0.80"
    	Option		"MaxSpeed" "1.0"
    	Option		"AccelFactor" "0.0010"
    #	Option		"VertTwoFingerScroll" "true"
    #	Option		"HorizTwoFingerScroll" "true"
    	Option		"EdgeMotionMinSpeed" "200"
    	Option		"EdgeMotionMaxSpeed" "200"
    	Option		"UpDownScrolling" "1"
    	Option		"CircularScrolling" "1"
    	Option		"CircScrollDelta" "0.1"
    	Option		"CircScrollTrigger" "2"
    	Option		"Emulate3Buttons" "on"
    	Option		"TapButton1" "1"
    	Option		"TapButton2" "2"
    	Option		"TapButton3" "3"
    EndSection

Reference: Synaptics

> Backlight

Brightness control (Fn+Home/End) works fine.

To change the brightness manually of the LCD you can either:

    echo 100 > /proc/acpi/video/VID1/LCD0/brightness	to set 100%
    echo 80 > /proc/acpi/video/VID1/LCD0/brightness	to set 80%

or

    xbacklight -inc 10%		to increase with 10%
    xbacklight -dec 10%		to decrease with 10%
    xbacklight -set 100		to set 100%
    xbacklight =100		to set 100%

> Webcam

Works.

Here is the output of "dmesg | grep Camera":

    input: UVC Camera (17ef:4807) as /class/input/input12

Output of "lsusb":

    Bus 007 Device 002: ID 17ef:4807 ChipsBnk 

You can test the webcam with mplayer:

    mplayer -fps 25 tv://

> Bluetooth

Not tested yet, but here is the output of "dmesg | grep Bluetooth":

    Bluetooth: Core ver 2.13
    Bluetooth: HCI device and connection manager initialized
    Bluetooth: HCI socket layer initialized
    Bluetooth: HCI USB driver ver 2.10

To control the bluetooth device I can run this:

    echo enable > /proc/acpi/ibm/bluetooth		To enable
    echo disable > /proc/acpi/ibm/bluetooth	To disable

And when the bluetooth device is enabled, it will appear as a usb
device. Output of "lsusb":

    Bus 001 Device 006: ID 0a5c:2110 Broadcom Corp. 

So, it seems that the device is recognized by the system and hopefully
works.

> Fingerprint Reader

Works without any problems, Use ThinkFinger

Output of "lsusb":

    Bus 001 Device 005: ID 0483:2016 SGS Thomson Microelectronics Fingerprint Reader

> Suspend / Hibernate

First install uswsusp and then test suspending to RAM... this should
work.

    sudo pacman uswsusp
    sudo /usr/sbin/s2ram -f

Then install acpid

    sudo pacman -S acpid

Then add it to rc.conf DAEMONS before hal (you did install hal, right ;)

Then edit /etc/acpi/default.sh to use /usr/sbin/s2ram -f when the
button/lid closes... make it look like the following:

    button/lid)
      /usr/sbin/s2ram -f
      #echo "LID switched!">/dev/tty5
      ;;

Configuration
-------------

> Language

I changed my language (swedish/sv_SE) and keyboardlayout in the
following files:

    /etc/environment
    /etc/X11/xorg.conf
    /etc/rc.conf
    /etc/locale.gen

And after that I ran this as root to update my locales:

    locale-gen

> xorg

See Xorg

> FluxBox

I also installed FluxBox as window manager. This is done by following:

    pacman -S fluxbox

And to load fluxbox with xorg, I created ~/.xinitrc and putted this into
it:

    #!/bin/bash
    exec startfluxbox

This is the output of "xrandr" after I installed the Intel graphical
driver:

    Screen 0: minimum 320 x 200, current 1440 x 900, maximum 1440 x 1440
    VGA disconnected (normal left inverted right x axis y axis)
    LVDS connected 1440x900+0+0 (normal left inverted right x axis y axis) 287mm x 180mm
      1440x900       60.0*+   50.0  
      1280x800       60.0  
      1280x768       60.0  
      1024x768       60.0  
      800x600        60.3  
      640x480        59.9  

It tells me that I am using the correct screen resolution (1440x900),
but there is still one problem. My characters in fluxbox is still
extremely large! This is a problem bound to the print resolution (dpi,
dots per inch). And to get rid of this, you can add the following in
/etc/X11/xinit/xserverrc:

    exec /usr/bin/X -nolisten tcp -dpi 96

or this into /etc/X11/xorg.conf:

    Section "Monitor"
    	DisplaySize	380 238 # 96 DPI @ 1440x900
    EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Thinkpad_X300&oldid=302857"

Category:

-   Lenovo

-   This page was last modified on 2 March 2014, at 08:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
