IBM ThinkPad T41
================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article covers the installation and configuration of Arch Linux on
an IBM/Lenovo T41 laptop. These laptops were very popular with corporate
customers, and are now available reconditioned fairly cheaply. Typical
spec is a 1.6GHz Pentium M, 512MB RAM, 32MB ATI Radeon graphics adapter
and a 40GB hard drive. It is possible to get most if not all of the
hardware to work in Arch.

Contents
--------

-   1 Preparation and Installation
-   2 ACPI
    -   2.1 Hibernation and Sleep
    -   2.2 CPU Frequency Scaling
    -   2.3 ACPI Events
    -   2.4 Special Modules
-   3 APM
    -   3.1 Hibernation
    -   3.2 Speedstep
-   4 Fn+FX Function Keys and Special Buttons
    -   4.1 Volume, Brightness, Thinklight & Lid
    -   4.2 Back and Forward
    -   4.3 Other Keys and Buttons
    -   4.4 tpb
-   5 UltraPad and TrackPoint
-   6 Networking
    -   6.1 Wireless
        -   6.1.1 Atheros Cards
        -   6.1.2 Cisco Cards
        -   6.1.3 Intel Cards
-   7 Display
-   8 Hard drive Active Protection
-   9 See also

Preparation and Installation
----------------------------

This laptop has a hidden protected area (HPA) at the end of the hard
drive, which can be used to restore the default OS (usually Windows XP
Pro) to the factory state. If you do not want to use this feature, or
have the recovery disks, you can reclaim about 3GB by disabling the "IBM
Predesktop Area" in the BIOS.

If you have the recovery disks or an intact HPA, they are the best way
to install Windows (if you want to dual boot). Do this first, as the
recovery disks will overwrite your MBR, and possibly other things too.
Then you can shrink down the partition it creates, and install Arch.

Note you can Create Recovery CDs from the preinstalled OS if you need
to, or if you're still under warranty, IBM may send some out to you.

You can then install Arch as normal: Official Install Guide.

ACPI
----

The TP41 has excelent ACPI support. For the steps below, you will need
acpid, which is available through pacman.

> Hibernation and Sleep

The easiest way is to use pm-utils, which supports suspend to RAM
(sleep), suspend to file and suspend to swap (hibernate).

> CPU Frequency Scaling

This Laptop has a Pentium M Banias chip, which supports speedstep

You need the cpufrequtils package, and either cpufreqd or cpudyn. The
correct module for the Banias is acpi_cpufreq.

> ACPI Events

Out of the box, Fn+F4, Fn+F12 and the power button generate ACPI events.
The thinkpad_acpi module can generate more events, see "FnFx and Special
Buttons" below.

> Special Modules

The thinkpad_acpi module (which may or may not be loaded by udev)
provides support for all hotkeys (see below) and a number of other
features. It has a procfs interface at /proc/acpi/ibm/ which can be used
to read out a number of thermal sensors, fan speed etc. and control
volume, brightness, LEDs, beep codes and much more. Control of fan speed
is possible if the driver is loaded with the experimental option, but if
you use this keep an eye on the thermal sensors.

The tp_smapi module is available in the AUR. On this model of thinkpad
it only provides extra battery information; Battery discharge control is
not supported. Note that this module conflicts with the hdaps module in
the kernel mainline, they cannot both be loaded at the same time.

APM
---

As an alternative to acpi, you can use apm. By default Arch Linux uses
the much more modern acpi, so you have to boot your kernel with apm. The
only reason to use apm is that with apm the ThinkPad keys work out of
the box. apm is missing some features of acpi. To do so, append
apm=on acpi=off to kernel parameters.

> Hibernation

With apm enabled, all hotkeys work out of the box, but to use suspend to
disk (Fn+F12), you have to prepare a "save2dsk.bin" file on a fat16
partition using the program [| tphdisk]. The Size of this file should be
ramsize+videoramsize+few mb more. eg:

    tphdisk 565 > save2dsk.bin

Do a cold reboot, so the bios can see the new file.

> Speedstep

As per ACPI

Fn+FX Function Keys and Special Buttons
---------------------------------------

> Volume, Brightness, Thinklight & Lid

The volume buttons, Fn+Home, Fn+End, Fn+PgUp and lid buttons are wired
directly to the relevant piece of hardware, so do not need any
configuration. With an appropriate mask (see below) they will still
produce an acpi event, which can be used to display onscreen messages
using xosd or libnotify.

> Back and Forward

The two buttons next to the arrow keys generate normal keystrokes (233
and 234) when pressed, and can used in xbindkeys or xmodmap, or as
shortcut keys. They can be used to change workspace in Metacity for
example. If you want Windows-like back and forward in your browser,
there are some instructions for most browsers on the Thinkwiki.

> Other Keys and Buttons

If you are using APM most Fn+Fx keys just work.

If you are using ACPI without the thinkpad_acpi module, many work out of
the box. If you want more/better/configurable keys, read on.

By default most of the keys and buttons produce an acpi event. You can
test which using:

    $ acpi_listen

Exactly which keys produce an event depends on the mask set in
/proc/acpi/ibm/hotkey. You can read the mask using cat, and change it
with something like:

    # echo enable,0x00ffffff > /proc/acpi/ibm/hotkey

The hex value is a mask, which controls which keys are handled by the
laptop firmware and which ones are handled by acpid. Exactly which bit
affects which key/button is unknown, but 0x00000000 sends all events to
the firmware, and 0x00ffffff send all events to acpid. The default is0
x008c7fff, which creates acpi events for most buttons, but not those
listed above which are connected directly to the hardware. If you want
to set the mask at every boot, just add the above command to
/etc/rc.local. If unsure, just leave it alone.

You must then set up acpid to handle the acpi events. In Arch this is
done through /etc/acpi/handler.sh, which is a bash script, and uses case
structures to decide what action to take for each event. With a mask of
0x00ffffff the following script handles most of the Fn+Fx keys according
to the blue icons on them.

FIXME: If you know how to toggle the external display on this laptop
(Fn+F7), please update the script

    #!/bin/sh

    # Acpi script that takes an entry for all actions. For an IBM 
    # Thinkpad t41, assumes hotkey mask 0x00ffffff. Uses netcfg package.
    # by Jack Barraclough

    set $*

    case "$1" in
    	ibm/hotkey)
    	case "$4" in
    		'00001003') # Fn + F3 switch off backlight
    		        xset -display :0 dpms force off
    		;;
    		'00001004') # Fn + F4 suspend
    			/usr/sbin/pm-suspend
    		;;
    		'00001005') #Fn + F5 toggles network
    			if [ -f /var/run/daemons/net-profiles ]
    			then
    				/etc/rc.d/net-profiles stop
    			else
    				/etc/rc.d/net-profiles start
    			fi
    		;;
    		'0000100c') # Fn + F12 hibernates
    			/usr/sbin/pm-hibernate
    		;;
    		*)
    			logger "ACPI action undefined: $*"
    		;;
    		#
    		# Add your own events here.
    		#
    	esac
    	;;
    	*)
    	logger "ACPI action undefined: $*"
    esac

This may seem like a lot of work just to get the hotkeys working, but it
is also very powerful and extensible. You can easily add more actions,
and every Fn+Fx combo generates an event. To control mpd with
Fn+{F9-F11} for example:

    	'00001009') # Tell MPD to skip back Fn+F9
    		mpc prev
    	;;
    	'0000100a') # Tell MPD to play/pause Fn+F10
    		mpc toggle
    	;;
    	'0000100b') # Tell MPD to skip forward Fn+F11
    		mpc next
    	;;

One word of warning: the script runs as root, so be careful. If you want
to start firefox using the Access IBM button for example, use su or sudo
to start it as your normal user, not root.

A complete list of buttons/keys and the events they produce is available
on the Thinkwiki.

> tpb

There is another method of getting these keys to work, using the nvram
kernel module and a piece of software called tpb. This is quite
complicated, and does not work as well. It is not recommended as
thinkpad_acpi supports all the buttons on this laptop. For the curious,
there is some information on the Thinkpad OSD page.

UltraPad and TrackPoint
-----------------------

Both the pad and TrackPoint are supported by the standard mouse driver,
and by the synaptics package, which provides more functionality, such as
scrolling using the edges of the pad. The below code will give you
windows like functionality. It'll let you scroll with the middle mouse
button, and also use it as a third mouse button for pasting and such.
There are more details on how to configure more options on Thinkwiki

    Section "InputDevice"
          Identifier  "Configured Mouse"
          Driver      "mouse"
          Option      "CorePointer"
          Option      "Device" "/dev/input/mice"
          Option      "Protocol" "ExplorerPS/2"
          Option      "Emulate3Buttons"   "on"
          Option      "Emulate3TimeOut"   "50"
          Option      "EmulateWheel"      "on"
          Option      "EmulateWheelTimeOut" "200"
          Option      "EmulateWheelButton"        "2"
          Option      "YAxisMapping" "4 5"
          Option      "XAxisMapping" "6 7"
          Option      "ZAxisMapping" "4 5"
    EndSection

Networking
----------

> Wireless

The T41 comes with three diffrent wireless cards:

-   IBM 11a/b/g Wireless LAN Mini PCI Adapter (which uses an Atheros
    chipset)
-   Cisco Aironet Wireless 802.11b
-   Intel PRO/Wireless LAN 2100 3B Mini PCI Adapter

You can check which you have with:

    lspci | grep Ethernet

All of which should work under linux, and more details can be found on
the Wireless network configuration page.

Atheros Cards

These cards work out of the box with the ath5k driver. The card appears
as wlan0.

Cisco Cards

FIXME: If you have a cisco card in your T41, please update this section
These should be supported by the open source airo module, or the closed
source mpi350 module from cisco.

Intel Cards

See Wireless network configuration#ipw2100 and ipw2200.

Display
-------

The laptop has a ATI Radeon 7500 or 9000 graphics adapter, supported by
the open source ATI driver. Note that as of fglrx 8.28.8 these chipsets
are not supported, so stick with the open source drivers. Most of the
options on the radeon man page and on the ATI driver page can be used
with this chip, but there are reports of crashes or blank screens when
FastAGPWrites is enabled. On option of interest not on the ATI page is
DynamicClocks, which can be used to reduce power consumption.

Hard drive Active Protection
----------------------------

The T41 has a built in accelerometer, which can be used to detect when
the laptop is dropped, and park the hard drive heads. As of Kernel
2.6.29, you no longer need to patch the kernel to make it work. See the
HDAPS page for a guide on setting this up.

See also
--------

-   ThinkWiki (an invaluable resource)
-   ThinkWiki Page on the T41
-   Thinkpad T41 Hardware Maintenance Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_T41&oldid=303181"

Category:

-   IBM

-   This page was last modified on 4 March 2014, at 22:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
