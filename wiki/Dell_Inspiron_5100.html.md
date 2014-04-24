Dell Inspiron 5100
==================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is based on my experience with arch on my Dell Inspiron 5100
laptop. Most of this information should apply to other 5xxx series
Inspiron laptops and similar generation laptops in general.

Contents
--------

-   1 Hardware
-   2 Kernel
    -   2.1 Initrd
-   3 Networking
    -   3.1 Wired
    -   3.2 Wireless
    -   3.3 Modem
-   4 Power Management
    -   4.1 ACPI
    -   4.2 CPU frequency scaling
-   5 Xorg
-   6 See also

Hardware
--------

Audio: Intel 82801DB AC'97 Audio

Video: ATi Radeon Mobility M7

Modem: Broadcom BCM v.92 56k WinModem

Wired NIC: Broadcom BCM4401

Wireless NIC: Intel IPW 2200 (*note most of these laptops came with a
Dell Truemobile 1300 card. aka Broadcom 4320.)

Kernel
------

The stock arch kernel contains everything you need to get this laptop
running.

> Initrd

Initrd will soon be part of current. Luckily there are no problems
setting up this laptop with initrd. The following is my mkinitrd.conf,
this is all you need if your root file system is formated ext3.

    # Initial Ramdisk setup
    # Attention:
    # You need only the stuff to be able to mount your root device!
    # USB/FW are only needed if you boot from such devices!
    # Disable whole subsystems by setting to "1"
    REMOVE_IDE=
    REMOVE_SCSI=1
    REMOVE_SATA=1
    REMOVE_CDROM=1
    REMOVE_USB=1
    REMOVE_FW=1
    REMOVE_RAID=1
    REMOVE_DM=1
    REMOVE_FS=

    # Define which modules are needed by adding "moduleX moduleY"
    # If left empty, all modules are included if they are not disabled above
    HOSTCONTROLLER_IDE=piix
    HOSTCONTROLLER_SCSI=
    HOSTCONTROLLER_SATA=
    HOSTCONTROLLER_USB=
    FILESYSTEMS=ext3

    # If you have an encrypted root filesystem, set it here
    CRYPT_DEVICE=

    # If you use software RAID for your root device (must be /dev/md0) then
    # list all the devices that belong to your /dev/md0 array here
    #    eg, RAID_DEVICES="/dev/hda3 /dev/hdc3"
    RAID_DEVICES=

    # Define additional modules here
    ADD_MODULE=
    REMOVE_MODULE=

Networking
----------

> Wired

Works fine using the b44 module.

> Wireless

My ipw2200 card works fine with the ipw2200 module.

The Truemobile 1300 card requires ndiswrapper I believe.

> Modem

The modem is believed to be a Broadcom BCM v.92 56k WinModem. The FCC
sticker on the bottom of my laptop labels is as a BCM9415M. Its a
winmodem and is on an intel AC'97 AMR interface. I do not use is and I
do not plan to. A quick google search says the best way to get this
modem working is buy a different one.

Power Management
----------------

> ACPI

This laptop seems to have the same acpi issues that plague most dell
laptops running linux. The i8k driver works for this laptop as it does
for most dell laptops. Add i8k to your modules array in rc.conf to
enable it.

    MODULES=(!usbserial !ide-scsi p4_clockmod i8k evdev)

You'll probably also want to run the i8kmon daemon since the bios
doesn't turn the cooling fan on until the cpu is about 70°C.

    pacman -S i8kmon

Then add i8kmon to your daemons array to start it at boot.

    DAEMONS=(syslog-ng network portmap !netfs crond alsa acpid cupsd cpufreq i8kmon)

The 5100 only has one fan where the original i8k had 2 and the driver is
looking to control both fans. It probably doesn't make a difference but
I disable the second fan in the i8kmon config file
/etc/i8kutils/i8kmon.conf

    # Temperature thresholds: {fan_speeds low_ac high_ac low_batt high_batt}
    set config(0)   {{- 0}  -1  60  -1  65}
    set config(1)   {{- 1}  50  70  55  75}
    set config(2)   {{- 2}  60  80  65  85}
    set config(3)   {{- 2}  70 128  75 128}

i8kmon sees the fan as the right fan. The - in the left fan position
means it will leave that fan alone.

> CPU frequency scaling

These laptops use a standard desktop p4 processor, no wonder they get so
hot. The processor supports throttling by way of the p4_clockmod module.
Add p4_clockmod to your modules array to enable it.

    MODULES=(!usbserial !ide-scsi p4_clockmod i8k evdev)

See the main CPU Frequency Scaling article.

Xorg
----

hwd does a pretty good job of generating the xorg.conf for you. You
should be able to use its config to start up X and get going but there
are a few things you can do to optimize it.

The laptop has an ati radeon card (I believe some of the more optioned
up versions have an nvidia card) but its a mobility m7 and is not
supported by the radeon package in community so you need to stick with
the driver that ships with the kernel.

The big changes you'll need to make are for the synaptics touchpad. Yes
the touchpad will work fine if you just leave it as a generic ps/2 mouse
but with the synaptics driver in extra there is no reason not to unlock
all of its features. Personally the tap click feature drives me crazy so
I have it disabled in my config, but you can probably figure out what
the different parameters do and change them to suit your taste

    Section "Input Device"
           Identifier  "Synaptics Mouse"
           Driver      "synaptics"
           Option      "Device"              "/dev/psaux"
           Option      "Protocol"            "auto-dev"
           Option      "LeftEdge"            "1700"
           Option      "RightEdge"           "5300"
           Option      "TopEdge"             "1700"
           Option      "BottomEdge"          "4200"
           Option      "FingerLow"           "25"
           Option      "FingerHigh"          "30"
           Option      "MaxTapTime"          "0"
           Option      "MaxTapMove"          "220"
           Option      "MaxDoubleTapTime"    "0"
           Option      "FastTaps"            "on"
           Option      "VertScrollDelta"     "100"
           Option      "HorizScrollDelta"    "100"
           Option      "MinSpeed"            "0.09"
           Option      "MaxSpeed"            "0.18"
           Option      "AccelFactor"         "0.0015"
           Option      "EmulateMidButtonTime""100"
           Option      "EdgeMotionMinZ"      "30"
           Option      "EdgeMotionMaxZ"      "35"
           Option      "EdgeMotionMinSpeed"  "0"
           Option      "EdgeMotionMaxSpeed"  "0"
           Option      "EdgeMotionUseAlways" "off"
           Option      "TapButton1"          "1"
           Option      "RBCornerButton"      "3"
           Option      "LBCornerButton"      "2"
           Option      "CoastingSpeed"       "0.1"
           Option      "SHMConfig"           "on"
    EndSection

To use this you'll need to add an InputDevice line in your server layout
section to use the synaptics mouse.

    InputDevice    "Synaptics Mouse" "CorePointer"

Remember you can only have one CorePointer so if you already have a
configured mouse with the "CorePointer" value, set one to
"SendCoreEvents", e.g.

    InputDevice    "Mouse1"          "CorePointer"
    InputDevice    "Synaptics Mouse" "SendCoreEvents"

See also
--------

-   This report has been listed in the Linux Laptop and Notebook
    Installation Survey: DELL.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_5100&oldid=231892"

Category:

-   Dell

-   This page was last modified on 26 October 2012, at 23:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
