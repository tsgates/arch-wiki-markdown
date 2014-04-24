Lenovo ThinkPad X120e
=====================

Summary help replacing me

Installation instructions for the Lenovo ThinkPad X120e

Should work for X121e too

Related articles

IBM ThinkPad X100e

Contents
--------

-   1 CPU
-   2 Video drivers
-   3 Wireless
-   4 Audio
-   5 Input
    -   5.1 TrackPoint scrolling (wheel emulation)
    -   5.2 Disabling the TrackPad
    -   5.3 TrackPoint speed and sensitivity
-   6 Power saving
    -   6.1 Disable Bluetooth
    -   6.2 ATI video card powersaving
    -   6.3 CPU undervolting
        -   6.3.1 Using PHC
        -   6.3.2 Using tpc
    -   6.4 Fan control
-   7 Suspend and hibernation
-   8 See also

CPU
---

The AMD CPU used on the X120e is microcode-upgradeable. To enable this
functionality install the amd-ucode packages (available on extra) and
add microcode to the MODULE list on /etc/rc.conf.

Video drivers
-------------

Users have the choice between the open source ATI video driver or the
closed source Catalyst video driver.

Wireless
--------

The Thinkpad x120e is available with one of two wireless cards.

-   The Realtek BGN Wifi card is currently supported out of the box by
    the rtl8192ce driver, which was integrated into the Linux kernel as
    of version 3.2. This card, however, suffers from access point
    association and connection stability problems, especially in meshed
    wireless networks due to poor wireless radius detection. Since
    driver development by Realtek effectively stopped as of January
    2012, the general consensus among many owners online has been to
    swap out this wireless card for a different better supported
    half-mini PCI card such as the Intel 6230. This however requires a
    BIOS patch to remove Lenovo's hardware restriction on which wireless
    cards can be used in the computer. More information in regards to
    that can be found in this thread.

-   The Broadcom ABGN Wifi card is currently supported by the b43
    driver. This driver is recommended over the broadcom-wl.

Audio
-----

The kernel modules work, but the HDMI audio is the primary device (not
the speaker). You can swap that:

    $ vim ~/.asoundrc

    defaults.pcm.card 1
    defaults.pcm.device 0
    defaults.ctl.card 1

Note: Alternatively, you can accomplish the same thing by configuring
the snd-hda-intel module:

    $ grep snd-hda-intel /etc/modprobe.d/snd-hda-intel.conf

    options snd-hda-intel index=1

By specifying index you should no longer specify the default in
~/.asoundrc.

Input
-----

> TrackPoint scrolling (wheel emulation)

To enable scrolling with the TrackPoint while holding down the middle
mouse button, create a new file /etc/X11/xorg.conf.d/20-thinkpad.conf
with the following content:

    Section "InputClass"
        Identifier	"Trackpoint Wheel Emulation"
        MatchProduct	"TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device"
        MatchDevicePath	"/dev/input/event*"
        Option		"EmulateWheel"		"true"
        Option		"EmulateWheelButton"	"2"
        Option		"Emulate3Buttons"	"false"
        Option		"XAxisMapping"		"6 7"
        Option		"YAxisMapping"		"4 5"
    EndSection

There are more details about how this works on the Xorg page.

> Disabling the TrackPad

If you try to use your x120e lying down you will notice its very easy to
hit the TrackPad buttons and invert the functionality of the other
inputs(fun).

Install xf86-input-synaptics from the official repositories.

You can now toggle the TrackPads functionality using the synclient
utility:

    $ synclient TouchpadOff=0 ; enables
    $ synclient TouchpadOff=1 ; disables

If you want this to be permanent add the option to your
/etc/X11/xorg.conf.d/10-synaptics.conf:

            Option          "TouchpadOff"             "1"

Also, you can use this script for change touchpad status:

     #!/bin/sh
     tstat=$(xinput list-props "SynPS/2 Synaptics TouchPad" | awk '/Synaptics Off/ { print $NF }')
     if [ $tstat = 0 ]; then
         synclient TouchpadOff=1
     else
         synclient TouchpadOff=0
     fi

> TrackPoint speed and sensitivity

You can up your trackpoint speed with next command:

    $ xinput --set-prop 13 'Device Accel Profile' 6

If you want this to be permanent speed up add the option to your
/etc/X11/xorg.conf.d/20-thinkpad.conf (if this is your X11 trackpoint
config, of course):

    Option		"AccelerationProfile"   "6"

To more acceleration profile read man "xorf.conf.d"

Power saving
------------

See power saving.

> Disable Bluetooth

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Using rfkill is  
                           the correct way to do    
                           this. (Discuss)          
  ------------------------ ------------------------ ------------------------

Note:You must first have the thinkpad_acpi kernel module loaded.

To save some power you can disable Bluetooth:

    # tee <<< disable /proc/acpi/ibm/bluetooth

If you want to disable Bluetooth at every boot just add that line to
/etc/rc.local

> ATI video card powersaving

Under the opensource ATI video card driver you can control the
clockspeed of the GPU. The recommended setting is:

    echo dynpm > /sys/class/drm/card0/device/power_method

This enables dynamic frequency switching based off of GPU load. Further
information on this topic can be found in ATI#Powersaving.

> CPU undervolting

Warning:Undervolting can lead to instability and consequently data loss,
only you are responsible if you break something

Using PHC

The Fusion Processor can be undervolted with the PHC-K8 tool. See PHC
for usage information. For the AMD Fusion you'll want to download phc-k8
from the AUR.

Note:In order to lower CPU power usage you must actually raise the PHC
values. (somewhat counter-intuitive)

"24 26 52" is what I have my E-350 set to. The three numbers represent
1600mhz, 1200mhz and 800mhz.

Warning:The three values listed above are stable on MY processor. Due to
variables during production, you're chip may be able to be undervolted
more or LESS. Feel free to post the stable values that you reach to this
wiki.

Using tpc

Another method for undervolting is tpc. It is more intuitive then PHC
tool and needs Kernelmodule cpuid and msr.

Information output available cores and current frequencies and voltage:

    # tpc -l

Example how to use:

Warning:DO THIS AT YOUR OWN RISK!!!! DON'T USE THIS VALUES!!! Approach
yourself to values whitch are working for you! This is just an example
how to use tpc

    # tpc -set core all pstate 2 frequency 825 vcore 0.825   
    # tpc -set core all pstate 1 frequency 1320 vcore 1.2250
    # tpc -set core all pstate 0 frequency 1650 vcore 1.3000

> Fan control

The X120e's fan spins constantly but luckily can be controlled by the
user.

Warning:Modify fan settings at your own risk, only you are responsible
if you toast your laptop or your lap.

Note:Even with undervolting the APU produces enough heat to have to
occasionally run the fan even at idle.

To enable manual fan control place the following into
/etc/modprobe.d/modprobe.conf:

    options thinkpad_acpi fan_control=1

Now you have to reload thinkpad_acpi module or reboot your netbook.

    # rmmod thinkpad_acpi && modprobe thinkpad_acpi

Now it should look like that:

    # cat /proc/acpi/ibm/fan 
    status:		disabled
    speed:		0
    level:		0
    commands:	level <level> (<level> is 0-7, auto, disengaged, full-speed)
    commands:	enable, disable
    commands:	watchdog <timeout> (<timeout> is 0 (off), 1-120 (seconds))

  
 At this point the fan will still be safely under the system's control.
You can either directly modify the values in /proc/acpi/ibm (NOT
RECOMMENDED. e.g. 'echo level 1 > /proc/acpi/ibm/fan') or install a fan
control daemon such as thinkfan from the AUR.

Suspend and hibernation
-----------------------

Suspend works out of the box, but hibernate may fail - the system
usually hangs with a black screen and a blinking power button led. To
fix this we need to modify the hibernation mode; using pm-utils is just
a matter of creaing a file /etc/pm/config.d/hibernate_mode containing a
single line:

    HIBERNATE_MODE="shutdown"

See also
--------

X120e on ThinkWiki Undervolting the AMD Fusion with PHC-tool

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X120e&oldid=281856"

Category:

-   Lenovo

-   This page was last modified on 7 November 2013, at 13:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
