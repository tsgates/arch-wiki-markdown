Lenovo Ideapad Yoga 2 Pro
=========================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: unnecessary      
                           article (Discuss)        
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Boot, UEFI
-   2 USB subsystem
-   3 Hardware Keys / User Input
    -   3.1 Keyboard special keys
    -   3.2 Hardware keys on right side
    -   3.3 Touchscreen
        -   3.3.1 Touchscreen button
    -   3.4 Synaptics touchpad
-   4 ACPI
    -   4.1 Touchpad
    -   4.2 Power button
    -   4.3 Backlight
    -   4.4 Battery
-   5 Graphics
-   6 Rotation/Conversion
-   7 Network
-   8 See also

Boot, UEFI
==========

By default, boots in UEFI mode. UEFI and Legacy modes both seem to work
fine, while UEFI is little more tricky to set up.

USB subsystem
=============

USB3 port on the left side, USB2 port on the right. Why that?

syslog

    usb 2-7: unable to read config index 0 descriptor/start -71

after login to a shell, it is good to

    ~# dmesg -D

or you will find it hard to work.

on Gentoo, my syslog fills with

    Dec  5 08:40:44 localhost kernel: [  290.632613] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 15360 bytes, 15117 bytes untransferred
    Dec  5 08:40:44 localhost kernel: [  290.735110] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 15360 bytes, 15117 bytes untransferred
    Dec  5 08:40:44 localhost kernel: [  290.837534] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 15360 bytes, 15117 bytes untransferred
    Dec  5 08:40:44 localhost kernel: [  290.940070] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 15360 bytes, 15117 bytes untransferred
    Dec  5 08:40:44 localhost kernel: [  291.042570] xhci_hcd 0000:00:14.0: ep 0x81 - asked for 15360 bytes, 15117 bytes untransferred

at a rate of at least 10 lines a second..

Ubuntu shows strictly _nothin_ in the logs, it is really annoying maybe
I was just missing something

Hardware Keys / User Input
==========================

To access boot menu, you must use the alternate power button, just next
to the standard one. While this is a nice feature, it can be confusing
if you don't know about it and requires to shut down completely to
acceess boot menu or BIOS settings. It would be nice to access the boot
menu with 'del' key wil booting.. No keypad available at all

Keyboard special keys
---------------------

BIOS has a setting to invert the fn/non-fn behaviour.

    fn+F1   XF86AudioMute
    fn+F2   XF86AudioLowerVolume
    fn+F3   XF86AudioRaiseVolume
    fn+F4   Alt_L+<F4>
    fn+F5   <F5>
    fn+F6   n/a
    fn+F7   n/a
    fn+F8   Alt_L+Tab
    fn+F9   screen_off_what_mode?
    fn+F10  super_L+p
    fn+F11  XF86MonBrightnessDown
    fn+F12  XF86MonBrightnessUp

Hardware keys on right side
---------------------------

from screen hinge to front:

    XF86AudioRaiseVolume
    XF86AudioLowerVolume
    Super_L+o

more media buttons would have been appreciated..

Touchscreen
-----------

Touchscreen USB device seems to come and go as long as 'usbtouchscreen'
module is not leaded.

use "touchegg" to be able to scroll with two fingers and stuff like
that. seems to work more or less with default config, more tuning
probably needed

> Touchscreen button

    Super_L, but a fake one! key_down and key_up generated simultaneously on touch release

when touching the "Window button" area, touch feedback is done with a
vibrator. as of now, it seems it is not possible to control it by
software. We hope to see a firmware update to support this...

Synaptics touchpad
------------------

Default settings are crap. Here are some better ones, which allow you
to:

-   middle click by tapping with two fingers
-   right click with 3-finger tap
-   lower zone of touchpad is inefective for pointer motion, leaving
    room for three buttons (left, middle, right) which don't make the
    pointer move when clicked. note you can't leave a finger on the
    "inactive" zone of the touchpad and at the same time use another
    finger to move the pointer, this will be seen as a two-finger move
    (usually scrolling..)

I still find the double-click interval to be a little short, but no
success yet.

/etc/X11/xorg.conf.d/50-synaptics.conf

    Section "InputClass"
           Identifier "touchpad"
           Driver "synaptics"
           MatchIsTouchpad "on"
                   Option "TapButton1" "1"
                   Option "TapButton2" "2"
                   Option "TapButton3" "3"
                   Option "VertEdgeScroll" "off"
                   Option "VertTwoFingerScroll" "on"
                   Option "HorizEdgeScroll" "off"
                   Option "HorizTwoFingerScroll" "on"
                   Option "CircularScrolling" "off"
                   Option "CircScrollTrigger" "2"
                   Option "EmulateTwoFingerMinZ" "40"
                   Option "EmulateTwoFingerMinW" "8"
                   #Option "EmulateTwoFingerMinZ" "282"
                   #Option "EmulateTwoFingerMinW" "7"
                   Option "CoastingSpeed" "0"
                   #Option "CoastingSpeed" "5"
                   Option "CoastingFriction" "15"
                   Option "LeftEdge" "1768"
                   Option "RightEdge" "5406"
                   Option "TopEdge" "1640"
                   Option "BottomEdge" "4498"
                   Option "FingerLow" "35"
                   Option "FingerHigh" "45"
                   Option "MaxTapTime" "120"
                   Option "MaxTapMove" "300"
                   Option "MaxDoubleTapTime" "180"
                   Option "SingleTapTimeout" "180"
                   Option "ClickTime" "100"
                   Option "EmulateMidButtonTime" "120"
                   Option "VertScrollDelta" "107"
                   Option "HorizScrollDelta" "107"
                   Option "CornerCoasting" "0"
                   Option "MinSpeed" "1"
                   Option "MaxSpeed" "1.75"
                   Option "AccelFactor" "0.0371885"
                   Option "TouchpadOff" "0"
                   Option "LockedDrags" "0"
                   Option "LockedDragTimeout" "5000"
                   Option "RTCornerButton" "0"
                   Option "RBCornerButton" "0"
                   Option "LTCornerButton" "0"
                   Option "LBCornerButton" "0"
                   Option "ClickFinger1" "1"
                   Option "ClickFinger2" "2"
                   Option "ClickFinger3" "3"
                   Option "CircScrollDelta" "0.1"
                   Option "PalmDetect" "0"
                   Option "PalmMinWidth" "10"
                   Option "PalmMinZ" "200"
                   Option "PressureMotionMinZ" "30"
                   Option "PressureMotionMaxZ" "160"
                   Option "PressureMotionMinFactor" "1"
                   Option "PressureMotionMaxFactor" "1"
                   Option "GrabEventDevice" "1"
                   Option "TapAndDragGesture" "1"
                   Option "AreaLeftEdge" "0"
                   Option "AreaRightEdge" "0"
                   Option "AreaTopEdge" "0"
                   Option "AreaBottomEdge" "4100"
                   Option "HorizHysteresis" "20"
                   Option "VertHysteresis" "20"
                   Option "ClickPad" "1"
                   # these settings need to be set with synclient, seems to be ineffective here..
                   Option "RightButtonAreaLeft" "4501"
                   Option "RightButtonAreaRight" "0"
                   Option "RightButtonAreaTop" "4100"
                   Option "RightButtonAreaBottom" "0"
                   Option "MiddleButtonAreaLeft" "2500"
                   Option "MiddleButtonAreaRight" "4500"
                   Option "MiddleButtonAreaTop" "4100"
                   Option "MiddleButtonAreaBottom" "0"
    EndSection                  

~/.xinit (partial)

    # order is important here!
    synclient RightButtonAreaLeft=4501
    synclient RightButtonAreaRight=0
    synclient RightButtonAreaTop=4100
    synclient RightButtonAreaBottom=0
    synclient MiddleButtonAreaRight=4500
    synclient MiddleButtonAreaLeft=2500
    synclient MiddleButtonAreaTop=4100
    synclient MiddleButtonAreaBottom=0

    xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Profile" 2
    xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Constant Deceleration" 4
    xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Adaptive Deceleration" 4
    xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Velocity Scaling" 8

ACPI
====

I modified /etc/acpi/default.sh to allow for some debugging and
additional features (see below):

    #!/bin/sh
    set $*
    group=${1%%/*}
    device=$2
    id=$3
    value=$4
    log_unhandled() {
           logger "ACPI event unhandled: $*"
    }
    case "$group" in
           button)
                   case "$action" in
                           power)
                                   /etc/acpi/actions/powerbtn.sh
                                   ;;
                           lid)
                                   /etc/acpi/actions/lid.sh
                                   ;;
                           *)      log_unhandled $* ;;
                   esac
                   ;;
           ac_adapter)
                   case "$value" in
                           *)      log_unhandled $* ;;
                   esac
                   ;;
           *)      echo $* > /dev/tty5
                   log_unhandled $* ;;
    esac

  

Touchpad
--------

Touchpad is lame, and sends random input is being sent from time to
time, especially when lid is closed. If, like me, you like your computer
to keep on running when the lid is closed, it is a MUST to disable the
touchpad with ACPI events:

/etc/acpi/actions/lid.sh

    #!/bin/bash
    export DISPLAY=:0
    if grep closed /proc/acpi/button/lid/LID0/state
    then
           synclient TouchpadOff=1 2>/dev/tty5 && echo "lid closed, disabling touchpad" >/dev/tty5
    else
           synclient TouchpadOff=0 2>/dev/tty5 && echo "lid open, eênabling touchpad" >/dev/tty5
    fi

of course, echo statement is optional and for debug purposes..

  

Power button
------------

You will probably want to assign the "power" button to some smarter
action:

/etc/acpi/actions/powerbtn.sh

    #!/bin/bash
    export DISPLAY=:0
    echo "power button pressed, going to sleep" > /dev/tty5
    xscreensaver-command -lock 2> /dev/tty5 && echo "screen locked" >> /dev/tty5
    sleep 1
    echo mem>/sys/power/state

this script locks the screen, waits a second, and sends the computer to
sleep. the sleep delay is required or the next time you open the lid and
press a key (any key will do to get the computer out of sleep), the
desktop will be visible for a second before xscreensaver blanking it.

Backlight
---------

"old" (ref needed) kernel require kernel boot argument

    acpi_backlight=vendor

Some distributions (eg: Ubuntu) boot with backlight set to minimum.
Hardware keys should work fine in this case.

Screen backlight brightness can be set with

    echo $VAL > /sys/class/backlight/intel_backlight/brightnes

with $VAL between 0 and 937

Battery
-------

Battery info can be accessed with

    ls /sys/class/power_supply/BAT1/*

Unfortunately, the values obtained there have no units (older Lenovo
products had rates in mA, battery voltage, etc.)

Graphics
========

Steam crashes trying to run games complaining about missing i965 module.
It seems some applications treat it as accelerated, and some do not.

Resolution seems to be not so well supported by some desktop
environments/window managers. XFCE works fine. I use fvwm, it is really
well suited for this. I will post my config for this soon..

With standard X defaults, the font is really small. I find it OK when
sitting on a desk, but whenever there's the slightest vibration I cannot
read anymore.

~/.Xresources

    xterm*VT100.geometry:     120x40
    xterm*faceName:           Terminus:style=Regular:size=12
    !xterm*font:              -*-dina-medium-r-*-*-16-*-*-*-*-*-*-*
    xterm*dynamicColors:      true
    xterm*utf8:               2
    xterm*eightBitInput:      true
    xterm*saveLines:          512
    xterm*scrollKey:          true
    xterm*scrollTtyOutput:    false
    xterm*scrollBar:          false
    !xterm*rightScrollBar:     true
    xterm*jumpScroll:         true
    xterm*multiScroll:        true
    xterm*toolBar:            false

  

Rotation/Conversion
===================

You can easily rotate screen with xrandr, however it does not rotate
touchscreen/touchpad input which makes it fairly awkward to use. There
is a project attempting to address this. Keyboard hardware-disables in
tablet mode, but touchpad is still active which needs to be addressed.
No ACPI or keycode signals appear to be emitted for the various
laptop,tent,tablet states.

Network
=======

Network is known to cause trouble. it is needed to

    ~# rfkill unblock wlan

There 'might' be an issue with 64bit distros and the network, which is
then so unstable it becomes unusable. More testing needed to confirm
this.

It may (or may not) help to unload/blacklist the 'ideapad_laptop' module
(specially to get networkmanager to handle your wifi).

See also
========

-   The LinLap site has some good information - see [[1]]
-   a good Review of Arch Linux on a HiDPI Lenovo Yoga 2 Pro by KeithCU
    with useful comments

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_Ideapad_Yoga_2_Pro&oldid=305450"

Category:

-   Lenovo

-   This page was last modified on 18 March 2014, at 14:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
