Acer Aspire Timeline 1825PTZ
============================

The Acer Aspire Timeline 1825PTZ is a Netvertible from Acer. Also look
at Acer Aspire Timeline 1810tz.

Contents
--------

-   1 Hardware
    -   1.1 /proc/cpuinfo
    -   1.2 lspci
-   2 Touchpad
-   3 Touchscreen
    -   3.1 rotate
    -   3.2 rotate back
-   4 Webcam
-   5 Audio

Hardware
========

/proc/cpuinfo
-------------

    processor	: 0
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 23
    model name	: Genuine Intel(R) CPU           U4100  @ 1.30GHz
    stepping	: 10
    cpu MHz		: 1300.000
    cache size	: 2048 KB
    physical id	: 0
    siblings	: 2
    core id		: 0
    cpu cores	: 2
    apicid		: 0
    initial apicid	: 0
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 13
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2
                     ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl 
                     est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm
    bogomips	: 2593.29
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

    processor	: 1
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 23
    model name	: Genuine Intel(R) CPU           U4100  @ 1.30GHz
    stepping	: 10
    cpu MHz		: 1300.000
    cache size	: 2048 KB
    physical id	: 0
    siblings	: 2
    core id		: 1
    cpu cores	: 2
    apicid		: 1
    initial apicid	: 1
    fpu		: yes
    fpu_exception	: yes
    cpuid level	: 13
    wp		: yes
    flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2
                     ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl 
                     est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm
    bogomips	: 2593.37
    clflush size	: 64
    cache_alignment	: 64
    address sizes	: 36 bits physical, 48 bits virtual
    power management:

lspci
-----

    00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
    00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
    00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
    00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
    00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
    01:00.0 Ethernet controller: Attansic Technology Corp. Device 1063 (rev c0)
    02:00.0 Network controller: Intel Corporation WiFi Link 100 Series

Touchpad
========

[1] Hi, I want to share my xorg config to solve this problem (xinput is
not the best approach ;P) so, on /etc/X11/xorg.conf you will find
something like this:

    Section "ServerLayout"
            Identifier     "X.org Configured"
            Screen      0  "Screen0" 0 0
            InputDevice    "Mouse0" "CorePointer"
            InputDevice    "SynapticsTouchpad" "SendCoreEvents"
            InputDevice    "Keyboard0" "CoreKeyboard"
    EndSection

(...) Remove (or comment) line 4 and 5, also you may remove the
respective Section "InputDevice"s. You do not want this because you have
/etc/X11/xorg.conf.d/10-synaptics.conf so lets add some options there,
this is my configuration (I've an Acer AS1410 laptop):

    Section "InputClass"
            Identifier "SynapticsTouchPad"
            Driver "synaptics"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/mouse*"
            Option "TapButton1" "1"
            Option "TapButton2" "2"
            Option "TapButton3" "3"
            Option "EmulateTwoFingerMinZ" "50"
            Option "EmulateTwoFingerMinW" "10"
            Option "AccelFactor" "0.01"
            Option "MinSpeed" "1.3"
            Option "MaxSpeed" "1.9"
    EndSection

Thats all, you only need to restart X ps: check /var/log/Xorg.0.log if
something is not working

Touchscreen
===========

When you rotate the touchscreen and want to rotate the desktop, the
touchscreen calibration is messed up. I have two scripts to rotate it
and rotate it back. They also recalibrate the touchscreen. You can bind
them to some key.

rotate
------

    #!/bin/bash
    device=`xinput list | grep Cando | grep -o 'id=[0-9]*' | sed 's/id=//'`

    xrandr --output LVDS1 --rotate left

    xinput set-prop --type=int --format=8 $device "Evdev Axes Swap" 1
    xinput set-prop --type=int --format=8 $device "Evdev Axes Inversion" 1 1
    xinput set-prop --type=int --format=32 $device "Evdev Axis Calibration" 10751 0 19 18925 

rotate back
-----------

    #!/bin/bash
    device=`xinput list | grep Cando | grep -o 'id=[0-9]*' | sed 's/id=//'`

    xrandr --output LVDS1 --rotate normal

    xinput set-prop --type=int --format=8 $device "Evdev Axes Swap" 0
    xinput set-prop --type=int --format=8 $device "Evdev Axes Inversion" 0 0
    xinput set-prop --type=int --format=32 $device "Evdev Axis Calibration" 1 18873 44 10751

Webcam
======

Works out of the box

    mplayer tv://

As mentioned in Acer_Aspire_Timeline_1810tz#Webcam you can add !uvcvideo
to rc.conf modules to prevent webcam from auto loading to save power.

I use following script to easy turn on/off webcam:

    #!/bin/bash

    if [ "$1" == "on" ]; then
            modprobe uvcvideo
    fi 

    if [ "$1" == "off" ]; then
            modprobe -r uvcvideo
    fi

    if [ "$1" == "show" ]; then
            mplayer tv://
    fi

    if [ "$1" == "" ]; then

            if [ "`lsmod | grep uvcvideo`" == "" ]; then
                    echo "cam status: off";
            else
                    echo "cam status: on";
            fi
    fi

  
 To turn on:

    > sudo cam on

To turn off:

    > sudo cam off

To check status:

    > cam
    cam status: off

To start mplayer showing the webcam:

    > cam show

Audio
=====

See ALSA.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_Timeline_1825PTZ&oldid=196482"

Category:

-   Acer

-   This page was last modified on 23 April 2012, at 12:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
