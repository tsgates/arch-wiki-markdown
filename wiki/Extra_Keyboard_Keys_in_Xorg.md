Extra Keyboard Keys in Xorg
===========================

Summary

A general overview of how to assign actions to extra keyboard keys in
Xorg.

Related

Xorg

Xmodmap

Extra Keyboard Keys

Extra Keyboard Keys in Console

When we are in a graphical environment we may want a key to print a
special character or execute a command. There are some ways of doing
that and they are covered in this HOWTO.

Note:This article assumes that your keys already have keycodes and that
you know these codes, if not, see the Extra Keyboard Keys article where
it is explained.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Map keycodes to symbols                                            |
|     -   1.1 Introduction                                                 |
|     -   1.2 Step 1: Create the xmodmap file                              |
|     -   1.3 Step 2: Testing                                              |
|     -   1.4 Step 3: Making it permanent                                  |
|                                                                          |
| -   2 Map keycodes to actions                                            |
|     -   2.1 Using your Desktop Environment tools                         |
|         -   2.1.1 Gnome                                                  |
|         -   2.1.2 KDE                                                    |
|         -   2.1.3 Xfce4                                                  |
|         -   2.1.4 Openbox                                                |
|         -   2.1.5 PekWM                                                  |
|         -   2.1.6 Xmonad                                                 |
|         -   2.1.7 i3                                                     |
|                                                                          |
|     -   2.2 Using third-party programs                                   |
|         -   2.2.1 keytouch                                               |
|         -   2.2.2 actkbd                                                 |
|         -   2.2.3 xbindkeys                                              |
+--------------------------------------------------------------------------+

Map keycodes to symbols
=======================

Introduction
------------

The most traditional and proficient way to make a key output a character
when you are in X is to use xmodmap. Xmodmap is roughly the X equivalent
of loadkeys: it reads a file containing some directives. As loadkeys, it
can be used to modify many aspects of the behaviour of your keyboard
(such as modifiers, etc.), but I will not cover these aspects in this
article. The only kind of directive I am interested in here associates
an X keycode to a keysym. xmodmap is included in the xorg-server-utils
package in the Official Repositories.

Step 1: Create the xmodmap file
-------------------------------

In this file, you have to list the keycode directives, with the
following syntax:

    keycode <Xkeycode> = <keysym>

The list of X keysyms can be read in /usr/include/X11/keysymdef.h.
Anyway, most of them are intuitive. Let us say that the X keycode of my
hotkey is 239. If I want it to output a literal 'e', I will write the
following directive:

    keycode 239 = e

If I want it to output the symbol of the American currency, I will write
the following directive:

    keycode 239 = dollar

This can also be used to assign functions to multimedia keys. Special
functions can be found in /usr/include/X11/XF86keysym.h.

An example ~/.Xmodmap:

    keycode 160 = XF86AudioMute
    keycode 176 = XF86AudioRaiseVolume
    keycode 174 = XF86AudioLowerVolume

Multimedia programs such as Rhythmbox and Exaile are designed to work
with keys assigned to XF86 Symbols out-of-the-box, without the need to
configure a third-party application.

Step 2: Testing
---------------

Finally I have to source the file with xmodmap:

    $ xmodmap ~/.Xmodmap

Step 3: Making it permanent
---------------------------

Obviously, this will work only for the current X session, use xprofile
to make it permanent.

Map keycodes to actions
=======================

Using your Desktop Environment tools
------------------------------------

> Gnome

Gnome Control Center is quite complete for the extra keyboard keys
management. In fact it can directly detect scancodes which means that it
can map any key seen by the kernel.

> KDE

Keyboard shortcuts can be configured in System Settings -> Shortcuts and
Gestures.

> Xfce4

You can change the keyboard shortcuts in Keyboard Settings, which can be
run using xfce4-keyboard-settings.

> Openbox

You can set keyboard shortcuts and actions in the keyboard section of
your ~/.config/openbox/rc.xml file. For example, the following will
lower the volume with a media key:

    <keybind key="XF86AudioLowerVolume">
    <action name="Execute">
    <execute>amixer set Master 5- unmute</execute>
    </action>
    </keybind>

For more information, please visit urukrama's Openbox Guide or the
Openbox Wiki.

You can use obkey utility from AUR for easy configuration.

> PekWM

Setting keys in PekWM is accomplished by editing your ~/.pekwm/keys
file. For example, adding the following at the bottom of the Global
section will lower the volume with a media key:

    KeyPress = "XF86AudioLowerVolume" { Actions = "exec amixer set Master 5%- unmute &" }

> Xmonad

If you use Xmonad as a stand alone window manager, you can edit the
xmonad.hs to add unbound keyboard keys. You just need to find the Xf86
name of the key (such as XF86PowerDown) and look it up in
/usr/include/X11/XF86keysym.h. It will give you a keycode (like
0x1008FF2A) which you can use to add a line like the following in the
keybindings section of your xmonad.hs:

    ((0,               0x1008FF2A), spawn "sudo pm-suspend")

> i3

Open your ~/.i3/config and just bind the key (keysym or keycode) to a
command:

    bindsym XF86MonBrightnessDown  exec  xbacklight -dec 10
    bindsym Print                  exec  scrot

Using third-party programs
--------------------------

> keytouch

KeyTouch is a program which allows you to easily configure the extra
function keys of your keyboard. This means that you can define, for
every individual function key, what to do if it is pressed.

See the detailed article: keytouch.

> actkbd

From actkbd home page:

actkbd (available in AUR) is a simple daemon that binds actions to
keyboard events. It recognises key combinations and can handle press,
repeat and release events. Currently it only supports the linux-2.6
evdev interface. It uses a plain-text configuration file which contains
all the bindings.

A sample configuration and guide is available here.

> xbindkeys

xbindkeys (available in the extra repository) allows advanced mapping of
keycodes to actions independently of the Desktop Environment.

A GUI called xbindkeys_config is available in AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Extra_Keyboard_Keys_in_Xorg&oldid=224083"

Categories:

-   Keyboards
-   X Server
