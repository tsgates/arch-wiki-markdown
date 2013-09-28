Wacom Tablet
============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installing                                                         |
|     -   2.1 Check if kernel drivers needed (usually not)                 |
|     -   2.2 Install Wacom drivers                                        |
|     -   2.3 Automatical setup                                            |
|     -   2.4 Manual setup                                                 |
|         -   2.4.1 Dynamic with udev                                      |
|             -   2.4.1.1 USB-devices                                      |
|             -   2.4.1.2 Serial devices                                   |
|                                                                          |
|         -   2.4.2 Static setup                                           |
|         -   2.4.3 Xorg configuration                                     |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 General concepts                                             |
|         -   3.1.1 Temporary configuration                                |
|         -   3.1.2 Permanent configuration                                |
|                                                                          |
|     -   3.2 Specific configuration tips                                  |
|         -   3.2.1 Changing orientation                                   |
|         -   3.2.2 Remapping Buttons                                      |
|             -   3.2.2.1 Finding out the button IDs                       |
|             -   3.2.2.2 The syntax                                       |
|             -   3.2.2.3 Some examples                                    |
|             -   3.2.2.4 Execute custom commands                          |
|             -   3.2.2.5 Application specific hotkeys                     |
|                                                                          |
|         -   3.2.3 TwinView Setup                                         |
|         -   3.2.4 Xrandr Setup                                           |
|                                                                          |
|     -   3.3 Pressure curves                                              |
|                                                                          |
| -   4 Application-specific configuration                                 |
|     -   4.1 The GIMP                                                     |
|     -   4.2 Inkscape                                                     |
|     -   4.3 Krita                                                        |
|     -   4.4 VirtualBox                                                   |
|     -   4.5 Web Browser Plugin                                           |
|                                                                          |
| -   5 Newer tablets & Troubleshooting                                    |
| -   6 Dynamic Xorg setup with HAL (deprecated)                           |
|     -   6.1 HAL tablet calibration fix                                   |
|                                                                          |
| -   7 References                                                         |
+--------------------------------------------------------------------------+

Introduction
------------

Before we begin, I would like to point out that this guide was started
for USB based Wacom tablets, so much of the info in here focuses on
that. Usually it's recommended to rely on Xorg's auto-detection or to
use a dynamic setup. However for an internal tablet device one might
consider a static Xorg setup in case autodetection does not work. A
static Xorg setup is usually not able to recognize your Wacom tablet
when it's connected to a different USB port or even after unplugging and
replugging it into the same port, and as such it should be considered as
deprecated.

It is also worth to mention that this wiki article is very much
influenced by the very helpful Gentoo Linux Wiki - HOWTO Wacom Tablet,
which I recommend anyone visit if they would like to learn about things
that are not covered here.

Installing
----------

> Check if kernel drivers needed (usually not)

After plugging in the tablet (in case of a USB device) check lsusb
and/or dmesg  to see if the kernel recognizes your tablet. It should
also be listed in /proc/bus/input/devices.

In case it's not recognized, which might happen for new devices not
supported by current kernel, it is also possible to install git version
of kernel driver from: stable branch (wacom-linux-git), next branch
(wacom-next-linux-git) or mainline branch (wacom-mainline-linux-git).

> Install Wacom drivers

Thanks to The Linux Wacom Project, you only need to install the
xf86-input-wacom package, which contains everything needed to use a
Wacom tablet on Linux.

     # pacman -S xf86-input-wacom

Note:There is also xf86-input-wacom-git in AUR which provides git
version of xf86-input-wacom, but you might encounter some troubles. For
me the buttons for example did only work with the stable release, not
with the git version. So it's recommended to try xf86-input-wacom irst.

  

> Automatical setup

Newer versions of X should be able to automatically detect and configure
your device. Before going any further, restart X so the new udev rules
take effect. Test if your device was recognized completely (i.e., that
both pen and eraser work, if applicable), by issuing command

     $ xsetwacom --list devices

which should detect all devices with type, for example

     Wacom Bamboo 2FG 4x5 Pen stylus 	id: 8	type: STYLUS    
     Wacom Bamboo 2FG 4x5 Pen eraser 	id: 9	type: ERASER    
     Wacom Bamboo 2FG 4x5 Finger touch	id: 13	type: TOUCH     
     Wacom Bamboo 2FG 4x5 Finger pad 	id: 14	type: PAD       

You can also test it by opening Gimp or Xournal and checking the
extended input devices section, or whatever tablet-related configuration
is supported by the software of your choice.

For this to work you don't need any xorg.conf file, any configurations
are made in files in the /etc/X11/xorg.conf.d/ folder. If everything is
working you can skip the manual configuration and proceed to the
configuration section to learn how to further customize your tablet.

With the arrival of Xorg 1.8 support for HAL was dropped in favor of
udev which might break auto-detection for some tablets as fitting udev
rules might not exist yet, so you may need to write your own.

If you have linuxwacom or linuxwacom-dev remove those packages first.
They are known to cause problems with newer version of X.
xf86-input-wacom is the only package you need to install the X11
drivers.

> Manual setup

A manual configuration is done in /etc/X11/xorg.conf or in a separate
file in the /etc/X11/xorg.conf.d/ directory. The Wacom tablet device is
accessed using a input event interface in /dev/input/ which is provided
by the kernel driver. The interface number event?? is likely to change
when unplugging and replugging into the same or especially a different
USB port. Therefore it's wise to don't refer to the device using it's
concrete event?? interface (static configuration) but by letting udev
dynamically create a symbolic link to the correct event file (dynamic
configuration).

Dynamic with udev

Note:In AUR there is wacom-udev package, which includes udev-rules-file.
You might skip this part and move on to the xorg.conf configuration if
you are using the wacom-udev package from AUR.

Assuming udev is already installed you simply need to install wacom-udev
from AUR, e.g. by using

     $ yaourt -S wacom-udev

USB-devices

After (re-)plugging in your USB-tablet (or at least after rebooting)
some symbolic links should appear in /dev/input refering to your tablet
device.

     $ ls /dev/input/wacom* 
     /dev/input/wacom  /dev/input/wacom-stylus  /dev/input/wacom-touch

If not, your device is likely to be not yet included in the udev
configuration from wacom-udev which resides in
/usr/lib/udev/rules.d/10-wacom.rules. It's a good idea to copy the file
e.g. to 10-my-wacom.rules before modifiing it, else it might be reverted
by a package upgrade.

Add your device to the file by duplicating some line of another device
and adapting idVendor,idProduct and the symlink name to your device. The
two id's can by determined using

    $ lsusb | grep -i wacom
    Bus 002 Device 007: ID 056a:0062 Wacom Co., Ltd

In this example idVendor is 056a and idProduct 0062. In case you have
device with touch (e.g. Bamboo Pen&Touch) you might need to add a second
line for the touch input interface. For details check the linuxwacom
wiki Fixed device files with udev.

Save the file and reload udev's configuration profile using the command
udevadm control --reload-rules Check again the content of /dev/input to
make sure that the wacom symlinks appeared. Note that you may need to
plug-in the tablet again for the device to appear.

The files of further interest for the Xorg configuration are
/dev/input/wacom and for a touch-device also /dev/input/wacom_touch.

Serial devices

The wacom-udev should also include support for serial devices. Users of
serial tablets might be also interested in the inputattach tool from
linuxconsole package. The inputattach command allows to bind serial
device into /dev/input tree, for example with:

     # inputattach --w8001 /dev/ttyS0

See man inputattach for help about available options. As for USB devices
one should end up with a file /dev/input/wacom and proceed with the Xorg
configuration.

Static setup

If you insist in using a static setup just refer to your tablet in the
Xorg configuration in the next section using the correct
/dev/input/event?? files as one can find out by looking into
/proc/bus/input/devices.

Xorg configuration

In either case, dynamic or static setup you got now one or two files in
/dev/input/ which refer to the correct input event devices of your
tablet. All that is left to do is add the relevent information to
/etc/X11/xorg.conf, or a dedicated file under /etc/X11/xorg.conf.d/. The
exact configuration depends on your tablet's features of course.
xsetwacom --list devices might give helpful informations on what
InputDevice sections are needed for your tablet.

An example configuration for a Volito2 might look like this

    Section "InputDevice"
        Driver        "wacom"
        Identifier    "stylus"
        Option        "Device"       "/dev/input/wacom"   # or the corresponding event?? for a static setup
        Option        "Type"         "stylus"
        Option        "USB"          "on"                 # USB ONLY
        Option        "Mode"         "Relative"           # other option: "Absolute"
        Option        "Vendor"       "WACOM"
        Option        "tilt"         "on"  # add this if your tablet supports tilt
        Option        "Threshold"    "5"   # the official linuxwacom howto advises this line
    EndSection
    Section "InputDevice"
        Driver        "wacom"
        Identifier    "eraser"
        Option        "Device"       "/dev/input/wacom"   # or the corresponding event?? for a static setup
        Option        "Type"         "eraser"
        Option        "USB"          "on"                  # USB ONLY
        Option        "Mode"         "Relative"            # other option: "Absolute"
        Option        "Vendor"       "WACOM"
        Option        "tilt"         "on"  # add this if your tablet supports tilt
        Option        "Threshold"    "5"   # the official linuxwacom howto advises this line
    EndSection
    Section "InputDevice"
        Driver        "wacom"
        Identifier    "cursor"
        Option        "Device"       "/dev/input/wacom"   # or the corresponding event?? for a static setup
        Option        "Type"         "cursor"
        Option        "USB"          "on"                  # USB ONLY
        Option        "Mode"         "Relative"            # other option: "Absolute"
        Option        "Vendor"       "WACOM"
    EndSection

Make sure that you also change the path ("Device") to your mouse, as it
will be /dev/input/mouse_udev now.

    Section "InputDevice"
        Identifier  "Mouse1"
        Driver      "mouse"
        Option      "CorePointer"
        Option      "Device"             "/dev/input/mouse_udev"
        Option      "SendCoreEvents"     "true"
        Option      "Protocol"           "IMPS/2"
        Option      "ZAxisMapping"       "4 5"
        Option      "Buttons"            "5"
    EndSection

Add this to the ServerLayout section

    InputDevice "cursor" "SendCoreEvents" 
    InputDevice "stylus" "SendCoreEvents"
    InputDevice "eraser" "SendCoreEvents"

And finally make sure to update the indentifier of your mouse in the
ServerLayout section – as mine went from

    InputDevice    "Mouse0" "CorePointer"

to

    InputDevice    "Mouse1" "CorePointer"

Configuration
-------------

> General concepts

The configuration can be done in two ways temporary using the
`xsetwacom` tool, which is included in xf86-input-wacom or permanent in
xorg.conf or better in a extra file in /etc/X11/xorg.conf.d. The
possible options are identical so it's recommended to first use
`xsetwacom` for testing and later add the final config to the Xorg
configuration files.

Temporary configuration

For the beginning it's a good idea to inspect the default configuration
and all possible options using the following commands.

     $ xsetwacom --list devices                    # list the available devices for the get/set commands
     Wacom Bamboo 16FG 4x5 Finger touch	id: 12	type: TOUCH
     Wacom Bamboo 16FG 4x5 Finger pad	id: 13	type: PAD       
     Wacom Bamboo 16FG 4x5 Pen stylus	id: 17	type: STYLUS    
     Wacom Bamboo 16FG 4x5 Pen eraser	id: 18	type: ERASER
     $ xsetwacom --get "Wacom Bamboo 16FG 4x5" all # using the device name
     $ xsetwacom --get 17 all                      # or equivalently use the device id
     $ xsetwacom --list parameters                 # to get an explanation of the Options
     $ man wacom                                   # get even more details

Caution, don't use the device id when writing shell scripts to set some
options as the ids might change after an hotplug.

Options can be changed with the --set flag. Some useful examples are

     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger touch" ScrollDistance 50  # change scrolling speed
     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger touch" Gesture off        # disable multitouch gestures
     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger touch" Touch off          # disable touch

For further configuration tips and tricks see below in #Specific
configuration tips.

Note:You can reset your temporary configuration at any time by
unplugging and replugging in your tablet.

Permanent configuration

To make a permanent configuration the preferred way for Xorg>1.8 is to
create a new file in /etc/X11/xorg.conf.d e.g. 52-wacom-options.conf
with the following content.

    /etc/X11/xorg.conf.d/52-wacom-options.conf

    Section "InputClass"
        Identifier "Wacom Bamboo stylus options"
        MatchDriver "wacom"
        MatchProduct "Pen"
        
        # Apply custom Options to this device below.
        Option "Rotate" "none"
        Option "RawSample" "20"
        Option "PressCurve" "0,10,90,100"
    EndSection

    Section "InputClass"
        Identifier "Wacom Bamboo eraser options"
        MatchDriver "wacom"
        MatchProduct "eraser"
        
        # Apply custom Options to this device below.
        Option "Rotate" "none"
        Option "RawSample" "20"
        Option "PressCurve" "5,0,100,95"
    EndSection

    Section "InputClass"
        Identifier "Wacom Bamboo touch options"
        MatchDriver "wacom"
        MatchProduct "Finger"
        
        # Apply custom Options to this device below.
        Option "Rotate" "none"
        Option "ScrollDistance" "18"
        Option "TapTime" "220"
    EndSection

    Section "InputClass"
        Identifier "Wacom Bamboo pad options"
        MatchDriver "wacom"
        MatchProduct "pad"
        
        # Apply custom Options to this device below.
        Option "Rotate" "none"
        
        # Setting up buttons
        Option "Button1" "1"
        Option "Button2" "2"
        Option "Button3" "3"
        Option "Button4" "0"
    EndSection

The identifiers can be set arbitrarily. The option names are (except for
the buttons) identical to the ones listed by xsetwacom --list parameters
and especially also in man wacom. As noted in #Remapping Buttons the
button ids seem to be different than the ones for xsetwacom.

> Specific configuration tips

Check out the [Howto section] in the Linuxwacom wiki.

Changing orientation

If you want to use your tablet in a different orientation you have to
tell this to the driver, else the movements don't cause the expected
results. This is done by setting the Rotate option for all devices.
Possible orientations are none,cw,ccw and half. A quick way is e.g.

     $ for i in 12 13 17 18; do xsetwacom --set $i Rotate half; done   # remember the ids might change when hotplugging

or use the following script like this ./wacomrot.sh half

    wacomrot.sh

    #!/bin/bash
    device="Wacom Bamboo 16FG 4x5"
    stylus="$device Pen stylus"
    eraser="$device Pen eraser"
    touch="$device Finger touch"
    pad="$device Finger pad"

    xsetwacom --set "$stylus" Rotate $1
    xsetwacom --set "$eraser" Rotate $1
    xsetwacom --set "$touch"  Rotate $1
    xsetwacom --set "$pad"    Rotate $1

Remapping Buttons

It's possible to remap the buttons with hotkeys.

Finding out the button IDs

Sometimes it needs some trial&error to find the correct button IDs. For
me they even differ for xsetwacom and the xorg.conf configuration. Very
helpful tools are xev or xbindkeys -mk. An easy way to proceed is the
following

     $ xsetwacom --get "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 1
     $ xsetwacom --get "Wacom Bamboo 16FG 4x5 Finger pad" Button 2 2
     $ xsetwacom --get "Wacom Bamboo 16FG 4x5 Finger pad" Button 3 3
     $ # and so on

Then fire up xev from a terminal window, place your mouse cursor above
the window and hit the buttons and write down the ids.

The syntax

The syntax of xsetwacom is flexible but not very well documented. The
general mapping syntax (extracted from the source code) for xsetwacom
0.17.0 is the following.

     KEYWORD [ARGS...] [KEYWORD [ARGS...] ...]
     
     KEYWORD + ARGS:
       key [+,-]KEY [[+,-]KEY ...]  where +:key down, -:key up, no prefix:down and up
       button BUTTON [BUTTON ...]   (1=left,2=middle,3=right mouse button, 4/5 scroll mouse wheel)
       modetoggle                   toggle absolute/relative tablet mode 
       displaytoggle                toggle cursor movement among all displays which include individual screens
                                    plus the whole desktop for the selected tool if it is not a pad.
                                    When the tool is a pad, the function applies to all tools that are asssociated
                                    with the tablet
     
     BUTTON: button ID as integer number
     
     KEY: MODIFIER, SPECIALKEY or ASCIIKEY
     MODIFIER: (each can be prefix with an l or an r for the left/right modifier (no prefix = left)
        ctrl=ctl=control, meta, alt, shift, super, hyper
     SPECIALKEY: f1-f35, esc=Esc, up,down,left,right, backspace=Backspace, tab, PgUp,PgDn
     ASCIIKEY: (usual characters the key produces, e.g. a,b,c,1,2,3 etc.)

Some examples

     $ xsetwacom --get "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 3 # right mouse button
     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 "key +ctrl z -ctrl"
     $ xsetwacom --get "Wacom Bamboo 16FG 4x5 Finger pad" Button 1
     key +Control_L +z -z -Control_L
     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 "key +shift button 1 key -shift"

even little macros are possible

     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 "key +shift h -shift e l l o"

Note:There seems to be a bug in the xf86-input-wacom driver version
0.17.0, at least for my Wacom Bamboo Pen & Touch, but I guess this holds
in general. It causes the keystrokes not to be overwritten correctly.

     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 "key a b c" # press button 1 -> abc
     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 "key d"     # press button 1 -> dbc  WRONG!

A simple workaround is to reset the mapping by mapping to "":

     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 ""          # to reset the mapping
     $ xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" Button 1 "key d"     # press button 1 -> d

Execute custom commands

Mapping custom commands to the buttons is a little bit tricky but
actually very simple. You'll need xbindkeys so install it using

     # pacman -S xbindkeys

To get well defined button codes add the following to your permanent
configuration file, e.g. /etc/X11/xorg.conf.d/52-wacom-options.conf in
the InputClass section of your pad device. Map the tablet's buttons to
some unused button ids.

     # Setting up buttons (preferably choose the correct button order, so the topmost key is mapped to 10 and so on)
     Option "Button1" "10"
     Option "Button2" "11"
     Option "Button3" "12"
     Option "Button4" "13"

Then restart your Xorg server and verify the buttons using xev or
xbindkeys -mk.

Now set up your xbindkeys configuration, if you don't already have one
you might want to create a default configuration

     $ xbindkeys --defaults > ~/.xbindkeysrc

Then add your custom key mapping to ~/.xbindkeysrc, for example

     "firefox"
         m:0x10 + b:10   (mouse)
     "xterm"
         m:0x10 + b:11   (mouse)
     "xdotool key ctrl-z"
         m:0x10 + b:12   (mouse)
     "send-notify Test "No need for escaping the quotes""
         m:0x10 + b:13   (mouse)

Application specific hotkeys

This is quite tricky as the usual tools don't allow application specific
hotkeys. However I found the idea quite appealing to use the buttons for
different thinks depending on the application.

To make this possible I use a python script which uses xorg-xprop,
xdotools and the custom commands setup from the last section, which
depends on xbindkeys.

Change the mappings in ~/.xbindkeysrc

     "appkey 1"
         m:0x10 + b:10   (mouse)
     "appkey 2"
         m:0x10 + b:11   (mouse)
     "appkey 3"
         m:0x10 + b:12   (mouse)
     "appkey 4"
         m:0x10 + b:13   (mouse)

And copy the following script to a file named appkey somewhere in your
path ($PATH) and make it executable using

     chmod 755 /usr/local/bin/appkey

    /usr/local/bin/appkey

    #!/usr/bin/python
    # written in 2012 by buergi
    # this script is public domain, no rights reserved, CC0
    # do with it whatever you want

    import sys
    from subprocess import Popen,PIPE

    def get_active_window_class(sep=':'):
        p = Popen(['xdotool', 'getactivewindow'], stdout=PIPE)
        winid  = p.communicate()[0]
        p = Popen(['xprop', '-id', winid, 'WM_CLASS'], stdout=PIPE)

        try:
            out = p.communicate()[0].decode('ascii')
        except UnicodeDecodeError as e:
            return 

        try:
            tmp = out.split(' = ',1)[1]
            winclass = sep.join(tmp.split('", "'))[1:-2]
        except IndexError as e:
            return 

        return winclass

    def send_key(keystroke):
        Popen(['xdotool', 'key', keystroke])

    def main(argc,argv):
        key=0
        if argc==2:
            key=argv[1]
        else:
            print("Usage: %s KEY"%argv[0])

        cls = get_active_window_class()
        if 'Firefox' in cls: # my configuration for Pentadactyl
            if key=='1':
                send_key('shift+h')
            if key=='2':
                send_key('shift+l')
            if key=='3':
                send_key('Escape')
                send_key('r')
        if 'Inkscape' in cls:
            if key=='1':
                send_key('F1')
            if key=='2':
                send_key('F2')
            if key=='3':
                send_key('ctrl+F6')
        if key=='4':
            # toggle finger touch
            p=Popen(['xsetwacom','--get','Wacom Bamboo 16FG 4x5 Finger touch','Touch'],stdout=PIPE)
            stat  = p.communicate()[0].decode('ascii').strip()
            istat = 'on' if 'off' in stat else 'off'
            Popen(['xsetwacom','--set','Wacom Bamboo 16FG 4x5 Finger touch','Touch',istat])
        return 0

    if __name__ == '__main__':
        main(len(sys.argv),sys.argv)

  

TwinView Setup

If you are going to use two Monitors the aspect ratio while using the
Tablet might feel unnatural. In order to fix this you need to add

    Option "TwinView" "horizontal"

To all of your Wacom-InputDevice entries in the xorg.conf file. You may
read more about that HERE

Xrandr Setup

xrandr sets two monitors as one big screen, mapping the tablet to the
whole virtual screen and deforming aspect ratio. For a solution see this
thread: archlinux forum.

If you just want to map the tablet to one of your screens, first find
out what the screens are called

    $ xrandr
    Screen 0: minimum 320 x 200, current 3840 x 1080, maximum 16384 x 16384
    HDMI-0 disconnected (normal left inverted right x axis y axis)
    DVI-0 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 477mm x 268mm
      1920x1080      60.0*+
      1680x1050      60.0  
      ...
    VGA-0 connected 1920x1080+1920+0 (normal left inverted right x axis y axis) 477mm x 268mm
      1920x1080      60.0*+
      1680x1050      60.0  
      ...

Then you need to know what is the ID of your tablet.

    $ xsetwacom --list devices
    WALTOP International Corp. Slim Tablet stylus   id: 12  type: STYLUS

In my case I want to map the tablet (ID: 12) to the screen on the right,
which is "VGA-0". I can do that with this command

    $ xsetwacom --set 12 MapToOutput "VGA-0"

This should immediately work, no root necessary.

If xsetwacom replies with "Unable to find an output ..." an X11 geometry
string of the form WIDTHxHEIGHT+X+Y can be specified instead of the
screen identifier. In this example

    $ xsetwacom --set 12 MapToOutput "1920x1080+1920+0"

should also map the tablet to the screen on the right.

> Pressure curves

You can add two options to xorg.conf to change how the pressure is
registered when putting pressure on the pen. Example:

     Option        "PressCurve"    "50,0,100,50"         # Custom preference
     Option        "Threshold"     "60"                  # sensitivity to do a "click"

Application-specific configuration
----------------------------------

> The GIMP

To enabled proper usage, and pressure sensitive painting in The GIMP,
just go to Preferences → Input Devices → Configure Extended Input
Devices.... Now for each of your eraser, stylus, and cursor devices, set
the mode to Screen, and remember to save.

-   Please take note that if present, the pad device should be kept
    disabled as I do not think The GIMP supports such things.
    Alternatively, to use such features of your tablet you should map
    them to keyboard commands with a program such as Wacom ExpressKeys.

-   You should also take note that the tool selected for the stylus is
    independent to that of the eraser. This can actually be quite handy,
    as you can have the eraser set to be used as any tool you like.

For more information checkout the Setting up GIMP section of GIMP Talk -
Community - Install Guide: Getting Wacom Drawing Tablets To Work In
Gimp.

> Inkscape

As in The GIMP, to do the same simply got to File → Input Devices....
Now for each of your eraser, stylus, and cursor devices, set the mode to
Screen, and remember to save.

> Krita

Krita 2.0 and later only require that QT is able to use your tablet to
function properly. If your tablet is not working in Krita, then make
sure to check it is working in QT first. The effect of tablet pressure
can then be tweaked in the painttop configuration, for example by
selecting opacity, then selecting pressure from the drop down and
adjusting the curve to your preference.

For earlier versions of Krita, simply go to Settings → Configure
Krita... Click on Tablet and then like in Inkscape and GIMP set stylus
and any others' mode to screen.

> VirtualBox

My current setup is :

     Guest OS: Windows XP
     Tablet: Wacom Graphire4
     Linux Driver: xf86-input-wacom 0.8.4-1

First, make sure that your tablet works well under Arch. Then, download
and install the last driver from Wacom website on the guest OS. Shutdown
the virtual machine, go to Settings > USB. Select Add Filter From Device
and select your tablet (e.g. WACOM CTE-440-U V4.0-3 [0403]). Select Edit
Filter, and change the last item Remote to Any.

> Web Browser Plugin

A plugin that imitates the official Wacom web plugin can be found on the
AUR as wacomwebplugin. It has been tested successfully using Chromium
and Firefox.

With this plugin it is possible to make use of online tools such as
deviantART's Muro. This plugin is in early stages so as always, your
mileage may vary.

Newer tablets & Troubleshooting
-------------------------------

Newer tablets's drivers might not be in the kernel yet, and additional
manipulations might be needed. For example, for the Wacom Bamboo Connect
CTL-470/k and Pen & Touch CTH670, follow the instructions in this
thread. There seems to be a problem with the CTH670 that is fixed in the
attachment found in this post To compile it use the same instructions as
in this thread

  

Dynamic Xorg setup with HAL (deprecated)
----------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: HAL support was  
                           dropped in Xorg 1.8      
                           which entered the repos  
                           in June 2010, it should  
                           not be used anymore      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  

Note: In Xorg 1.8 and later, support for HAL is dropped. Input
hotplugging will NOT work with these versions of X, you need to use udev
(see above) instead.

Note: The linuxwacom package from AUR already includes a fitting fdi
file, so you might skip this part and just try out if it works after
installing linuxwacom and restarting X.

To use a Wacom/WALTOP/N-Trig tablet with HAL Xorg hotplugging create
/etc/hal/fdi/policy/10-tablet.fdi with this code:

    <?xml version="1.0" encoding="UTF-8"?> <!-- -*- SGML -*- -->

    <deviceinfo version="0.2">
     <device>
       <match key="info.capabilities" contains="input">
         <match key="info.product" contains="Wacom">
           <merge key="input.x11_driver" type="string">wacom</merge>
           <merge key="input.x11_options.Type" type="string">stylus</merge>
         </match>
         <match key="info.product" contains="WALTOP">
           <merge key="input.x11_driver" type="string">wacom</merge>
           <merge key="input.x11_options.Type" type="string">stylus</merge>
         </match>
       </match>
       <match key="info.product" contains="HID 1b96:0001">
         <match key="info.parent" contains="if0">
          <merge key="input.x11_driver" type="string">wacom</merge>
          <merge key="input.x11_options.Type" type="string">stylus</merge>
         </match>
       </match>
      </device>
     </deviceinfo>

Then kill your X server, restart HAL and start the X server again.

Following fdi file is known to work with the Bamboo Fun tablet (model
CTE-650). Using this file corrects several problems with the stylus that
appear when using the default fdi file above. Create the file
/etc/hal/fdi/policy/10-tablet.fdi with the following contents:

    <?xml version="1.0" encoding="UTF-8"?>
    <deviceinfo version="0.2">
      <device>
        <match key="info.category" contains="input">
          <match key="info.product" contains_outof="Wacom">
            <merge key="input.x11_driver" type="string">wacom</merge>
            <merge key="input.x11_options.Type" type="string">pad</merge>
            <append key="info.callouts.add" type="strlist">hal-setup-wacom</append>
            <append key="wacom.types" type="strlist">eraser</append>
            <append key="wacom.types" type="strlist">cursor</append>
            <append key="wacom.types" type="strlist">stylus</append>
          </match>
        </match>
        <match key="info.capabilities" contains="serial">
          <match key="@info.parent:pnp.id" contains_outof="WACf001;WACf002;WACf003;WACf004;WACf005;WACf006;WACf007;WACf008;WACf009;WACf00a;WACf00b;WACf00c;FUJ02e5">
            <append key="info.capabilities" type="strlist">input</append>
            <merge key="input.x11_driver" type="string">wacom</merge>
            <merge key="input.x11_options.Type" type="string">pad</merge>
            <merge key="input.x11_options.ForceDevice" type="string">ISDV4</merge>
            <merge key="input.device" type="copy_property">serial.device</merge>
            <append key="info.callouts.add" type="strlist">hal-setup-wacom</append>
            <append key="wacom.types" type="strlist">stylus</append>
            <match key="@info.parent:pnp.id" contains_outof="WACf008;WACf009">
              <append key="wacom.types" type="strlist">touch</append>
            </match>
          </match>
        </match>
      </device>
      <device>
        <match key="info.capabilities" contains="input.mouse">
          <match key="info.product" contains="WACOM">
            <match key="info.product" contains="Tablet">
              <merge key="input.x11_driver" type="string">wacom</merge>
              <merge key="input.x11_options.Type" type="string">pad</merge>
              <append key="info.callouts.add" type="strlist">hal-setup-wacom</append>
              <append key="wacom.types" type="strlist">eraser</append>
              <append key="wacom.types" type="strlist">cursor</append>
              <append key="wacom.types" type="strlist">stylus</append>
            </match>
          </match>
        </match>
      </device>
    </deviceinfo>

> HAL tablet calibration fix

In order for calibration to work even when the screen is rotated (this
applies for both serial and USB tablets), the wacom-names script is
useful. It renames your X input devices so that they can be recognized
by the linuxwacom driver. Download it from here. You need to be a Ubuntu
forums member to download it. If you are not, here is the script.
Remember, it was originally intended for Ubuntu so the instructions do
not all apply to us Archers:

    # wacom-names script by Roger E. Critchlow, Jr. (4-12-09)
    #   modified by gali98/Favux (4-14-09)
    #
    # Place the wacom-names script in  /etc/init.d/wacom-names and link it as
    # /etc/rc{2,3,4,5}.d/S27wacom-names.
    # Use "sudo update-rc.d wacom start 27 2 3 4 5 ." or "sudo update-rc.d wacom defaults 27".
    # Using S27 starts the script after hal and before gdm.  This allows us to modify the hal
    # properties before the xserver sees them for the first time.
    #
    # The script renames the input devices back to what wacomcpl and xsetwacom expect them to
    # be, so rotation and interactive calibration work.  It also enables xorg.conf & .xinitrc
    # style configuration of Wacom features like the stylus button(s) and calibration.
    #
    # The script needs to be executable.  chmod +x wacom-names

    #! /bin/sh
    ## find any wacom devices
    for udi in `hal-find-by-property --key input.x11_driver --string wacom`
    do
    type=`hal-get-property --udi $udi --key input.x11_options.Type`
    ## rewrite the names that the Xserver will use
    hal-set-property --udi $udi --key info.product --string $type
    #
    ## To add a xorg.conf or xsetwacom (.xinitrc) style configuration, say mapping a stylus
    ## button, you could add to the script:
    #case $type in
    #stylus|eraser)
    ## eg:  map stylus button 2 to mouse button 3 (right click)
    #hal-set-property --udi $udi --key input.x11_options.Button2 --string 3
    #
    #;;
    #esac
    done

Copy and paste and (or directly) save it as wacom-names to /etc/rc.d and
make it an executable.

    # chmod +x /etc/rc.d/wacom-names

Add wacom-names to the DAEMONS line in your rc.conf. Make sure to put it
after HAL, and do not background HAL, because this script will not work
if it runs before HAL has started. For example:

    DAEMONS=(syslog-ng @crond hal @acpid @alsa @gpm wacom-names)

Reboot your computer. From here you can either keep wacom-names in your
rc.conf if your rotation script calls on xsetwacom directly, or if you
just need the calibration data, you can now use wacomcpl.

If you are looking for more information, this thread at the Ubuntu
forums is incredibly useful, and also provided the link to Rec's
wacom-names script.

  

References
----------

-   Gentoo Linux Wiki - HOWTO Wacom Tablet
-   Linux Wacom Project Wiki
-   GIMP Talk - Community - Install Guide: Getting Wacom Drawing Tablets
    To Work In Gimp
-   Ubuntu Help: Wacom
-   Ubuntu Forums - Install a LinuxWacom Kernel Driver for Tablet PC's

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wacom_Tablet&oldid=248421"

Category:

-   Input devices
