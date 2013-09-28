Joystick
========

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Joysticks can be a bit of a hassle to get working in Linux. Not because
they are poorly supported, but simply because you need to determine
which modules to load to get your joystick working, and it's not always
very obvious!

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Setup                                                              |
|     -   1.1 Determining Which Modules You Need                           |
|     -   1.2 Loading the Modules                                          |
|     -   1.3 Testing Your Configuration                                   |
|     -   1.4 USB Joysticks                                                |
|     -   1.5 Xbox 360 Controllers                                         |
|         -   1.5.1 xboxdrv with two controllers                           |
|                                                                          |
|     -   1.6 Troubleshooting                                              |
|         -   1.6.1 Joystick moving mouse                                  |
|         -   1.6.2 Joystick sending keystrokes                            |
+--------------------------------------------------------------------------+

Setup
=====

Determining Which Modules You Need
----------------------------------

For an extensive overview of all joystick related modules in Linux, you
will need access to the Linux kernel sources -- specifically the
Documentation section. Unfortunately, pacman kernel packages do not
include what we need. If you have the kernel sources downloaded, have a
look at Documentation/input/joystick.txt. You can browse the kernel
source tree at kernel.org by clicking the "C" (current changesets) link,
then clicking the "tree" link near the top. Here's a link to the
Documentation from kernel 2.6.17.11.

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

Loading the Modules
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

USB Joysticks
-------------

You need to get USB working, and then modprobe your joystick driver,
which is usbhid, as well as joydev. If you use a usb mouse or keyboard,
usbhid will be loaded already and you just have to load the joydev
module.

Xbox 360 Controllers
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

Troubleshooting
---------------

> Joystick moving mouse

Sometimes USB joystick can be recognized as HID mouse (only in X, it is
still being installed as /dev/input/js0 as well). Known issue is cursor
being moved by the joystick, or escaping to en edge of a screen right
after plugin. If your application can detect joystick by it self, you
can remove xf86-input-joystick package:

    # pacman -R xf86-input-joystick

More gentle solution is to add:

    Option "StartKeysEnabled" "False"
    Option "StartMouseEnabled" "False"

at the end of your /etc/X11/xorg.conf.d/50-joystick.conf of joystick
InputClass.

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
    	Option	"MapAxis5" "keylow=113 keyhigh=114"
    	Option	"MapAxis6" "keylow=111 keyhigh=116"
    EndSection

Note:The MatchIsJoystick "on" line doesn't seem to be required for this
to work but you may want to uncomment it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Joystick&oldid=248935"

Category:

-   Input devices
