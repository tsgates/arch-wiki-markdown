Toshiba Tecra M4
================

The Tecra M4 is a convertible-PC produced by Toshiba.

Mine includes 512MByte of RAM, 60Gbyte SATA-HDD, NVidia 6200 graphics
card and a serial Wacom tablet.

This will be a short introduction on how to make everything work
perfectly.

This tutorial is a bit work in progress so stay tuned ;)

Contents
--------

-   1 Installation
-   2 Wireless drivers
-   3 Installing Wacom Tablet
-   4 Optimizing battery lifetime
    -   4.1 CPUFreq
    -   4.2 PHC
-   5 Mapping screen-key to something that makes sense
-   6 Script for changing orientation
-   7 What does not work

Installation
============

Just boot the ArchLinux Installation disc and install the basics

Wireless drivers
================

This PC contains an intel wireless card, that is supported by the
ipw2200.

Therefor run a

    # pacman -S ipw2200-fw

and afterwards reload the ipw2200 driver.

Installing Wacom Tablet
=======================

Install xf86-input-wacom from AUR - if you installed aurpac like me:

     $ aurpac -S xf86-input-wacom

Now, you'll have to configure xorg.conf:

    # X -configure
    # cp /root/xorg.conf.new /etc/X11/xorg.conf
    # nano -w /etc/X11/xorg.conf

The ServerLayout Section should look like this:

    Section "ServerLayout"
    	Identifier      "Default Layout" 
    	Screen "Screen0"
    	Inputdevice     "cursor" "SendCoreEvents"
    	Inputdevice     "stylus" "SendCoreEvents"
    	Inputdevice     "eraser" "SendCoreEvents"
    	Identifier     "X.org Configured"
    	Screen      0  "Screen0" 0 0
    	InputDevice    "Mouse0" "CorePointer"
    	InputDevice    "Keyboard0" "CoreKeyboard"
           InputDevice    "Touchpad"  
    EndSection

In section "Module" add

    Load  "synaptics"

The Input-Sections:

    Section "InputDevice"
     Driver          "wacom"
     Identifier      "cursor"
     Option          "Device" "/dev/ttyS0"
     Option          "Type" "cursor"
     Option          "ForceDevice" "ISDV4"
     Option          "Rotate" "NONE"
    EndSection

    Section "InputDevice"
     Driver          "wacom"
     Identifier      "stylus"
     Option          "Device" "/dev/ttyS0"
     Option          "Type" "stylus"
     Option          "ForceDevice" "ISDV4"
     Option          "Rotate" "NONE"
    EndSection

    Section "InputDevice"
      Driver          "wacom"
      Identifier      "eraser"
      Option          "Device" "/dev/ttyS0"
      Option          "Type" "eraser"
      Option          "ForceDevice" "ISDV4"
      Option          "Rotate" "NONE"
    EndSection

This is my Input-Section for the touchpad

    Section "InputDevice"
      Identifier  "Synaptics Touchpad"
      Driver      "synaptics"
      Option      "AlwaysCore"        "true"  # send events to CorePointer
      Option      "Device"            "/dev/psaux"
      Option      "Protocol"          "auto-dev"
      Option      "SHMConfig"         "false" # configurable at runtime? security risk
      Option      "LeftEdge"          "1700"  # x coord left
      Option      "RightEdge"         "5300"  # x coord right
      Option      "TopEdge"           "1700"  # y coord top
      Option      "BottomEdge"        "4200"  # y coord bottom
      Option      "FingerLow"         "25"    # pressure below this level triggers release
      Option      "FingerHigh"        "30"    # pressure above this level triggers touch
      Option      "MaxTapTime"        "180"   # max time in ms for detecting tap
      Option      "VertEdgeScroll"    "true"  # enable vertical scroll zone
      Option      "HorizEdgeScroll"   "true"  # enable horizontal scroll zone
      Option      "CornerCoasting"    "true"  # enable continuous scroll with finger in corner
      Option      "CoastingSpeed"     "0.30"  # corner coasting speed
      Option      "VertScrollDelta"   "100"   # edge-to-edge scroll distance of the vertical scroll
      Option      "HorizScrollDelta"  "100"   # edge-to-edge scroll distance of the horizontal scroll
      Option      "MinSpeed"          "0.10"  # speed factor for low pointer movement
      Option      "MaxSpeed"          "0.60"  # maximum speed factor for fast pointer movement
      Option      "AccelFactor"       "0.0020"    # acceleration factor for normal pointer movements
      Option      "VertTwoFingerScroll"   "true"  # vertical scroll anywhere with two fingers
      Option      "HorizTwoFingerScroll"  "true"  # horizontal scroll anywhere with two fingers
      Option      "TapButton1" "1"
      Option      "TapButton2" "2"
      Option      "TapButton3" "3"
    EndSection

My Device Section

    Section "Device"
    	Identifier  "Card0"
    	Option	"NoLogo" "1" # I do not like the NVidia Logo
    	Option "RandRRotation" "true" # making it possible to rotate the screen
    	Option "Coolbits" "1"
    	Option "RegistryDwords" "PerfLevelSrc=0x3333" # for saving battery lifetime
    	Driver      "nvidia"
    	VendorName  "nVidia Corporation"
    	BoardName   "NV43 [Geforce Go 6600TE/6200TE]"
    	BusID       "PCI:1:0:0"
    EndSection

Optimizing battery lifetime
===========================

CPUFreq
-------

Just install cpufrequtils

PHC
---

I reduced VCores to make my battery live longer: install intel-phc and
linux-phc-optimize from AUR

    $ aurpac -S intel-phc linux-phc-optimize

then run

    # linux-phc-optimize

remember the original and the optimized values - you'll need them ;)
then I created the following script /etc/rc.d/phc

    #!/bin/bash

    case "$1" in
     start)
       stat_busy "Optimizing PHC VIDs"
       echo "14:21 12:15 10:9 8:4 6:3" > /sys/devices/system/cpu/cpu0/cpufreq/phc_controls
         stat_done
       ;;
     stop)
       stat_busy "Resetting PHC VIDs"
       echo "14:41 12:36 10:30 8:24 6:18" > /sys/devices/system/cpu/cpu0/cpufreq/phc_controls
         stat_done
       ;;
     restart)
       $0 stop
       sleep 1
       $0 start
       ;;
     *)
       echo "usage: $0 {start|stop|restart}"  
    esac
    exit 0

the bold passages are the optimized and original values - these are for
my Pentium M 1,86GHz the formate is the following:

    14:value_for_full_speed 12:value_for_speed2 10:value_for_speed3

etc etc in the "Optimizing" part insert the optimized values and in the
"Resetting" part the original values.

Mapping screen-key to something that makes sense
================================================

by default, the buttons on the screen return the combinations Super_L +
[1-7] I prefer this tiny joystick to use as page up and page down - so I
tried xmodmap

    $ nano -w .Xmodmap

change the line of keycode 134 to

    keycode 134 = Mode_switch NoSymbol Mode_switch NoSymbol Super_R

and the following lines:

    keycode  10 = 1 exclam Prior Prior onesuperior exclamdown
    keycode  11 = 2 quotedbl Next Next twosuperior oneeighth
    keycode  12 = 3 section Prior Prior threesuperior sterling
    keycode  13 = 4 dollar Next Next onequarter currency

that produces: tablet is landscape and orientation "normal" - joystick
up -> page up, down -> page down tablet is portrait and orientation
"left" - joystick up -> page up, down -> page down

Script for changing orientation
===============================

    # nano -w /usr/bin/rotate

    #!/bin/bash

    #### rotate.sh - A script for tablet PCs to rotate the display.

    ## This software is licensed under the CC-GNU GPL.
    ## http://creativecommons.org/licenses/GPL/2.0/

    ## https://wiki.archlinux.org/index.php/Tablet_PC
    ## REQUIRES: linuxwacom (http://sourceforge.net/apps/mediawiki/linuxwacom/index.php?title=Main_Page)

    #### Function(s)
    function set_normal {
     xrandr -o normal
     xsetwacom set "stylus" Rotate NONE
     xsetwacom set "cursor" Rotate NONE
     xsetwacom set "eraser" Rotate NONE
     orientation="normal"
    }

    function set_left {
     xrandr -o left
     xsetwacom set "stylus" Rotate CCW
     xsetwacom set "cursor" Rotate CCW
     xsetwacom set "eraser" Rotate CCW
     orientation="left"
    }

    #### Variable(s)
    orientation="$(xrandr --query --verbose | grep '(normal left inverted right) 0mm x 0mm' | awk '{print $5}')"

    #### Main
    if [ "$orientation" = "normal" ]; then
    	set_left
    elif [ "$orientation" = "right" ]; then
    	set_normal
    elif [ "$orientation" = "inverted" ]; then
    	set_normal
    elif [ "$orientation" = "left" ]; then
    	set_normal
    fi

    #### EOF

  

    # chmod 0755 /usr/bin/rotate

I customized the given script a bit, because turning right and inverted
made no sense for me. This script can now be used with
gnome-keybinding-properties

What does not work
==================

-   Mapping joystick to page_up/down AND using the rotate button in
    gnome-keybinding-properties at the same time
-   sound does work, if you reload the snd_intel8x0 module after boot -
    do not know, why

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Tecra_M4&oldid=262380"

Category:

-   Toshiba

-   This page was last modified on 11 June 2013, at 16:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
