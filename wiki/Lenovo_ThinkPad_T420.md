Lenovo ThinkPad T420
====================

This article covers the installation and configuration of Arch Linux on
a Lenovo T420 laptop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Hardware                                                           |
|     -   2.1 Fingerprint reader                                           |
|     -   2.2 Some Media Keys                                              |
|     -   2.3 Untested                                                     |
|                                                                          |
| -   3 Laptop Settings                                                    |
|     -   3.1 ACPI                                                         |
|     -   3.2 Tp_smapi                                                     |
|     -   3.3 CPU Frequency Scaling                                        |
|     -   3.4 Fans                                                         |
|     -   3.5 Laptop Mode Tools                                            |
|     -   3.6 Synaptics                                                    |
|     -   3.7 NVIDIA Optimus                                               |
|     -   3.8 Optional kernel boot arguments                               |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Media Keys                                                   |
|     -   4.2 Rebind Forward and Back keys                                 |
|     -   4.3 Turn touchpad on and off                                     |
|     -   4.4 Volume up/down not changing volume                           |
|     -   4.5 Shutdown on Battery                                          |
|     -   4.6 Hang on Reboot                                               |
|     -   4.7 No Backlight Controls                                        |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

This laptop supports UEFI as well as the traditional BIOS.

There are no issues with installing Arch Linux with the latest Archiso.

The rest of the installation process can be followed with the official
install guide.

Hardware
--------

All hardware works out of the box except the following:

> Fingerprint reader

Fingerprint reader works great with fprint and PAM (installation of
fingerprint-gui recommended).

See Fprint#Setup_fingerprint-gui for more information.

> Some Media Keys

-   See below

> Untested

-   Firewire

Laptop Settings
---------------

> ACPI

ACPI is well supported here. No obvious troubleshoots.

> Tp_smapi

Unfortunately, tp_smapi is only partially supported on the Thinkpad
T420. A number of features work since version 0.41. For example, the
hard drive protection mechanism HDAPS now works well. See the linked
wiki entry.

Some features like setting the starting threshold for charging the
battery do not yet work. To control the battery charging thresholds,
install the Perl script tpacpi-bat from the AUR.

Insert the acpi_call kernel module by running

    modprobe acpi_call

Manually set the thresholds by calling

    perl /usr/lib/perl5/vendor_perl/tpacpi-bat -v startChargeThreshold 0 40
    perl /usr/lib/perl5/vendor_perl/tpacpi-bat -v stopChargeThreshold 0 80

The example values 40 and 80 given here are in percent of the full
battery capacity. Adjust them to your own needs. You may also want to
write a simple set-battery.service and enable it to set them at startup.
While these values should be permanent, they will be reset any time the
battery is removed.

    [Unit]
    Description=Set battery capacity

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/perl /usr/lib/perl5/vendor_perl/tpacpi-bat -v stopChargeThreshold 0 80
    ExecStart=/usr/bin/perl /usr/lib/perl5/vendor_perl/tpacpi-bat -v startChargeThreshold 0 40

    [Install]
    WantedBy=multi-user.target

Also, if you are dual booting with Windows, you can still control the
battery charging thresholds with Lenovo's Power Manager which
communicates directly to the battery controller.

When using systemd, you may want to blacklist the tp_smapi module if
your systemd-modules-load.service fails, as new ThinkPads handle
everything over acpi.

> CPU Frequency Scaling

CPU frequency scaling is fully supported with all of the available
processor models with this laptop.

> Fans

The thinkpad_acpi kernel module needs to be configured so user space
programs can control the fan speed.

    /etc/modprobe.d/thinkpad_acpi.conf

    options thinkpad_acpi fan_control=1

The thinkfan configuration file also needs to know how to set the fan
speed. Replace the default sensor settings with the following.

    /etc/thinkfan.conf

    sensor /sys/devices/virtual/thermal/thermal_zone0/temp

You can add or remove services by editing the DAEMONS array in your
/etc/rc.conf file. It will initially look something like this:

    DAEMONS=(...@thinkfan...)

Or, if you are using systemd, simply type

    # systemctl enable thinkfan.service

> Laptop Mode Tools

No significant issues were found using Laptop Mode Tools.

Possible bug with Lenovo_ThinkPad_T420#Shutdown on Battery

tlp From the AUR is an alternative tool that can replace
laptop-mode-tools.

> Synaptics

TouchPad and TrackPoint do work out of the box, but the TouchPad is way
too sensitive (i.e. fast) to be usable, since it is recognized as a
mouse. To fix this, install the xf86-input-synaptics package and add the
following two files to your /etc/X11/xorg.conf.d/ directory:

    50-thinkpad-trackpoint.conf

     Section "InputClass"
            Identifier      "ThinkPad TrackPoint"
            MatchProduct    "TPPS/2 IBM TrackPoint"
            MatchDevicePath "/dev/input/event*"
            Option          "EmulateWheel"          "true"
            Option          "EmulateWheelButton"    "2"
            Option          "XAxisMapping"          "6 7"
            Option          "YAxisMapping"          "4 5"
     EndSection

    50-twofingerscroll.conf

     Section "InputClass"
            Identifier      "two finger scrolling"
            Driver          "synaptics"
            MatchProduct    "SynPS/2 Synaptics TouchPad"
            MatchDevicePath "/dev/input/event*"
            Option          "VertTwoFingerScroll"   "on"
            Option          "HorizTwoFingerScroll"  "on"
            Option          "EmulateTwoFingerMinW"  "8"
            Option          "EmulateTwoFingerMinZ"  "40"
            Option          "TapButton1"            "1"
     EndSection

Adjust to your own needs. Read Touchpad Synaptics for more information.

To adjust the speed/sensitivity of the TrackPoint add these lines in
your /etc/rc.local script:

    /etc/rc.local

    TPDEV=/sys/devices/platform/i8042/serio1
    echo -n 180 > $TPDEV/speed
    echo -n 200 > $TPDEV/sensitivity

Possible range of values are 1-255.

> NVIDIA Optimus

Bumblebee works as intended on models with NVIDIA Optimus

> Optional kernel boot arguments

Using the following kernel boot parameters reduces battery drain:

    i915.i915_enable_rc6=1
    i915.i915_enable_fbc=1
    i915.lvds_downclock=1 
    i915.semaphores=1

Note: With the current 3.6.x kernels, there appears to be a power
regression with an unknown cause. It is yet to be fixed in any 3.7
versions of the kernel.

Troubleshooting
---------------

> Media Keys

Media keys that work out of the box:

-   Wireless On/Off
-   Backlight Brightness settings
-   Thinklight
-   Mute

Media Keys that Do Not work out of the box:

-   Volume keys (Works out-of-the-box in Gnome)
-   Microphone mute (Will most likely require a custom kernel patch)

You must find a workaround and bind the keys yourself for the rest of
them.

> Rebind Forward and Back keys

Keys forward and back (next to cursor keys) can be easily remapped to
PageDown/PageUp.

Install xmodmap with the package xorg-server-utils

Create a ~/.Xmodmap file with content:

    keysym XF86Back = Page_Up
    keysym XF86Forward = Page_Down

Add this line to your ~/.xinitrc to make it work:

    xmodmap ~/.Xmodmap

You can also re-map AudioPrev (Fn+Left) and AudioNext (Fn+Right) to
Home/End:

    keysym XF86AudioNext = End
    keysym XF86AudioPrev = Home

Note:You have to log out for the changes to take effect.

Note:The keys should work out of the box, at least on KDE.

> Turn touchpad on and off

For some, the (Fn+F8) key does not switch the touchpad on and off. Here
is a simple keybind to add to your ~/.xbindkeysrc for keys to quickly
change your touchpad state. For these to take effect, run xbindkeysrc.
This binds Fn+F8 to 'toggle the touchpad on and off'. (Tested in i3wm
and xfce4, where normal Fn+F8 does not toggle the touchpad)

    # Toggle the Touchpad on|off
    "synclient TouchpadOff=`synclient -l | grep -ce TouchpadOff.*0`"
       m:0x0 + c:199
       XF86TouchpadToggle

> Volume up/down not changing volume

Another quick keybind for ~/.xbindkeysrc to change the volume (which
does not work on some DEs). Again, run xbindkeys for these to take
effect. Taken from Xbindkeys

    #increase volume
    "amixer set Master playback 1+"
       m:0x0 + c:123
       XF86AudioRaiseVolume

    #decrase volume
    "amixer set Master playback 1-"
       m:0x0 + c:122
       XF86AudioLowerVolume

Also, while the mute button works, I rebound it to interface with ALSA.

    # Toggle mute
    "amixer set Master toggle"
       m:0x0 + c:121
       XF86AudioMute

> Shutdown on Battery

Some users have reported that the T420 was rebooting on shutdown on
battery power. There have been quite a few attempts to fix this. Three
are detailed here.

One way is to disable the module ehci_hcd. See
Kernel_modules#Blacklisting for more information.

Or try disable Laptop-mode. Add !laptop-mode to the DAEMONS array in
/etc/rc.conf:

    DAEMONS=(...!laptop-mode...)

This forum post details another way to have your computer not reboot on
shutdown. Turning off the laptop-mode daemon causes battery life to
suffer, so when on the move and in need of a simple way to shutdown,
this seems to work better.

> Hang on Reboot

This is a problem on many laptops and can be fixed by blacklisting the
e1000e kernel module.

> No Backlight Controls

One user has reported that the brightness controls (fn+home, fn+end) did
not work in some desktop environments. This could be fixed by adding the
following kernel options:

    acpi_backlight=vendor acpi_osi=Linux

See also
--------

-   Lenovo ThinkPad T420s
-   Arch Linux on ThinkPad T420i

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T420&oldid=247933"

Category:

-   Lenovo
