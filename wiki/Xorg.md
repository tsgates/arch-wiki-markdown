Xorg
====

Related articles

-   Start X at Login
-   Execute commands after X start
-   Display manager
-   Window manager
-   Font Configuration
-   Cursor Themes
-   Desktop environment
-   Wayland
-   Mir

From http://www.x.org/wiki/:

The X.Org project provides an open source implementation of the X Window
System. The development work is being done in conjunction with the
freedesktop.org community. The X.Org Foundation is the educational
non-profit corporation whose Board serves this effort, and whose Members
lead this work.

Xorg is the public, open-source implementation of the X window system
version 11. Since Xorg is the most popular choice among Linux users, its
ubiquity has led to making it an ever-present requisite for GUI
applications, resulting in massive adoption from most distributions. See
the Xorg Wikipedia article or visit the Xorg website for more details.

Contents
--------

-   1 Installation
    -   1.1 Driver installation
-   2 Running
-   3 Configuration
    -   3.1 Using .conf files
    -   3.2 Using xorg.conf
    -   3.3 Sample configurations
-   4 Input devices
    -   4.1 Mouse acceleration
    -   4.2 Extra mouse buttons
    -   4.3 Touchpad Synaptics
    -   4.4 Keyboard settings
-   5 Monitor settings
    -   5.1 Getting started
    -   5.2 Multiple monitors
        -   5.2.1 More than one graphics card
    -   5.3 Display size and DPI
        -   5.3.1 Setting DPI manually
    -   5.4 DPMS
-   6 Composite
-   7 Tips and tricks
    -   7.1 X startup tweaking (startx)
    -   7.2 Nested X session
    -   7.3 Starting GUI programs remotely
    -   7.4 On-demand disabling and enabling of input sources
-   8 Troubleshooting
    -   8.1 Common problems
    -   8.2 CTRL right key does not work with oss keymap
    -   8.3 X clients started with "su" fail
    -   8.4 Program requests "font '(null)'"
    -   8.5 Frame-buffer mode problems
    -   8.6 DRI with Matrox cards stops working
    -   8.7 Recovery: disabling Xorg before GUI login
    -   8.8 X failed to start: Keyboard initialization failed
    -   8.9 Black screen, No protocol specified.., Resource temporarily
        unavailable for all or some users

Installation
------------

You will need to install the essential package xorg-server, available in
the official repositories.

Additionally, some packages from the xorg-apps group are useful for
certain configuration tasks, they are pointed out in the relevant
section/page.

Tip:The default X environment is rather bare, and you will typically
seek to install a window manager or a desktop environment to supplement
X.

> Driver installation

The Linux kernel includes open-source video drivers and support for
hardware accelerated framebuffers. However, userland support is required
for OpenGL and 2D acceleration in X11.

First, identify your card:

    $ lspci | grep VGA

Then install an appropriate driver. You can search the package database
for a complete list of open-source video drivers:

    $ pacman -Ss xf86-video

The default graphics driver is vesa (package xf86-video-vesa), which
handles a large number of chipsets but does not include any 2D or 3D
acceleration. If a better driver cannot be found or fails to load, Xorg
will fall back to vesa.

In order for video acceleration to work, and often to expose all the
modes that the GPU can set, a proper video driver is required:

Brand

Type

Driver

Multilib Package  
(for 32-bit applications on Arch x86_64)

 Documentation 

>  AMD/ATI 

 Open source 

xf86-video-ati

lib32-ati-dri

ATI

Proprietary

catalyst

lib32-catalyst-utils

AMD Catalyst

> Intel

Open source

xf86-video-intel

lib32-intel-dri

Intel Graphics

> Nvidia

Open source

xf86-video-nouveau

lib32-nouveau-dri

Nouveau

Proprietary

nvidia

lib32-nvidia-libgl

NVIDIA

nvidia-304xx

lib32-nvidia-304xx-utils

nvidia-173xx

lib32-nvidia-173xx-utils

nvidia-96xx

lib32-nvidia-96xx-utils

> VIA

Open source

xf86-video-openchrome

–

VIA

Xorg should run smoothly without closed source drivers, which are
typically needed only for advanced features such as fast 3D-accelerated
rendering for games, dual-screen setups, and TV-out.

Running
-------

See also: Start X at Login

Tip:The easiest way to start X is by using a display manager such as
GDM, KDM or SLiM.

If you want to start X without a display manager, install the package
xorg-xinit. Optionally, the packages xorg-twm, xorg-xclock and xterm
allows for a default environment, as described below.

The startx and xinit commands will start the X server and clients (the
startx script is merely a front end to the xinit command). To determine
the client to run, startx/xinit will first look to parse a ~/.xinitrc
file in the user's home directory. In the absence of ~/.xinitrc, it
defaults to the global file /etc/X11/xinit/xinitrc, which defaults to
starting a basic environment with the Twm window manager, Xclock and
Xterm. For more information, see xinitrc.

> Note:

-   X must always be run on the same tty where the login occurred, to
    preserve the logind session. This is handled by the default
    /etc/X11/xinit/xserverrc. See General Troubleshooting#Session
    permissions for details.
-   If a problem occurs, then view the log at /var/log/Xorg.0.log. Be on
    the lookout for any lines beginning with (EE), which represent
    errors, and also (WW), which are warnings that could indicate other
    issues.
-   If there is an empty .xinitrc file in your $HOME, either delete or
    edit it in order for X to start properly. If you do not do this X
    will show a blank screen with what appears to be no errors in your
    Xorg.0.log. Simply deleting it will get it running with a default X
    environment.

Warning:If you choose to use xinit instead of startx, you are
responsible for passing -nolisten tcp and ensuring the session does not
break by starting X on a different tty.

Configuration
-------------

Note:Arch supplies default configuration files in /etc/X11/xorg.conf.d,
and no extra configuration is necessary for most setups.

Xorg uses a configuration file called xorg.conf and files ending in the
suffix .conf for its initial setup: the complete list of the folders
where these files are searched can be found at [1] or by running
man xorg.conf, together with a detailed explanation of all the available
options.

> Using .conf files

The /etc/X11/xorg.conf.d/ directory stores user-specific configuration.
You are free to add configuration files there, but they must have a
.conf suffix: the files are read in ASCII order, and by convention their
names start with XX- (two digits and a hyphen, so that for example 10 is
read before 20). These files are parsed by the X server upon startup and
are treated like part of the traditional xorg.conf configuration file.
The X server essentially treats the collection of configuration files as
one big file with entries from xorg.conf at the end.

> Using xorg.conf

Xorg can also be configured via /etc/X11/xorg.conf or /etc/xorg.conf.
You can also generate a skeleton for xorg.conf with:

    # Xorg :0 -configure

This should create a xorg.conf.new file in /root/ that you can copy over
to /etc/X11/xorg.conf.

Alternatively, your proprietary video card drivers may come with a tool
to automatically configure Xorg: see the article of your video driver,
NVIDIA or AMD Catalyst, for more details.

Note:Configuration file keywords are case insensitive, and "_"
characters are ignored. Most strings (including Option names) are also
case insensitive, and insensitive to white space and "_" characters.

> Sample configurations

-   xorg.conf

Sample 1

Note:Sample configuration file using /etc/X11/xorg.conf.d/10-evdev.conf
for the keyboard layouts. Note the commented out InputDevice sections.

-   /etc/X11/xorg.conf.d/10-evdev.conf

Sample 1

Note:This is the 10-evdev.conf file that goes with the xorg.conf sample
1.

-   /etc/X11/xorg.conf.d/10-monitor.conf

1.  VMware
2.  KVM
3.  NVIDIA

Note:nvidia-ck binary drivers (v325); Dual GPU, Dual Monitor, Dual
Screen; No Twinview, No Xinerama; Rotated and vertically placed screen1
above screen0.

Input devices
-------------

Udev will detect your hardware and evdev will act as the hotplugging
input driver for almost all devices. Udev is provided by systemd and
xf86-input-evdev is required by xorg-server, so there is no need to
explicitly install those packages. If evdev does not support your
device, install the needed driver from the xorg-drivers group.

You should have 10-evdev.conf in the /etc/X11/xorg.conf.d/ directory,
which manages keyboards, mice, touchpads and touchscreens.

See the following pages for specific instructions, or the Fedora wiki
entry for more examples.

> Mouse acceleration

See the main page: Mouse acceleration

> Extra mouse buttons

See the main page: All Mouse Buttons Working

> Touchpad Synaptics

See the main page: Touchpad Synaptics

> Keyboard settings

See the main page: Keyboard Configuration in Xorg

Monitor settings
----------------

> Getting started

Note:Newer versions of Xorg are auto-configuring, you should not need to
use this.

First, create a new config file, such as
/etc/X11/xorg.conf.d/10-monitor.conf.

    /etc/X11/xorg.conf.d/10-monitor.conf

    Section "Monitor"
        Identifier             "Monitor0"
    EndSection

    Section "Device"
        Identifier             "Device0"
        Driver                 "vesa" #Choose the driver used for this monitor
    EndSection

    Section "Screen"
        Identifier             "Screen0"  #Collapse Monitor and Device section to Screen section
        Device                 "Device0"
        Monitor                "Monitor0"
        DefaultDepth           16 #Choose the depth (16||24)
        SubSection             "Display"
            Depth              16
            Modes              "1024x768_75.00" #Choose the resolution
        EndSubSection
    EndSection

> Multiple monitors

See main article Multihead for general information.

See also GPU-specific instructions:

-   NVIDIA#Multiple monitors
-   Nouveau#Dual Head
-   AMD Catalyst#Double Screen (Dual Head / Dual Screen / Xinerama)
-   ATI#Dual Head setup

More than one graphics card

You must define the correct driver to use and put the bus ID of your
graphic cards.

    Section "Device"
        Identifier             "Screen0"
        Driver                 "nouveau"
        BusID                  "PCI:0:12:0"
    EndSection

    Section "Device"
        Identifier             "Screen1"
        Driver                 "radeon"
        BusID                  "PCI:1:0:0"
    EndSection

To get your bus ID:

    $ lspci | grep VGA

    01:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600M GT] (rev a1)

The bus ID here is 1:0:0.

> Display size and DPI

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Xorg always sets 
                           dpi to 96. See this,     
                           this and finally this.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The DPI of the X server is determined in the following manner:

1.  The -dpi command line option has highest priority.
2.  If this is not used, the DisplaySize setting in the X config file is
    used to derive the DPI, given the screen resolution.
3.  If no DisplaySize is given, the monitor size values from DDC are
    used to derive the DPI, given the screen resolution.
4.  If DDC does not specify a size, 75 DPI is used by default.

In order to get correct dots per inch (DPI) set, the display size must
be recognized or set. Having the correct DPI is especially necessary
where fine detail is required (like font rendering). Previously,
manufacturers tried to create a standard for 96 DPI (a 10.3" diagonal
monitor would be 800x600, a 13.2" monitor 1024x768). These days, screen
DPIs vary and may not be equal horizontally and vertically. For example,
a 19" widescreen LCD at 1440x900 may have a DPI of 89x87. To be able to
set the DPI, the Xorg server attempts to auto-detect your monitor's
physical screen size through the graphic card with DDC. When the Xorg
server knows the physical screen size, it will be able to set the
correct DPI depending on resolution size.

To see if your display size and DPI are detected/calculated correctly:

    $ xdpyinfo | grep -B2 resolution

Check that the dimensions match your display size. If the Xorg server is
not able to correctly calculate the screen size, it will default to
75x75 DPI and you will have to calculate it yourself.

If you have specifications on the physical size of the screen, they can
be entered in the Xorg configuration file so that the proper DPI is
calculated:

    Section "Monitor"
        Identifier             "Monitor0"
        DisplaySize             286 179    # In millimeters
    EndSection

If you only want to enter the specification of your monitor without
creating a full xorg.conf create a new config file. For example
(/etc/X11/xorg.conf.d/90-monitor.conf):

    Section "Monitor"
        Identifier             "<default monitor>"
        DisplaySize            286 179    # In millimeters
    EndSection

If you do not have specifications for physical screen width and height
(most specifications these days only list by diagonal size), you can use
the monitor's native resolution (or aspect ratio) and diagonal length to
calculate the horizontal and vertical physical dimensions. Using the
Pythagorean theorem on a 13.3" diagonal length screen with a 1280x800
native resolution (or 16:10 aspect ratio):

    $ echo 'scale=5;sqrt(1280^2+800^2)' | bc  # 1509.43698

This will give the pixel diagonal length and with this value you can
discover the physical horizontal and vertical lengths (and convert them
to millimeters):

    $ echo 'scale=5;(13.3/1509)*1280*25.4' | bc  # 286.43072
    $ echo 'scale=5;(13.3/1509)*800*25.4'  | bc  # 179.01920

Note:This calculation works for monitors with square pixels; however,
there is the seldom monitor that may compress aspect ratio (e.g 16:10
aspect resolution to a 16:9 monitor). If this is the case, you should
measure your screen size manually.

Setting DPI manually

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: The following    
                           option is reported to    
                           work only with NVIDIA    
                           proprietary drivers.     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

DPI can be set manually if you only plan to use one resolution (DPI
calculator):

    Section "Monitor"
        Identifier             "Monitor0"
        Option                 "DPI" "96 x 96"
    EndSection

If you use an NVIDIA card, you can manually set the DPI adding the
options bellow on /etc/X11/xorg.conf.d/20-nvidia.conf (inside Device
section):

    Option              "UseEdidDpi" "False"
    Option              "DPI" "96 x 96"

For RandR compliant drivers, you can set it by:

    $ xrandr --dpi 96

See Execute commands after X start to make it permanent.

Note:While you can set any dpi you like and applications using Qt and
GTK will scale accordingly, it's recommended to set it to 96, 120 (25%
higher), 144 (50% higher), 168 (75% higher), 192 (100% higher) etc., to
reduce scaling artifacts to GUI that use bitmaps. Reducing it below 96
dpi may not reduce size of graphical elements of GUI as typically the
lowest dpi the icons are made for is 96.

> DPMS

DPMS (Display Power Management Signaling) is a technology that allows
power saving behaviour of monitors when the computer is not in use. This
will allow you to have your monitors automatically go into standby after
a predefined period of time. See: DPMS

Composite
---------

The Composite extension for X causes an entire sub-tree of the window
hierarchy to be rendered to an off-screen buffer. Applications can then
take the contents of that buffer and do whatever they like. The
off-screen buffer can be automatically merged into the parent window or
merged by external programs, called compositing managers. See the
following page for more info.

-   Compiz -- The original composite/window manager from Novell
-   Xcompmgr -- A simple composite manager capable of drop shadows and
    primitive transparency
-   Compton -- A fork of xcompmgr with feature improves and bug fix
-   Cairo Composite Manager -- A versatile and extensible composite
    manager which uses cairo for rendering.
-   Wikipedia:Compositing window manager

Tips and tricks
---------------

> X startup tweaking (startx)

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: /usr/bin/startx  
                           should not be modified,  
                           startx recognises the    
                           options as command line  
                           arguments (Discuss)      
  ------------------------ ------------------------ ------------------------

For X's option reference see:

    $ man Xserver

The following options have to be appended to the variable
"defaultserverargs" in the /usr/bin/startx file:

-   Enable deferred glyph loading for 16 bit fonts:

    -deferglyphs 16

Note:If you start X with kdm, the startx script does not seem to be
executed. X options must be appended to the variable ServerArgsLocal in
the /usr/share/config/kdm/kdmrc file.

> Nested X session

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: mention xephyr   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

To run a nested session of another desktop environment:

    $ /usr/bin/Xnest :1 -geometry 1024x768+0+0 -ac -name Windowmaker & wmaker -display :1

This will launch a Window Maker session in a 1024 by 768 window within
your current X session.

This needs the package xorg-server-xnest to be installed.

> Starting GUI programs remotely

See main article: SSH#X11 forwarding.

> On-demand disabling and enabling of input sources

With the help of xinput you can temporarily disable or enable input
sources. This might be useful, for example, on systems that have more
than one mouse, such as the ThinkPads and you would rather use just one
to avoid unwanted mouse clicks.

Install the xorg-xinput package from the official repositories.

Find the ID of the device you want to disable:

    $ xinput

For example in a Lenovo ThinkPad T500, the output looks like this:

    $ xinput

    ⎡ Virtual core pointer                          id=2    [master pointer  (3)]
    ⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
    ⎜   ↳ TPPS/2 IBM TrackPoint                     id=11   [slave  pointer  (2)]
    ⎜   ↳ SynPS/2 Synaptics TouchPad                id=10   [slave  pointer  (2)]
    ⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
        ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
        ↳ Power Button                              id=6    [slave  keyboard (3)]
        ↳ Video Bus                                 id=7    [slave  keyboard (3)]
        ↳ Sleep Button                              id=8    [slave  keyboard (3)]
        ↳ AT Translated Set 2 keyboard              id=9    [slave  keyboard (3)]
        ↳ ThinkPad Extra Buttons                    id=12   [slave  keyboard (3)]

Disable the device with xinput --disable device_id, where device_id is
the device ID you want to disable. In this example we will disable the
Synaptics Touchpad, with the ID 10:

    $ xinput --disable 10

To re-enable the device, just issue the opposite command:

    $ xinput --enable 10

Troubleshooting
---------------

> Common problems

If Xorg will not start, the screen is completely black, the keyboard and
mouse are not working, etc., first take these simple steps:

-   Check the log file: cat /var/log/Xorg.0.log
-   Check specific pages in Category:Input devices if you have issues
    with keyboard, mouse, touchpad etc.
-   Finally, search for common problems in ATI, Intel and NVIDIA
    articles.

> CTRL right key does not work with oss keymap

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: The file will be 
                           overwritten on           
                           xkeyboard-config update; 
                           for such simple task     
                           should be used Xmodmap.  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Edit as root /usr/share/X11/xkb/symbols/fr, and change the line:

    include "level5(rctrl_switch)"

to

    // include "level5(rctrl_switch)"

Then restart X, reboot or run

    setxkbmap fr oss

> X clients started with "su" fail

If you are getting "Client is not authorized to connect to server", try
adding the line:

    session        optional        pam_xauth.so

to /etc/pam.d/su. pam_xauth will then properly set environment variables
and handle xauth keys.

> Program requests "font '(null)'"

-   Error message: "unable to load font `(null)'."

Some programs only work with bitmap fonts. Two major packages with
bitmap fonts are available, xorg-fonts-75dpi and xorg-fonts-100dpi. You
do not need both; one should be enough. To find out which one would be
better in your case, try this:

    $ xdpyinfo | grep resolution

and use what is closer to you (75 or 100 instead of XX)

    # pacman -S xorg-fonts-XXdpi

> Frame-buffer mode problems

If X fails to start with the following log messages,

    (WW) Falling back to old probe method for fbdev
    (II) Loading sub module "fbdevhw"
    (II) LoadModule: "fbdevhw"
    (II) Loading /usr/lib/xorg/modules/linux//libfbdevhw.so
    (II) Module fbdevhw: vendor="X.Org Foundation"
           compiled for 1.6.1, module version=0.0.2
           ABI class: X.Org Video Driver, version 5.0
    (II) FBDEV(1): using default device

    Fatal server error:
    Cannot run in framebuffer mode. Please specify busIDs for all framebuffer devices

uninstall fbdev:

    # pacman -R xf86-video-fbdev

> DRI with Matrox cards stops working

If you use a Matrox card and DRI stops working after upgrading to Xorg,
try adding the line:

    Option "OldDmaInit" "On"

to the Device section that references the video card in xorg.conf.

> Recovery: disabling Xorg before GUI login

If Xorg is set to boot up automatically and for some reason you need to
prevent it from starting up before the login/display manager appears (if
the system is wrongly configured and Xorg does not recognize your mouse
or keyboard input, for instance), you can accomplish this task with two
methods.

-   Change default target to rescue.target. See systemd#Change default
    target to boot into.
-   If you have not only a faulty system that makes Xorg unusable, but
    you have also set the GRUB menu wait time to zero, or cannot
    otherwise use GRUB to prevent Xorg from booting, you can use the
    Arch Linux live CD. Boot up the live CD and log in as root. You need
    a mount point, such as /mnt, and you need to know the name of the
    partition you want to mount.

You can use the command,

    # fdisk -l

to see your partitions. Usually, the one you want will be resembling
/dev/sda1. Then, to mount this to /mnt, use

    # mount /dev/sda1 /mnt

Then your filesystem will show up under /mnt. From here you can delete
the gdm daemon to prevent Xorg from booting up normally or make any
other necessary changes to the configuration.

> X failed to start: Keyboard initialization failed

If your hard disk is full, startx will fail. /var/log/Xorg.0.log will
end with:

    (EE) Error compiling keymap (server-0)
    (EE) XKB: Could not compile keymap
    (EE) XKB: Failed to load keymap. Loading default keymap instead.
    (EE) Error compiling keymap (server-0)
    (EE) XKB: Could not compile keymap
    XKB: Failed to compile keymap
    Keyboard initialization failed. This could be a missing or incorrect setup of xkeyboard-config.
    Fatal server error:
    Failed to activate core devices.
    Please consult the The X.Org Foundation support  at http://wiki.x.org
    for help.
    Please also check the log file at "/var/log/Xorg.0.log" for additional information.
    (II) AIGLX: Suspending AIGLX clients for VT switch

Make some free space on your root partition and X will start.

> Black screen, No protocol specified.., Resource temporarily unavailable for all or some users

X creates configuration and temporary files in current user's home
directory. Make sure there is free disk space available on the partition
your home directory resides in. Unfortunately, X server does not provide
any more obvious information about lack of disk space in this case.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xorg&oldid=305711"

Categories:

-   X Server
-   Graphics

-   This page was last modified on 20 March 2014, at 01:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
