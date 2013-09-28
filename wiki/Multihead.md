Multihead
=========

Summary

This article offers some hints and tips to get the most out of Arch
Linux on a computer with more than one attached monitor.

Related

Xorg

DualScreen

Having multiple screens is still somewhat uncommon, many programs are
not written to handle a system with multiple screens and display
incorrectly. This article covers both advanced configuration of a so
called multihead system, as well as various workarounds for those
programs which need help to work correctly in a multihead environment.

Note:The terms used in this article are very specific to avoid
confusion. Monitor refers to a physical display device, such as an LCD
panel. Screen refers to an X-Windows screen, that is a monitor attached
to a display. Display refers to a collection of screens that are in use
at the same time showing parts of a single desktop. You can drag windows
among all screens in a single display.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Xinerama, TwinView and separate screens                            |
|     -   1.1 Separate screens                                             |
|     -   1.2 Xinerama                                                     |
|     -   1.3 TwinView                                                     |
|                                                                          |
| -   2 Full screen games                                                  |
| -   3 Applications                                                       |
| -   4 Window managers                                                    |
+--------------------------------------------------------------------------+

Xinerama, TwinView and separate screens
---------------------------------------

When configuring a multihead X-Windows workstation, a decision needs to
be made about how each screen will be configured.

> Separate screens

This is the original way of configuring multiple monitors with X, and it
has been around for decades. Each physical monitor is assigned as an X
screen, and while you can move the mouse between them, they are more or
less independent.

Normally the X display has a single identifier such as :0 set in the
DISPLAY environment variable, but in this configuration each screen has
a different $DISPLAY value. The first screen is :0.0, the second is :0.1
and so on.

With this configuration it is not possible to move windows between
screens, apart from a few special programs like GIMP and Emacs which
have multi-screen support. For most programs you must change the DISPLAY
environment variable when launching to have the program appear on
another screen:

    # Launch a terminal on the second screen
    $ DISPLAY=:0.1 urxvt &

Alternatively if you have a terminal on each screen launching programs
will inherit the DISPLAY value and appear on the same screen they were
launched on. But moving an application between screens involves closing
it and reopening it again on the other screen.

Working this way does have certain advantages, such as windows popping
up on one screen won't steal the focus away from you if you are working
on another screen - each screen is quite independent.

> Xinerama

This is the official way of doing genuine multihead X. Screens are
configured as separate X screens like in the previous section, but
Xinerama combines all screens into a single display (:0) making it
possible to drag windows between screens.

This is the only way to get complex multihead support, such as being
able to move windows between screens that are connected to different
video cards, possibly from different manufacturers, with some in
landscape and others in portrait mode.

Simple Xinerama layouts can be configured with xrandr however for more
complex control, custom X configuration files must be created. Here are
some examples.

This is a ServerLayout section which controls where each monitor sits
relative to the others.

    /etc/X11/xorg.conf.d/90-serverlayout.conf

    Section "ServerLayout"
      Identifier   "Main"
      Screen       0 "Primary"
      Screen       1 "DellPortraitLeft" RightOf "Primary"
      Screen       2 "Wacom" RightOf "DellPortraitLeft"
      Screen       3 "U2412" LeftOf "Primary"
      Option         "Xinerama" "1"  # enable XINERAMA extension.  Default is disabled.
    EndSection

Each Screen in the above section is defined in a separate file, such as
this one:

    /etc/X11/xorg.conf.d/30-screen-dell2001.conf

    # Define the monitor's physical specs
    Section "Monitor"
      Identifier   "Dell 2001FP"
      VertRefresh  60
      Option  "dpms"  "on"

      # Modelines are probably unnecessary these days, but it does give you fine grained control

      # 1600x1200 @ 60.00 Hz (GTF) hsync: 74.52 kHz; pclk: 160.96 MHz
      Modeline "1600x1200"  160.96  1600 1704 1880 2160  1200 1201 1204 1242  -HSync +Vsync
    EndSection

    # Define a screen that uses the above monitor.  Note the Monitor value matches the above
    # Identifier value, and the Device value matches one of the video cards defined below
    # (the card and connector this monitor is actually plugged in to.)
    Section "Screen"
      Identifier   "DellPortraitLeft"
      Device       "GeForce 8600GTb"
      Monitor      "Dell 2001FP"
      DefaultDepth 24
      SubSection "Display"
        Depth     24
        Modes     "1600x1200"
        ViewPort  0 0
        Virtual   1600 1200
      EndSubsection

      # This screen is in portrait mode
      Option "Rotate" "left"
    EndSection

You will need to create a Device section for each monitor, i.e. a dual
head video card will have two Device sections. The following example
shows how to configure two video cards each providing two outputs, for a
total of four monitors.

    /etc/X11/xorg.conf.d/20-nvidia.conf

    # First head of first video card in the system
    Section "Device"
      Identifier  "GeForce 8600GT"
      Driver      "nvidia"

      # If you have multiple video cards, the BusID controls which one this definition refers
      # to.  You can omit it if you only have one card.
      BusID       "PCI:1:0:0"

      # Need to flag this as only referring to one output on the card
      Screen      0

      # For nVidia devices, this controls which connector the monitor is connected to.
      Option      "UseDisplayDevice"   "DFP-0"

      # We want control!
      Option      "DynamicTwinView"    "FALSE"

      # Various performance and configuration options
      Option      "AddARGBGLXVisuals"  "true"
      Option      "UseEDIDDpi"         "false"
      Option      "DPI"                "96 x 96"
      Option      "Coolbits"           "1"
    EndSection

    # Second head of same video card (note different Identifier but same BusID.)  We can omit
    # the UseDisplayDevice option this time as it will pick whichever one is remaining.
    Section "Device"
      Identifier  "GeForce 8600GTb"
      Driver      "nvidia"
      BusID       "PCI:1:0:0"
      # This is the second output on this card
      Screen      1

      # Same config options for all cards
      Option      "AddARGBGLXVisuals"  "true"
      Option      "UseEDIDDpi"         "false"
      Option      "DPI"                "96 x 96"
      Option      "Coolbits"           "1"
      Option      "DynamicTwinView"    "FALSE"
    EndSection

    # First head of second video card, note different BusID.
    Section "Device"
      Identifier  "G210"
      Driver      "nvidia"
      BusID       "PCI:2:0:0"
      Screen      0

      # Same config options for all cards
      Option      "AddARGBGLXVisuals"  "true"
      Option      "UseEDIDDpi"         "false"
      Option      "DPI"                "96 x 96"
      Option      "Coolbits"           "1"
      Option      "DynamicTwinView"    "FALSE"
    EndSection

    # Second head of second video card.  Output connector is set here, which means the previous
    # Device will use the other connector, whatever it may be.
    Section "Device"
      Identifier  "G210b"
      Driver      "nvidia"
      BusID       "PCI:2:0:0"
      Screen      1
      Option      "UseDisplayDevice"   "DFP-1"

      # Same config options for all cards
      Option      "AddARGBGLXVisuals"  "true"
      Option      "UseEDIDDpi"         "false"
      Option      "DPI"                "96 x 96"
      Option      "Coolbits"           "1"
      Option      "DynamicTwinView"    "FALSE"
    EndSection

> TwinView

TwinView is nVidia's extension which makes two monitors attached to a
video card appear as a single screen. TwinView provides Xinerama
extensions so that applications are aware there are two monitors
connected, and thus it is incompatible with Xinerama. However if you
only have two monitors and they are both connected to the same nVidia
card, there is little difference between TwinView and Xinerama (although
in this situation TwinView may offer slightly better performance.)

If you wish to attach more than two monitors or monitors attached to
other video cards, you will need to use Xinerama instead of TwinView.
Likewise at the time of writing, both monitors must be in the same
orientation - you cannot have one in landscape and the other in portrait
mode.

In the past, TwinView was the only way to get OpenGL acceleration with
nVidia cards while being able to drag windows between screens. However
modern versions of the nVidia closed-source driver are able to provide
OpenGL acceleration even when using Xinerama.

Full screen games
-----------------

Many games require their window to appear at (0,0) when running in
full-screen. If the screen you have at (0,0) - the left-most one - is
not one you wish to game on, it is almost impossible to move a
full-screen game onto a different screen.

A workaround for this is to create a separate X11 configuration (a new
layout) just for playing games, which may have less (or only one) screen
configured. You can then launch games using this separate layout, while
normal desktop work uses the original multihead configuration.

To create a new layout, copy /etc/X11/xorg.d/90-serverlayout.conf and
call it 91-serverlayout-gaming.conf. It is important to use a number
larger than 90, as the one with the lowest number will become the
default used when you first load X.

Adjust this new configuration file to your preferred gaming
configuration. Here is an example (based on the example Xinerama
configuration above) with only one screen defined, noting that the
screen specifics (such as resolution) are defined in other files and are
unchanged from and shared with the normal configuration:

    /etc/X11/xorg.conf.d/91-serverlayout-gaming.conf

     # New screen layout only using a single screen called "Primary"
     Section "ServerLayout"
       Identifier   "Gaming"
       Screen       0 "Primary" Absolute 0 0
     EndSection

Tip:While it's easiest to just reuse the existing screen definitions,
you can of course define new ones if you wish to have a different set of
screen resolutions available.

To use this new layout, launch the game via the startx script:

    # Launch Xonotic on a new X11 display using the "Gaming" layout
    startx /usr/bin/xonotic-glx -fullscreen -- :1 -layout Gaming

Note that:

-   You must specify the full path to the command to run, here
    /usr/bin/xonotic-glx.
-   The :1 must refer to an empty unused display. The first display you
    are likely using for your desktop is :0, so :1 will be fine for most
    people. But should you want to launch a second game at the same
    time, you would have to change this to :2.
-   Just as you can switch between text consoles with Alt+Ctrl+F1 and
    back to X with Alt+Ctrl+F7, the new display will sit on Alt+Ctrl+F8.
    So you can switch back to your desktop with Alt+Ctrl+F7 and back to
    the game with Alt+Ctrl+F8. This is because you are running an
    independent X desktop, so if you switch out of the game with Alt+Tab
    or equivalent there will be an empty desktop with no window manager
    running.

Applications
------------

This section lists tips for individual applications.

-   mplayer: use -xineramascreen 1 to make the video play on screen #1
    (the second screen.) Add xineramascreen=1 to ~/.mplayer/config to
    make permanent.
-   Xonotic: if you are playing across multiple screens and you are
    unable to turn left/right properly, set vid_stick_mouse to 1 in
    ~/.xonotic/data/config.cfg

Window managers
---------------

This section lists window managers and how they cope with multiple
monitors.

-   Awesome - works
-   KDE - does not work properly, second monitor seen as virtual
    desktop, inaccessible (2012-10-15)
-   MATE - works
-   i3 - works
-   XMonad - works (screens are different workspaces, both accessible
    and switching is possible by both keyboard and mouse) - as of 1th
    March 2013

Retrieved from
"https://wiki.archlinux.org/index.php?title=Multihead&oldid=248828"

Category:

-   X Server
