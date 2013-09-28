Lenovo ThinkPad X61T
====================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

As the x61t is a Core 2 Duo, i'm going to install Arch x86_64 on it.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preparation of machine for Linux installation                      |
| -   2 No optical drive installation                                      |
|     -   2.1 Preferred method, IMG files                                  |
|     -   2.2 Deprecated/Old method, ISO files                             |
|         -   2.2.1 Preparation of Installation medium                     |
|                                                                          |
|     -   2.3 Boot USB harddrive on thinkpad x61t                          |
|     -   2.4 proceed with installation as you wish                        |
|                                                                          |
| -   3 Specific Hardware Setup                                            |
|     -   3.1 Sound                                                        |
|     -   3.2 Ethernet                                                     |
|     -   3.3 Firewire                                                     |
|     -   3.4 USB                                                          |
|     -   3.5 Power Management                                             |
|         -   3.5.1 suspend machine                                        |
|                                                                          |
|     -   3.6 Wireless network device                                      |
|     -   3.7 Xorg                                                         |
|     -   3.8 Stylus                                                       |
|     -   3.9 Trackpoint                                                   |
|         -   3.9.1 Press to Select                                        |
|         -   3.9.2 Sensitivity & Speed                                    |
|                                                                          |
|     -   3.10 SD card reader                                              |
|     -   3.11 Fingerprint Reader                                          |
|     -   3.12 CPU Frequency Scaling                                       |
|     -   3.13 Bluetooth                                                   |
+--------------------------------------------------------------------------+

Preparation of machine for Linux installation
---------------------------------------------

-   make backup of 1st primary partition if possible. this is the
    recovery tools from Lenovo/IBM - do not remove it... with grub you
    can later set it to be accessible!
-   resize NTFS parition with MS Windows Vista or remove it completely
    from drive ... make space at the end of the hard drive for Arch
    Linux (in my case 80 GB hard drive 24GB Linux / and /home)

No optical drive installation
-----------------------------

As I do not have an optical drive and the x61t has no optical drive
itself, the installation was done from an external USB storage device
(hard drive or USB key).

> Preferred method, IMG files

Since Arch Linux release 2008.06 Arch Linux has provided USB images. If
you want to install Arch from an older ISO image please refer to
Deprecated/Old method, ISO files

Download Arch's latest installation img from your local mirror. Insert
an empty or expendable USB stick and determine its path. Then dd the
.img to the USB stick like this:

    dd if=archlinux-2008.06-[core_or_ftp]-i686.img of=/dev/sdx

where if= is the path to the img file and of= is your USB device. Make
sure to use /dev/sdx and not /dev/sdx1.

Note:This will irrevocably delete all files on your USB stick, so make
sure you do not have any important files on the stick before doing this.

Continue with Boot USB harddrive on thinkpad x61t

> Deprecated/Old method, ISO files

Preparation of Installation medium

-   Requirements
    -   packages: util-linux (provides cfdisk), syslinux, dosfstools
        (provides mkdosfs)
    -   running Arch Linux on a machine to prepare installation medium
    -   access to internet

-   use cfdisk to create a primary FAT16 Partition (type=0c) on the usb
    stick and make it bootable
-   use

    mkdosfs /dev/sdXY

to create a file system on the partition and then mount it

    mount -t msdos /dev/sdXY /media/installharddrive

-   download Arch Linux installation ISO base from internet and mount it
    locally:

    mount -t iso9660 -o loop /path/to/archlinux.iso /media/iso

-   copy content from ISO to the installation harddrive:

    cp -ra /media/iso/* /media/installharddrive

and copy isolinux files to root of partition:

    cp /media/installharddrive/isolinux/* /media/installharddrive/

then rename isolinux.cfg to syslinux.cfg

    mv /media/installharddrive/isolinux.cfg /media/installharddrive/syslinux.cfg 

-   unmount installation harddisk
-   install syslinux to partition

    syslinux -s /dev/sdXY

> Boot USB harddrive on thinkpad x61t

Press F12 on the keyboard when you see the Thinkpad logo post screen.
Then select the USB key from menu.

> proceed with installation as you wish

see for details Official_Arch_Linux_Install_Guide

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

Ethernet
--------

works out of the box - autoloaded module: e1000

    e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
    e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
    e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO

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

get packages

    pacman -S iwlwifi iwlwifi-4965-ucode

arch loads the module

    iwl4965

and wireless works fine

Xorg
----

-   works with xf86-video-intel

Stylus
------

Is a wacom on serial. install from AUR linuxwacom then add to xorg.conf

           InputDevice     "stylus" "SendCoreEvents"
           InputDevice     "eraser" "SendCoreEvents"
           InputDevice     "cursor" "SendCoreEvents"
           InputDevice     "touch"  "SendCoreEvents"

to ServerLayout

and

    Section "InputDevice"
           Driver "wacom"
           Identifier "stylus"
           Option "Device" "/dev/ttyS0" # SERIAL ONLY
           Option "Type" "stylus"
           Option "ForceDevice" "ISDV4" # Tablet PC ONLY
    EndSection
    Section "InputDevice"
           Driver "wacom"
           Identifier "eraser"
           Option "Device" "/dev/ttyS0" # SERIAL ONLY
           Option "Type" "eraser"
           Option "ForceDevice" "ISDV4" # Tablet PC ONLY
    EndSection
    Section "InputDevice"
           Driver "wacom"
           Identifier "cursor"
           Option "Device" "/dev/ttyS0" # SERIAL ONLY
           Option "Type" "cursor"
           Option "ForceDevice" "ISDV4" # Tablet PC ONLY
    EndSection
    Section "InputDevice"
           Identifier "touch"
           Driver "wacom"
           Option "Device" "/dev/ttyS0" # SERIAL ONLY
           Option "Type" "touch"
           Option "ForceDevice" "ISDV4" # Tablet PC ONLY
           Option "BottomX" "915" # Must set to enable the hole
           Option "BottomY" "950" # screen as a touch screen.
           Option "TopX" "48"     # Without them there is a margin
           Option "TopY" "79"     # of two cm around the edge without input
    EndSection

and it works. However please note that the multitouch support is not
perfect...

Xorg log tells a little bit more info:

    (==) Wacom General ISDV4 tablet speed=9600 maxX=24576 maxY=18432 maxZ=255 resX=2540 resY=2540  tilt=disabled
    (==) Wacom device "cursor" top X=0 top Y=0 bottom X=24576 bottom Y=18432
    (==) Wacom device "eraser" top X=0 top Y=0 bottom X=24576 bottom Y=18432
    (==) Wacom device "stylus" top X=0 top Y=0 bottom X=24576 bottom Y=18432

so this device has 255 sensitivity steps and has a resolution of 2540 x
2540 it tells you also that the screen size is 245.76 mm times 184.32 mm
big. if in xorg.conf the DisplaySize is not set by X -configure, you can
add the following line in the Monitor section:

    DisplaySize       245   185 

this helps some apps to determine the resolution of your monitor ("dpi
value") and set the sizes of objects or fonts right (e.g. in the 1:1
mode where something printed should equal something seen on the display)

  

AUTOMATIC ROTATION (added by bbs) -- for automatic rotation consider the
script found here -- thanks to Luke -- this script works well.

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
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X61T&oldid=254493"

Category:

-   Lenovo
