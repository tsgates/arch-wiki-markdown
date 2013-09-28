Accents on US keyboards
=======================

Typing in foreign languages such as French, Italian and German can be
difficult on an American keyboard. To remedy this, Xorg provides options
such as the compose key and the xmodmap utility.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 XCompose                                                           |
|     -   1.1 Key combinations                                             |
|     -   1.2 Environment variables                                        |
|                                                                          |
| -   2 xmodmap                                                            |
+--------------------------------------------------------------------------+

XCompose
--------

The compose key, when pressed in sequence with other keys, produces a
Unicode character. E.g., in most configurations pressing <Compose> ' e
produces é.

Compose keys appeared on some computer keyboards decades ago, especially
those produced by Sun Microsystems. However, it can be enabled on any
keyboard with setxkbmap. For example, compose can be set to right alt by
running:

    setxkbmap -option compose:ralt

If you want another key to be your Compose key, see
/usr/share/X11/xkb/rules/base.lst at the compose: lines.

You may also edit your /etc/X11/xorg.conf.d/10-evdev.conf and change
InputClass / 'evdev keyboard catchall' to look like this.

    Section "InputClass"
            Identifier "evdev keyboard catchall"
            MatchIsKeyboard "on"
            MatchDevicePath "/dev/input/event*"
            Driver "evdev"
            Option "XkbOptions" "terminate:ctrl_alt_bksp,compose:ralt"
    EndSection

> Key combinations

By default, the compose key uses combinations defined in a file. The
file used depends on the user's locale: an American using
LC_CTYPE=en_US.UTF-8, for instance, would find the defaults in
/usr/share/X11/locale/en_US.UTF-8/Compose.

Some of the default combinations are listed below:

    Compose ` a : à
    Compose ' e : é
    Compose ^ i : î
    Compose ~ n : ñ
    Compose / o : ø
    Compose " u : ü
    Compose o c : ©
    Compose + - : ±
    Compose : - : ÷

However, you can define your own compose key combinations by copying the
default file to ~/.XCompose and editing it. The compose key works with
any of the thousands of valid Unicode characters, including those
outside the Basic Multilingual Plane.

> Environment variables

Some unfriendly applications (including many GTK apps) will override the
compose key and default to their own built-in combinations. You can
typically fix this by setting environment variables; for instance, you
can fix the behavior for GTK with:

    export GTK_IM_MODULE=xim

xmodmap
-------

The xmodmap utility that is supplied with Xorg allows user to completely
remap the keyboard. See xmodmap#Accents on US keyboards for more
information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Accents_on_US_keyboards&oldid=253902"

Categories:

-   Keyboards
-   Internationalization
