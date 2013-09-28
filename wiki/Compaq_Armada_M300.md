Compaq Armada M300
==================

This article describes the additional configuration needed on a brand
new ArchLinux installation to get the most of a Compaq Armada M300
laptop.

This laptop is very old but with ArchLinux and the following setup it is
still useful for browsing, skyping and even "light open officing".

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware Identification                                            |
| -   2 Hardware Setup                                                     |
|     -   2.1 Keyboard                                                     |
|     -   2.2 Video                                                        |
|     -   2.3 CPU scaling                                                  |
|     -   2.4 Wireless                                                     |
|         -   2.4.1 Wireless at boot up                                    |
|                                                                          |
| -   3 Additional Configuration                                           |
|     -   3.1 additions to /etc/rc.local                                   |
|     -   3.2 Hotkey configuration                                         |
|         -   3.2.1 LCD brightness                                         |
|         -   3.2.2 LCD / VGA Switch                                       |
|         -   3.2.3 Volume up, down and mute                               |
|                                                                          |
| -   4 Problems and not tested issues                                     |
|     -   4.1 Dual Monitor                                                 |
+--------------------------------------------------------------------------+

Hardware Identification
-----------------------

After installing ArchLinux i686, please check that:

    # lscpu
    Architecture:          i686
    CPU(s):                1
    Thread(s) per core:    1
    Core(s) per socket:    1
    CPU socket(s):         1
    Vendor ID:             GenuineIntel
    CPU family:            6
    Model:                 8
    Stepping:              6
    CPU MHz:               600.000

and

    # lspci
    00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) (rev 03)
    00:04.0 CardBus bridge: Texas Instruments PCI1211
    00:05.0 VGA compatible controller: ATI Technologies Inc 3D Rage LT Pro (rev dc)
    00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
    00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
    00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
    00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
    00:08.0 Multimedia audio controller: ESS Technology ES1978 Maestro 2E (rev 10)
    00:09.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 09)
    00:09.1 Serial controller: Agere Systems LT WinModem

corresponds to your hardware.

Hardware Setup
--------------

Lets get the features of the laptop correctly working in order to get
the most of it.

> Keyboard

Edit /etc/rc.conf and set KEYMAP="us-acentos" if you want to use
international characters.

> Video

Necessary driver packages:

-   xf86-input-synaptics
-   xf86-video-mach64

Note:For additional information, see the Xorg page

Note:Update: Oct, 24, 2010: The AUR package mach64drm should bring back
3D rendering for current kernel versions.

> CPU scaling

See CPU Frequency Scaling.

Note:If you are unable to switch frequencies, please check the BIOS
settings for SpeedStep support

> Wireless

Even though the M300 has no default wireless support, you might have a
PCMCIA card. For it to work, you must first:

    # pacman -S wireless_tools

then bring it up

    # ifconfig eth1 up

Note:Your card may be given a name other than eth1. Check by issueing
the command iwconfig

and watch the neighborhood:

    # iwlist scan

Note:If you run into troubles with your wireless card, check the
Wireless Setup article

Wireless at boot up

For the wireless network to automatically connect to you favorite access
points, there is an excellent article named Low Memory Footprint
Advanced Network Scripts for Sub Laptops

Additional Configuration
------------------------

> additions to /etc/rc.local

In order to have the mixer to always get back to the presetted values,
install alsa-utils and add the following to /etc/rc.local

    # mixer settings
    amixer set Master on 31
    amixer set PCM on 25
    amixer set Mic cap
    amixer set Capture on 8

For you to get your clock always updated, add: -- you might need this if
your CMOS battery is gone

    # set the time
    sleep 20        # give sometime for the network to connect
    if ((`ip route| wc -l` > 3)); then
            ntpdate pool.ntp.org
    fi

Note:please assure the ntp package is installed

> Hotkey configuration

LCD brightness

Add the following to /usr/local/bin/backlight_control:

    #! /bin/bash

    # backlight_control
    # =================
    #
    # Increase or decrease the LCD backlight brightness of (some) laptops
    #
    # Configure the following global keys to perform the following commands:
    #
    # XF86MonBrightnessUp:           /usr/local/bin/backlight_control inc
    # XF86MonBrightnessDown:         /usr/local/bin/backlight_control dec

    # constants
    SYSDEV="/sys/devices/virtual/backlight/acpi_video0"

    # parameters
    OP=$1

    function getCurrentBrightness {
            ((cb=`cat ${SYSDEV}/brightness`))
            echo $cb
    }

    function setCurrentBrightness {
            cb=$1
            sudo bash -c "echo $cb >${SYSDEV}/brightness"
    }

    function incBrightness {
            ((cb=`getCurrentBrightness`))
            ((cb=cb+1))
            setCurrentBrightness $cb
    } 

    function decBrightness {
            ((cb=`getCurrentBrightness`))
            ((cb=cb-1))
            setCurrentBrightness $cb
    }

    case "$OP" in
            inc)
                    incBrightness
            ;;
            dec)
                    decBrightness
            ;;
            *)
            echo "Usage: $0 {inc|dec}"
    esac

LCD / VGA Switch

Create /usr/local/bin/switch_display and add the following:

    #! /bin/bash

    # switch_display
    # ==============
    #
    # Switch the output combinations of LVDS and a possibly connected VGA when the appropriate
    # function key is pressed
    #
    # Configure the following global keys to perform the following commands:
    #
    # XF86Display:           /usr/local/bin/switch_display

    curr_res=`xrandr | grep "Screen 0" | sed 's/.*current \([^,]*\),.*/\1/'`
    if [ "$curr_res" == "2304 x 800" ]; then         # this is the resolution when both displays are active
    	xrandr --verbose --output LVDS1 --off
    	xrandr --verbose --output VGA1 --mode 1024x768 -r 75.1 --primary
    elif [ "$curr_res" == "1024 x 768" ]; then       # resolution when only the VGA is activated
    	xrandr --verbose --output LVDS1 --mode 1280x800 --primary
    	xrandr --verbose --output VGA1 --off
    else   # when only the LVDS is activated
    	xrandr --verbose --output LVDS1 --mode 1280x800 --primary
    	xrandr --verbose --output VGA1 --mode 1024x768 -r 75.1 --right-of LVDS1
    fi

Volume up, down and mute

Create a script called /usr/local/bin/volume_control:

    #! /bin/bash

    # volume_control
    # ==============

    # Perform mixer actions according to laptop / multimedia keyboard special key presses
    # like muting/unmuting, increasing/decrasing the volume, etc.
    #
    # Configure the following global keys to perform the following commands:
    #
    # XF86AudioMute:           /usr/local/bin/volume_control flip_muteness
    # XF86AudioLowerVolume:    /usr/local/bin/volume_control dec
    # XF86AudioRaiseVolume:    /usr/local/bin/volume_control inc

    # constants
    AMIXER="/usr/bin/amixer"

    # parameters
    OP=$1

    function flipMuteness {
    	if amixer get Master | tail -n 1 | grep -- '\[on\]'; then
    		amixer set Master mute
    	else
    		amixer set Master on
    	fi
    }
     
    function getCurrentVolume {
    	amixer get Master | tail -n 1 | sed 's/.*Playback \([0-9]*\).*/\1/'
    }

    function setCurrentVolume {
            cv=$1
    	amixer set Master $cv
    }

    function incVolume {
            ((cv=`getCurrentVolume`))
            ((cv=cv+1))
            setCurrentVolume $cv
    }

    function decVolume {
            ((cv=`getCurrentVolume`))
            ((cv=cv-1))
            setCurrentVolume $cv
    }

    case "$OP" in
            inc)
                    incVolume
            ;;
            dec)
                    decVolume
            ;;
    	flip_muteness)
    		flipMuteness
    	;;
            *)
            echo "Usage: $0 {inc|dec}"
    esac

Problems and not tested issues
------------------------------

> Dual Monitor

You'd probably have to do it by hand. Add this to the beginning of your
~/.xinitrc:

    # set multiple monitors
    xrandr --verbose --output LVDS1 --mode 1024x768 --primary
    xrandr --verbose --output VGA1 --mode 1024x768 -r 75.1 --right-of LVDS1

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compaq_Armada_M300&oldid=249172"

Category:

-   HP
