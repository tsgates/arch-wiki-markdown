Mouse acceleration
==================

There are several ways of setting mouse acceleration:

1.  by editing xorg configuration files
2.  the xorg-server-utils package provides two programs that can be used
    to change those settings from a shell or a script:
    -   xset
    -   xinput

3.  many Desktop Environments provide a configuration GUI for mouse
    settings. They should be easy to find and use.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setting mouse acceleration                                         |
|     -   1.1 In xorg configuration                                        |
|     -   1.2 Using xset                                                   |
|     -   1.3 Using xinput                                                 |
|                                                                          |
| -   2 Disabling mouse acceleration                                       |
+--------------------------------------------------------------------------+

Setting mouse acceleration
--------------------------

> In xorg configuration

See man xorg.conf for details.

Examples:

    /etc/X11/xorg.conf.d/50-mouse-acceleration.conf

    Section "InputClass"
    	Identifier "My Mouse"
    	MatchIsPointer "yes"
    # set the following to 1 1 0 respectively to disable acceleration.
    	Option "AccelerationNumerator" "2"
    	Option "AccelerationDenominator" "1"
    	Option "AccelerationThreshold" "4"
    EndSection

    /etc/X11/xorg.conf.d/50-mouse-deceleration.conf

    Section "InputClass"
    	Identifier "My Mouse"
    	MatchIsPointer "yes"
    # some curved deceleration
    #	Option "AdaptiveDeceleration" "2"
    # linear deceleration (mouse speed reduction)
    	Option "ConstantDeceleration" "2"
    EndSection

You can also assign settings to specific hardware by using
"MatchProduct", "MatchVendor" and other matches inside class sections.

> Using xset

To get the current values, use:

    xset q | grep -A 1 Pointer

To set new values, type:

    xset m ACCELERATION THRESHOLD

where ACCELERATION defines how many times faster the cursor will move
than the default speed, when the cursor moves more than THRESHOLD pixels
in a short time. ACCELERATION can be a fraction, so if you want to slow
down the mouse you can use 1/2, and if 3 is slightly too fast, but 2 is
too slow, you can use 5/2, etc.

To get the default settings back:

    xset m default

For more info see man xset.

To make it permanent, edit xorg configuration (see above) or add
commands to xprofile. The latter won't affect speed in a Display
Manager.

> Using xinput

First, get a list of devices plugged in (ignore any virtual pointers):

    xinput list

Take note of the ID. You may also use the full name in commands if the
ID is prone to changing.

Get a list of available properties and their current values available
for modification with

    xinput list-props 9

where 9 is the ID of the device you wish to use. Or

    xinput list-props 'Bobs mouse brand'

where Bobs mouse brand is the name of your mouse given by xinput list

Example, changing the property of Constant Deceleration to 2:

    $ xinput list-props 9
    Device 'Bobs mouse brand':
           Device Enabled (121):   1
           Device Accel Profile (240):     0
           Device Accel Constant Deceleration (241):       1.000000
           Device Accel Adaptive Deceleration (243):       1.000000
           Device Accel Velocity Scaling (244):    10.000000
    $ xinput --set-prop 'Bobs mouse brand' 'Device Accel Constant Deceleration' 2

To make it permanent, edit xorg configuration (see above) or add
commands to xprofile. The latter won't affect speed in a Display
Manager.

  

* * * * *

  
 Configuration example

You may need to resort to using more than one method to achieve your
desired mouse settings. Here's what I did to configure a generic optical
mouse:

~/.xinitrc

    # First, slow down the default movement speed 3 times so that it's more precise.
    xinput --set-prop 9 'Device Accel Constant Deceleration' 3 &
    # Then, enable acceleration and make it 3 times faster after moving past 6 pixels.
    xset mouse 3 6 &

Disabling mouse acceleration
----------------------------

Mouse acceleration has changed dramatically in recent X server versions;
using xset to disable acceleration doesn't work as it used to and is not
recommended anymore.

Recent changes on PointerAcceleration can be read here.

To completely disable any sort of acceleration/deceleration, create the
following file:

    /etc/X11/xorg.conf.d/50-mouse-acceleration.conf

    Section "InputClass"
    	Identifier "My Mouse"
    	MatchIsPointer "yes"
    	Option "AccelerationProfile" "-1"
    	Option "AccelerationScheme" "none"
    EndSection

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mouse_acceleration&oldid=241764"

Categories:

-   Mice
-   X Server
