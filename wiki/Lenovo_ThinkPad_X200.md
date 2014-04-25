Lenovo ThinkPad X200
====================

  Summary help replacing me
  ---------------------------------------------------------------------------------
  This article covers the Arch Linux support for the Lenovo ThinkPad X200 laptop.

The Lenovo ThinkPad X200 is a wonderful high-quality laptop featuring a
12.1" widescreen WXGA monitor, an Intel Core 2 Duo processor (2.26 -
2.66GHz), an Intel Graphics Media Accelerator 4500MHD and up to 4GB of
RAM whilst still maintaining impressive battery life.

While Arch Linux is running flawlessly on this laptop there are a few
things you have to configure manually. This article will aid you in
configuring your system and will provide additionally hints to make your
ThinkPad X200 experience even better.

Contents
--------

-   1 Setup
    -   1.1 Wireless
    -   1.2 Graphics
    -   1.3 Audio
    -   1.4 Fingerprint Reader
-   2 Configuration
    -   2.1 GRUB kernel parameter
    -   2.2 Disable bluetooth at boot
    -   2.3 Enable tap to select
    -   2.4 Hard Disk Shock Protection
    -   2.5 Mute button
    -   2.6 Screen calibration
    -   2.7 Loading the correct ICC colour profile
    -   2.8 Screen rotation
    -   2.9 Screen auto-rotation
    -   2.10 Power consumption and fan control
    -   2.11 Suspend to RAM
-   3 Unsupported
-   4 Troubleshooting
    -   4.1 failed to execute '/usr/sbin/inputattach'
    -   4.2 System feels unresponsive
    -   4.3 PM device: Resume from hibernation error: Failed to restore
        -19
    -   4.4 mei_me 0000:00:03.0: suspend
    -   4.5 pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:03:00
    -   4.6 Uhhuh. NMI received for unknown reason 30.
-   5 See also

Setup
-----

> Wireless

The ThinkPad X200 has a Intel PRO/Wireless 5100 AGN wireless adapter
included. In order to make it work you have to install the
iwlwifi-5000-ucode package when you install from a 2010.05 snapshot in
order to get the firmware, by now the package is included in the
linux-firmware package.

Now you can choose whatever network configuration programs you want to
use. If you do not already know which network manager you want to use,
we highly recommend netctl.

If you experience connectivity problems such as a slow connection or
aborts, especially when connected to an (Enterprise) WPA2 network, then
try to load the iwlwifi module with the options 11n_disable=1,
11n_disable=2, swcrypto=1, bt_coex_active=0. There is no clear
recommendation which of these options to be used as for some users
11n_disable=1 already solves the problem sufficiently, for others
bt_coex_active=0. Thus, play around with each of them. Example:

    modprobe iwlwifi 11n_disable=2

If some of them work out for you, then make the options permanent by
creating the file /etc/modprobe.d/wireless.conf and adding the
following:

    options iwlwifi 11n_disable=2
    # Disable blinking LED wireless light 
    options iwlwifi led_mode=1

> Graphics

The graphics card is supported by the xf86-video-intel driver package
from the extra repository. The Xorg server makes use of this
automatically. There's no need for a Xorg configuration file.

    # pacman -S xf86-video-intel

> Audio

Audio is supported out of the box after installing the necessary alsa
packages from the core repository.

    # sudo pacman -S alsa-lib

See Alsa for more information.

> Fingerprint Reader

See fprint.

Configuration
-------------

> GRUB kernel parameter

Many kernel parameters usually recommended in the past to increase
performance and battery conservation are obsolete or already implemented
in the kernel by default. As such the actual kernel line in
/etc/default/grub can look very minimal:

    GRUB_CMDLINE_LINUX_DEFAULT="acpi_osi=Linux zswap.enabled=1 zswap.compressor=lz4 resume=/dev/mapper/VolGroup00-Swap"

acpi_osi=Linux is required to make the mute button working and
zswap.enabled=1 as well as zswap.compressor=lz4 will increase the speed
on resume from hibernation.

> Disable bluetooth at boot

In order to disable bluetooth at boot you just need to add the following
line to a newly created /etc/tmpfiles.d/disable-bluetooth.conf file.
Please note, that there is no longer support for a /etc/rc.local file.

    w /proc/acpi/ibm/bluetooth - - - - disable

> Enable tap to select

You can enable the double click through tapping on your track point.
Create a /etc/tmpfiles.d/enable-tap-to-select.conf with the following
content:

    w /sys/devices/platform/i8042/serio1/press_to_select - - - - 1

> Hard Disk Shock Protection

The ThinkPad X200 comes with an integrated 2-axis accelerometer
providing the possibility of parking the hard drive's disk heads
preventing from data loss due to heavy shocks.

First you'll have to install tp_smapi and hdapsd from official
repositories (Community). Then you have to load the hdaps module
provided by tp_smapi with the option invert=7 passed. This will correct
the orientation of the accelerometer's axises. If you are using systemd,
create a file /etc/modules-load.d/tp_smapi.conf with the following line:

    # Load tp_smapi at boot
    options tp_smapi invert=7

Then you need to start the hdapsd daemon:

    # systemctl enable hdapsd
    # systemctl start hdapsd

Now check your log files with journalctl if you see any
parking/unparking entries which indicate that hdapsd is successfully
configured.

For full information see: HDAPS

Note:If you experience parking / un-parking events when not moving your
hard disk, then you might use the wrong invert value. Install and run
hdaps-gl and check whether it shows your machine in the correct
orientation when turning the machine. If not, you need to change the
invert value. Alternatively to reloading the module you can also
directly write a value between 0 and 7 to
/sys/devices/platform/hdaps/invert.

> Mute button

If the mute button on your keyboard is not working, then be sure to add
acpi_osi="Linux" to your boot parameter in /etc/default/grub.

    GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi_osi=Linux"

> Screen calibration

If you experience your stylus to be working very imprecisely, then you
might need to calibrate it first. Install xinput_calibrator and run the
following command:

    sudo xinput_calibrator --device "Serial Wacom Tablet WACf004 stylus"

After calibration you need to create the file called
/etc/X11/xorg.conf.d/99-calibration.conf with the settings provided by
xinput_calibrator.

> Loading the correct ICC colour profile

Download TPLCD.ICM and move it to ~/.color/icc. Load the profile with
xcalib as follows:

    $ /usr/bin/xcalib -d :0 ~/.color/icc/TPLCD.ICM

> Screen rotation

The screen rotation hardware button does not work by default. First you
have to assign this button to a free keycode. In order to find out an
unused keycode, you can use the command xmodmap -pke | less.

    # File: /etc/systemd/system/setkeycodes.service 

    [Unit]
    Description=Assign each hardware button to a free keycode on boot

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/setkeycodes 0x67 184 0x6c 185 0x68 186 0x66 187

    [Install]
    WantedBy=multi-user.target

Note: Commands like xmodmap, xev, showkey, dmesg, setkeycodes can help
you.   
 Here is a very good tutorial for adding extra keys : Extra Keyboard
Keys

Then you can assign the script for screen rotation to that button.

    # File: /usr/local/bin/screen_rotation.sh

    #!/bin/sh

    # Find the line in "xrandr -q --verbose" output that contains current screen orientation and "strip" out current orientation.

    rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"

    # Using current screen orientation proceed to rotate screen and input tools.

    case "$rotation" in
        normal)
        # rotate to the left
        xrandr -o left
        xsetwacom set "Serial Wacom Tablet WACf004 stylus" rotate ccw
        xsetwacom set "Serial Wacom Tablet WACf004 eraser" rotate ccw
        ;;
        left)
        # rotate to normal
        xrandr -o normal
        xsetwacom set "Serial Wacom Tablet WACf004 stylus" rotate none
        xsetwacom set "Serial Wacom Tablet WACf004 eraser" rotate none
        ;;
    esac

The assignment of the keycode to the script depends on your desktop
environment. For Gnome the assignment can be easily done in the Keyboard
preferences of custom shortcuts. If you are using another desktop
environment (such as XFCE, LXDE, Fluxbox ...) you can always use the
program xbindkeys.

> Screen auto-rotation

The auto-rotation of the screen does not work by default. First you have
to install the HDAPS package so as to get the values worked out by the
integrated 2-axis accelerometer of the Thinkpad X200. Then the following
script will enable you to use the accelerometer's data to automatically
rotate your screen :

    #!/bin/bash

    # (To have the exact names of these devices you should type the command : xsetwacom --list devices )
    stylus="Serial Wacom Tablet stylus" 
    eraser="Serial Wacom Tablet eraser"

    function rotate {
        if [ $# -lt 1 ]; then  # error ...
    	exit 1 
        fi

        case "$1" in
            up)
                nextRotate="none"
                nextOrient="normal" ;;
            down)
                nextRotate="half"
                nextOrient="inverted" ;;
    	right)
                nextRotate="ccw"
                nextOrient="left" ;;
    	left)
                nextRotate="cw"
                nextOrient="right";;
        esac

        # Rotate the screen      
        xrandr -o $nextOrient

        # Rotate the tablet                      
        xsetwacom set "$stylus" Rotate $nextRotate
        xsetwacom set "$eraser" Rotate $nextRotate
    }

    while true; do
        # 1) We extract data about the actual position
        position=$(cat /sys/devices/platform/hdaps/position)
        x=$(echo $position | sed -n "s/(\([-0-9]*\),\([-0-9]*\).*)/\1/p") # most of time contained in [350,650]
        y=$(echo $position | sed -n "s/(\([-0-9]*\),\([-0-9]*\).*)/\2/p") # most of time contained in [-650,-350]

        # 2) We work out the x value (= left and right inclination) (always between 
        if [ $x -lt 400 ]; then
    	rotate left
        elif [ $x -gt 600 ]; then
    	rotate right
        fi
        
        # 3) We work out the y value (= front and back inclination)
        if [ $y -gt -400 ]; then
    	rotate down
        elif [ $y -lt -600 ]; then
    	rotate up
        fi

        # 4) wait before checking the value again
        sleep 0.5
    done

Then you can run this script at the startup in order to make your screen
automatically rotate when you need it. For instance, you can use the
file ~/.fluxbox/startup on fluxbox, or the command :
gnome-session-properties if you are using Gnome 3).

> Power consumption and fan control

Note:There is a useful blog post describing possible measures to reduce
power consumption of a X200T to almost 7 Watt.

You might notice a beeping whilst your system is running. This is due to
missing fan control. Install the tlp package from AUR to enable
extensive fan and power consumption control.

You can further disable the nmi-watchdog by creating the file
/etc/tmpfiles.d/disable-nmi-watchdog.conf with the following line:

    w /proc/sys/kernel/nmi_watchdog - - - - 0

This will disable the watchdog at startup.

Additionally you might want to define different brightness level and
automatically dim your screen when you are running on battery. A DE and
WM independent solution is the usage of pm-utils. Detailed instructions
can be found here. They are tested to work with a X200T.

> Suspend to RAM

Suspend to RAM is working out of the box with the standard Arch Linux
kernel after installing pm-utils from extra.

    # pacman -S pm-utils

Issue the command

    # pm-suspend

as root to suspend to RAM. The laptop will wake up on any key press or
on opening the lid.

Note: Very seldom after resuming the backlight won't come back on. The
following page on ThinkWiki might provide information on how to solve
this issue: Problem with display remaining black after resume.

Unsupported
-----------

Unlike those on older models, the fingerprint reader on the X200
("Authentec 2810") is unsupported on linux as there are no working
drivers either in the kernel or outside[1].

Troubleshooting
---------------

> failed to execute '/usr/sbin/inputattach'

If you see the above error in your logs, copy
/usr/lib/udev/rules.d/70-wacom.rules to /etc/udev/rules.d/70-wacom.rules
and comment out SUBSYSTEM of inputattach.

> System feels unresponsive

If your system feels unresponsive and lagging, you can try creating a
file called /etc/modprobe.d/drm_kms.conf:

    options drm_kms_helper poll=N

> PM device: Resume from hibernation error: Failed to restore -19

This is likely to be related to the tpm_tis and tpm modules not being
properly unloaded before hibernation. These modules are required by the
device listed in the error as 00:0a:

    # dmesg | grep 00:0a
    [    0.377877] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
    [   10.746742] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
    [   10.746751] tpm_tis 00:0a: Intel iTPM workaround enabled
    [   10.866734] tpm_tis 00:0a: TPM is disabled/deactivated (0x6)

To unload the module create the following executable file called
/usr/lib/systemd/system-sleep/tpm.sh, assuming the use of the systemd
hibernation procedure:

    #!/bin/sh
    case $1/$2 in
      pre/*)
        echo "Going to $2..."
        modprobe -r tpm
        modprobe -r tpm_tis
        ;;
      post/*)
        echo "Waking up from $2..."
        modprobe tpm
        modprobe tpm_tis
        ;;
    esac

> mei_me 0000:00:03.0: suspend

If you are seeing this error, a workaround is to blacklist the mei and
mei_me modules. More information can be found here.

> pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:03:00

See #mei_me 0000:00:03.0: suspend.

> Uhhuh. NMI received for unknown reason 30.

The Thinkpad X200 is known to report the following error on resume from
hibernation or suspension:

    Uhhuh. NMI received for unknown reason 30.
    Dazed and confused, but trying to continue
    Do you have a strange power saving mode enabled?

In this case you can disable the high precision event timer (HPET) by
adding "nohpet" to your GRUB kernel parameter line.

See also
--------

-   Thinkwiki: X200 Overview
-   ThinkWiki: How to reduce power consumption

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X200&oldid=305985"

Category:

-   Lenovo

-   This page was last modified on 20 March 2014, at 17:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
