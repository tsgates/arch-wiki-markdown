Lenovo ThinkPad X61T
====================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: All info already 
                           covered by Beginners'    
                           guide and Laptop.        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

As the x61t is a Core 2 Duo you can install Arch x86_64 on it.

Contents
--------

-   1 Preparation of machine for Linux installation
-   2 No optical drive installation
    -   2.1 Boot USB harddrive on thinkpad x61t
    -   2.2 proceed with installation as you wish
-   3 Specific Hardware Setup
    -   3.1 Sound
    -   3.2 Firewire
    -   3.3 USB
    -   3.4 Power Management
        -   3.4.1 suspend machine
    -   3.5 Wireless network device
    -   3.6 Xorg
    -   3.7 Stylus
    -   3.8 Trackpoint
        -   3.8.1 Press to Select
        -   3.8.2 Sensitivity & Speed
    -   3.9 SD card reader
    -   3.10 Fingerprint Reader
    -   3.11 CPU Frequency Scaling
    -   3.12 Bluetooth

Preparation of machine for Linux installation
---------------------------------------------

-   make backup of 1st primary partition if possible. this is the
    recovery tools from Lenovo/IBM - do not remove it... with grub you
    can later set it to be accessible!
-   resize NTFS partition with MS Windows Vista or remove it completely
    from drive ... make space at the end of the hard drive for Arch
    Linux (in my case 80 GB hard drive 24GB Linux / and /home)

No optical drive installation
-----------------------------

As I do not have an optical drive and the x61t has no optical drive
itself, the installation was done from an external USB storage device
(hard drive or USB key).

Download Arch's latest installation img from your local mirror. Insert
an empty or expendable USB stick and determine its path. Then dd the
.img to the USB stick like this:

    dd if=archlinux-2008.06-[core_or_ftp]-i686.img of=/dev/sdx

where if= is the path to the img file and of= is your USB device. Make
sure to use /dev/sdx and not /dev/sdx1.

Note:This will irrevocably delete all files on your USB stick, so make
sure you do not have any important files on the stick before doing this.

Continue with Boot USB harddrive on thinkpad x61t

> Boot USB harddrive on thinkpad x61t

Press F12 on the keyboard when you see the Thinkpad logo post screen.
Then select the USB key from menu.

> proceed with installation as you wish

see for details Installation guide

Specific Hardware Setup
=======================

Sound
-----

Used to work out of the box - following modules were loaded
automatically

    [damir@Apollon Arch]$ lsmod | grep snd
    snd_seq_oss            32896  0
    snd_seq_midi_event      7808  1 snd_seq_oss
    snd_seq                55680  4 snd_seq_oss,snd_seq_midi_event
    snd_seq_device          7956  2 snd_seq_oss,snd_seq
    snd_hda_intel         347940  4
    snd_pcm_oss            44576  0
    snd_pcm                82568  3 snd_hda_intel,snd_pcm_oss
    snd_timer              22536  3 snd_seq,snd_pcm
    snd_page_alloc          8720  2 snd_hda_intel,snd_pcm
    snd_mixer_oss          16896  1 snd_pcm_oss
    snd                    57064  14          
    snd_seq_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss
    soundcore               7968  1 snd

  
 However, lately, one must set the model of the sound system to thinkpad
in the file: /etc/modprobe.d/modprobe.conf Create that file, and set the
contents to:

     options snd-hda-intel model=thinkpad

Firewire
--------

works out of the box

USB
---

works out of the box

Power Management
----------------

> suspend machine

    pm-suspend

works (keyboard, mouse, stylus, sound, network) with one detail: when in
X, the display lamp is not turned on. workaround: ctrl-alt-f1 to switch
to vesa frame buffer turns the lamp on and when switching back to
ctrl-alt-f7 the X has then the lamp turned on as well. no idea why this
happens.

Wireless network device
-----------------------

Wifi work fine out of the box.

Xorg
----

-   works with xf86-video-intel

Stylus
------

Is a wacom on serial. install xf86-input-wacom from Arch repository and
it should work. By default it doesnt work very well on the sides of the
screen, but you can adjust it using xsetwacom.

    xsetwacom --list

to find out what is the name and number of your wacom and then

    xsetwacom set [name_or_number] Area 0 0 24576 18432

you can find out your defaults with get Area instead of set and if you
break something just use

    xsetwacom set 12 ResetArea

  
 AUTOMATIC ROTATION (added by bbs) -- for automatic rotation consider
the script found here -- thanks to Luke -- this script works well.

please note you must update your handler.sh for the acpi events to
properly call this script -- contact unk.nown [at] unix [dot] net -- if
you have any questions

Trackpoint
----------

> Press to Select

Press to Select allows you to tap the control stick which will simulate
a left click. You can enable this feature by typing the following in to
a terminal (you may need to be root):

    echo -n 1 > /sys/devices/platform/i8042/serio1/press_to_select 

If you want to enable Press to Select at boot then add the previuos line
to /etc/rc.local.

Disable it in a similar manner:

    echo -n 0 > /sys/devices/platform/i8042/serio1/press_to_select

> Sensitivity & Speed

Adjusting the speed and sensitivity of the TrackPoint requires echoing a
value between 0 and 255 into the appropriate file. For example, for a
speed of 120 and a sensitivity of 250, type the following into a
terminal:

    echo -n 120 > /sys/devices/platform/i8042/serio0/serio2/speed 
    echo -n 250 > /sys/devices/platform/i8042/serio0/serio2/sensitivity

SD card reader
--------------

Works out of the box.

    sdhci: Secure Digital Host Controller Interface driver
    sdhci: Copyright(c) Pierre Ossman
    sdhci: SDHCI controller found at 0000:05:00.2 [1180:0822] (rev 21)

Device is located at:

    /dev/mmcblk0

Fingerprint Reader
------------------

    USB ID 0483:2016

Works fine with the ThinkFinger binary drivers version 0.3. i will
include the thinkfinger pkg in [extra].

CPU Frequency Scaling
---------------------

See the CPU Frequency Scaling article.

Bluetooth
---------

Works after following Bluetooth page. (If you have this option
installed)

    #lsusb
       Bus 003 Device 002: ID 0a5c.2110 Broadcom Corp. Bluetooth Controller

To deactivate bluetooth:

    echo 0 > /sys/devices/platform/thinkpad_acpi/bluetooth_enable 

or to enable:

    echo 1 > /sys/devices/platform/thinkpad_acpi/bluetooth_enable

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X61T&oldid=302860"

Category:

-   Lenovo

-   This page was last modified on 2 March 2014, at 08:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
