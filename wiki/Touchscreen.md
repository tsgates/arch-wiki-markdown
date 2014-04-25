Touchscreen
===========

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Calibrating 
                           Touchscreen.             
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you ever tried to set up a touchscreen device in linux, you might
have noticed that it's either working out of the box (besides some
calibration) or is very tedious, especially when it isn't supported by
the kernel.

Contents
--------

-   1 Introduction
-   2 Available X11 drivers
-   3 evtouch drivers
    -   3.1 Calibration
        -   3.1.1 Rough calibration
        -   3.1.2 Fine calibration (optional)
        -   3.1.3 Correct orientation of the coordinate system
        -   3.1.4 Make the calibration persistent to unplugging or
            suspending
-   4 Using a touchscreen in a multi-head setup

Introduction
------------

This article assumes that your touchscreen device is supported by the
kernel (e.g. by the usbtouchscreen module). That means there exists a
/dev/input/event* node for your device. Check out

    less /proc/bus/input/devices

to see if your device is listed or try

    cat /dev/input/event? # replace ? with the event numbers

for every of your event nodes while touching the display.

If you found the corresponding node, it's likely that you will be able
to get the device working.

Available X11 drivers
---------------------

There are a lot of touchscreen input drivers for X11 out there. The most
common ones are in the extra repository:

-   xf86-input-evtouch (in AUR)
-   xf86-input-elographics

Less common drivers, not contained in the repository, are:

-   xf86-input-magictouch
-   xf86-input-mutouch
-   xf86-input-plpevtch
-   xf86-input-palmax
-   xf86-input-elo2300 (*)
-   xf86-input-microtouch (*)
-   xf86-input-penmount (*)

(Note: (*) are deprecated and thus were removed from the repos [1])

Proprietary drivers exist for some devices (e.g.: xf86-input-egalax),
but it's recommended to try the open source drivers first.

Depending on your touchscreen device choose an appropriate driver.

The evtouch input drivers support a wide variety of touchscreens from
different vendors like Fujitsu, eGalax, IDEACO, ITM, and Touchkit.

Note:Since I've only got one touchscreen device (USB 0eef:0001 D-WAV
Scientific Co., Ltd eGalax TouchScreen) which works with the evtouch
driver I confine myself to this driver. Perhaps someone can add details
about how to set up other drivers.

evtouch drivers
---------------

First, install xf86-input-evtouch from the AUR.

This package already includes a set of udev rules to create a permanent
node for your input device in /etc/udev/rules.d/69-touchscreen.rules.

If everything worked fine so far, you should have a symlink
/dev/input/evtouch_event to your input device. If not, your touch device
might not work with evtouch, but you can add a custom udev rule for your
device and try it anyway.

In case you configured X server to use HAL hot-plugging, the touchscreen
should work now after restarting the X server. Else you have to add the
corresponding "InputDevice" section to xorg.conf as described on
evtouch's webside.

> Calibration

It's assumed that you have the touchscreen working now in X11 and that
you're using hot-plugging for configuration. If you manually set up your
input devices and thus switched off hot-plugging, you have to add the
X11 options of this section to the xorg.conf file instead (see evtouch's
webside for details again).

Rough calibration

For touchscreen calibration the xf86-input-evtouch package includes a
calibration program.

    sudo /usr/lib/xf86-input-evtouch/calibrate.sh

No matter whether you started it from TTY or X11, this will start a new
X server and bring up a white screen. Move the pen around the display
border, along all edges a view times to get the minimum and maximum
coordinates. Press Return. Then tap exactly on the red cross. The next
cross will turn red, touch it again and repeat this procedure for all
crosses. When your done you should return to command line. The
calibration data was written to /etc/evtouch/config.

To restore the calibration data after booting add evtouch_config to the
DAEMONS variable in /etc/rc.conf

    DAEMONS=( ... evtouch_config ... )

This will read the calibration data from /etc/evtouch/config and set the
corresponding X options using HAL.

You can now (re)start your X server and enjoy your calibrated
touchscreen.

Fine calibration (optional)

If your not satisfied with the calibration you can do further tweaking
by changing the values in /etc/evtouch/config manually. MINX, MINY,
MAXX, MAXY are the minimal and maximal coordinates and the nine X?,Y?
pairs are the coordinates of the calibration points in the order you
touched them.

Correct orientation of the coordinate system

The 9 point calibration assures that the coordinate axis are orientated
in a way that your cursor moves to the right when your pen does (due to
the signs of the X,Y pairs). In case you nevertheless notice your cursor
is moving in the wrong direction you can add

    hal_set swapx 1
    hal_set swapy 1

to /etc/rc.d/evtouch_config (of course this will get overwritten when
you upgrade the package)

When X and Y axis are swaped and your touchscreen uses the
usbtouchscreen kernel module you can add the following line to
/etc/modprobe.d/modprobe.conf

    options usbtouchscreen swap_xy=1

Correct orientation can also be done using scripts which utilize xrandr
and xinput. This was used and tested on a thinkpad x220t. A shell script
to make the rotation (portrait view) and fix the coordinate system for
the touch screen would be

     #!/bin/bash
     xrandr --screen 0 -o right
     xinput set-prop "Wacom ISDv4 E6 Pen" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1

exchanging "Wacom ISDv4 E6 Pen" with your input device from

     xinput list

The shell script should be made executable by

     chmod +x nameofscript.sh

A script to change orientation back would be

     #!/bin/bash
     xrandr --screen 0 -o normal 
     xinput set-prop "Wacom ISDv4 E6 Pen" --type=float "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1

Make the calibration persistent to unplugging or suspending

You may notice that after unplugging the touch device and replugging it
while the X server is running, your calibration is messed up. The same
happens when you resume from hibernation or suspend.

The reason is, that your calibration setting get set only once, at boot
time by evtouch_config. When you unplug it the settings are removed when
evtouch is unloaded. On plugging it in HAL sets the default settings as
specified in /usr/share/hal/fdi/policy/20thirdparty/50-....fdi and loads
the evtouch driver, which reads the calibration settings into its
memory. Therefore it doesn't work to simply call evtouch_config while
the X window system is running.

The only way I found to make the calibration settings survive a
replug-in or a hibernation is to set them directly in the HAL policy
file. The following command converts the calibration settings to HAL
policy format and prints the result on stdout.

    awk -F= '{print "        <merge key=\"input.x11_options."tolower($1)"\" type=\"string\">"$2"</merge>"}' /etc/evtouch/config

Replace the corresponding merge commands in the policy file
(/usr/share/hal/fdi/policy/20thirdparty/50-....fdi) corresponding to
your device.

Of course you do not need the evtouch_config daemon any more when you
use this method, so you can remove it from /etc/rc.conf.

Note: when you have problems with right clicking or drag and drop you
can try tweaking the settings ([2] [3]) in the fdi file. You can also
set the swapx, swapy options here in case you need them.

WARNING: The fdi files will be overwritten when you upgrade
xf86-input-evtouch, so all your changes will be lost.

Using a touchscreen in a multi-head setup
-----------------------------------------

To use multiple displays (some of which are touchscreens), you need to
tell Xorg the mapping between the touch surface and the screen.

This can be done very easily with xinput:

Take for example the setup of having a wacom tablet and an external
monitor. When we type xrandr we get a list of our two displays:

    $ xrandr
    Screen 0: minimum 320 x 200, current 2944 x 1080, maximum 8192 x 8192
    LVDS1 connected 1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
       1024x768       60.0*+
       800x600        60.3     56.2  
       640x480        59.9  
    VGA1 connected 1920x1080+1024+0 (normal left inverted right x axis y axis) 477mm x 268mm
       1920x1080      60.0*+
       1600x1200      60.0  
       1680x1050      60.0  
       1680x945       60.0  

You see we have two displays here. LVDS1 and VGA1. LVDS1 is the display
internal to the tablet, and VGA1 is the external monitor. We wish to map
our stylus input to LVDS1. So we have to find the ID of the stylus
input:

     $ xinput --list
    ⎡ Virtual core pointer                    	id=2	[master pointer  (3)]
    ⎜   ↳ Virtual core XTEST pointer              	id=4	[slave  pointer  (2)]
    ⎜   ↳ QUANTA OpticalTouchScreen               	id=9	[slave  pointer  (2)]
    ⎜   ↳ TPPS/2 IBM TrackPoint                   	id=11	[slave  pointer  (2)]
    ⎜   ↳ Serial Wacom Tablet WACf004 stylus      	id=13	[slave  pointer  (2)]
    ⎜   ↳ Serial Wacom Tablet WACf004 eraser      	id=14	[slave  pointer  (2)]
    ⎣ Virtual core keyboard                   	id=3	[master keyboard (2)]
        ↳ Virtual core XTEST keyboard             	id=5	[slave  keyboard (3)]
        ↳ Power Button                            	id=6	[slave  keyboard (3)]
        ↳ Video Bus                               	id=7	[slave  keyboard (3)]
        ↳ Sleep Button                            	id=8	[slave  keyboard (3)]
        ↳ AT Translated Set 2 keyboard            	id=10	[slave  keyboard (3)]
        ↳ ThinkPad Extra Buttons                  	id=12	[slave  keyboard (3)]

We see that we have two stylus inputs who's ID's are 13 and 14. We now
need to simply map our inputs to our output like so:


    xinput --map-to-output 13 LVDS1
    xinput --map-to-output 14 LVDS1

More info can be found at Calibrating_Touchscreen

Retrieved from
"https://wiki.archlinux.org/index.php?title=Touchscreen&oldid=286801"

Category:

-   Input devices

-   This page was last modified on 7 December 2013, at 09:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
