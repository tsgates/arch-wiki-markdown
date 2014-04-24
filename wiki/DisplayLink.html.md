DisplayLink
===========

DisplayLink devices on Linux still only have experimental support. While
some people have had success in using them, it is generally not an easy
process and not guaranteed to work. The steps on this page describe the
generally most successful methods of using external monitors with
DisplayLink.

Contents
--------

-   1 Installation
    -   1.1 udl
-   2 Configuration
    -   2.1 Load the framebuffer device
    -   2.2 Configuring X Server
        -   2.2.1 Xinerama setup
        -   2.2.2 Dual X setup
-   3 Troubleshooting
    -   3.1 Screen redraw is broken
    -   3.2 X crashes or keeps blank
    -   3.3 Cannot start in framebuffer mode. Please specify busIDs for
        all framebuffer devices
-   4 See Also

Installation
------------

Install the xf86-video-fbdev package, which provides framebuffer video
for X.org.

Hardware-level support is provided by the kernel module udlfb, which
should be loadable by default in Arch.

Note: Support for the features in xf86-video-fbdev-for-displaylink and
udlfb from the AUR have been included upstream and are no longer needed.
Use the official packages instead.

> udl

A rewrite of the udlfb module is underway. It is being replaced by udl
and integrated into the kernel's drm infrastructure. The new drivers are
part of the stock Arch kernel and found in
/lib/modules/$(uname -r)/kernel/drivers/gpu/drm/udl.

These new drivers may be added with modprobe udl if you would like to
try them out. This is now the best way to get DisplayLink working on
Linux, since the old udlfb drivers have had regressions possibly
breaking them for everyone. It also works with Xrandr, which udlfb does
not.

It seems that blacklisting udlfb and installing xf86-video-modesetting
is now enough. After that, run:

    # xrandr --listproviders

    Providers: number : 2
    Provider 0: id: 0x49 cap: 0xb, Source Output, Sink Output, Sink Offload crtcs: 2 outputs: 8 associated providers: 0 name:Intel
    Provider 1: id: 0x13c cap: 0x2, Sink Output crtcs: 1 outputs: 1 associated providers: 0 name:modesetting

To connect provider 1 (this is the DisplayLink device) to provider 0:

    # xrandr --setprovideroutputsource 1 0

and xrandr will add a DVI output you can use as normal with xrandr. This
is still experimental but supports hotplugging and when works, it's by
far the simplest setup. If it works then everything below is
unnecessary.

Configuration
-------------

These instructions assume that you already have an up and running X
server and are simply adding a monitor to your existing setup.

> Load the framebuffer device

Before your system will recognize your DisplayLink device, the udlfb
kernel module must be loaded. To do this, run

    # modprobe udlfb

If your DisplayLink device is connected, it should show some visual
indication of this. Although a green screen is the standard indicator of
this, other variations have been spotted and are perfectly normal. Most
importantly, the output of dmesg should show something like the
following, indicating a new DisplayLink device was found:

    usb 2-1.2: new high-speed USB device number 5 using ehci-pci
    udlfb: DisplayLink Lenovo LT1421 wide - serial #6V9BBRM1
    udlfb: vid_17e9&pid_03e0&rev_0108 driver's dlfb_data struct at ffff880231e54800
    udlfb: console enable=1
    udlfb: fb_defio enable=1
    udlfb: shadow enable=1
    udlfb: vendor descriptor length:17 data:17 5f 01 0015 05 00 01 03 00 04
    udlfb: DL chip limited to 1500000 pixel modes
    udlfb: allocated 4 65024 byte urbs
    udlfb: 1366x768 @ 60 Hz valid mode
    udlfb: Reallocating framebuffer. Addresses will change!
    udlfb: 1366x768 @ 60 Hz valid mode
    udlfb: set_par mode 1366x768
    udlfb: DisplayLink USB device /dev/fb1 attached. 1366x768 resolution. Using 4104K framebuffer memory

Furthermore, /dev should contain a new fb device, likely /dev/fb1 if you
already had a framebuffer for your primary display.

To automatically load udlfb at boot, create the file udlfb.conf in
/etc/modules-load.d/ with the following contents:

    /etc/modules-load.d/udlfb.conf

    udlfb

For more information on loading kernel modules, see Kernel
modules#Loading.

> Configuring X Server

There are two primary ways people use DisplayLink devices with X on
desktop Linux computers:

-   Xinerama with a single X server
-   Two separate X servers, linked together in some way

While Xinerama is probably the more desirable setup, it is also less
likely to work. Both methods are described below.

Note:xrandr is not known to work with udlfb. It does, however,
reportedly work with udl.

Xinerama setup

You must update or create an xorg.conf with a properly configured
ServerLayout to use a DisplayLink monitor, as Xorg will prefer internal
monitors by default. The DisplayLink device is normally only usable if
it is set as screen0 and the internal display as screen1.

Add this to the bottom of your xorg.conf:

    /etc/X11/xorg.conf

     ################ DisplayLink ###################
     Section "Device"
            Identifier      "DisplayLinkDevice"
            Driver          "fbdev" 
            BusID           "USB"               # needed to use multiple DisplayLink devices 
            Option          "fbdev" "/dev/fb0"  # change to whatever device you want to use
     #      Option          "rotate" "CCW"      # uncomment for rotation
     EndSection
     
     Section "Monitor"
            Identifier      "DisplayLinkMonitor"
     EndSection
     
     Section "Screen"
            Identifier      "DisplayLinkScreen"
            Device          "DisplayLinkDevice"
            Monitor         "DisplayLinkMonitor"
            DefaultDepth    16
     EndSection

Then edit your server layout to look something like this

    Screen		0	"DisplayLinkScreen"
    Screen		1	"Internal" RightOf "DisplayLinkScreen"
    Option		"Xinerama" "on"

Change Internal to your main display, then restart X.

Dual X setup

This section is a work in progress. For now, please refer to the steps
covered in the Gentoo Wiki for details on this setup.

Troubleshooting
---------------

> Screen redraw is broken

If you are using udl as your kernel driver and the monitor appears to
work, but is only updating where you move the mouse or when windows
change in certain places, then you probably have the wrong modeline for
your screen. Getting a proper modeline for your screen with a command
like

    gtf 1366 768 59.9

where 1366 and 768 are the horizontal and vertical resolutions for your
monitor, and 59.9 is the refresh rate from its specs. To use this,
create a new mode with xrandr like follows:

    xrandr --newmode "1368x768_59.90"  85.72  1368 1440 1584 1800  768 769 772 795  -HSync +Vsync

and add it to Xrandr:

    xrandr --addmode DVI-0 1368x768_59.90

Then tell the monitor to use that mode for the DisplayLink monitor, and
this should fix the redraw issues. Check the Xrandr page for information
on using a different mode.

> X crashes or keeps blank

If X crashes, or nothing is shown at load, try to start X only using the
external display by updating xorg.conf as follows:

     Screen		0	"DisplayLinkScreen"
     #Screen		1	"Internal" RightOf "DisplayLinkScreen"
     #Option		"Xinerama" "on"

There are reported instances in which Xinerama requires all its Screen
color depths to be the same. In both Screen sections, try changing the
DefaultDepth to 16.

    Section "Screen"
        ...
        DefaultDepth    16
        ...
    EndSection

Note: With fbdev this is not true anymore, because fbdev provides
virtual 24 bit support. Everything may be used with DefaultDepth 24.
However, USB 2.0 has less bandwidth than a standard monitor, so a
performance update may be seen from setting it to 16 bit mode.

> Cannot start in framebuffer mode. Please specify busIDs for all framebuffer devices

With two monitors configured in Xinerama mode, /var/log/Xorg.0.log will
sometimes display the following error:

    Fatal server error:
    Cannot run in framebuffer mode. Please specify busIDs for all framebuffer devices

As indicated by this Gentoo Forums thread, KMS might be incompatible
with fbdev. They also suggested the possible fix of running
startx -- -retro which will allow X to run even when, to X itself, it
doesn't appear to be working.

Note:A bug report has been filed for this issue.

See Also
--------

-   DisplayLink Open Source: Official DisplayLink open source support
    forum
-   Plugable: Vendor blog chronicling Linux support for DisplayLink.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DisplayLink&oldid=274646"

Category:

-   Other hardware

-   This page was last modified on 8 September 2013, at 02:49.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
