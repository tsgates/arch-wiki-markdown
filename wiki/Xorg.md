Xorg
====

Summary

An all-inclusive overview about installing and managing Xorg

Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

Related

Start X at Login

Execute commands after X start

Login Manager

Window Manager

Font Configuration

X11 Cursors

Get All Mouse Buttons Working

Desktop Environment

Wayland

Free Video Drivers

Intel Graphics

ATI

Nouveau

Proprietary Video Drivers

AMD Catalyst

NVIDIA

Xorg is the public, open-source implementation of the X window system
version 11. Since Xorg is the most popular choice among Linux users, its
ubiquity has led to making it an ever-present requisite for GUI
applications, resulting in massive adoption from most distributions. See
the Xorg Wikipedia article or visit the Xorg website for more details.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running                                                            |
| -   3 Configuration                                                      |
|     -   3.1 Using split files                                            |
|     -   3.2 Using single file                                            |
|                                                                          |
| -   4 Input devices                                                      |
|     -   4.1 Touchpad Synaptics                                           |
|     -   4.2 Disabling input hot-plugging                                 |
|     -   4.3 Keyboard settings                                            |
|         -   4.3.1 Key repeat delay and rate                              |
|         -   4.3.2 Viewing keyboard settings                              |
|         -   4.3.3 Setting keyboard layout with hot-plugging              |
|         -   4.3.4 Setting keyboard layout without hot-plugging           |
|             (deprecated)                                                 |
|         -   4.3.5 Switching between keyboard layouts                     |
|         -   4.3.6 Enable pointerkeys                                     |
|                                                                          |
|     -   4.4 InputClasses                                                 |
|         -   4.4.1 Example configurations                                 |
|             -   4.4.1.1 Example: Wheel emulation (for a Trackpoint)      |
|             -   4.4.1.2 Example: Tap-to-click                            |
|             -   4.4.1.3 Example: Keyboard layout and model on Acer 5920G |
|                 laptop                                                   |
|             -   4.4.1.4 Example: Third button emulation (for all         |
|                 attached mice)                                           |
|                                                                          |
| -   5 Graphics                                                           |
|     -   5.1 Driver installation                                          |
|     -   5.2 Monitor settings                                             |
|         -   5.2.1 Getting started                                        |
|         -   5.2.2 Multiple monitors/Dual screen                          |
|             -   5.2.2.1 NVIDIA                                           |
|             -   5.2.2.2 More than one graphics card                      |
|             -   5.2.2.3 Script to toggle internal/external display for   |
|                 laptops                                                  |
|                                                                          |
|         -   5.2.3 Display Size and DPI                                   |
|             -   5.2.3.1 Setting DPI manually                             |
|                                                                          |
|         -   5.2.4 DPMS                                                   |
|                                                                          |
| -   6 Composite                                                          |
|     -   6.1 Disabling the extension                                      |
|     -   6.2 See also                                                     |
|                                                                          |
| -   7 Sample configurations                                              |
|     -   7.1 Sample 1: xorg.conf & /etc/X11/xorg.conf.d/10-evdev.conf     |
|                                                                          |
| -   8 Tips and tricks                                                    |
|     -   8.1 X startup (/usr/bin/startx) tweaking                         |
|     -   8.2 Nested X session                                             |
|     -   8.3 Starting GUI Programs Remotely                               |
|     -   8.4 On-Demand Disabling and Enabling of Input Sources            |
|                                                                          |
| -   9 Troubleshooting                                                    |
|     -   9.1 Common problems                                              |
|     -   9.2 Ctrl+Alt+Backspace does not work                             |
|         -   9.2.1 With input hot-plugging                                |
|             -   9.2.1.1 System-wide                                      |
|             -   9.2.1.2 User-specific                                    |
|                                                                          |
|         -   9.2.2 Without input hot-plugging                             |
|                                                                          |
|     -   9.3 CTRL right key does not work with oss keymap                 |
|     -   9.4 Apple keyboard issues                                        |
|     -   9.5 Touchpad tap-click issues                                    |
|     -   9.6 Extra mouse buttons not recognized                           |
|     -   9.7 X clients started with "su" fail                             |
|     -   9.8 Program requests "font '(null)'"                             |
|     -   9.9 Frame-buffer mode problems                                   |
|     -   9.10 DRI with Matrox cards stops working                         |
|     -   9.11 Recovery: disabling Xorg before GUI login                   |
|     -   9.12 X failed to start : Keyboard initialization failed          |
|     -   9.13 black screen, No protocol specified.., Resource temporarily |
|         unavailable for all or some users                                |
+--------------------------------------------------------------------------+

Installation
------------

First, you will need to install the X server with the package
xorg-server, available in the Official Repositories. You may also want
the useful utilities contained in the xorg-apps group.

Udev will detect your hardware and evdev will act as the hotplugging
input driver for almost all devices. Udev is provided by systemd and
xf86-input-evdev is required by xorg-server, so there is no need to
explicitly install those packages.

Tip:The default X environment is rather bare, and you will typically
seek to install a window manager or a desktop environment to supplement
X.

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
Xterm.

Note:X must always be run on the same tty where the login occurred, to
preserve the logind session. This is handled by the default
/etc/X11/xinit/xserverrc.

Warning:If you choose to use xinit instead of startx, you are
responsible for passing -nolisten tcp and ensuring the session does not
break by starting X on a different tty.

For more information, see xinitrc.

Note:

-   If a problem occurs, then view the log at /var/log/Xorg.0.log. Be on
    the lookout for any lines beginning with (EE), which represent
    errors, and also (WW), which are warnings that could indicate other
    issues.
-   If there is an empty .xinitrc file in your $HOME, either delete or
    edit it in order for X to start properly. If you do not do this X
    will show a blank screen with what appears to be no errors in your
    Xorg.0.log. Simply deleting it will get it running with a default X
    environment.

Configuration
-------------

Note:Arch supplies default configuration files in /etc/X11/xorg.conf.d,
and no extra configuration is necessary for most setups.

> Using split files

The /etc/X11/xorg.conf.d/ directory stores user-specific configuration.
You are free to add configuration files to /etc/X11/xorg.conf.d/, but
they must start with XX- (where XX is a number) and have a .conf suffix
(10 is read before 20, for example). These files are parsed by the X
server upon startup and are treated like part of the traditional
xorg.conf configuration file. The X server essentially treats the
collection of configuration files as one big file with entries from
xorg.conf at the end.

> Using single file

Xorg can also be configured via /etc/X11/xorg.conf or /etc/xorg.conf.
You can also generate skeleton for the xorg.conf by

     # Xorg :0 -configure

That should create an xorg.conf.new file in /root/ that you can copy
over to /etc/X11/xorg.conf for more information see man xorg.conf

Alternatively, your video card drivers may come with a tool to
automatically configure Xorg. In the case of NVIDIA, try nvidia-xconfig.
For ATI with the proprietary driver, try aticonfig.

Note: Config file keywords are case-insensitive, and “_” characters are
ignored. Most strings (including Option names) are also
case-insensitive, and insensitive to white space and “_” characters.

Input devices
-------------

Installing input drivers is not needed for most hardware. Nevertheless,
if evdev does not support your device, install the needed driver from
the xorg-drivers group (try pacman -Sg xorg-drivers for a listing).

You should have 10-evdev.conf in the /etc/X11/xorg.conf.d directory,
which manages the keyboard, the mouse, the touchpad and the touchscreen.

> Touchpad Synaptics

Main page: Touchpad Synaptics

If you have a laptop, you need to install the touchpad driver provided
by the xf86-input-synaptics package in the Official Repositories.

After installation, you can find 10-synaptics.conf in the
/etc/X11/xorg.conf.d directory. It is safe to comment out/delete the
InputClass line regarding the touchpad in 10-evdev.conf.

> Disabling input hot-plugging

Since version1.8 Xorg-server uses udev for device detection. The
following will disable the use of udev.

    Section "ServerFlags"
        Option          "AutoAddDevices" "False"
    EndSection

Warning:This will disable Xorg hot-plugging for all input devices and
revert to the same behavior as xorg-server 1.4. It is much more
convenient to let udev configure your devices. Therefore, disabling
hot-plugging is not recommended!

> Keyboard settings

Xorg may fail to detect your keyboard correctly. This might give
problems with your keyboard layout or keyboard model not being set
correctly.

To see a full list of keyboard models, layouts, variants and options,
open /usr/share/X11/xkb/rules/xorg.lst.

To set the keymap for the current Xorg session:

    $ setxkbmap dvorak

Key repeat delay and rate

Use xset r rate DELAY RATE to change them, then use xinitrc to make it
permanent. Values 170 and 30 are a good start point.

Viewing keyboard settings

    $ setxkbmap -print -verbose 10


     Setting verbose level to 10
     locale is C
     Applied rules from evdev:
     model:      evdev
     layout:     us
     options:    terminate:ctrl_alt_bksp
     Trying to build keymap using the following components:
     keycodes:   evdev+aliases(qwerty)
     types:      complete
     compat:     complete
     symbols:    pc+us+inet(evdev)+terminate(ctrl_alt_bksp)
     geometry:   pc(pc104)
     xkb_keymap {
             xkb_keycodes  { include "evdev+aliases(qwerty)" };
             xkb_types     { include "complete"      };
             xkb_compat    { include "complete"      };
             xkb_symbols   { include "pc+us+inet(evdev)+terminate(ctrl_alt_bksp)"    };
             xkb_geometry  { include "pc(pc104)"     };
     };

Setting keyboard layout with hot-plugging

Note:If you use GNOME, these settings will be ignored. You will have to
set the keyboard layout from the GNOME Keyboard applet. Follow the
Keyboard Layout link and add the layout you require and remove any you
do not. For XkbOptions, see GNOME#Modify_Keyboard_with_XkbOptions.

To change your keyboard layout, create a number-*.conf file (e.g.
10-keyboard.conf) with the following content:

    /etc/X11/xorg.conf.d/10-keyboard.conf

    Section "InputClass"
        Identifier             "Keyboard Defaults"
        MatchIsKeyboard	   "yes"
        Option	           "XkbLayout" "us"
        Option                 "XkbVariant" "colemak"
    EndSection

Alternatively, you can also combine XkbLayout and XkbVariant:

    /etc/X11/xorg.conf.d/10-keyboard.conf

    Section "InputClass"
        Identifier             "Keyboard Defaults"
        MatchIsKeyboard	   "yes"
        Option	           "XkbLayout" "us(colemak)"
    EndSection

Setting keyboard layout without hot-plugging (deprecated)

Note:Changing the keyboard layout through this method requires disabling
input hot-plugging.

To change the keyboard layout, use the XkbLayout option in the keyboard
InputDevice section. For example, if you have a keyboard with the
English (Great Britain) layout, your keyboard InputDevice section might
look similar to this:

    Section "InputDevice"
        Identifier             "Keyboard0"
        Driver                 "kbd"
        Option                 "XkbLayout" "gb"
    EndSection

To change the keyboard model, use the XkbModel option in the keyboard
InputDevice section. For example, if you have a Microsoft Wireless
Multimedia Keyboard:

    Option "XkbModel" "microsoftmult"

Switching between keyboard layouts

To be able to easily switch keyboard layouts, modify the Options used in
either of the above two methods. For example, to switch between a US and
a Swedish layout using the Caps Lock key, create a file
/etc/X11/xorg.conf.d/01-keyboard-layout.conf with the following content:

    Section "InputClass"
            Identifier             "keyboard-layout"
            MatchIsKeyboard        "on"
            Option "XkbLayout"     "us, se"
            Option "XkbOptions"    "grp:caps_toggle"
    EndSection

As an alternative, you can add the following to your .xinitrc:

    setxkbmap -layout "us, se" -option "grp:caps_toggle"

This is mainly useful if you run a Desktop Environment which does not
take care of keyboard layouts for you.

Tip:If you want to get a list of possible values for the layout and
options, you can find them in /usr/share/X11/xkb/rules/xorg.lst. They
are under sections ! layout and ! option respectively. These values work
for both the configuration file solution, and the command line
alternative.

Enable pointerkeys

Mouse keys is now disabled by default and has to be manually enabled:

    /etc/X11/xorg.conf.d/20-enable-pointerkeys.conf

    Section "InputClass"
        Identifier             "Keyboard Defaults"
        MatchIsKeyboard        "yes"
        Option                 "XkbOptions" "keypad:pointerkeys"
    EndSection

You can also run:

    $ setxkbmap -option keypad:pointerkeys

Both will make the Shift+Num Lock shortcut toggle mouse keys.

> InputClasses

Taken from: https://fedoraproject.org/wiki/Input_device_configuration

InputClasses are a new type of configuration section that does not apply
to a single device but rather to a class of devices, including
hotplugged devices. An InputClass section's scope is limited by the
matches specified – to apply to an input device, all matches must apply
to a device. An example InputClass section is provided below:

    Section "InputClass"
        Identifier             "touchpad catchall"
        MatchIsTouchpad        "on"
        Driver                 "synaptics"
    EndSection

The next snippet might also be helpful:

    Section "InputClass"
            Identifier             "evdev touchpad catchall"
            MatchIsTouchpad        "on"
            MatchDevicePath        "/dev/input/event*"
            Driver                 "evdev"
    EndSection

If this snippet is present in the xorg.conf or xorg.conf.d, any touchpad
present in the system is assigned the synaptics driver. Note that due to
precedence order (alphanumeric sorting of xorg.conf.d snippets) the
Driver setting overwrites previously set driver options – the more
generic the class, the earlier it should be listed. The default snippet
shipped with the xorg-x11-drv-Xorg package is 00-evdev.conf and applies
the evdev driver to all input devices.

The match options specify which devices a section may apply to. To match
a device, all match lines must apply. The following match lines are
supported (with examples):

-   MatchIsPointer, MatchIsKeyboard, MatchIsTouchpad,
    MatchIsTouchscreen, MatchIsJoystick – boolean options to apply to a
    group of devices.
-   MatchProduct "foo|bar": match any device with a product name
    containing either "foo" or "bar"
-   MatchVendor "foo|bar|baz": match any device with a vendor string
    containing either "foo", "bar", or "baz"
-   MatchDevicePath "/dev/input/event*": match any device with a device
    path matching the given patch (see fnmatch(3) for the allowed
    pattern)
-   MatchTag "foo|bar": match any device with a tag of either "foo" or
    "bar". Tags may be assigned by the config backend – udev in our case
    – to label devices that need quirks or special configuration.

An example section for user-specific configuration is:

    Section "InputClass"
        Identifier             "lasermouse slowdown"
        MatchIsPointer         "on"
        MatchProduct           "Lasermouse"
        MatchVendor            "LaserMouse Inc."
        Option                 "ConstantDeceleration" 20
    EndSection

This section would match a pointer device containing "Lasermouse" from
"Lasermouse Inc." and apply a constant deceleration of 20 on this device
– slowing it down by factor 20.

Some devices may get picked up by the X server when they really should
not be. These devices can be configured to be ignored:

    Section "InputClass"
        Identifier            "no need for accelerometers in X"
        MatchProduct          "accelerometer"
        Option                "Ignore" "on"
    EndSection

Example configurations

The following subsections describe example configurations for commonly
used configuration options. Note that if you use a desktop environment
such as GNOME or KDE, options you set in the xorg.conf may get
overwritten with user-specific options upon login.

Example: Wheel emulation (for a Trackpoint)

If you own a computer with a Trackpoint (a Thinkpad, for example) you
can add the following to the xorg.conf to use the middle button to
emulate a mouse wheel:

    Section "InputClass"
        Identifier            "Wheel Emulation"
        MatchIsPointer        "on"
        MatchProduct          "TrackPoint"
        Option                "EmulateWheelButton" "2"
        Option                "EmulateWheel" "on"
    EndSection

For full support of TrackPoints (including horizontal scrolling) you can
use the following:

    Section "InputClass"
        Identifier            "Trackpoint Wheel Emulation"
        MatchProduct	  "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device"
        MatchDevicePath	  "/dev/input/event*"
        Option		  "EmulateWheel"		"true"
        Option		  "EmulateWheelButton"	        "2"
        Option		  "Emulate3Buttons"	        "false"
        Option		  "XAxisMapping"		"6 7"
        Option		  "YAxisMapping"		"4 5"
    EndSection

Example: Tap-to-click

Tap-to-click can be enabled in the mouse configuration dialog (in the
touchpad tab) but if you need tapping enabled at gdm already, the
following snippet does it for you:

    Section "InputClass"
        Identifier            "tap-by-default"
        MatchIsTouchpad       "on"
        Option                "TapButton1" "1"
    EndSection

Example: Keyboard layout and model on Acer 5920G laptop

Keyboard model and layout may be set in the file
/etc/X11/xorg.conf.d/keyboard.conf or any other .conf file in the same
directory.

-   MatchIsKeyboard "yes": set the input device to a keyboard
-   Option "XkbModel" "acer_laptop": set the keyboard model to an Acer
    laptop keyboard. You may replace acer_laptop with your actual
    keyboard layout.
-   Option "XkbLayout" "be": set the keyboard layout to belgian. You may
    replace be with whatever layout you have.
-   Option "XkbVariant" "sundeadkeys": set the layout variant to Sun
    dead keys. You may omit the XkbVariant option if you stick with the
    default variant.

Note that a list of keyboard layouts and models can be found in
/usr/share/X11/xkb/rules/base.lst

    Section "InputClass"
        Identifier             "Keyboard Defaults"
        MatchIsKeyboard        "yes"
        Option                 "XkbModel" "acer_laptop"
        Option                 "XkbLayout" "be"
        Option                 "XkbVariant" "sundeadkeys"
    EndSection

Example: Third button emulation (for all attached mice)

Third button emulation allows you to use the 1 and 2 buttons (left and
right click) together to produce a button 3 event (middle-click), which
is really useful for copy and paste in X.

We will modify the mouse input catchall in
/etc/X11/xorg.conf.d/10-evdev.conf

    Section "InputClass"
            Identifier "evdev pointer catchall"
            MatchIsPointer "on"
            MatchDevicePath "/dev/input/event*"
            Driver "evdev"
            Option "Emulate3Buttons"     "True"
            Option "Emulate3Timeout"     "25"
    EndSection

Here you see the Option "Emulate3Buttons"     "True" and
Option "Emulate3Timeout"     "25" options that specify that 3 buttons
should be emulated and the delay to recognize both buttons down as a
middle click is 25ms.

Graphics
--------

> Driver installation

The default graphics driver is vesa (xf86-video-vesa), which handles a
large number of chipsets but does not include any 2D or 3D acceleration.
To enable graphics acceleration, you will need to install and use the
driver specific to your graphics card.

First, identify your card:

    $ lspci | grep VGA

Then, install an appropriate driver. You can search for these packages
with the following command:

    $ pacman -Ss xf86-video

Common open source drivers:

-   NVIDIA: xf86-video-nouveau (see Nouveau)
-   Intel: xf86-video-intel (see Intel)
-   ATI: xf86-video-ati (see ATI)

Common proprietary drivers:

-   NVIDIA: nvidia (see NVIDIA)
-   ATI: catalyst (see ATI Catalyst)

Xorg should run smoothly without closed source drivers, which are
typically needed only for advanced features such as fast 3D-accelerated
rendering for games, dual-screen setups, and TV-out.

> Monitor settings

Getting started

Note:This step is OPTIONAL and should not be done unless you know what
you are doing.  
 This step is NOT OPTIONAL if using dual monitors and the nouveau
driver. See Nouveau#Configuration.

First, create a new config file, such as
/etc/X11/xorg.conf.d/10-monitor.conf.

Insert the following code into the config file mentioned above:

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
        DefaultDepth            16 #Choose the depth (16||24)
        SubSection             "Display"
            Depth               16
            Modes              "1024x768_75.00" #Choose the resolution
        EndSubSection
    EndSection

Multiple monitors/Dual screen

NVIDIA

Please see: NVIDIA#Multiple monitors.

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

Script to toggle internal/external display for laptops

Run the following script after connecting to external displays with your
computer to change the display used by Xorg. It checks if a display is
connected to the port specified in EXT before changing displays.

To find out the display names to be specified in EXT run:

    # xrandr -q

The internal display should be connected when running the script, which
is always true for a laptop. To use this script the package xorg-xrandr
needs to be installed.

    #!/bin/bash

    IN="LVDS1"
    EXT="VGA1"

    if (xrandr | grep "$EXT" | grep "+")
        then
        xrandr --output $EXT --off --output $IN --auto
        else
            if (xrandr | grep "$EXT" | grep " connected")
                then
                xrandr --output $IN --off --output $EXT --auto
            fi
    fi

Display Size and DPI

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

    echo 'scale=5;sqrt(1280^2+800^2)' | bc  # 1509.43698

This will give the pixel diagonal length and with this value you can
discover the physical horizontal and vertical lengths (and convert them
to millimeters):

    echo 'scale=5;(13.3/1509)*1280*25.4' | bc  # 286.43072
    echo 'scale=5;(13.3/1509)*800*25.4'  | bc  # 179.01920

Note:This calculation works for monitors with square pixels; however,
there is the seldom monitor that may compress aspect ratio (e.g 16:10
aspect resolution to a 16:9 monitor). If this is the case, you should
measure your screen size manually.

Setting DPI manually

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

    xrandr --dpi 96

See Execute commands after X start to make it permanent.

Note: while you can set any dpi you like and applications using Qt and
GTK will scale accordingly, it's recommended to set it to 96, 120 (25%
higher), 144 (50% higher), 168 (75% higher), 192 (100% higher) etc., to
reduce scaling artifacts to GUI that use bitmaps. Reducing it below 96
dpi may not reduce size of graphical elements of GUI as typically the
lowest dpi the icons are made for is 96.

DPMS

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
merged by external programs, called compositing managers.

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Is this actually 
                           still true in recent     
                           Xorg releases? (Discuss) 
  ------------------------ ------------------------ ------------------------

The Composite extension can't be used simultaneously with Xinerama.
However, it can be used simultaneously with Nvidia Twinview.

> Disabling the extension

The composite extension is enabled by default. To disable it, add this
to xorg.conf or a file in /etc/xorg.conf.d:

    Section "Extensions"
        Option             "Composite" "Disable"
    EndSection

This may slightly improve your performance with some drivers.

> See also

-   AIGLX
-   Compiz -- The original composite/window manager from Novell
-   Xcompmgr -- A simple composite manager capable of drop shadows and
    primitive transparency
-   Compton -- A fork of xcompmgr with feature improves and bug fix
-   Cairo Composite Manager -- A versatile and extensible composite
    manager which uses cairo for rendering.
-   Wikipedia:Compositing window manager

Sample configurations
---------------------

Anyone who has an xorg.conf file written up that works, go ahead and
post a link to it here for others to look at. Please do not in-line the
entire configuration file; upload it somewhere else and link to it.

Please post input hotplugging configurations only, otherwise note that
your config is not using input hotplugging. (Xorg 1.8 = udev)

> Sample 1: xorg.conf & /etc/X11/xorg.conf.d/10-evdev.conf

This is a sample configuration file using
/etc/X11/xorg.conf.d/10-evdev.conf for the keyboard layouts:

Note:The "InputDevice" sections are commented out, because
/etc/X11/xorg.conf.d/10-evdev.conf is taking care of them.

    xorg.conf: http://pastebin.com/raw.php?i=EuSKahkn
    /etc/X11/xorg.conf.d/10-evdev.conf: http://pastebin.com/raw.php?i=4mPY35Mw
    /etc/X11/xorg.conf.d/10-monitor.conf (VMware): http://pastebin.com/raw.php?i=fJv8EXGb
    /etc/X11/xorg.conf.d/10-monitor.conf (KVM): http://pastebin.com/raw.php?i=NRz7v0Kn

Tips and tricks
---------------

> X startup (/usr/bin/startx) tweaking

For X's option reference see:

    $ man Xserver

The following options have to be appended to the variable
"defaultserverargs" in the /usr/bin/startx file:

-   Enable deferred glyph loading for 16 bit fonts:

    -deferglyphs 16

Note:If you start X with kdm, the startx script does not seem to be
executed. X options must be appended to the variable "ServerArgsLocal"
or "ServerCmd" in the /usr/share/config/kdm/kdmrc file. By default kdm
options are:

    ServerArgsLocal=-nolisten tcp
    ServerCmd=/usr/bin/X

> Nested X session

To run a nested session of another desktop environment:

    $ /usr/bin/Xnest :1 -geometry 1024x768+0+0 -ac -name Windowmaker & wmaker -display :1

This will launch a Window Maker session in a 1024 by 768 window within
your current X session.

This needs the package xorg-server-xnest to be installed.

> Starting GUI Programs Remotely

To start up a program that uses X when logged in remotely (such as
through ssh), you need to type this in from the remote login Bash shell:

    export DISPLAY=:0

Then invoke the program the way you would locally from the shell.

Hint: Add that line to ~/.bashrc to have it happen automatically every
time you log in.

> On-Demand Disabling and Enabling of Input Sources

With the help of xinput you can temporarily disable or enable input
sources. This might be useful, for example, on systems that have more
than one mouse, such as the ThinkPads and you would rather use just one
to avoid unwanted mouse clicks. Let's see how to accomplish this.

Install xinput from the xorg-xinput package:

    # pacman -S xorg-xinput

Find the ID of the device you want to disable:

    xinput

For example in a Lenovo ThinkPad T500, the output looks like this:

    $ xinput

    ⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
    ⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
    ⎜   ↳ TPPS/2 IBM TrackPoint                   	id=11	[slave  pointer  (2)]
    ⎜   ↳ SynPS/2 Synaptics TouchPad              	id=10	[slave  pointer  (2)]
    ⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
        ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
        ↳ Power Button                            	id=6	[slave  keyboard (3)]
        ↳ Video Bus                               	id=7	[slave  keyboard (3)]
        ↳ Sleep Button                            	id=8	[slave  keyboard (3)]
        ↳ AT Translated Set 2 keyboard            	id=9	[slave  keyboard (3)]
        ↳ ThinkPad Extra Buttons                  	id=12	[slave  keyboard (3)]

Disable the device with xinput --disable DEVICE, where DEVICE is the
device ID you want to disable. In this example we'll disable the
Synaptics Touchpad, with the ID 10:

    xinput --disable 10

To re-enable the device, just issue the opposite command:

    xinput --enable DEVICE

Troubleshooting
---------------

> Common problems

If Xorg will not start, the screen is completely black, the keyboard and
mouse are not working, etc., first take these simple steps:

-   Check the log file: cat /var/log/Xorg.0.log
-   Install input driver (keyboard, mouse, joystick, tablet, etc...):
-   Finally, search for common problems in ATI, Intel and NVIDIA
    articles.

> Ctrl+Alt+Backspace does not work

There are two ways of restoring Ctrl+Alt+Backspace; with and without
input-hotplugging. Using hot-plugging is recommended.

With input hot-plugging

System-wide

Within /etc/X11/xorg.conf.d/10-evdev.conf, simply add the following:

    Section "InputClass"                                                            
            Identifier "Keyboard Defaults"                                          
            MatchIsKeyboard "yes"                                                   
            Option "XkbOptions" "terminate:ctrl_alt_bksp"                           
    EndSection

Note:Using Gnome, an alternative would be to install the
gnome-tweak-tool from extra. Within the Gnome Tweak Tool: Typing >
Terminate and select the option Ctrl+Alt+Backspace from the dropdown
menu. This reactivates the keyboard shortcut for killing the X server in
Gnome.

Note:On KDE, this system-wide setting has no effect. To restore, go to
Kickoff > Computer > System Settings which will open up the System
Settings window. Click on 'Input Devices'. In this new window click the
Keyboard tab and then click on the advanced tab. In this new window,
click the box for 'Configure keyboard options.' Expand the entry for
'Key sequence to kill the X server' and ensure Ctrl+Alt+Backspace is
checked. Click Apply and close the System Settings window. You now have
your Ctrl+Alt+Backspace back in KDE.

User-specific

Another way is to put this line in xinitrc:

    setxkbmap -option terminate:ctrl_alt_bksp

Note:This setting has no effect on Gnome 3.

Without input hot-plugging

New Xorg disables zapping with Ctrl+Alt+Backspace by default. You can
enable it by adding the following line to /etc/X11/xorg.conf,

    Option                    "XkbOptions" "terminate:ctrl_alt_bksp"

to InputDevice section for keyboard.

> CTRL right key does not work with oss keymap

Edit as root /usr/share/X11/xkb/symbols/fr, and change the line :

    include "level5(rctrl_switch)"

to

    // include "level5(rctrl_switch)"

Then restart X or reboot.

> Apple keyboard issues

See: Apple Keyboard

> Touchpad tap-click issues

See: Synaptics

> Extra mouse buttons not recognized

See: Get All Mouse Buttons Working

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

-   From the GRUB menu, you can specify the runlevel in the kernel line
    by adding a number to the end of the kernel line specifying the run
    level you want. The following example sets the run level to 3:

     kernel /boot/vmlinuz-linux root=/dev/disk/by-uuid/..ro 3

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

> X failed to start : Keyboard initialization failed

If your hard disk is full, startx will fail. /var/log/Xorg.0.log will
end with:

    (EE) Error compiling keymap (server-0)
    (EE) XKB: Couldn't compile keymap
    (EE) XKB: Failed to load keymap. Loading default keymap instead.
    (EE) Error compiling keymap (server-0)
    (EE) XKB: Couldn't compile keymap
    XKB: Failed to compile keymap
    Keyboard initialization failed. This could be a missing or incorrect setup of xkeyboard-config.
    Fatal server error:
    Failed to activate core devices.
    Please consult the The X.Org Foundation support  at http://wiki.x.org
    for help.
    Please also check the log file at "/var/log/Xorg.0.log" for additional information.
     (II) AIGLX: Suspending AIGLX clients for VT switch

Make some free space on your root partition and X will start.

> black screen, No protocol specified.., Resource temporarily unavailable for all or some users

X creates configuration and temporary files in current user's home
directory. Make sure there is free disk space available on the partition
your home directory resides in. Unfortunately, X server does not provide
any more obvious information about lack of disk space in this case.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xorg&oldid=253992"

Category:

-   X Server
