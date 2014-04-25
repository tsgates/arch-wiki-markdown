Mouse acceleration
==================

There are several ways of setting mouse acceleration:

1.  By editing xorg configuration files
2.  The xorg-server-utils package provides two programs that can be used
    to change those settings from a shell or a script:
    -   xset
    -   xinput

3.  Many desktop environments provide a configuration GUI for mouse
    settings. They should be easy to find and use.

Contents
--------

-   1 Setting mouse acceleration
    -   1.1 In Xorg configuration
    -   1.2 Using xset
    -   1.3 Using xinput
    -   1.4 Configuration example
-   2 Disabling mouse acceleration

Setting mouse acceleration
--------------------------

> In Xorg configuration

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

    $ xset q | grep -A 1 Pointer

To set new values, type:

    $ xset m acceleration threshold

where acceleration defines how many times faster the cursor will move
than the default speed. threshold is the velocity required for
acceleration to become effective, usually measured in device units per
10ms. acceleration can be a fraction, so if you want to slow down the
mouse you can use 1/2, 1/3, 1/4, ... if you want to make it faster you
can use 2/1, 3/1, 4/1, ...

Threshold defines the point at which acceleration should occur in pixels
per 10 ms. If threshold is zero, e.g. if you use:

    $ xset m 3/2 0

as suggested in the man page, then acceleration is treated as "the
exponent of a more natural and continuous formula."

To get the default settings back:

    $ xset m default

For more info see man xset.

To make it permanent, edit xorg configuration (see above) or add
commands to xprofile. The latter won't affect speed in a display
manager.

> Using xinput

First, get a list of devices plugged in (ignore any virtual pointers):

    $ xinput list

Take note of the ID. You may also use the full name in commands if the
ID is prone to changing.

Get a list of available properties and their current values available
for modification with

    $ xinput list-props 9

where 9 is the ID of the device you wish to use. Or

    $ xinput list-props mouse brand

where mouse brand is the name of your mouse given by $ xinput list

Example, changing the property of Constant Deceleration to 2:

    $ xinput list-props 9

    Device 'mouse brand':
           Device Enabled (121):   1
           Device Accel Profile (240):     0
           Device Accel Constant Deceleration (241):       1.000000
           Device Accel Adaptive Deceleration (243):       1.000000
           Device Accel Velocity Scaling (244):    10.000000

    $ xinput --set-prop 'mouse brand' 'Device Accel Constant Deceleration' 2

To make it permanent, edit xorg configuration (see above) or add
commands to xprofile. The latter won't affect speed in a Display
manager.

> Configuration example

You may need to resort to using more than one method to achieve your
desired mouse settings. Here's what I did to configure a generic optical
mouse: First, slow down the default movement speed 3 times so that it's
more precise.

    $ xinput --set-prop 9 'Device Accel Constant Deceleration' 3 &

Then, enable acceleration and make it 3 times faster after moving past 6
units.

    $ xset mouse 3 6 &

If you are satisfied of the results, store the preceding commands in
~/.xinitrc.

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

and restart X.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mouse_acceleration&oldid=301267"

Categories:

-   Mice
-   X Server

-   This page was last modified on 24 February 2014, at 11:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
