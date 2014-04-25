Joystick
========

Joysticks can be a bit of a hassle to get working in Linux. Not because
they are poorly supported, but simply because you need to determine
which modules to load to get your joystick working, and it's not always
very obvious!

Contents
--------

-   1 Joystick Input Systems
-   2 Determining which modules you need
-   3 Loading the modules
-   4 Testing Your Configuration
-   5 USB joysticks
-   6 PS3 controller
-   7 Xbox 360 controllers
    -   7.1 xboxdrv with two controllers
    -   7.2 Mimic Xbox 360 controller
        -   7.2.1 Playstation 3 Controlllers via USB
        -   7.2.2 Playstation 2 Adapter
-   8 Setting up deadzones
    -   8.1 Deadzones in Xorg
    -   8.2 Deadzones in the Kernel Driver
-   9 Disable Joystick From Controlling Mouse
-   10 Troubleshooting
    -   10.1 Joystick moving mouse
    -   10.2 Joystick sending keystrokes

Joystick Input Systems
----------------------

Linux actually has 2 different input systems for Joysticks. The original
'Joystick' interface and the newer 'evdev' based one.

'/dev/input/jsX' maps to the 'Joystick' API interface and
/dev/input/eventX maps to the 'evdev' ones (this also includes other
input devices such as mice and keyboards).

Most new games will default to the 'evdev' ones. However many of the
ones mentioned here (such as jscal, jstest and jstest-gtk) only work
with the older 'Joystick' interface making calibration/mapping with
those tools mostly useless. 'evdev' doesn't support any remapping or
calibration leaving it up to the applications to support it.

You can override SDL and force it to use the 'Joystick' API by setting
the environment variable 'SDL_JOYSTICK_DEVICE=/dev/input/js0'. This can
help many games such as X3.

You can normally see and test both in wine with 'wine control joy.cpl'.

It's also worth mentioning that there is also a xorg driver
'xf86-input-joystick'. It just to allow you to control the
mouse/keyboard in xorg using a joystick, for most people this will be
undesirable. This mean that editing xorg.conf.d files for
calibration/button mapping in games is pointless.

Determining which modules you need
----------------------------------

For an extensive overview of all joystick related modules in Linux, you
will need access to the Linux kernel sources -- specifically the
Documentation section. Unfortunately, pacman kernel packages do not
include what we need. If you have the kernel sources downloaded, have a
look at Documentation/input/joystick.txt. You can browse the kernel
source tree at kernel.org by clicking the "cgit" (git frontend) link for
the kernel that you're using, then clicking the "tree" link near the
top. Here's a link to the Documentation from kernel 3.12.6.

Some joysticks need specific modules, such as the Microsoft Sidewinder
controllers (sidewinder), or the Logitech digital controllers (adi).
Many older joysticks will work with the simple analog module. If your
joystick is plugging in to a gameport provided by your soundcard, you
will need your soundcard drivers loaded - however, some cards, like the
Soundblaster Live, have a specific gameport driver (emu10k1-gp). Older
ISA soundcards may need the ns558 module, which is a standard gameport
module.

As you can see, there are many different modules related to getting your
joystick working in Linux, so I couldn't possibly cover everything here.
Please have a look at the documentation mentioned above for details.

Loading the modules
-------------------

You need to load a module for your gameport (ns558, emu10k1-gp, cs461x,
etc...), a module for your joystick (analog, sidewinder, adi, etc...),
and finally the kernel joystick device driver (joydev). Add these to
your /etc/rc.conf, or simply modprobe them. The gameport module should
load automatically, as this is a dependency of the other modules.

Testing Your Configuration
--------------------------

Once the modules are loaded, you should find a new device:
/dev/input/js0. You can simply cat the device to see if it works - move
the stick around, press all the buttons. I found my Logitech Thunderpad
Digital had two buttons that weren't working with the analog module.
After reading some docs, I saw there was a specific adi module for this
controller. The moral of the story is, if it doesn't work the first
time, do not give up, and read those docs thoroughly! I couldn't get
anything working at all until I found that documentation.

Another way of testing is using jstest from the AUR joyutils package.
That package also has jscal for calibrating your device. If you have too
many buttons and axes to fit on a single line or your pad has an
accelerometer (it continuously sends new events even when nothing really
happens) you should use a graphical tool. AUR has jstest-gtk-git for
that purpose. It's essential for testing and troubleshooting a sixaxis.

USB joysticks
-------------

You need to get USB working, and then modprobe your joystick driver,
which is usbhid, as well as joydev. If you use a usb mouse or keyboard,
usbhid will be loaded already and you just have to load the joydev
module.

PS3 controller
--------------

The Sixaxis gamepad works out of the box when plugged in via USB. Steam
properly recognizes it as a PS3 pad and Big Picture can be launched with
the PS button. Big Picture and some games may act as if it was a 360
controller.

Gamepad control over mouse is on by default. You may want to turn it off
before playing games, See below.

Some people found that the controller is detected properly out of the
box, but none of the buttons and analogs do a thing. Pressing the PS
button solves the issue. The lights (they keep flashing) and the rumble
on DualShock 3 don't work.

Xbox 360 controllers
--------------------

The controllers should work without additional packages, but the
wireless controller needs a wireless reciever (the charge-and-play cable
can not be used for communicating with the controller). Both the wired
controllers and the wireless reciever is supported by the xpad kernel
module.

Unfortunately xpad has problems with new wireless controllers:

-   incorrect button mapping. (discussion in Steam bugtracker)
-   not-working sync. All four leds keep blinking, but controller works.
    (discussion in Arch Forum)

The working solution is use xboxdrv. It is alternative driver wich works
in userspace. It could be launched as system service.

If you wish to use the controller for controlling the mouse, or mapping
buttons to keys, etc. you should use the xf86-input-joystick package
(configuration help can be found using man joystick). If the mouse locks
itself in a corner, it might help changing the MatchDevicePath in
/etc/X11/xorg.conf.d/50-joystick.conf from /dev/input/event* to
/dev/input/js*.

> xboxdrv with two controllers

xboxdrv supports a multitude of controllers, but it works only in daemon
mode. The simplest way is launch xboxdrv as service in daemon mode:

    ExecStart = /usr/bin/xboxdrv -D -c /etc/conf.d/xboxdrv

And add support of the second controller in config file:

     [xboxdrv]
     silent = true
     next-controller = true
     [xboxdrv-daemon]
     dbus = disabled

> Mimic Xbox 360 controller

xboxdrv can be used to make any controller register as an Xbox 360
controller with the --mimic-xpad switch. This may be desirable for games
that support Xbox 360 controllers out of the box, but have trouble
detecting or working with other gamepads.

First, you need to find out what each button and axis on the controller
is called. You can use evtest from the AUR for this. Run evtest and
select the device event ID number (/dev/input/event*) that corresponds
to your controller. Press the buttons on the controller and move the
axes to read the names of each button and axis.

Here is an example of the output:


    Event: time 1380985017.964843, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90003
    Event: time 1380985017.964843, type 1 (EV_KEY), code 290 (BTN_THUMB2), value 1
    Event: time 1380985017.964843, -------------- SYN_REPORT ------------
    Event: time 1380985018.076843, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90003
    Event: time 1380985018.076843, type 1 (EV_KEY), code 290 (BTN_THUMB2), value 0
    Event: time 1380985018.076843, -------------- SYN_REPORT ------------
    Event: time 1380985018.460841, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90002
    Event: time 1380985018.460841, type 1 (EV_KEY), code 289 (BTN_THUMB), value 1
    Event: time 1380985018.460841, -------------- SYN_REPORT ------------
    Event: time 1380985018.572835, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90002
    Event: time 1380985018.572835, type 1 (EV_KEY), code 289 (BTN_THUMB), value 0
    Event: time 1380985018.572835, -------------- SYN_REPORT ------------
    Event: time 1380985019.980824, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90006
    Event: time 1380985019.980824, type 1 (EV_KEY), code 293 (BTN_PINKIE), value 1
    Event: time 1380985019.980824, -------------- SYN_REPORT ------------
    Event: time 1380985020.092835, type 4 (EV_MSC), code 4 (MSC_SCAN), value 90006
    Event: time 1380985020.092835, type 1 (EV_KEY), code 293 (BTN_PINKIE), value 0
    Event: time 1380985020.092835, -------------- SYN_REPORT ------------
    Event: time 1380985023.596806, type 3 (EV_ABS), code 3 (ABS_RX), value 18
    Event: time 1380985023.596806, -------------- SYN_REPORT ------------
    Event: time 1380985023.612811, type 3 (EV_ABS), code 3 (ABS_RX), value 0
    Event: time 1380985023.612811, -------------- SYN_REPORT ------------
    Event: time 1380985023.708768, type 3 (EV_ABS), code 3 (ABS_RX), value 14
    Event: time 1380985023.708768, -------------- SYN_REPORT ------------
    Event: time 1380985023.724772, type 3 (EV_ABS), code 3 (ABS_RX), value 128
    Event: time 1380985023.724772, -------------- SYN_REPORT ------------

In this case, BTN_THUMB, BTN_THUMB2 and BTN_PINKIE are buttons and
ABS_RX is the X axis of the right analogue stick. You can now mimic an
Xbox 360 controller with the following command:

    $ xboxdrv --evdev /dev/input/event* --evdev-absmap ABS_RX=X2 --evdev-keymap BTN_THUMB2=a,BTN_THUMB=b,BTN_PINKIE=rt --mimic-xpad

Use xboxdrv --help-button to see the names of the Xbox controller
buttons and axes and bind them accordingly by expanding the command
above. Axes mappings should go after --evdev--absmap and button mappings
follow --evdev-keymap (comma separated list; no spaces).

By default, xboxdrv outputs all events to the terminal. You can use this
to test that the mappings are correct. Append the --silent option to
keep it quiet.

Playstation 3 Controlllers via USB

If you own a PS3 controller and can connect with USB, xboxdrv has the
mappings built in. Just run the program (and detach the running driver)
and it works!

    $ sudo xboxdrv --silent --detach-kernel-driver

Playstation 2 Adapter

To fix the button mapping of PS2 dual adapters and mimic the Xbox
controller you can run the following command:

     sudo xboxdrv --evdev /dev/input/event* \
         --evdev-absmap ABS_X=x1,ABS_Y=y1,ABS_RZ=x2,ABS_Z=y2,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \
         --axismap -Y1=Y1,-Y2=Y2 \
         --evdev-keymap   BTN_TOP=x,BTN_TRIGGER=y,BTN_THUMB2=a,BTN_THUMB=b,BTN_BASE3=back,BTN_BASE4=start,BTN_BASE=lb,BTN_BASE2=rb,BTN_TOP2=lt,BTN_PINKIE=rt,BTN_BASE5=tl,BTN_BASE6=tr \
         --mimic-xpad --silent

Setting up deadzones
--------------------

If you want to set up the deadzones of your analog input you have to do
it separately for the xorg (for mouse and keyboard emulation) and the
kernel driver (for gaming).

> Deadzones in Xorg

Add a similar line into your /etc/X11/xorg.conf.d/50-joystick.conf
before the EndSection:

    Option "MapAxis1" "deadzone=1000"

1000 is the default value, but you can set anything between 0 and 30
000. To get the axis number see the "Testing Your Configuration" section
of this article. If you already have an option with a specific axis just
type in the deadzone=value at the end of the parameter separated by a
space.

> Deadzones in the Kernel Driver

The easiest way is using jstest-gtk-git. Select the controller you want
to edit, then click the calibration button at the bottom of the dialog.
You must set the CenterMin and CenterMax values for joysticks and analog
sticks, RangeMin for triggers. Then use jscal for to dump the new values
into a shell script:

    jscal -p /dev/input/jsX > jscal.sh # replace X with your joystick's number 
    chmod +x jscal.sh

Now you need to make a udev rule (for example
/etc/udev/rules.d and name it 85-jscal.rules) so the script will
automatically run when you connect the controller:

    SUBSYSTEM=="input", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="c268", ACTION=="add", RUN+="/usr/bin/jscal.sh"

To get the idVendor and idProduct use
udevadm info --attribute-walk --name /dev/input/jsX

Finally we must announce SDL our joystick device, or else it will just
ignore these to use its own settings. Add this to your ~/.bashrc :
export SDL_JOYSTICK_DEVICE=/dev/input/jsX (Again, replace X to your
device number.)

Disable Joystick From Controlling Mouse
---------------------------------------

If you want to play games with your controller, you might want to
disable gamepad control over mouse cursor. To do this, edit
/etc/X11/xorg.conf.d/50-joystick.conf so that it looks like this:

    /etc/X11/xorg.conf.d/50-joystick.conf 

    Section "InputClass"
            Identifier "joystick catchall"
            MatchIsJoystick "on"
            MatchDevicePath "/dev/input/event*"
            Driver "joystick"
            Option "StartKeysEnabled" "False"       #Disable mouse
            Option "StartMouseEnabled" "False"      #support
    EndSection

Troubleshooting
---------------

> Joystick moving mouse

Sometimes USB joystick can be recognized as HID mouse (only in X, it is
still being installed as /dev/input/js0 as well). Known issue is cursor
being moved by the joystick, or escaping to en edge of a screen right
after plugin. If your application can detect joystick by it self, you
can remove xf86-input-joystick package.

More gentle solution is to Disable Joystick From Controlling Mouse.

> Joystick sending keystrokes

This is a good solution for systems where restarting Xorg is a rare
event because it's a static configuration loaded only on X startup. I
use it on my media PC running XBMC controlled with Logitech Cordless
RumblePad 2. Due to a problem with the d-pad (a.k.a. "hat") being
recognized as another axis, I used to run Joy2key as a workaround. Since
I upgraded to XBMC 11.0 and joy2key 1.6.3-1, this setup no longer worked
for me. I ended up taking a more direct approach and let Xorg handle
joystick events.

First, make sure you have xf86-input-joystick installed. Then, create
/etc/X11/xorg.conf.d/51-joystick.conf like so:

     Section "InputClass"
      Identifier "Joystick hat mapping"
      Option "StartKeysEnabled" "True"
      #MatchIsJoystick "on"
      Option "MapAxis5" "keylow=113 keyhigh=114"
      Option "MapAxis6" "keylow=111 keyhigh=116"
     EndSection

Note:The MatchIsJoystick "on" line doesn't seem to be required for this
to work but you may want to uncomment it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Joystick&oldid=305913"

Category:

-   Input devices

-   This page was last modified on 20 March 2014, at 17:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
