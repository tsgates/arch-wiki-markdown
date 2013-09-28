Logitech MX1000
===============

  
 Disclaimer: this information is current as of Arch Linux 2007.08 (Don't
Panic). For later releases, your mileage may vary. In the true spirit of
a Wiki, if you determine that this content needs to be updated for a
later release, please go ahead and do so!

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Quick Overview                                                     |
| -   2 Get, Install evdev                                                 |
| -   3 Modify xorg.conf to Use evdev as Your Mouse Driver                 |
| -   4 Modify Xorg ServerLayout to Use Your evdev Mouse                   |
| -   5 Map The Mouse Buttons to the Desired Functions                     |
| -   6 A Brief Digression - Moving Functions Amongst Mouse Buttons        |
| -   7 Enable Thumb Button Forward and Back                               |
| -   8 Enable Scroll Wheel Tilt Horizontal Scrolling                      |
| -   9 Enable Scroll Wheel Front, Back Button Scrolling                   |
| -   10 One Button Left                                                   |
| -   11 Summary                                                           |
+--------------------------------------------------------------------------+

Quick Overview
--------------

This Wiki page will show you how to get your MX1000 mouse working as
desired. This is defined as:

-   Left click, Right click, Center click all working
-   Forward and Backward scroll wheel, Left and Right horizontal
    scrolling all working
-   The up and down scroll buttons in front and back of the scroll wheel
    working
-   Thumb buttons doing Forward and Back in your browser (Firefox used
    as an example)

  
 What we will do to achieve this is:

-   Get and install evdev
-   Modify xorg.conf to use evdev as your mouse driver
-   Get and install xvkbd and xbindkeys
-   Create a ~/.xbindkeysrc containing the following:

    "/usr/bin/xvkbd -xsendevent -text "\[Alt_L]\[Left]""
    m:0x0 + b:8
    "/usr/bin/xvkbd -xsendevent -text "\[Alt_L]\[Right]""
    m:0x0 + b:9
    "/usr/bin/xvkbd -xsendevent -text "\[Up]""
    m:0x0 + b:11
    "/usr/bin/xvkbd -xsendevent -text "\[Down]""
    m:0x0 + b:12
    "/usr/bin/xvkbd -xsendevent -text "\[Left]""
    m:0x0 + b:13 
    "/usr/bin/xvkbd -xsendevent -text "\[Right]""
    m:0x0 + b:14

This will setup your MX1000 so that it works as desired.

That's the overview. Now onto the details of each step.

Get, Install evdev
------------------

First, use evdev as the Xorg mouse driver. evdev is a newer driver that
allows you to effectively use mice with more than 7 buttons. Get this
module, install it, and make sure it is loaded each time you run Linux.

For Arch, this means:

    # pacman --sync xf86-input-evdev

and adding "evdev" to the modules list in /etc/rc.conf.

  

Modify xorg.conf to Use evdev as Your Mouse Driver
--------------------------------------------------

Next, in /etc/X11/xorg.conf, create an evdev-based input device that
specifies your mouse (if your mouse does not work after changing to the
evdev driver, it might be because evdev needs the "Device" option, fx
'Option "Device" "/dev/input/event4"', see
http://www.linux-gamers.net/modules/wiwimod/index.php?page=HOWTO+Mouse+Buttons&back=HOWTO+INDEX+Hardware
for details):

    # evdev based section for Logitech MX1000 mouse

    Section "InputDevice"
       Identifier  "Evdev Mouse"
       Driver      "evdev"
       Option      "Name" "Logitech USB Receiver"
       Option      "CorePointer"
    EndSection

  
 Note that none of the usual "Buttons" and "ZAxisMapping" statements are
not needed with evdev. Note as well that the "Name" field above is
critically important. This is the linkage between evdev and xorg. Find
out the name for your device via:

    # egrep "Name|Handlers" /proc/bus/input/devices

In the case of the Logitech MX1000 mouse, which is wireless, it is:
"Logitech USB Receiver". Make sure you add the "Name" option to your
InputDevice section for the mouse.

Modify Xorg ServerLayout to Use Your evdev Mouse
------------------------------------------------

Now modify the Xorg server layout to use this mouse entry:

    Section "ServerLayout"
       Identifier     "Xorg Configured"
       Screen         0  "Screen0" 0 0
       InputDevice    "Keyboard0" "CoreKeyboard"
       InputDevice    "Evdev Mouse" "CorePointer"
    EndSection

  

Map The Mouse Buttons to the Desired Functions
----------------------------------------------

To get all of the buttons working and doing what you want them to, you
need to use xev to map out the buttons: what buttons are recognized via
evdev and what function each of the recognized buttons performs. Your
job then is to move functions around between buttons, via xmodmap, if
some functions are showing up on buttons you do not want them on (and
presumably not showing on the buttons you DO want them on) and then add
in any remaining functions via xbindkeys. The net result of this work
should be a set of buttons on your MX1000 that do what you want.

Start by making sure that you have no legacy "xmodmap" commands in your
startup sequence. Also, if you have a file called .xbindkeysrc in your
home directory, move it out of there to somewhere else. Restart X.

Now, to start the mouse setup, we need to map out the mouse in its "raw"
(totally unmapped) state, and understand what buttons are recognized via
evdev and what function each of these buttons does in your
application(s) of interest, usually file managers and web browsers.

To do this, open an xterm and type:

    xev | grep -i button

Move your mouse pointer into the xev window and systematically move
through each button on your mouse. Click the button and write down the
button number (referred to hereafter as the "logical button number" for
that button) that xev reports. When done, you can close xev. Next, go to
you application of choice, usually your web browser, and try out each
button there, noting down what function it performs.

  
 When you are done with this, you will have a complete map of your mouse
in its "raw" state:

-   Which buttons are recognized
-   The xev logical button number for each physical button on the mouse
-   What function each button performs in your application(s) of choice

  
 When I did this for the MX1000 under Arch 2007.08, I got the following:

    Mouse Button                 xev Button Number    Current Fn      Desired Fn
    ----------------------------------------------------------------------------
    Left Click                   1                    Left Click      Left Click    
    Scroll Wheel Center Click    2                    Center Click    Center Click
    Right Click                  3                    Right Click     Right Click
    Scroll Fwd Roll              4                    Scroll Fwd      Scroll Fwd
    Scroll Back Roll             5                    Scroll Back     Scroll Back
    Back Thumb Button            8                    None            Browser Back
    Forward Thumb Button         9                    None            Browser Fwd
    Center Thumb Button          10                   None            None
    Scroll Fwd Button            11                   None            None
    Scroll Back Button           12                   None            None
    Left Horizontal Scroll       13                   None            Left Scroll
    Right Horizontal Scroll      14                   None            Right Scroll

Note that xev button numbers 6 and 7 are not defined by the above. evdev
does not report any of the MX1000 buttons as button numbers 6 or 7.

Looking at the above, we see that we have no desired functions showing
up on the wrong buttons, but we do have several desired functions that
simply do not show up at all. So, the good news is that we do not need
to fiddle with the infamous xmodmap command at all to get our MX1000
doing what we want it to.

  

A Brief Digression - Moving Functions Amongst Mouse Buttons
-----------------------------------------------------------

A brief digression in the interests of completeness. What if we DID have
functions showing up on the wrong buttons? How would we re-arrange them
so that the desired functions showed up on the desired buttons? This is
where xmodmap comes into play. In general, xmodmap maps logical buttons
onto physical buttons. In the below:

    xmodmap -e "pointer = 1 2 3 4 5 6 7 8 9 10 11 12 13 14"

xmodmap maps logical buttons 1 - 14 onto identically the same physical
buttons. The physical button number is implied; the numbers that you
type represent the logical button number that will be reported when the
associated physical button is pressed. Hence, the above statement is in
essence a nil operation. It changes nothing.

However, as an example, lets assume that we had the Browser Back and
Browser Forward functions showing up on Buttons 6 and 7 and that we
wanted them on buttons 8 and 9 (this is NOT the case for the MX1000 - it
is just being used as an example). In this case, the following statement
would achieve the desired remapping:

    xmodmap -e "pointer = 1 2 3 4 5 8 9 6 7 10 11 12 13 14"

As you can see, this statement maps logical button 8 into the position
of physical button 6, logical button 9 into the position of physical
button 7 and so on. Hence, when physical button 6 is pressed, the
original function of physical button 8 will be reported by evdev.
Similarly, when physical button 7 is pressed, the original function of
physical button 9 will be reported. In case you are experiencing
temporary confusion about the actual buttons on your mouse and the
physical buttons numbers being referred to here, remember that you
established the evdev mapping between the actual buttons on your MX1000
and the physical button numbers being discussed here when you mapped the
mouse in its "raw" state above.

This ends the digression. In case you ever do need to do this with
another mouse, you now know how to use xmodmap to move logical functions
around between buttons on your mouse.

Enable Thumb Button Forward and Back
------------------------------------

Back to the MX1000. As we discovered from our mapping exercise, there
are no functions showing up on the wrong mouse buttons, just several
functions that are not showing up at all. We will use xbindkeys to
resolve this, by discovering the keystrokes that cause the browser to do
the desired function, and then mapping those keystrokes onto the mouse
buttons of interest.

Unfortunately, the only way to determine the keystrokes that produce the
desired result is to experiment until you find them. For Firefox, it
turns out that ALT-Left_Arrow causes the browser to perform the Back
function, and ALT-Right_Arrow causes it to do the Forward function. So,
we wish to map MX1000 physical button 8 (the Back thumb button) to
ALT+Left_Arrow and MX1000 physical button 9 (the Forward thumb button)
to ALT+Right_Arrow.

To do this mapping, get and install xvkbd and xbindkeys.

For Arch, this means:

    # pacman --sync xvkbd
    # pacman --sync xbindkeys

Now create file ~/.xbindkeysrc, containing:

    # Mouse Buttons
    "/usr/bin/xvkbd -xsendevent -text "\[Alt_L]\[Left]""
    m:0x0 + b:8 
    "/usr/bin/xvkbd -xsendevent -text "\[Alt_L]\[Right]""
    m:0x0 + b:9

and add the following to your .xinitrc, or somewhere where it will be
executed each time X starts:

    % xbindkeys

At this point, the MX1000's Forward and Back buttons should be doing
your bidding in at least Firefox. Now what about horizontal scrolling?

  

Enable Scroll Wheel Tilt Horizontal Scrolling
---------------------------------------------

The MX1000 comes with a tilting scroll wheel. If you tilt it to the
left, the intent is that the screen should scroll to the left. Tilt it
to the right and the screen should scroll to the right. To get this
function working in Firefox, we need to discover the keystrokes that
cause Firefox to scroll left and right and then map those onto MX1000
physical buttons 13 and 14 respectively (the scroll wheel's tilt left
and right button numbers, as we discovered above when we mapped the
mouse in its "raw" state via xev.

So, what are the required keystrokes? Like the above, it turns out that
you have to determine which keys they are through trial and error
unfortunately. For Firefox, you will eventually discover that a left
arrow key scrolls the screen the left and a right arrow key scrolls it
to the right. So, our objective is to map MX1000 physical button 13 to
Left_Arrow and MX1000 physical button 14 to Right_Arrow.

To do this, simply add the following to the .xbindkeysrc we created
above:

    "/usr/bin/xvkbd -xsendevent -text "\[Left]""
    m:0x0 + b:13
    "/usr/bin/xvkbd -xsendevent -text "\[Right]""
    m:0x0 + b:14

That is it. Restart X and you will find that left and right scrolling
now work just fine!

Enable Scroll Wheel Front, Back Button Scrolling
------------------------------------------------

The MX1000 has a button immediately in front of the scroll wheel and one
immediately behind the scroll wheel. These are intended to be a
click-able way of scrolling up and down in addition to the "roll the
scroll wheel" way. Per the above initial mapping of the mouse, we have
seen that evdev reports these as buttons 11 and 12.

By trial and error, we can learn that Firefox performs scrolling up and
down when the Up Arrow key and the Down Arrow key respectively are
pressed. If you have a number pad on your keyboard, and Numlock is off,
this same is true of the number pad 8 and 2 keys.

To enable the scroll wheel buttons, simply add a little more to your
~/.xbindkeysrc, per:

    "/usr/bin/xvkbd -xsendevent -text "\[Up]""
    m:0x0 + b:11
    "/usr/bin/xvkbd -xsendevent -text "\[Down]""
    m:0x0 + b:12

One Button Left
---------------

There is a button on the MX1000 in the middle between the Forward and
Back thumb buttons that I believe Logitech calls the Tasks button. I
have never found a use for this particular button, but as we saw above,
evdev reports it as button 10:

Using the ~/.xbindkeysrc approach, you should be able to map this button
onto any function that you may find useful. Good luck!

Summary
-------

At this point, your MX1000 should be working exactly to your taste. In
summary, what we have done is:

-   Installed evdev and used it as the xorg driver for our MX1000 mouse
-   Mapped the mouse with xev to determine what buttons are recognized
    by evdev and what their logical button number is
-   Moved any functions that were showing up on the wrong buttons onto
    the desired buttons (we didn't need to do this with the MX1000, but
    it is something that will frequently be needed for other mice, so we
    went through it for completeness)
-   Mapped some desired functions onto the intended buttons via
    xbindkeys

  
 Of course, this is not MX1000 specific at all - you can apply these
steps to ANY mouse and get it working too.

All done! Simple n'est pas? :-) Enjoy your MX1000!

Retrieved from
"https://wiki.archlinux.org/index.php?title=Logitech_MX1000&oldid=205864"

Category:

-   Mice
