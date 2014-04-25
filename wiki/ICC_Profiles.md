ICC Profiles
============

  Summary help replacing me
  --------------------------------------------------------------------------------------------------------------------------------------------------------
  This article attempts to introduce available methods to install and load ICC profiles for the benefit of color management across desktop applications.

Contents
--------

-   1 Introduction
-   2 Profile Generation
    -   2.1 File Transfer
    -   2.2 Gnome Color Manager
    -   2.3 LPROF ICC Profiler
        -   2.3.1 Monitor Calibration
            -   2.3.1.1 Contrast/Brightness
            -   2.3.1.2 Color Temperature
        -   2.3.2 Monitor Profiling
    -   2.4 Argyll CMS
    -   2.5 ThinkPads
-   3 Loading ICC Profiles
    -   3.1 xcalib
        -   3.1.1 Xinitrc Example
        -   3.1.2 JWM <StartupCommand> Example
    -   3.2 dispwin
        -   3.2.1 Xinitrc Example
        -   3.2.2 JWM <StartupCommand> Example
-   4 Additional Resources

Introduction
------------

As it pertains to general desktop use, an ICC profile is a binary file
which contains precise data regarding the color attributes of an input,
or output device (Source). Single, or multiple profiles can be applied
across a system and its devices to produce consistent and repeatable
results for graphic and document editing and publishing. ICC profiles
are typically calibrated with a (tristimulus) colorimeter, or a
spectrophotometer when absolute color accuracy is required.

Profile Generation
------------------

> File Transfer

Profile generation on a Windows 7/Vista/XP, or Mac OS X system is one of
the easiest and most widely recommended methods to obtain a ICC monitor
profile. Since ICC color profiles are written to an open specification,
they are compatible across operating systems. Transferring profiles from
one OS to another can be used as a workaround for the lack of support
for certain spectrophotometers, or colorimeters under Linux: one can
simply produce a profile on a different OS and then use it in a Linux
workflow (Source). Recommended colorimeters include the X-Rite i1Display
2, the Spyder3 Pro and the open Source Hardware ColorHug. Note that the
system on which the profile is generated must host the exact same video
card and monitor for which the profile is to be used. Once generation of
an ICC profile, or a series of profiles is complete on a Windows
7/Vista/XP system, copy the file(s) from the default path:

    C:\WINDOWS\System32\spool\drivers\color

Mac OS X generally stores saved ICC profiles in one of two locations:

    /Library/ColorSync/Profiles
    /Users/USER_NAME/Library/ColorSync/Profile

Once the appropriate .icc/.icm files have been copied, install the
device profiles to your desired system. Common installation device
profiles directories on Linux include:

    /usr/share/color/icc
    /usr/local/share/color/icc
    /home/USER_NAME/.color/icc

Note:Ensure that the calibrated contrast, brightness and RGB settings of
the monitor do not change between the time of calibration and the
loading of the ICC profile.

> Gnome Color Manager

On Gnome, an ICC profile can easily by created by using
gnome-color-manager. Under Gnome, this is accessible via the Control
Center and is pretty straightforward to use. You'll need a colorimeter
device to use this feature.

> LPROF ICC Profiler

LPROF is an ICC profiler with a graphical user interface listed under
lprof in the Arch User Repository (AUR).

Note:The following walkthrough has been modified from the ArchWiki
article Using LPROF to Profile Monitors.

Monitor Calibration

Contrast/Brightness

Adjust the lighting in the room to what you will be using when working.
Even if your screen is coated with an anti-reflective coating, you
should avoid light falling directly on it. Let your monitor warm up for
at least an hour for the image to get stabilized. If your calibration
device has an ambient diffuser, adjust your room brightness to reach the
recommended target lux point.

1.  Set the monitor contrast to maximum, or 100%.
2.  Next, display a pure black over entire screen by creating a small,
    black PNG image (all pixels have RGB = 0, 0, 0) and opening it up in
    a picture viewer that is capable of displaying an image in
    fullscreen mode without any controls.
3.  Reduce the vertical size of the monitor screen (not the PNG image
    displayed by a picture viewer but the whole of what's displayed on
    the screen) to 60% to 70% of the full height. What is revealed above
    and below the picture is called a non-scanned area, and since that
    area is not receiving any voltage, it is the blackest of black your
    monitor is capable of displaying.
4.  Locate the brightness control (usually a sun, circle with rays
    projecting from it's edges) and lower the value until the black
    image matches the non-scanned area.

Color Temperature

As we said in the introduction, setting color temperature must occur at
noon. If you only have fixed factory default color temperature, you do
not really need to wait for the sunny day to come. Just set it to 6500K.

Place your monitor so that you can see outside the window and your
screen at the same time. For this step, you also need to create a white
square image (RGB = 255, 255, 255), roughly 10 by 10 centimeters (4 by 3
inches). Using the same Gwenview technique as with brightness/contrast,
display the white square on a pure black background.

1.  First, prepare your eyes by staring at the outside world for a
    while. Let them adjust to the daylight viewing condition for a few
    minutes.
2.  Glance at the monitor, and the white square for a few second (it has
    to be short, because eyes will readjust quickly).
3.  If the square seems yellowish, you need higher color temperature, or
    if it has a blueish cast, the temperature needs to be lowered.
4.  Keep glancing, looking out the window, and adjusting the white
    temperature, until the square looks pure white

Take your time with the steps described above. It is essential to get it
right.

Monitor Profiling

Start lprof. You will be presented by a fairly large window with
multiple tabs on the right.

1.  Click on the Monitor Profiler tab. Then click on the large Enter
    monitor values >> button.
2.  White point should be set to 6500K (daylight).
3.  Primaries should be set to either SMPTE RP145-1994, or EBU
    Tech.3213-E or P22, or whatever appropriate values for your monitor.
    If you come across correct values for your monitor, enter those by
    selecting User Defined from the drop-down. If in doubt, you may use
    P22 for all monitors with Trinitron CRTs (in this case, Trinitron is
    not related to Sony Trinitron mointors and TVs), and SMPTE
    RP145-1994 for other CRTs.
4.  Click the Set Gamma and Black Point button.
5.  You will now see a full-screen view of two charts with some controls
    at the bottom.
6.  Uncheck the Link channels check-box and adjust individual Red,
    Green, and Blue gamma by either moving the slider left or right, or
    by entering and changing values in the three boxes to the left. The
    goal is to make the chart on the left (the smaller square one) flat.
    When you are satisfied with how it looks, check the Link channels
    check-box and adjust the gamma again.
7.  When you are done, click OK. Click OK again.

When you are finished entering monitor values, you might want to enter
some information about the monitor. This is not mandatory, but it is
always nice to know what profile is for what.

1.  Click Profile identification button.
2.  Fill in the data.
3.  Click OK to finish.

After you are all done, click on the '...' button next to Output Profile
File box. Enter the name of your profile: somemonitor.icc. Click Create
Profile button, and you are done.

> Argyll CMS

The Argyll Color Management System is a complete suite of command-line
profile creation and loading tools listed under argyllcms in the Arch
User Repository (AUR).

-   Review the official Argyll CMS documentation for details on how to
    profile selected devices.

> ThinkPads

See color profiles for IBM/Lenovo ThinkPad notebook monitor profile
(generic) support.

Loading ICC Profiles
--------------------

ICC profiles are loaded either by the session daemon or by a dedicated
ICC loader. Both Gnome and KDE have daemons capable of loading ICC
profiles from colord. If you use colord in combination with either
gnome-settings-daemon or colord-kde, the profile will be loaded
automagically. If you're not using neither Gnome nor KDE, you may
install an independent daemon, xiccd, which does the same but does not
depend on your desktop environment. Do not start two ICC-capable daemons
(e.g. gnome-settiongs-daemon and xiccd) at the same time.

If you're not using any ICC-capable session daemon, make sure you use
only one ICC loader - either xcalib, dispwin, dispcalGUI-apply-profiles
or others, otherwise you easily end up with uncontrolled environment.
(The most recently run loader set the calibration, and the earlier
loaded calibration is overwritten.)

Before using a particular ICC loader, you should understand that some
tools set only the calibration curves (e.g. xcalib), other tools set
only the display profile to X.org _ICC_PROFILE atom (e.g. xicc) and
other tools do both tasks at once (e.g. dispwin,
dispcalGUI-apply-profiles).

> xcalib

-   xcalib is a lightweight monitor calibration loader which can load an
    ICC monitor profile to be shared across desktop applications. xcalib
    is part of the Arch User Repository (AUR).

Xinitrc Example

Load profile P221W-sRGB.icc in /usr/share/color/icc on display host:0
when X server starts

    #!/bin/bash

    /usr/bin/xcalib -d :0 /usr/share/color/icc/P221W-sRGB.icc

JWM <StartupCommand> Example

Load profile P221W-Native.icc in /usr/local/share/color/icc on display
host:0 when JWM starts

     <StartupCommand>xcalib -d :0 /usr/local/share/color/icc/P221W-Native.icc</StartupCommand>

> dispwin

-   dispwin is a part of argyllcms in the Arch User Repository (AUR).

Xinitrc Example

Load profile 906w-6500K.icc in /home/arch/.color/icc on display 0 when X
server starts

    #!/bin/bash

    /usr/bin/dispwin -d0 /home/arch/.color/icc/906w-6500K.icc

JWM <StartupCommand> Example

Load Argyll calibration file 906w-7000K.cal in
/usr/local/share/color/icc on display 1 when JWM starts

     <StartupCommand>dispwin -d1 /usr/local/share/color/icc/906w-7000K.cal</StartupCommand>

Additional Resources
--------------------

-   Using LPROF to Profile Monitors - Additional details on how to
    profile monitors
-   Linux Color Management - Wikipedia
-   Argyll Color Management System - Official Site
-   LPROF Main Help Window - Details on profiling printers and scanners

Retrieved from
"https://wiki.archlinux.org/index.php?title=ICC_Profiles&oldid=284815"

Category:

-   Graphics and desktop publishing

-   This page was last modified on 27 November 2013, at 07:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
