All Mouse Buttons Working
=========================

This article is for users that have a mouse with more than 7 mouse
buttons and want to be able to use all of them. Logitech makes several
of these (if you have a Logitech Marble® Mouse you can also look at this
page), and Microsoft makes a few as well.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Finding the Mouse Name                                             |
| -   3 Configuring Xorg                                                   |
| -   4 Post Configuration                                                 |
|     -   4.1 Google Chrome                                                |
|     -   4.2 Opera                                                        |
|     -   4.3 Firefox                                                      |
|         -   4.3.1 Horizontal Scroll                                      |
|                                                                          |
|     -   4.4 Firefox3                                                     |
|         -   4.4.1 Thumb Buttons - Forward and Back                       |
|                                                                          |
|     -   4.5 xmodmap tweaking                                             |
|                                                                          |
| -   5 Alternate Methods                                                  |
|     -   5.1 Method 1 - IMPS/2                                            |
|     -   5.2 Method 2 - ExplorerPS/2                                      |
|     -   5.3 Method 3 - Auto                                              |
|     -   5.4 Method 4 - btnx                                              |
|     -   5.5 Method 5 - easystroke                                        |
|     -   5.6 Firefox 3 button 6 + 7 correction:                           |
|                                                                          |
| -   6 Binding keyboard to mouse buttons                                  |
|     -   6.1 xvkbd and xbindkeys                                          |
|     -   6.2 Why standard methods are not enough?                         |
|     -   6.3 kbde                                                         |
|     -   6.4 evrouter                                                     |
|     -   6.5 Binding + and - in Logitech G5 mouse                         |
|     -   6.6 startup scripts                                              |
|                                                                          |
| -   7 User Tools                                                         |
| -   8 See Also                                                           |
+--------------------------------------------------------------------------+

Prerequisites
-------------

Note:These are helper comments, and can be ignored if you are looking
for nothing but raw information. Due to community feedback, I decided to
add a bit more commenting that describes what's going on "behind the
scenes" with this configuration.

We will be using the evdev driver for Xorg. EVentDEVice is an advanced
driver for USB input devices which offers much greater power over the
standard Xorg mouse driver. It is also more "direct" than the mouse
driver, allowing lower latency and less translation issues.

-   Note that evdev is both a kernel module and an Xorg input driver.
    All the Arch kernels come with the evdev module.

With the newer Xorg 11R7.0 it seems only the following changes to
/etc/X11/xorg.conf need to be made with nothing else needing to be done.

Finding the Mouse Name
----------------------

Note:To get accurate information it is sometimes required to execute
this command from a boot where no Xorg or mouse drivers have been
loaded.

The first step is to find the name of the mouse. To do this, execute the
following command:

    $ egrep "Name|Handlers" /proc/bus/input/devices

This should output something like this:

    N: Name="Logitech USB Gaming Mouse"
    H: Handlers=mouse0 event0 ts0 
    N: Name="HID 0566:3002"
    H: Handlers=kbd event1 

The mouse is the one that has the Handlers=mouse0, so the name of the
device is Logitech USB Gaming Mouse.

Note:My mouse is a Logitech G5; your mouse is probably different, and
therefore the Name will be different.

Copy the name of the device, and open up /etc/X11/xorg.conf.

Configuring Xorg
----------------

Now, we need an entry in xorg.conf that tells X how to use this mouse.
It should look something like this:

    Section "InputDevice"
      Identifier      "Evdev Mouse"
      Driver          "evdev"
      Option          "Name" "Logitech USB Gaming Mouse"
      Option          "evBits"  "+1-2"
      Option          "keyBits" "~272-287"
      Option          "relBits" "~0-2 ~6 ~8"
      Option          "Pass"    "3"
      Option          "CorePointer"
    EndSection

Replace the Name option with the name you copied from above. You may
also omit the CorePointer option if you use multiple mice or experience
errors when attempting to load Xorg. The other options are all basic
mouse configurations for evdev and should work with most mice.

Next, we need to tell X to use the mouse, so look in xorg.conf for
ServerLayout.

Modify the ServerLayout section to use "Evdev Mouse" as the device. When
you are done, it should look something like this:

    Section "ServerLayout"
      Identifier     "Default Layout"
      Screen 0       "Monitor0" 0 0
      InputDevice    "Keyboard0" "CoreKeyboard"
      InputDevice    "Evdev Mouse" "CorePointer"
    EndSection

The only thing you should change in the layout is the InputDevice line
that refers to your mouse.

That should be all that is required.

-   Edit by: xxsashixx

This is for Logitech G5 Mouse users. I have not tested this for other
mice, but if you do not add this, your mouse MAY not work. If you do not
need to add this, then don't.

Put

    Option "Device" "/dev/input/event[#]"

in the InputDevice section or else the mouse will not be picked up.

[#] = The number you got from:

    egrep "Name|Handlers" /proc/bus/input/devices

-   Edit by: bapman

With the above method, your mouse might not to work after reboot (event
number changes). To fix this, you can use symlinks in /dev/input/by-id.
For example:

    Option      "Device" "/dev/input/by-id/usb-Logitech_USB_Receiver-event-mouse"

To find the appropriate id, do:

    ls /dev/input/by-id/

-   Edit by: Diamir

With a Desktop type keyboard-mouse, this does not work because there is
only one USB attachment and /dev/input/by-id contains only the keyboard.
In this case, we can create a udev rule to get a consistent link. The
following rules create the link /dev/input/usbmouse which points on the
correct event entry:

    KERNEL=="event[0-9]*", BUS=="usb", SYSFS{modalias}=="usb:v045Ep008Ad7373dc00dsc00dp00ic03isc00ip00", SYMLINK+="input/usbmouse"

You can call it z10_usb_mouse.rules and put it in /etc/udev/rules.d

The cryptic value to use for SYSFS(modalias) can be get the following
way:

enter the command cat /proc/bus/input/devices

You will find the keyboard and the mouse and see event4 is the mouse in
this case:

    I: Bus=0003 Vendor=045e Product=008a Version=0111
    N: Name="Microsoft Microsoft Wireless Optical Desktop� 1.00"
    P: Phys=usb-0000:00:10.0-2/input0
    S: Sysfs=/devices/pci0000:00/0000:00:10.0/usb1/1-2/1-2:1.0/input/input3
    U: Uniq=
    H: Handlers=kbd event0 
    B: EV=120013
    B: KEY=1000000000007 ff800000000007ff febeffdff3cfffff fffffffffffffffe
    B: MSC=10
    B: LED=107

    I: Bus=0003 Vendor=045e Product=008a Version=0111
    N: Name="Microsoft Microsoft Wireless Optical Desktop� 1.00"
    P: Phys=usb-0000:00:10.0-2/input1
    S: Sysfs=/devices/pci0000:00/0000:00:10.0/usb1/1-2/1-2:1.1/input/input4
    U: Uniq=
    H: Handlers=kbd mouse0 event1 
    B: EV=17
    B: KEY=3000000000000 0 1f0000 f8400244000 601878d800d448 1e000000000000 0
    B: REL=7c3
    B: MSC=10

So I enter the following command (adapt event # to your particular
case):

    udevinfo -a -p `udevinfo -q path -n /dev/input/event4` | grep modalias
    ATTRS{modalias}=="input:b0003v045Ep008Ae0111-0,1,2,4,k71,72,73,74,83,86,8A,8C,8E,8F,9B,9C,9E,9F,A3,A4,A5,A6,AB,AC,B5,B6,CE,D2,D5,E2,E7,E8,E9,EA,EB,110,111,112,113,114,1B0,1B1,r0,1,6,7,8,9,A,am4,lsfw"
    ATTRS{modalias}=="usb:v045Ep008Ad7373dc00dsc00dp00ic03isc00ip00"
    ATTRS{modalias}=="pci:v00001106d00003038sv00001043sd000080EDbc0Csc03i00"

grab the ATTRS which becomes with usb: to complete "SYSFS{modalias}== "
entry

And finally, use usbmouse as the Device Option in xorg.conf:

    Option "Device" "/dev/input/usbmouse"

Post Configuration
------------------

> Google Chrome

It just works™.

Horizontal scroll works out of the box - push the scroll wheel left or
right. Thumb buttons also work as next/previous page.

> Opera

It just works™.

Note: buttons can be mapped to functions easily in
Preferences > Advanced > Shortcuts > Mouse set-up. For example, to bind
button 8 to back:

1.  Navigate to mouse set-up and expand the Application drop-down
2.  In the input column, type: Button 8
3.  In the actions column, type: Back

> Firefox

Horizontal Scroll

By default, left right scroll on a FX/MX mouse translates into
back/forward, respectively. If you do not like this, open about:config
and change a few values:

    mousewheel.horizscroll.withnokey.action      0
    mousewheel.horizscroll.withnokey.numlines   -3

OR (tested on Logitech G5)

    mousewheel.horizscroll.withnokey.action      2
    mousewheel.horizscroll.withnokey.numlines    2

NOTE: If you use a positive value for numlines, your left/right will
switch, ie: pressing left scrolls the window to the right.

> Firefox3

OR (tested on Microsoft Wireless Intellimouse explorer 2.0)

    mousewheel.horizscroll.withnokey.action         2
    mousewheel.horizscroll.withnokey.numlines      -1
    mousewheel.horizscroll.withnokey.sysnumlines   false

Note: If you use the true value for numlines, your left/right will be
inverted.

  

Thumb Buttons - Forward and Back

Note: The following maybe redundant depending on whether xev detects all
your mouse buttons correctly (functions can be mapped on a per-app
basis) or you want to change the default behaviour.

To do this we need to map keystrokes to the desired mouse buttons and
install xvkbd and xbindkeys.

    # pacman -S xvkbd xbindkeys

In most modern applications which use back/forward features, XF86Back is
mapped to back and XF86Forward is mapped to forward by default. On most
MX mice the thumb buttons resolve to 8 & 9. If your mouse is different,
check button numbers using xev and replace the numbers used in the
example (b:8 & b:9).

So if you have an MX mouse you would create the file ~/.xbindkeysrc,
containing:

    # Mouse Buttons
    "xvkbd -xsendevent -text "\[XF86Back]""
    m:0x0 + b:8 
    "xvkbd -xsendevent -text "\[XF86Forward]""
    m:0x0 + b:9

Now to test... Run the following command and if it works as expected
remember to add xbindkeys to .xinitrc or somewhere where it will be
executed each time X starts. Also, this should work with Epiphany and
Konqueror without any additional configuration or use of imwheel.

    xbindkeys

The above info and more help may be found in the MX1000_Buttons wiki.

> xmodmap tweaking

Note: None of the below is necessary with evdev, but it's here for
non-evdev users. Unless something doesn't work on your mouse, ignore
this whole section!

If you use .xinitrc to load X, then add this to .xinitrc (change for the
number of buttons you have):

     xmodmap -e "pointer = 1 2 3 6 7 8 9 10 11 12 4 5" &

Note that buttons 4 and 5 must go on the end or else your scroll wheel
won't work.

If you use GDM/XDM/KDM instead of .xinitrc, then create the file
~/.Xmodmap and add this to it (change for the number of buttons you
have):

     pointer = 1 2 3 6 7 8 9 10 11 12 4 5

-   GDM/XDM/KDM read the ~/.Xmodmap file if it's present, whereas startx
    does not. Another solution would be to add this to your ~/.xinitrc:
    xmodmap -e $(cat ~/.Xmodmap). This would allow you to use *DM and
    startx while only having to edit ~/.Xmodmap when you need to make
    changes.

You may have to play with these numbers a bit to get your desired
behavior. Some mice use buttons 6 and 7 for the scroll wheel, in which
case those buttons would have to be the last numbers. Keep playing with
it until it works!

You can also check to see which buttons are being read with a program
called 'xev', which is part of XOrg. When xev is run, it will show a box
on your desktop that you can put the cursor into and click buttons to
find out what buttons have been mapped.

Alternate Methods
-----------------

The following methods use standard X.org mouse input driver
(xf86-input-mouse) instead of using the evdev driver. It works on mice
up to 7 buttons. Edit /etc/X11/xorg.conf InputDevice section for your
mouse to reflect the changes shown below. Then restart X and you're
done.

> Method 1 - IMPS/2

This has been tested on an IntelliMouse Explorer 3.0. Your mileage may
vary, as this does not seem to work for all said mice.

       Driver      "mouse"
       Option      "Protocol" "IMPS/2"
       Option      "Device" "/dev/input/mice"
       Option      "ZAxisMapping" "4 5 6 7"

> Method 2 - ExplorerPS/2

This has been tested on a Logitech MX400 and MX518 and should work on
any mx series mouse with up to 7 buttons.

       Driver         "mouse"
       Option         "Protocol" "ExplorerPS/2"
       Option         "Device" "/dev/input/mice"
       Option         "Buttons" "7"
       Option         "ZAxisMapping" "4 5"
       Option         "ButtonMapping" "1 2 3 6 7"

Settings from above also works for Microsoft InteliMouse Explorer 3.0
that connects through USB.

> Method 3 - Auto

This has been tested on a Logitech MX400 and should work on most mice
with up to 7 buttons.

       Driver         "mouse"
       Option         "Protocol" "auto"
       Option         "Device" "/dev/input/mice"
       Option         "Buttons" "7"
       Option         "ZAxisMapping" "4 5"
       Option         "ButtonMapping" "1 2 3 6 7"

This has been tested to work with Logitech MX1000.

       Driver         "mouse"
       Option         "Protocol" "auto"
       Option         "Device" "/dev/input/mice"
       Option         "Emulate3Buttons" "no"
       Option         "Buttons" "12"
       Option         "ZAxisMapping" "4 5 7 6 8 9"

> Method 4 - btnx

Note:Though very convenient, btnx is no longer available. Its developper
states "btnx might not work as intended on some distros anymore" and it
is advised to use easystroke instead.

btnx: Button Extension – a GNU/GPL mouse tool for GNU/Linux

This allows the use of all buttons on the Logitech MX Revolution and
reportedly other multi-button mice as well. Provides greater control &
configuration than the evdev driver.

btnx is a daemon, as such it needs to be configured as root, and its
actions are available to all users.

Install via AUR: btnx-config then btnx. Be sure the xorg.conf "Device"
is at the default /dev/input/mice rather than evdev.

Then configure your buttons by running btnx-config as root:

    btnx-config

Save your configuration and start btnx daemon (as root):

    rc.d start btnx

You're likely to want this daemon to be started during boot, so add it
to the DAEMONS array of you're /etc/rc.conf

    DAEMONS=(.... @btnx ....)

> Method 5 - easystroke

easystroke is a gesture-recognition application for X11

easystroke is a mouse gesture application, but it can be used to manage
mouse buttons as well. It's main advantage o-ver btnx is that it's more
versatile. On the other hand, it's user-based, so any user has to
configure it to reflect his own needs.

In order to set up easystroke to manage your extra mouse buttons, you'll
need to do this (example features Back/Forward mouse buttons) : run:

    easystroke -g

Go to Preferences tab > Additional buttons > Add, and add any special
button.

Note:In case of easystroke doesn't automatically detect mouse buttons,
you can specify it manually. Button identifiers (numbers) can be viewed
by xev

Go to Action tab > Add action, give the new action a name, as Type
choose "Key", as Details set "Alt+Left" for Back button, "Alt+Right" for
Forward button, as Stroke click the proper mouse button (confirm if a
warning is displayed), and voilà! Your mouse button is configured.

Note: Since Firefox 3, buttons 6 + 7 are no longer mapped to back and
forward as in Firefox 2. Therefore, if using the above methods in Xorg,
refer further to corrective methods below if necessary

> Firefox 3 button 6 + 7 correction:

For MX518, try changing the above ButtonMapping Option to:

    Option         "ButtonMapping" "1 2 3 8 9" 

And restart X. (Successfully tested on MX518)

Another method:

Leave back/forward mapped to 6+7 in xorg. In Firefox 3 about:config
change the following keys:

    mousewheel.horizscroll.withnokey.action = 2
    mousewheel.horizscroll.withnokey.numlines = -1
    mousewheel.horizscroll.withnokey.sysnumlines = false

Binding keyboard to mouse buttons
---------------------------------

> xvkbd and xbindkeys

Let's say we want to bind some mouse buttons to keyboard ones. The
problem we will encounter is that we do not know how to emulate a key
press. Here comes in handy xvkbd. We can use it along with xbindkeys.

    xbindkeys --defaults >> ~/.xbindkeysrc
    xbindkeys

to restart xbindkeys type:

    pkill -f xbindkeys
    xbindkeys 

Here's example ~/.xbindkeysrc config:

    "xvkbd  -text "\[F8]""
           m:0x0 + b:8
    "xvkbd  -text "\[Shift]\[Left]""
           m:0x0 + b:9
    "xvkbd  -text "\[Shift]\[Right]""
           m:0x0 + b:10
    "xvkbd  -text 2"
           m:0x0 + b:11
    "xvkbd  -text 3"
           m:0x0 + b:12

if you want to check your mouse buttons number use xev. Don't forget to
type capital letters in xvkbd -text usage and to escape opening bracket
with \, or you get simply [Shift] written.

Here is an example for xbindkeys to enable x selection paste(third click
pasting), you need both xsel and xvkbd installed, What it does it
executes that command whenever button 13 of the mouse is pressed (in
~/.xbindkeysrc) :

     "xvkbd -no-jump-pointer -text "\D1`xsel`" 2>/dev/null"
     b:13

> Why standard methods are not enough?

This will work great for X servers, but it seems not to work in some
specific situations, like in Enemy Territory game. So I will describe a
bit more advanced configuration, which work with my logitech G5 buttons
- I can use all my 5 additional buttons along with 3 standard and a
scroll, which gives overall 10 events to use in Enemy Territory. So here
we go:

Note: Update: evrouter can now simulate X11 key events so it is now
possible to skip kbde and only use evrouter to bind keyboard buttons to
your mouse.

> kbde

To emulate keystroke which will be later detected in Enemy Territory we
need something more advanced than xvkbd. Here comes in handy kbde, but
it doesn't exist in AUR yet – we've got to compile it by ourselves. We
need two programs: kbde and kbde-driver. Kbde website is located on
sourceforge [1], check it for download, you need only kbde-driver.
Apparently, it doesn't work for me without some hacking. Use your editor
and add

    #include <linux/version.h>

somewhere near other includes in the driver/kbde.c file. (OK, I'm not
sure whether it is a proper way to compile it, but it works). Assuming
that you've already done that try:

    tar -zxvf kbde-driver-1*
    cd kbde-driver-1*
    make
    # if you do not have sudo just use su and type this as root
    sudo make install mknod
    modprobe kbde

and now you should have kbde working. If you want to use it as a
non-root (yes, you want) change permissions, the quickest and dirtiest
way is (note that I added my startup scripts at the end of this text):

    chgrp users /dev/kbde
    chmod 220 /dev/kbde

If not try reading installation instructions on the site. Now we can use
it to emulate keystrokes visible even in login shells:

    kbde --press 5 --release 5 -b

this will press 5 for about three times. If you want to type a string
using this, rather than this use --asci=STRING, as press sometimes
generates 3 strokes before it is released.

> evrouter

Now we need something which will work when Enemy Territory is loaded.
Apparently, xbindkeys does not work here, so we need another program:
evrouter [2], which can be found in the AUR: [3]

OK, so now we must have evdev and we can NOT use it in X, so here is how
my example /etc/X11/xorg.conf mouse section looks like:

     Section "InputDevice"
       
       Identifier  "Logitech G5"
       
       Driver      "mouse"
       Option      "Protocol" "Auto"
       Option      "Device" "/dev/input/mouse1" # probably you'll need here mouse0
       Option      "Name"   "Logitech USB Gaming Mouse"
       Option      "Buttons" "8" # set this to your number of buttons
       Option      "ZAxisMapping" "4 5"

     EndSection

and now we have to restart the X server. You will run this as user, and
event devices are owned by root, so you got to change the permissions at
this point. Let us say we do it just like that, but I advise you to do
this more carefully (note that I added my start-up scripts at the end of
this text):

    chgrp users /dev/input/event*
    chmod 660 /dev/input/event*

Now we can use the --dump option to check what we will have to bind and
to which device:

    evrouter --dump /dev/input/event*
    # here click buttons you would like to bind

It will give you output similar to config. Here is my example config
~/.evrouterrc with kbde usage:

    "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/278 "SHELL/kbde --press 2 --release 2 -b"
    "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/279 "SHELL/kbde --press 3 --release 3 -b"
    "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/274 "SHELL/kbde --press 4 --release 4 -b"
    "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/277 "SHELL/kbde --press 5 --release 5 -b"
    "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/276 "SHELL/kbde --press 6 --release 6 -b"

Same config using evrouters built in X11 key event emulator instead of
kbde:

      "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/278 "XKey/2"
      "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/278 "XKey/3"
      "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/278 "XKey/4"
      "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/278 "XKey/5"
      "Logitech USB Gaming Mouse" "/dev/input/event.*" any key/278 "XKey/6"

  
 This works great, even in Enemy Territory. The "none" modifier means
that I have to only press the button, other options are Ctrl+Alt and so
on. Here I use "any" because "none" means that after pressing Shift,
Ctrl, or Alt, our buttons would not work. Also note that it accepts
regular expressions for mouse name and event path. Then, after setting
up a config, run service with:

    evrouter /dev/input/event* >> /dev/null

or change the event* to a device corresponding to your mouse -- but be
aware that the numbers are changing sometimes. It will work in
background, while outputting some annoying messages, so we stream it to
/dev/null. If something went wrong, run it without streaming and check
what it outputs. If you want to end it, you have to delete
/tmp/evrouter.* manually. Here is a script to kill evrouter:

    #!/bin/bash
    evrouter -q
    rm -f /tmp/.evrouter*

and here is one to start it:

    #!/bin/bash
    mydevicename="Logitech USB Gaming Mouse"

    device=`evrouter -D /dev/input/event* | grep "$mydevicename"` | cut -d ":" -f 2
    evrouter $device > /dev/null

You have to edit the mydevicename variable to its proper value (the one
which is shown by evrouter -D), or just change it to listen on all
events by changing device var to /dev/input/event*. OK, I have saved
them in /usr/bin/. Now, everything should be ready for use!

> Binding + and - in Logitech G5 mouse

If you want to bind the buttons + and - in G5/7 mouse, which normally
changes DPI, you have to use g5hack [4] released by a lomoco author.

    wget http://piie.net/temp/g5_hiddev.c
    gcc -o g5hack g5_hiddev.c
    ./g5hack /dev/usb/hiddev0 3

This will change your DPI to 2000, light the 1st LED and disables DPI
on-the-fly changing, so you can use it with evrouter. If you would use
it frequently I suggest you to copy it to the /usr/bin directory:

    $ sudo cp g5hack /usr/bin/

If you want to bind your + and - buttons you must copy the line at the
bottom (one with the comment '"-" button does not function anymore'
above) to the mode you will be using, like, for example, under the "case
3:" you can put it on the line with the comment 'turn on third led'
above (deleting the old one before of course).

For the newest G5 mouse which is reported as "product 0xc049" original
hack does not work. You have to simply change the
#define MOUSE_G5 0xc041 to #define MOUSE_G5 0xc049 and recompile.

> startup scripts

Currently, I am using a startup script with a few dirty methods, so if
somebody can propose better, please edit. I have created an input group
and made my user a member of it.

/etc/rc.local:

    #!/bin/bash
    # creating /dev/kbde nod and changing permissions
    # also do not forget to add kbde in modules line in /etc/rc.conf
    # to be honest, I'm not sure why we have to create /dev/kbde after each startup, but it seems that only this way it works
    # maybe first check if it's needed for you, too
    mknod --mode=220 /dev/kbde c 11 0 
    chgrp input /dev/kbde
    # changing permissions for event* -- evrouter needs that
    chmod 660 /dev/input/event*
    chgrp input /dev/input/event*
    # g5hack ran for a few times to make sure that it'll work...
    # note that I've add it to /usr/bin, you should probably put your full path here
    # you probably should skip this lines, especially if you do not have a Logitech g5/g3/g7
    g5hack /dev/usb/hiddev0 3
    g5hack /dev/usb/hiddev0 3
    g5hack /dev/usb/hiddev0 3

~/.kde/Autostart/init:

    #!/bin/bash
    # there I use my script to start evrouter, which I have presented above
    evrouter-start
    # here I map my buttons so I can use G5 thumb button as push to talk in TS
    # note that I have to use it as middle button also on KDE
    # you probably do not need it
    xmodmap -e "pointer = 1 9 3 4 5 6 7 2 8 10 11 12"

And voila, we've got it working immediately after KDE login.

User Tools
----------

imwheel provides configurable mouse wheel and button mapping. It can be
configured globally or for individual processes.

Sample ~/.imwheelrc to enable back/forward thumb buttons for all
applications and increased scroll speed in Chromium:

    "^chromium$"
    None, Up, Button4, 3
    None, Down, Button5, 3
    ".*"
    None, Thumb1, Alt_L|Left
    None, Thumb2, Alt_L|Right

lomoco for Logitech MX mice will help you set the proper resolution,
enable or disable smart scroll (with boot time support too!), etc.
lomoco is available from the [community] repository and can be installed
with the following command:

Be sure to look at /etc/udev/lomoco_mouse.conf and set up the the
options you want to be automatically applied when the mouse gets loaded
by udev.

Note:The lomoco package may be out of date. There is a hack for newer
Logitech mice: [5]

See Also
--------

-   http://www.gentoo-wiki.info/HOWTO_Advanced_Mouse

For similar setup, specially for Logitech MX, see:

-   http://lotphelp.com/lotp/lotp-guide-logitech-mx-mouse-ubuntu

Retrieved from
"https://wiki.archlinux.org/index.php?title=All_Mouse_Buttons_Working&oldid=255849"

Categories:

-   Mice
-   X Server
