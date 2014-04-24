Apple Keyboard
==============

  

Contents
--------

-   1 More Information
-   2 Function keys do not work
    -   2.1 If the above doesn't work for your wireless keyboard
-   3 < and > have changed place with § and ½
-   4 < and > have changed place with ^ and °
-   5 Media Keys
-   6 PrintScreen and SysRq
-   7 Treating Apple Keyboards Like Regular Keyboards

More Information
----------------

For background information see this page:
https://help.ubuntu.com/community/AppleKeyboard

Note:Some of the settings can be made permanent with a configuration
file for a kernel module. For this to work, the file hast to be added to
FILES in mkinitcpio.conf cause the kernel module will be autoloaded
while booting.

Tip:If you want to use sudo to write into a system directory you can't
use shell redirection. Use tee like so

    $ echo 0 | sudo tee /sys/module/hid_apple/parameters/iso_layout

Function keys do not work
-------------------------

If your F<num> keys do not work, this is probably because the kernel
driver for the keyboard has defaulted to using the media keys and
requiring you to use the Fn key to get to the F<num> keys. To change
this behaviour, you have to change the driver setting. Do the following
as root:

    # echo 2 > /sys/module/hid_apple/parameters/fnmode

If it tells you that the file doesn't exist, you probably have an older
kernel and will have to do the following instead:

    # echo 2 > /sys/module/hid/parameters/pb_fnmode

Place whatever option worked for you in /etc/modprobe.d/hid_apple.conf
to make the setting permanent.

> If the above doesn't work for your wireless keyboard

If hid_apple/parameters and/or hid/parameters/pb_fnmode is missing in a
recent Apple Bluetooth keyboard model and kernel 3.4.

First thing: identify your keyboard. Execute as root (hidd is part of
package bluez from the official repositories):

    # hidd --show

You should see something like:

    40:CA:EC:32:85:AB Apple Wireless Keyboard [05ac:0255] connected 

So with the vendor (05ac) and device (0255) ID it's easier to find out
if the current kernel has support for it. Actually, the above device is
listed in the linux kernel 3.4. If you check drivers/hid/hid-ids.h you
should see the following line:

    #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI  0x0255

But support for the Function Key is missing.

In order to fix it rebuild your kernel from abs with the following
patch: http://pastebin.com/CvFJz3Fn

This bug is already reported upstream
https://bugzilla.kernel.org/show_bug.cgi?id=43135 and part of the
vanilla kernel since 3.5

< and > have changed place with § and ½
---------------------------------------

If the < and > are switched with the § and ½ keys, run the following
command in your graphical environment:

    $ setxkbmap -option apple:badmap

Place that command into ~/.bashrc file to have it run automatically when
you log in.

You can also apply the change system-wide by creating (or editing)
/etc/X11/xorg.conf.d/10-keymap.conf as such:

    Section "InputClass"
        Identifier "keyboard catchall"
        MatchIsKeyboard "true"
        Driver "evdev"
        Option "XkbOptions" "apple:badmap"
    EndSection

  
 If the above approach doesn't seem to work, you can add these two lines
to your ~/.Xmodmap file:

    keycode  49 = less greater less greater bar brokenbar
    keycode  94 = section degree section degree notsign notsign

If you use a Canadian multilingual layout (where the "ù" and the "/" is
switch) use this :

    keycode  94 = slash backslash slash backslash bar brokenbar
    keycode  49 = ugrave Ugrave ugrave Ugrave notsign notsign

Then run xmodmap ~/.Xmodmap. This command can also go into ~/.bashrc.

< and > have changed place with ^ and °
---------------------------------------

With German layout, circumflex/degree symbol and 'smaller than'/'bigger
than' are exchanged.

The new way:

First, try if the new method works for you (you have to be root)

    # echo 0 > /sys/module/hid_apple/parameters/iso_layout

To make the changes permanent add the following line to
/etc/modprobe.d/hid_apple.conf:

    options hid_apple iso_layout=0

To fix this the old way, do the following:

    $ xmodmap -e 'keycode 49 = less greater less greater bar brokenbar bar' -e 'keycode 94 = dead_circumflex degree dead_circumflex degree U2032 U2033 U2032'

Now try your keys. When it works, you may want the change permanently.
So execute this:

    $ xmodmap -pke | grep " 49" >> ~/.Xmodmap
    $ xmodmap -pke | grep " 94" >> ~/.Xmodmap

Media Keys
----------

The evdev driver should produce keycodes that map to the appropriate
keysyms for your media keys by default. You can confirm that by running
xev in a console window and watching the console output as you press
your media keys.

For these keys to have any effect, you will have to assign actions to
them. Refer to Extra Keyboard Keys in Xorg for more about that.

  
 If you have confirmed that your media keys are not producing the
correct keycodes, create or edit the ~/.Xmodmap file so that it includes
these lines:

    keycode 160 = XF86AudioMute
    keycode 176 = XF86AudioRaiseVolume
    keycode 174 = XF86AudioLowerVolume

    keycode 144 = XF86AudioPrev
    keycode 162 = XF86AudioPlay
    keycode 153 = XF86AudioNext

    keycode 101 = XF86MonBrightnessDown
    keycode 212 = XF86MonBrightnessUp

    keycode 204 = XF86Eject

and then run xmodmap ~/.Xmodmap. Place that command in the ~/.bashrc
file to have it run automatically when you log in.

PrintScreen and SysRq
---------------------

Apple Keyboards have an F13 key instead of a PrintScreen/SysRq key. This
means that Alt+SysRq sequences do not work, and application actions
associated with PrintScreen (such as taking screenshots in many games
that work under Wine) do not work. Both issues can be addressed by
installing keyfuzz from the Arch User Repository.

With keyfuzz installed, run the following command:

    echo "458856 99" | /usr/sbin/keyfuzz -s -d /dev/input/by-id/usb-Apple__Inc_Apple_keyboard-event-kbd

458856 (0x070068) is the scancode of F13, and 99 is the keycode of
PrintScreen/SysRq. You can determine the scancode of a particular key
with getscancodes from the AUR, and the keycode from
/usr/include/linux/input.h.

Other versions of the Apple Aluminum Keyboard may require a slightly
different device path, so adjust it as needed. You can make this change
permanent by putting the command in /etc/rc.local.

Treating Apple Keyboards Like Regular Keyboards
-----------------------------------------------

If you want to use your Apple keyboard like a regular US-layout
keyboard, with Alt on the left side of Meta, you can use the AUR package
un-apple-keyboard. Currently it only works for the aluminium USB model.
The package does the following things:

-   Adds a /etc/modprobe.d/hid_apple.conf file which enables the F keys
    by default, as above.
-   Uses keyfuzz to remap F13-15 to PrintScreen/SysRq, Scroll Lock, and
    Pause, respectively
-   Swaps the ordering of the Alt and Meta (Command) keys to match all
    other keyboards, again using keyfuzz.
-   Applies these changes automatically when you plug in your keyboard,
    with a udev rule.

You will need to add /etc/modprobe.d/hid_apple.conf to FILES in
mkinitcpio.conf. Otherwise if you boot your computer with the Apple
keyboard plugged in, the F keys will not be the default.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Apple_Keyboard&oldid=302202"

Category:

-   Keyboards

-   This page was last modified on 26 February 2014, at 11:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
