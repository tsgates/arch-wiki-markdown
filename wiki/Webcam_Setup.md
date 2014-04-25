Webcam Setup
============

This is a guide to setting up your webcam in Arch Linux.

Contents
--------

-   1 Linux webcam support
-   2 Identify your webcam
    -   2.1 pwc
    -   2.2 qc-usb
    -   2.3 qc-usb-messenger
    -   2.4 zr364xx
    -   2.5 sn9c102
    -   2.6 gspca
    -   2.7 stv680
    -   2.8 linux-uvc
    -   2.9 ov51x-jpeg
    -   2.10 r5u870 (Ricoh)
    -   2.11 stk11xx (Syntek)
-   3 Make sure the module is loaded for your webcam
-   4 Permissions
    -   4.1 udev
    -   4.2 devfs
-   5 Webcam configuration
-   6 Get software to use your webcam
    -   6.1 Cheese
    -   6.2 GTK+ UVC Viewer (guvcview)
    -   6.3 Kopete
    -   6.4 Kamoso
    -   6.5 xawtv
    -   6.6 VLC
    -   6.7 MPlayer
    -   6.8 FFmpeg
    -   6.9 ekiga
    -   6.10 Sonic-snap
    -   6.11 Skype
    -   6.12 Motion
-   7 Troubleshooting
    -   7.1 Microsoft Lifecam Studio/Cinema

Linux webcam support
--------------------

Most probably your webcam will work out of the box. In that case you may
skip to section Webcam_Setup#Webcam configuration if you want to
configure color, brightness and other parameters. Otherwise follow the
steps below.

Identify your webcam
--------------------

Identify the name of your webcam (using, for example, lsusb) and find a
proper driver. Below is a list of webcams, and what drivers they work
with. Click on the link to the right of the device name for information
on compiling modules and other information. If you get your webcam to
work, add the name of the webcam and the driver you used to the list!

> pwc

-   Creative Labs Webcam Pro Ex
-   Logitech QuickCam Notebook Pro (only the "Pro" models)
-   Logitech Quickcam Pro 4000
-   Philips ToUCams (not confirmed at the moment, but it is using the
    pwc driver if I remember correctly)
-   Philips SPC900NC

> qc-usb

-   Dexxa Webcam
-   Labtec Webcam (old model)
-   LegoCam
-   Logitech Quickcam Express (old model)
-   Logitech QuickCam Notebook (not the "Pro" models)
-   Logitech Quickcam Web

> qc-usb-messenger

-   Logitech Quickcam Messenger
-   Logitech Quickcam Communicate (for Communicate MP/S5500 or "for
    Business" see the linux-uvc section below)

It is now in the community repo.

> Note:

-   If qc-usb-messenger does not work use the gspca module, by
    installing the gspcav1 package.
-   Now this driver is a module included in kernel 2.6.27.

> zr364xx

This driver can be used for many webcams like:

-   Aiptek PocketDV 3300
-   Creative PC-CAM 880
-   Konica Revio 2
-   Genius Digital Camera
-   Maxell Maxcam PRO DV3

You can find the full list of supported devices here. You can find a
PKGBUILD for this driver in the AUR.

> sn9c102

-   Trust Spacecam series
-   Maxell Smartcam (for notebooks): 352x288 max. resolution @ 3fps

> gspca

An extensive list of supported webcams is available [1].

Note:This driver does not have V4L1 support.

> stv680

Many cheap no-name cameras that came out Asia in the last couple of
years use the stv680 chipset. Most of these cameras were novelty items
(i.e. Pencam, SpyC@m and LegoCam).

-   Aiptek PenCam series
-   Digitaldream series
-   Dolphin Peripherals series
-   Lego LegoCam
-   Trust SpyC@m series
-   Welback Coolcam

A more-complete list of webcams that use the stv680 chipset is available
here.

> linux-uvc

-   Genius iLook 1321
-   Logitech Webcam C250
-   Logitech Webcam C270
-   Logitech Webcam C600
-   Logitech HD Webcam C525
-   Logitech Quickcam Pro 5000
-   Logitech Quickcam Pro 9000
-   Logitech Quickcam Orbit AF
-   Logitech Quickcam Orbit MP
-   Logitech Quickcam S5500
-   Microdia Pavilion Webcam (on MSI PR200)
-   Logitech Quickcam Communicate MP/S5500 or "for Business"
-   Chicony Electronics CNF7051

You can find a full list of supported UVC devices here.

As of kernel 2.6.26 linux-uvc is part of the kernel. Just load the
uvcvideo module.

> Note:

-   This driver does not have V4L1 support.
-   With WebCam SCB-0385N (usb ID 2232:1005), WebCam SC-0311139N (usb ID
    2232:1020) and WebCam SC-03FFL11939N (usb ID 2232:1028), you might
    need to add some configuration to the module if the usage of the
    camera makes the system freeze :

    /etc/modprobe.d/uvcvideo.conf

    options uvcvideo nodrop=1

> ov51x-jpeg

-   Sony EyeToy
-   Chicony DC-2120
-   Chicony DC-2120 pro
-   Trust Spacecam 320
-   Hercules Webcam Deluxe
-   Hercules Webcam Classic
-   Creative Live! Cam Notebook Pro VF0400
-   Creative Live! Cam Vista IM
-   Creative Live! Cam Vista IM VF0420
-   Creative Vista Webcam VF0330
-   ASUS webcam Model?
-   Philips PCVC820K/00
-   NGS showtime plus
-   HP VGA Webcam with Integrated Microphone

This is a kernel module found in the AUR with some additions to the
original driver that provide jpeg decompression.

For me to get my "Creative Live! Cam Vista IM" working with Skype, I had
to add this line to /etc/modprobe.d/modprobe.conf:

    options ov51x-jpeg forceblock=1

> r5u870 (Ricoh)

-   HP Pavilion Webcam
-   HP Webcam 1000
-   Sony VAIO VGP-VCCx

The Ricoh webcam is built into most new Sony laptops.

Install r5u87x-hg (provides firmware too) and run the loader command.

> stk11xx (Syntek)

-   Integrated camera in lot of Asus laptops
-   Asus A8J, F3S, F5R, F5GL, F9E, VX2S, V1S, A6T

Just install the stk11xx AUR package. It contains the right kernel
module.

Make sure the module is loaded for your webcam
----------------------------------------------

Add your webcam's module in /etc/modules-load.d/webcam.conf so it will
be loaded into the kernel during init stage bootstrapping.

If your webcam is USB, the kernel should automatically load the proper
driver. If this is the case, check dmesg after you plug your webcam in.
You should see something like this:

    $ dmesg|tail

    sn9c102: V4L2 driver for SN9C10x PC Camera Controllers v1:1.24a
    usb 1-1: SN9C10[12] PC Camera Controller detected (vid/pid 0x0C45/0x600D)
    usb 1-1: PAS106B image sensor detected
    usb 1-1: Initialization succeeded
    usb 1-1: V4L2 device registered as /dev/video0
    usb 1-1: Optional device control through 'sysfs' interface ready
    usbcore: registered new driver sn9c102

Permissions
-----------

In order to use your webcam, you need to have permission to use
/dev/video0.

> udev

If you use udev, you only need to be in the group video. You can check
it with:

    $ groups

To add a user to the group run under root:

    # gpasswd -a <username> video

Note the next two steps may not be required as they should already be
set by udev

Set group of device to video:

    # chgrp video /dev/video0

Set permissions of the device:

    # chmod 660 /dev/video0

Tip:If you need to load webcams in order (i.e. get the /dev/video0..n
device order) or set ownership or permissions, take a look at writing
rules for Writing udev rules.

> devfs

Add the following to your /etc/devfsd.conf. This will give normal users
permission to use /dev/video0 (your webcam).

    REGISTER        video0       PERMISSIONS     root.users 0660

Webcam configuration
--------------------

If you want to configure brightness, color and other webcam parameters
(e.g. in the case when out-of-the-box colors are too
bluish/reddish/greenish) you may use GTK+ UVC Viewer (guvcview),
available in the Official repositories as package guvcview. Just install
it and launch, and it will present you a list of configurable settings.
Changing these settings will affect all applications (e.g. Skype).

Get software to use your webcam
-------------------------------

Version 2.6.27 of the Linux kernel supports many new webcam drivers.
Legacy Video4Linux API has been dropped, and these drivers now only
support Video4Linux version 2. Pixel format decoding has been pushed to
user space, since Video4Linux version 2 does not support kernel space
decoding. The libv4l library provides userland applications with pixel
decoding services and will be used by most programs. Other compatibility
layers are also available.

If your device is created but your image looks strange (mine was nearly
completely green), you probably need this.

If the application has V4L2 support but no pixelformat support (eg:
cheese) then use the following command:

    LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so cheese

If the application only supports the older version of V4L (Skype is the
most popular of this kind of software) then use this command:

    LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so skype

Tip:You also might want to put a line like the following into
/etc/profile or xprofile so you do not have to type that long command
all the time:

    export LD_PRELOAD=/usr/'$LIB'/libv4l/v4l2convert.so

or

    export LD_PRELOAD=/usr/'$LIB'/libv4l/v4l1compat.so

For 32-bit applications (e.g. Skype) within Arch64, install the
lib32-v4l-utils package.

If the webcam works fine on guvcview, but it does not work in Skype, you
may also need to set

    export XLIB_SKIP_ARGB_VISUALS=1

before starting it.

> Cheese

Cheese is the GNOME photo/video taking client. It is similar to Photo
Booth in Mac OS X. It is in the official repositories.

> GTK+ UVC Viewer (guvcview)

In addition to being a convenient way to configure your webcam, guvcview
also allows capturing (with sound!) and viewing video from devices
supported by the Linux UVC driver. Available in the official
repositories as package guvcview. Just install it and launch, and it
will present you a list of configurable settings. Changing these
settings will affect all applications (e.g. Skype).

> Kopete

Kopete is the KDE instant messaging (IM) client. As of KDE 3.5, it has
support for MSN and Yahoo! webcams, but not every cam works yet. It is
included in the kdenetwork package.

> Kamoso

Application to take pictures and videos out of your webcam for KDE.
Available in the AUR: kamoso.

> xawtv

This is a basic v4l device viewer, and although it is intended for use
with TV tuner cards, it works well with webcams. It will display what
your webcam sees in a window. Install it (xawtv) and run it with:

    $ xawtv -c /dev/video0

If you are using an nVidia graphic card, and you get an error like

    X Error of failed request:  XF86DGANoDirectVideoMode
     Major opcode of failed request:  139 (XFree86-DGA)
     Minor opcode of failed request:  1 (XF86DGAGetVideoLL)
     Serial number of failed request:  69
     Current serial number in output stream:  69

you should instead run it as:

    $ xawtv -nodga

google talk

> VLC

VLC can also be used to view and record your webcam. In VLC's file menu,
open the 'Capture Device...' dialog and enter the video and audio device
files. Or from the command line, do:

    $ vlc v4l:// :v4l-vdev="/dev/video0" :v4l-adev="/dev/audio2"

This will make VLC mirror your webcam. To take stills, simply choose
'Snapshot' in the 'Video' menu. To record the stream, you add a --sout
argument, e.g.

    $ vlc v4l:// :v4l-vdev="/dev/video0" :v4l-adev="/dev/audio2" \ 
      --sout "#transcode{vcodec=mp1v,vb=1024,scale=1,acodec=mpga,ab=192,channels=2}:duplicate{dst=std{access=file,mux=mpeg1,dst=/tmp/test.mpg}}"

(Obviously a bit overkill with regard to the bit rates but it is fine
for testing purposes.) Notice that this will not produce a mirror on the
display - in order to see what you are recording, you would need to add
the display as a destination to the argument:

    ... :duplicate{dst=display,dst=std{access= ....

(Though this can tax older hardware somewhat...)

> MPlayer

To use MPlayer to take snapshots from your webcam run this command from
the terminal:

    $ mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot

From here you have to press s to take the snapshot. The snapshot will be
saved in your current folder as shotXXXX.png. If you want to record
continuous video:

    $ mencoder tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0:forceaudio:adevice=/dev/dsp -ovc lavc -oac mp3lame -lameopts cbr:br=64:mode=3 -o filename.avi

Press Ctrl+c to end the recording.

> FFmpeg

See FFmpeg#Recording webcam.

> ekiga

This is very similar to Microsoft NetMeeting. Install the ekiga package
from the official repositories. The configuration druid will set
everything up for you.

> Sonic-snap

Sonic-snap [2] is a viewer/grabber for sn9c102-based webcams only.
sonic-snap is available in the AUR.

> Skype

The newest version of Skype has video support. Check Video Devices in
the options for a test image which you can double-click to make full
screen. Install the skype package. If you get green/disorted picture
with skype read the section Webcam_Setup#Get software to use your webcam
above.

If your running x86-64 you might actually need to install
lib32-v4l-utils and then run skype with

    LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so skype

You can either set an alias for skype, or rename the original skype
binary in /usr/bin and create a text file containing the above option,
or you can simply adjust the Command line in the options for the Skype
icon in your favourite desktop environment.

> Motion

Motion is a program that monitors the video signal from cameras. It is
able to detect if a significant part of the picture has changed; in
other words, it can detect motion.

motion can only handle v4l2 devices so if you need to use a camera that
only has v4l1 drivers you need to preload v4l1compat.so as previously
mentioned. Otherwise you will get loads of errors about motion not able
to find a suitable palette.

Tip:If you need to load webcams in order (i.e. get the /dev/video0..n
device order) or set ownership or permissions, take a look at writing
rules for writing udev rules.

Troubleshooting
---------------

> Microsoft Lifecam Studio/Cinema

Under certain configurations, the Microsoft lifecam studio/cinema may
request too much usb bandwidth and fail see Uvcvideo FAQ. In this case
try loading the uvcvideo driver with quirks=0x80. Add it to
/etc/modprobe.d/uvcvideo.conf :

    /etc/modprobe.d/uvcvideo.conf

    ## fix bandwidth issue for lifecam studio/cinema
    options uvcvideo quirks=0x80

Retrieved from
"https://wiki.archlinux.org/index.php?title=Webcam_Setup&oldid=303582"

Category:

-   Imaging

-   This page was last modified on 8 March 2014, at 10:08.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
