Touchpad Synaptics
==================

> Summary

This article details the installation and configuration of the Synaptics
input driver in Arch Linux.

> Related

Xorg

Touchpad Synaptics/10-synaptics.conf example

This article details the installation and configuration process of the
Synaptics input driver for Synaptics (and ALPS) touchpads found on most
notebooks.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Frequently used options                                      |
|     -   2.2 Other options                                                |
|     -   2.3 GNOME                                                        |
|     -   2.4 MATE                                                         |
|     -   2.5 Configuration on the fly                                     |
|         -   2.5.1 Console tools                                          |
|         -   2.5.2 Graphical tools                                        |
|                                                                          |
| -   3 Advanced Configuration                                             |
|     -   3.1 Using xinput to determine touchpad capabilities              |
|     -   3.2 Synclient                                                    |
|     -   3.3 Circular Scrolling                                           |
|     -   3.4 Natural Scrolling                                            |
|     -   3.5 Software Toggle                                              |
|     -   3.6 Disable Trackpad while Typing                                |
|         -   3.6.1 Using automatic palm detection                         |
|         -   3.6.2 Using .xinitrc                                         |
|         -   3.6.3 Using a Login Manager                                  |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 xorg.conf.d/50-synaptics.conf doesn't seem to apply under    |
|         GNOME and MATE                                                   |
|     -   4.2 ALPS Touchpads                                               |
|     -   4.3 The touchpad is not working, Xorg.0.log shows "Query no      |
|         Synaptics: 6003C8"                                               |
|     -   4.4 Touchpad detected as "PS/2 Generic Mouse" or "Logitech PS/2  |
|         mouse"                                                           |
|     -   4.5 Non-functional Synaptics Special Abilities (multi-tap,       |
|         scrolling, etc.)                                                 |
|     -   4.6 Disable touchpad upon external mouse detection               |
|     -   4.7 Cursor Jump                                                  |
|     -   4.8 Touchpad device is not located at /dev/input/*               |
|     -   4.9 Firefox and special touchpad events                          |
|     -   4.10 Opera: horizontal scrolling issues                          |
|     -   4.11 Scrolling and multiple actions with Synaptics on LG Laptops |
|     -   4.12 Other external mouse issues                                 |
|     -   4.13 Touchpad synchronization issues                             |
|     -   4.14 Delay between a button tap and the actual click             |
|     -   4.15 SynPS/2 Synaptics TouchPad can not grab event device,       |
|         errno=16                                                         |
|     -   4.16 Synaptics Loses Multitouch Detection After Rebooting From   |
|         Windows                                                          |
|     -   4.17 Buttonless TouchPads (aka ClickPads)                        |
|     -   4.18 Touchpad detected as mouse (elantech touchpads)             |
|                                                                          |
| -   5 External Resources                                                 |
+--------------------------------------------------------------------------+

Installation
------------

The Synaptics driver can be installed with the package
xf86-input-synaptics, available in the official repositories.

Configuration
-------------

The primary method of configuration for the touchpad is through an Xorg
server configuration file. After installation of xf86-input-synaptics, a
default configuration file is located at
/etc/X11/xorg.conf.d/50-synaptics.conf.

Users can edit this file to configure the various driver options
available, for a complete list of all available options users should
refer to the synaptics manual page:

    $ man synaptics

Note:Synaptics 1.0 and higher support input device properties if the
driver is running on X server 1.6 or higher. On these driver versions,
Option "SHMConfig" is not needed to enable run-time configuration. See
man page for more info.

> Frequently used options

The following lists options that many users may wish to configure. Note
that all these options can simply be added to the main configuration
file in /etc/X11/xorg.conf.d/50-synaptics.conf, as shown in this example
configuration file where we have enabled vertical, horizontal and
circular scrolling:

    /etc/X11/xorg.conf.d/50-synaptics.conf

     Section "InputClass"
           Identifier "touchpad"
           Driver "synaptics"
           MatchIsTouchpad "on"
                  Option "TapButton1" "1"
                  Option "TapButton2" "2"
                  Option "TapButton3" "3"
                  Option "VertEdgeScroll" "on"
                  Option "VertTwoFingerScroll" "on"
                  Option "HorizEdgeScroll" "on"
                  Option "HorizTwoFingerScroll" "on"
                  Option "CircularScrolling" "on"
                  Option "CircScrollTrigger" "2"
                  Option "EmulateTwoFingerMinZ" "40"
                  Option "EmulateTwoFingerMinW" "8"
                  Option "CoastingSpeed" "0"
                  ...
     EndSection

 TapButton1
    (integer) configures which mouse-button is reported on a non-corner,
    one finger tap.
 TapButton2
    (integer) configures which mouse-button is reported on a non-corner,
    two finger tap
 TapButton3
    (integer) configures which mouse-button is reported on a non-corner,
    three finger tap
 RBCornerButton
    (integer) configures which mouse-button is reported on a right
    bottom corner, one finger tap (use Option "RBCornerButton" "3" to
    achieve Ubuntu style tap behaviour for right mouse button in lower
    right corner)
 RTCornerButton
    (integer) as above, but for top right corner, one finger tap.
 VertEdgeScroll
    (boolean) enables vertical scrolling while dragging across the right
    edge of the touch pad.
 HorizEdgeScroll
    (boolean) enables horizontal scrolling while dragging across the
    bottom edge of the touch pad.
 VertTwoFingerScroll
    (boolean) enables vertical scrolling using two fingers.
 HorizTwoFingerScroll
    (boolean) enables horizontal scrolling using two fingers.
 EmulateTwoFingerMinZ/W
    (integer) play with this value to set the precision of two finger
    scroll.

An example with a brief description of all options. As usual settings
will vary between machines. It is recommended that you discover your own
options using synclient.

Note:If you find that your hand frequently brushes your touchpad,
causing the TapButton2 option to be triggered (which will more than
likely paste from your clipboard), and you do not mind losing
two-finger-tap functionality, set TapButton2 to -1.

Note:Recent versions include a "Coasting" feature, enabled by default,
which may have the undesired effect of continuing almost any scrolling
until the next tap or click, even if you are no longer touching the
touchpad. This means that to scroll just a bit, you need to scroll (by
using the edge, or a multitouch option) and then almost immediately tap
the touchpad, otherwise scrolling will continue forever. If wish to
avoid this, set CoastingSpeed to 0.

> Other options

 VertScrollDelta and HorizScrollDelta
    (integer) configures the speed of scrolling, it's a bit
    counter-intuitive because higher values produce greater precision
    and thus slower scrolling. Negative values cause natural scrolling
    like in OS X.

 SHMConfig
    (boolean) Switch on/off shared memory for run-time debugging. This
    option does not have an effect on run-time configuration anymore and
    is only useful for hardware event debugging.

> GNOME

Users of GNOME may have to edit its configuration as well, because in
default it is set to disable tapping to click, horizontal scrolling and
not to allow touchpad disabling while typing.

To change these settings in Gnome 2:

1.  Run gconf-editor
2.  Edit the keys in the /desktop/gnome/peripherals/touchpad/ folder.

To change these settings in Gnome 3:

1.  Open System Settings.
2.  Click Mouse and Touchpad.
3.  Change the settings on the Touchpad tab.

Gnome settings daemon may override existing settings (for example ones
set in xorg.conf.d) for which there is no equivalent in any of the
graphical configuration utilities. It is possible to stop gnome from
touching mouse settings at all:

1.  Run dconf-editor
2.  Edit /org/gnome/settings-daemon/plugins/mouse/
3.  Uncheck the active setting

It will now respect your system's existing synaptics configuration.

> MATE

As with GNOME, it is possible configure the way MATE handles the
touchpad:

1.  Run mateconf-editor
2.  Edit the keys in the desktop/mate/peripherals/touchpad/ folder.

To prevent Mate settings daemon from overriding existing settings, do as
follows:

1.  Run mateconf-editor
2.  Edit /apps/mate_settings_daemon/plugins/mouse/
3.  Uncheck the active setting.

  

> Configuration on the fly

Next to the traditional method of configuration, the Synaptics driver
also supports on the fly configuration. This means that users can set
certain options through a software application, these options are
applied immediately without needing a restart of Xorg. This is useful to
test configuration options before you include them in the configuration
file.

Note:The SHMConfig option has been removed from Synaptics. Configuration
through synclient doesn't need it anymore.

Warning:On-the-fly configuration is non-permanent and will not remain
active through a reboot, suspend/resume, or restart of Xorg. This should
only be used to test, fine-tune or script configuration features.

Console tools

-   Synclient (Recommended) — command line utility to configure and
    query Synaptics driver settings on a live system, the tool is
    developed by the synaptics driver maintainers and is provided with
    the synaptics driver

http://xorg.freedesktop.org/ || xf86-input-synaptics

-   xinput — small general-purpose CLI tool to configure devices

http://xorg.freedesktop.org/ || xorg-xinput

Graphical tools

Warning:Some of the tools below still require the obsolete SHMConfig
mode, and will not work with current xf86-input-synaptics driver. Please
remove outdated tools from the list.

-   GPointing Device Settings — provides graphical on the fly
    configuration for several pointing devices connected to the system,
    including your synaptics touch pad. This application replaces
    GSynaptics as the preferred tool for graphical touchpad
    configuration through the synaptics driver

http://live.gnome.org/GPointingDeviceSettings ||
gpointing-device-settings

Note:For GPointingDeviceSettings to work with Synaptics touchpads both
xf86-input-synaptics and libsynaptics have to be installed!

-   GSynaptics (Deprecated!) — allows the user to configure options such
    as horizontal, vertical and circular scrolling as well as the option
    to enable or disable the touchpad. The GSynaptics website mentions
    that its development has stopped and that it will eventually be
    outdated, the application functions perfectly with xorg 1.11,
    through users looking for a graphical tools are suggested to use
    GPointingDeviceSettings instead, GSynaptics should only be used as a
    last resort

http://gsynaptics.sourceforge.jp/ || gsynaptics

-   Synaptiks — touchpad configuration and management tool for KDE. It
    provides a System Settings module to configure basic and advanced
    features of the touchpad. Additionally it comes with a little system
    tray application, which can switch the touchpad automatically off,
    while an external mouse is plugged or while you are typing.

http://synaptiks.lunaryorn.de || synaptiks

Advanced Configuration
----------------------

> Using xinput to determine touchpad capabilities

Depending on your model, synaptic touchpads may have or lack
capabilities. We can determine which capabilities your hardware supports
by using xinput.

-   left, middle and right hardware buttons
-   two finger detection
-   three finger detection
-   configurable resolution

First, find the name of your touchpad:

    $ xinput -list

You can now use xinput to find your touchpad's capabilities:

    $ xinput list-props "SynPS/2 Synaptics TouchPad" | grep Capabilities

          Synaptics Capabillities (309):  1, 0, 1, 0, 0, 1, 1

From left to right, this shows:

-   (1) device has a physical left button
-   (0) device does not have a physical middle button
-   (1) device has a physical right button
-   (0) device does not support two-finger detection
-   (0) device does not support three-finger detection
-   (1) device can configure vertical resolution
-   (1) device can configure horizontal resolution

Use xinput list-props "SynPS/2 Synaptics TouchPad" to list all device
properties.

> Synclient

Synclient can configure every option available to the user as documented
in $ man synaptics. A full list of the current user settings can be
brought up:

    $ synclient -l

Every listed configuration option can be controlled through synclient,
for example:

    $ synclient PalmDetect=1 (to enable palm detection)
    $ synclient TapButton1=1 (configure button events)
    $ synclient TouchpadOff=1 (disable the touchpad)

After you have successfully tried and tested your options through
synclient, you can make these changes permanent by adding them to
/etc/X11/xorg.conf.d/50-synaptics.conf.

The synclient monitor can display pressure and placement on the touchpad
in real-time, allowing further refinement of the default Synaptics
settings.

You can start the Synaptics monitor with the following command:

    $ synclient -m 100

Where -m activates the monitor and the following number specifies the
update interval in milliseconds.

This monitor provides information about the current state of your
touchpad. For example, if you move the mouse with the touchpad, the x
and y values in the monitor will change. Therewith you can easy figure
out your touchpad's dimension which is defined in the LeftEdge-,
RightEdge-, BottomEdge- and TopEdge-Options.

The abbreviations for the parameters are as follow:

  Abbreviation      Description
  ----------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------
  time              Time in seconds since the logging was started.
  x, y              The x/y coordinates of the finger on the touchpad. The origin is in the upper left corner.
  z                 The pressure value. It represents the pressure you are using to navigate on your touchpad.
  f                 Number of fingers currently touching the touchpad.
  w                 Value that represents the finger width.
  l,r,u,d,m,multi   Those values represent the state of the left, right, up, down, middle and multi buttons pressed where zero means not pressed and one means pressed.
  gl,gm,gr          For touchpads which have a guest device, this are the associated button states for guest left, guest middle and guest right pressed (1) and not pressed (0).
  gdx, gdy          x/y coordinates of the guest device.

If a value constantly is zero, it implies that this option is not
supported by your device.

Now use synclient to test new values. For example, to adjust minimum
pointer speed:

    $ synclient MinSpeed=0.5

To make the changes permanent, they will need to be put in your
/etc/X11/xorg.conf.d/50-synaptics.conf file.

> Circular Scrolling

Circular scrolling is a feature that Synaptics offers which closely
resembles the behaviour of iPods. Instead of (or additional to)
scrolling horizontally or vertically, you can scroll circularly. Some
users find this faster and more precise. To enable circular scrolling,
add the following options to the touchpad device section of
/etc/X11/xorg.conf.d/50-synaptics.conf:

    /etc/X11/xorg.conf.d/50-synaptics.conf

     Section "InputClass"
             ...
             Option      "CircularScrolling"          "on"
             Option      "CircScrollTrigger"          "0"
             ...
     EndSection

The option CircScrollTrigger may be one of the following values,
determining which edge circular scrolling should start:

    0    All Edges
    1    Top Edge
    2    Top Right Corner
    3    Right Edge
    4    Bottom Right Corner
    5    Bottom Edge
    6    Bottom Left Corner
    7    Left Edge
    8    Top Left Corner

Specifying something different from zero may be useful if you want to
use circular scrolling in conjunction with horizontal and/or vertical
scrolling. If you do so, the type of scrolling is determined by the edge
you start from.

To scroll fast, draw small circles in the center of your touchpad. To
scroll slowly and more precise, draw large circles.

> Natural Scrolling

It is possible to enable natural scrolling through synaptics. Simply use
negative values for VertScrollDelta and HorizScrollDelta like so:

    /etc/X11/xorg.conf.d/50-synaptics.conf

     Section "InputClass"
             ...
             Option      "VertScrollDelta"          "-111"
             Option      "HorizScrollDelta"         "-111"
             ...
     EndSection

> Software Toggle

You may find it useful to have a software toggle that will turn on or
off your touchpad, especially if it is extremely sensitive and you are
doing a lot of typing. Please also see #Disable touchpad upon external
mouse detection as that may be better solution, a matter of choice. The
advantage here is you have the control, while the other solution has a
daemon determine when to turn off the trackpad.

You will want to grab xbindkeys if you do not already have key binding
software.

Then save this script to something such as /sbin/trackpad-toggle.sh:

    /sbin/trackpad-toggle.sh

     #!/bin/bash
     
     synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')

Then finally add a key binding to use the script. It is best to call
with xbindkeys like so (file ~/.xbindkeysrc):

    ~/.xbindkeysrc

     "/sbin/trackpad-toggle.sh"
         m:0x5 + c:65
         Control+Shift + space

Now just (re)start xbindkeys and Ctrl+Shift+Space will now toggle your
trackpad!

Of course you could easily use any other keybinding software, such as
the ones provided by Xfce4 and GNOME.

> Disable Trackpad while Typing

Using automatic palm detection

First of all you should test if it works properly for your trackpad and
if the settings are accurate:

    $ synclient PalmDetect=1

Then test the typing. You can tweak the detection with:

    $ synclient PalmMinWidth=

which is the width of the area your hand touches, and

    $ synclient PalmMinZ=

which is the minimum Z distance at which the detection is performed.

Once you have found the correct settings, save them into
/etc/X11/xorg.conf.d/50-synaptics.conf like this:

    #synclient PalmDetect=1
    Option "PalmDetect" "1"
    #synclient PalmMinWidth=10
    Option "PalmMinWidth" "10"
    #synclient PalmMinZ=200
    Option "PalmMinZ" "200"

Using .xinitrc

To have the touchpad disabled automatically when you begin typing, add
the following line to your ~/.xinitrc before you run your window manager
(if not using a login manager):

    $ syndaemon -t -k -i 2 -d &

 -i 2
    sets the idle time to 2 seconds. The idle time specifies how many
    seconds to wait after the last key-press before enabling the
    touchpad again.
 -t
    tells the daemon not to disable mouse movement when typing and only
    disable tapping and scrolling.
 -k
    tells the daemon to ignore modifier keys when monitoring keyboard
    activity (e.g.: allows Ctrl+Left Click).
 -d
    starts as a daemon, in the background.

More details are available in the man page:

    $ man syndaemon

If you are using a login manager, you will need to specify the command
where your DE allows you to do so.

Using a Login Manager

The "-d" option is necessary to start syndaemon as a background process
for post Login instructions.

For GNOME: (GDM)

To start syndaemon you need to use Gnome's Startup Applications
Preferences program. Login to Gnome and go to System > Preferences >
Startup Applications. In the Startup Programs tab click the Add button.
Name the Startup Program whatever you like and input any comments you
like (or leave this field blank). In the command field add:

    In Gnome 3 run gnome-session-properties to access startup applications. 

    $ syndaemon -t -k -i 2 -d &

When you are done, click the Add button in the Add Startup Program
dialogue. Make sure the check box next to the startup program you have
created is checked, in the list of additional startup programs. Close
the Startup Applications Preferences window and you are done.

For KDE: (KDM)

Goto System Settings > Startup and Shutdown > Autostart, then click Add
Program, enter:

     syndaemon -t -k -i 2 -d &

Then check Run in terminal.

Troubleshooting
---------------

> xorg.conf.d/50-synaptics.conf doesn't seem to apply under GNOME and MATE

GNOME and MATE, by default, will overwrite various options for your
touch-pad. This includes configurable features for which there is no
graphical configuration within GNOME's system control panel. This may
cause it to appear that /etc/X11/xorg.conf.d/50-synaptics.conf isn't
applied. Please refer to the GNOME section in this article to prevent
this behavior.

-   Touchpad_Synaptics#GNOME

> ALPS Touchpads

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

TODOneeds to be rewritten for udev

For ALPS Touchpads, if the above configuration does not provide the
desired results, try the following configuration instead:

    /etc/X11/xorg.conf.d/50-synaptics.conf

      Section "ServerLayout"
        ...
        InputDevice    "USB Mouse" "CorePointer"
        InputDevice    "Touchpad"  "SendCoreEvents"
      EndSection

      Section "InputDevice"
            Identifier  "Touchpad"
        Driver  "synaptics"
        Option  "Device"   "/dev/input/mouse0"
        Option  "Protocol"   "auto-dev"
        Option  "LeftEdge"   "130"
        Option  "RightEdge"   "840"
        Option  "TopEdge"   "130"
        Option  "BottomEdge"   "640"
        Option  "FingerLow"   "7"
        Option  "FingerHigh"   "8"
        Option  "MaxTapTime"   "180"
        Option  "MaxTapMove"   "110"
        Option  "EmulateMidButtonTime"   "75"
        Option  "VertScrollDelta"   "20"
        Option  "HorizScrollDelta"   "20"
        Option  "MinSpeed"   "0.25"
        Option  "MaxSpeed"   "0.50"
        Option  "AccelFactor"   "0.010"
        Option  "EdgeMotionMinSpeed"   "200"
        Option  "EdgeMotionMaxSpeed"   "200"
        Option  "UpDownScrolling"   "1"
        Option  "CircularScrolling"   "1"
        Option  "CircScrollDelta"   "0.1"
        Option  "CircScrollTrigger"   "2"
        Option  "Emulate3Buttons"   "on"
      EndSection

> The touchpad is not working, Xorg.0.log shows "Query no Synaptics: 6003C8"

Due to the way synaptics is currently set-up, 2 instances of the
synaptics module are loaded. We can recognize this situation by opening
the xorg log file (/var/log/Xorg.0.log) and noticing this:

    /var/log/Xorg.0.log

     [ 9304.803] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev touchpad catchall"
     [ 9304.803] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad catchall"

Notice how 2 differently named instances of the module are being loaded.
In some cases, this causes the touchpad to become nonfunctional.

We can prevent this double loading by adding
MatchDevicePath "/dev/input/event*" to our
/etc/X11/xorg.conf.d/50-synaptics.conf file:

    /etc/X11/xorg.conf.d/50-synaptics.conf

     Section "InputClass"
           Identifier "touchpad catchall"
           Driver "synaptics"
           MatchIsTouchpad "on"
           MatchDevicePath "/dev/input/event*"
                 Option "TapButton1" "1"
                 Option "TapButton2" "2"
                 Option "TapButton3" "3"
     EndSection 

Restart X and check xorg logs again, the error should be gone and the
touchpad should be functional.

related bugreport: FS#20830

related forum topics:

-   https://bbs.archlinux.org/viewtopic.php?id=104769
-   https://bbs.archlinux.org/viewtopic.php?pid=825690

> Touchpad detected as "PS/2 Generic Mouse" or "Logitech PS/2 mouse"

This is caused by a kernel bug which was fixed in kernel version 3.3.
Wrongly detected touchpads cannot be configured with the Synaptic input
driver. To fix this, simply install the AUR package psmouse-alps-driver.

Among the affected notebooks are the following models:

-   Acer Aspire 7750G
-   Dell Latitude E6230, E6520, E6430 and E6530 (ALPS DualPoint
    TouchPad), Inspiron N5110 (ALPS GlidePoint), Inspiron 14R Turbo
    SE7420/SE7520 (ALPS GlidePoint)
-   Samsung
    NC110/NF210/QX310/QX410/QX510/SF310/SF410/SF510/RF410/RF510/RF710/RV515

You can check whether your touchpad is correctly detected by running:

    $ xinput list

More information can be found in this thread.

> Non-functional Synaptics Special Abilities (multi-tap, scrolling, etc.)

In some cases Synaptics touchpads only work partially. Features like
two-finger scrolling or two-finger middle-click do not work even if
properly enabled. This is probably related to the The touchpad is not
working problem mentioned above. Fix is the same, prevent double module
loading.

If preventing the module from loading twice does not solve your issue,
try commenting out the toggle "MatchIsTouchpad" (which is now included
by default in the synaptics config).

> Disable touchpad upon external mouse detection

With the assistance of udev, it is possible to automatically disable the
touchpad if an external mouse has been plugged in. To achieve this, add
the following udev rules to /etc/udev/rules.d/01-touchpad.rules:

    /etc/udev/rules.d/01-touchpad.rules

     ACTION=="add", SUBSYSTEM=="input", KERNEL=="mouse[0-9]", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/<your username>/.Xauthority", ENV{ID_CLASS}="mouse", ENV{REMOVE_CMD}="/usr/bin/synclient TouchpadOff=0", RUN+="/usr/bin/synclient TouchpadOff=1"
     

GDM stores Xauthority files in /var/run/gdm in a randomly-named
directory. For some reason also multiple authority files may appear for
a user. So you need udev rules like these:

    ACTION=="add", KERNEL=="mouse[0-9]", SUBSYSTEM=="input", PROGRAM="/usr/bin/find /var/run/gdm -name *username* -print -quit", ENV{DISPLAY}=":0.0",
    ENV{XAUTHORITY}="$result/database", RUN+="/usr/bin/synclient TouchpadOff=1"
    ACTION=="remove", KERNEL=="mouse[0-9]", SUBSYSTEM=="input", PROGRAM="/usr/bin/find /var/run/gdm -name *username* -print -quit", ENV{DISPLAY}=":0.0",
    ENV{XAUTHORITY}="$result/database", RUN+="/usr/bin/synclient TouchpadOff=0"

Note:udev rules must be a single line each, so format accordingly.

Note:These udev rules conflict with syndaemon (see #Using .xinitrc)

To disable touchpad and simultaneously kill syndaemon, you can use a
rule like this:

    ACTION=="add", KERNEL=="mouse[0-9]", SUBSYSTEM=="input", PROGRAM="/usr/bin/find /var/run/gdm -name *username* -print -quit", ENV{DISPLAY}=":0.0",ENV{XAUTHORITY}="$result/database", RUN+="/bin/sh -c '/usr/bin/synclient TouchpadOff=1 ; sleep 1; /bin/killall syndaemon; '"

If syndaemon starts automatically with mouse removal, then you can
combine this with the remove rule above. If you need to start syndaemon
yourself, then alter the command accordingly with your favourite
syndaemon options.

> Cursor Jump

Some users have their cursor inexplicably jump around the screen. There
currently no patch for this, but the developers are aware of the problem
and are working on it.

Another posibility is that you're experiencing IRQ losses related to the
i8042 controller (this device handles the keyboard and the touchpad of
many laptops), so you have two posibilities here:

1. rmmod && insmod the psmouse module. 2. append i8042.nomux=1 to the
boot line and reboot your machine.

> Touchpad device is not located at /dev/input/*

If that is the case, you can use this command to display information
about your input devices:

    $ cat /proc/bus/input/devices

Search for an input device which has the name "SynPS/2 Synaptics
TouchPad". The "Handlers" section of the output specifies what device
you need to specify.

Example output:

    $ cat /proc/bus/input/devices

     I: Bus=0011 Vendor=0002 Product=0007 Version=0000
     N: Name="SynPS/2 Synaptics TouchPad"
     P: Phys=isa0060/serio4/input0
     S: Sysfs=/class/input/input1
     H: Handlers=mouse0 event1
     B: EV=b
     B: KEY=6420 0 7000f 0

In this case, the Handlers are mouse0 and event1, so /dev/input/mouse0
would be used.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

TODOexplain how to apply this in /etc/X11/xorg.conf.d/50-synaptics.conf

> Firefox and special touchpad events

By default, Firefox is set up to do special events upon tapping or
scrolling certain parts of your touchpad. You can edit the settings of
those actions by typing about:config in your Firefox address bar. To
alter these options, double-click on the line in question, changing
"true" to "false" and vise versa.

To prevent Firefox from scrolling (backward/forward) through browser
history and instead scroll through pages, edit these settings as shown:

    mousewheel.horizscroll.withnokey.action = 1
    mousewheel.horizscroll.withnokey.sysnumlines = true

To prevent Firefox from redirecting you to URLs formed from your
clipboard content upon tapping the upper-right corner of your touchpad
(or middle mouse button), set the following option to "false":

    middlemouse.contentLoadURL = false

> Opera: horizontal scrolling issues

Same as above. To fix it, go to Tools -> Preferences -> Advanced ->
Shortcuts. Select "Opera Standard" mouse setup and click "Edit". In
"Application" section:

-   assign key "Button 6" to command "Scroll left"
-   assign key "Button 7" to command "Scroll right"

> Scrolling and multiple actions with Synaptics on LG Laptops

These problems seem to be occurring on several models of LG laptops.
Symptoms include: when pressing Mouse Button 1, Synaptics interprets it
as ScrollUP and a regular button 1 click; same goes for button 2.

The scrolling issue can be resolved by entering in xorg.conf:

    /etc/X11/xorg.conf.d/xorg.conf

    Option "UpDownScrolling" "0"

NOTE that this will make Synaptics interpret one button push as three.
There is a patch written by Oskar Sandberg[1] that removes these clicks.

Apparently, when trying to compile this against the latest version of
Synaptics it fails. The solution to this is using the GIT repository for
Synaptics[2].

There is also a package build file in the AUR to automate this:
xf86-input-synaptics-lg.

To build the package after downloading the tarball and unpacking it,
execute:

    $ cd synaptics-git

    $ makepkg

> Other external mouse issues

First, make sure your section describing the external mouse contains
this line (or that the line looks like this):

    /etc/X11/xorg.conf.d/xorg.conf

    Option     "Device" "/dev/input/mice"

If the "Device" line is different, change it to the above and try to
restart X. If this does not solve your problem, make your touchpad is
the CorePointer in the "Server Layout" section:

    /etc/X11/xorg.conf.d/xorg.conf

    InputDevice    "Touchpad" "CorePointer"

and make your external device "SendCoreEvents":

    /etc/X11/xorg.conf.d/xorg.conf

    InputDevice    "USB Mouse" "SendCoreEvents"

finally add this to your external device's section:

    /etc/X11/xorg.conf.d/xorg.conf

    Option      "SendCoreEvents"    "true"

If all of the above does not work for you, please check relevant bug
trackers for possible bugs, or go through the forums to see if anyone
has found a better solution.

> Touchpad synchronization issues

Sometimes the cursor may freeze for several seconds or start acting on
its own for no apparent reason. This behavior is accompanied by records
in /var/log/messages.log

    /var/log/messages.log

    psmouse.c: TouchPad at isa0060/serio1/input0 lost synchronization, throwing 3 bytes away

This problem has no general solution, but there are several possible
workarounds.

-   If you use CPU frequency scaling, avoid using the "ondemand"
    governor and use the "performance" governor when possible, as the
    touchpad may lose sync when the CPU frequency changes.
-   Avoid using an ACPI battery monitor.
-   Attempt to load psmouse with "proto=imps" option. To do that, add
    this line to your /etc/modprobe.d/modprobe.conf:

    /etc/modprobe.d/modprobe.conf

    options psmouse proto=imps

-   Try another desktop environment. Some users report that this problem
    only occurs when using XFCE or GNOME, for whatever reason

> Delay between a button tap and the actual click

If you experience a delay between the tap on the touchpad and the actual
click that is registered you need to enable FastTaps:

To do so, you should add Option "FastTaps" "1" to
/etc/X11/xorg.conf.d/50-synaptics.conf so that you have:

    /etc/X11/xorg.conf.d/50-synaptics.conf

     Section "InputClass"
          Identifier "Synaptics Touchpad"
          Driver "synaptics"
          ...
          Option "FastTaps" "1"
          ...
     EndSection

> SynPS/2 Synaptics TouchPad can not grab event device, errno=16

If you are using Xorg 7.4, you may get a warning like this from
/var/log/Xorg.0.log, thais is because the driver will grab the event
device for exclusive use when using the Linux 2.6 event protocol. When
it fails, X will return this error message.

Grabbing the event device means that no other user space or kernel space
program sees the touchpad events. This is desirable if the X config file
includes /dev/input/mice as an input device, but is undesirable if you
want to monitor the device from user space.

If you want to control it, add or modify the "GrabEventDevice" option in
you touchpad section in /etc/X11/xorg.conf.d/50-synaptics.conf:

    /etc/X11/xorg.conf.d/50-synaptics.conf

     ...
     Option "GrabEventDevice" "''boolean''"
     ...

This will come into effect when X is restarted, though you can also
change it by using synclient. When changing this parameter with the
synclient program, the change will not take effect until the Synaptics
driver is disabled and re-enabled. This can be achieved by switching to
a text console and then switching back to X.

> Synaptics Loses Multitouch Detection After Rebooting From Windows

Many drivers include a firmware that is loaded into flash memory when
the computer boots. This firmware is not necessarily cleared upon
shutdown, and is not always compatible with Linux drivers. The only way
to clear the flash memory is to shutdown completely rather than using
reboot. It is generally considered best practice to never use reboot
when switching between operating systems.

> Buttonless TouchPads (aka ClickPads)

Some laptops have a special kind of touchpad which has the mouse buttons
as part of the tracking plate, instead of being external buttons. For
example HP series 4500 ProBooks, ThinkPad X220 and X1 ThinkPad series
have this kind of a touchpad. By default whole button area is detected
as a left button resulting in the second mouse button being unusable and
click + drag will not work. Previously support for such devices was
achieved by using third party patches, but from version 1.6.0 the
synaptics driver has native multitouch support (using the mtdev
library).

  
 To enable other buttons modify the touchpad section in
/etc/X11/xorg.conf.d/50-synaptics.conf (or better, of your custom
synaptics configuration file prefixed with a higher number):

    /etc/X11/xorg.conf.d/50-synaptics.conf

    ...
    Option "ClickPad"         "true"
    Option "EmulateMidButtonTime" "0"
    Option "SoftButtonAreas"  "50% 0 82% 0 0 0 0 0"
    ...

These three options are the key, first one will enable multitouch
support, second will disable middle button emulation (not supported for
ClickPads), and third will define the button areas.

Format for the SoftButtonAreas option is (from man 4 synaptics):

    RightButtonAreaLeft RightButtonAreaRight RightButtonAreaTop RightButtonAreaBottom  MiddleButtonAreaLeft MiddleButtonAreaRight MiddleButtonAreaTop MiddleButtonAreaBottom

The above example is commonly found in documentation or synaptics
packages, and it translates to right half of the bottom 18% of the
touchpad to be a right button. There is no middle button defined. If you
want to define a middle button remember one key piece of information
from the manual; edge set to 0 extends to infinity in that direction.

In the following example right button will occupy 40% of the rightmost
part of the button area. We then proceed to setup the middle button to
occupy 20% of the touchpad in a small area in the center.

       ...
       Option     "SoftButtonAreas"  "60% 0 82% 0 40% 59% 82% 0"
       ...

You can use synclient to check the new soft button areas:

       $ synclient -l | grep -i ButtonArea
           RightButtonAreaLeft     = 3914
           RightButtonAreaRight    = 0
           RightButtonAreaTop      = 3918
           RightButtonAreaBottom   = 0
           MiddleButtonAreaLeft    = 3100
           MiddleButtonAreaRight   = 3873
           MiddleButtonAreaTop     = 3918
           MiddleButtonAreaBottom  = 0

If your buttons aren't working, soft button areas are not changing,
ensure you do not have a synaptics configuration file distributed by a
package which is overriding your custom settings (ie. some AUR packages
distribute configurations prefixed with very high numbers).

  

> Touchpad detected as mouse (elantech touchpads)

This can happend on some laptops with elantech touchpad, for example
ASUS x53s. In this situation you need psmouse-elantech package from AUR.

External Resources
------------------

-   Synaptics TouchPad driver

Retrieved from
"https://wiki.archlinux.org/index.php?title=Touchpad_Synaptics&oldid=252618"

Category:

-   Input devices
