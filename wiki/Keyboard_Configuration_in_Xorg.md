Keyboard Configuration in Xorg
==============================

Related articles

-   Keyboard Configuration in Console
-   Extra Keyboard Keys
-   Xorg
-   X KeyBoard extension

Note:This article covers only basic configuration without modifying
layouts, mapping extra keys etc. See Extra Keyboard Keys for these
advanced topics.

Xorg uses the X KeyBoard extension (XKB) to manage keyboard layouts.
Alternatively, xmodmap can be used to access the internal keymap table
directly. Generally it is not recommended to use xmodmap, except perhaps
for the simplest tasks.

This article describes low-level configuration using XKB which is
effective in most cases, but some desktop environments like GNOME
override it with its own settings. You should read the information
specific to the desktop environment:

-   GNOME#Modify Keyboard with XkbOptions
-   KDE#Set keyboard

Contents
--------

-   1 Viewing keyboard settings
    -   1.1 Third party utilities
-   2 Setting keyboard layout
    -   2.1 Using setxkbmap
    -   2.2 Using X configuration files
    -   2.3 Using localectl
-   3 Frequently used XKB options
    -   3.1 Switching between keyboard layouts
    -   3.2 Terminating Xorg with Ctrl+Alt+Backspace
    -   3.3 Swapping Caps Lock with Left Control
    -   3.4 Enabling mouse keys
    -   3.5 Configuring compose key
        -   3.5.1 Key combinations
    -   3.6 Currency sign on other key
-   4 Other settings
    -   4.1 Adjusting typematic delay and rate

Viewing keyboard settings
-------------------------

You can use the following command to see the actual XKB settings:

    $ setxkbmap -print -verbose 10

    Setting verbose level to 10
    locale is C
    Applied rules from evdev:
    model:      evdev
    layout:     us
    options:    terminate:ctrl_alt_bksp
    Trying to build keymap using the following components:
    keycodes:   evdev+aliases(qwerty)
    types:      complete
    compat:     complete
    symbols:    pc+us+inet(evdev)+terminate(ctrl_alt_bksp)
    geometry:   pc(pc104)
    xkb_keymap {
            xkb_keycodes  { include "evdev+aliases(qwerty)" };
            xkb_types     { include "complete"      };
            xkb_compat    { include "complete"      };
            xkb_symbols   { include "pc+us+inet(evdev)+terminate(ctrl_alt_bksp)"    };
            xkb_geometry  { include "pc(pc104)"     };
    };

> Third party utilities

There are some "unofficial" utilities which allow to print specific
information about the currently used keyboard layout.

-   xkb-switch-git:

    $ xkb-switch

    us

-   xkblayout-state:

    $ xkblayout-state print "%s"

    de

Setting keyboard layout
-----------------------

Keyboard layout in Xorg can be set in multiple ways. Here is an
explanation of used options:

-   XkbModel selects the keyboard model. This has an influence only for
    some extra keys your keyboard might have. The safe fallback are
    pc104 or pc105. But for instance laptops usually have some extra
    keys, and sometimes you can make them work by simply setting a
    proper model.
-   XkbLayout selects the keyboard layout. Multiple layouts may be
    specified in a comma-separated list, e.g. if you want to quickly
    switch between layouts.
-   XkbVariant selects a specific layout variant. For instance, the
    default sk variant is qwertz, but you can manually specify qwerty
    etc.

Warning:You must specify as many variants as the number of specified
layouts. If you want the default variant, specify an empty string as the
variant (the comma must stay). For example, to have the default us
layout as primary and the dvorak variant of us layout as secondary,
specify us,us as XkbLayout and ,dvorak as XkbVariant.

-   XkbOptions contains some extra options. Used for specifying layout
    switching, notification LED, compose mode etc.

The layout name is usually a 2-letter country code. To see a full list
of keyboard models, layouts, variants and options, along with a short
description, open /usr/share/X11/xkb/rules/base.lst. Alternatively, you
may use one of the following commands to see a list without a
description:

-   localectl list-x11-keymap-models
-   localectl list-x11-keymap-layouts
-   localectl list-x11-keymap-variants [layout]
-   localectl list-x11-keymap-options

Examples in the following subsections will have the same effect, they
will set pc104 model, cz as primary layout, us as secondary layout,
dvorak variant for us layout and the Alt+Shift combination for switching
between layouts.

> Using setxkbmap

The tool setxkbmap sets the keyboard layout for an active X server and
the setting is persistent only until the session ends, but you can use
xinitrc to make it persistent across reboots. It is useful to override
system-wide configuration specified by X configuration files.

The usage is as follows:

    $ setxkbmap [-model xkb_model] [-layout xkb_layout] [-variant xkb_variant] [-option xkb_options]

It is not necessary to specify all options, e.g. you can change just a
layout:

    $ setxkbmap -layout xkb_layout

See man 1 setxkbmap for a full list of command line arguments.

For example:

    $ setxkbmap -model pc104 -layout cz,us -variant ,dvorak -option grp:alt_shift_toggle

> Using X configuration files

The syntax of X configuration files is explained in Xorg#Configuration.
This method creates system-wide configuration which is persistent across
reboots.

Here is an example:

    /etc/X11/xorg.conf.d/10-keyboard.conf

    Section "InputClass"
            Identifier "system-keyboard"
            MatchIsKeyboard "on"
            Option "XkbLayout" "cz,us"
            Option "XkbModel" "pc104"
            Option "XkbVariant" ",dvorak"
            Option "XkbOptions" "grp:alt_shift_toggle"
    EndSection

> Using localectl

For convenience, the tool localectl may be used instead of manual
editing of X configuration file. It will save the configuration in
/etc/X11/xorg.conf.d/00-keyboard.conf, this file should not be manually
edited, because localectl will overwrite the changes on next start.

The usage is as follows:

    $ localectl set-x11-keymap layout [model] [variant] [options]

The following command will create a file
/etc/X11/xorg.conf.d/00-keyboard.conf with pretty much the same content
as the example above:

    $ localectl set-x11-keymap cz,us pc104 ,dvorak grp:alt_shift_toggle

Frequently used XKB options
---------------------------

> Switching between keyboard layouts

To be able to easily switch keyboard layouts, first specify multiple
layouts between which you want to switch (the first one is the default).
Then specify a key (or key combination), which will be used for
switching. For example, to switch between a US and a Swedish layout
using the CapsLock key, use us,se as an argument of XkbLayout and
grp:caps_toggle as an argument of XkbOptions.

You can use other key combinations than CapsLock, they are listed in
/usr/share/X11/xkb/rules/base.lst, start with grp: and end with _toggle.
To get the full list of available options, run the following command:

    $ grep "grp:.*_toggle" /usr/share/X11/xkb/rules/base.lst

> Terminating Xorg with Ctrl+Alt+Backspace

By default, the key combination Ctrl+Alt+Backspace is disabled. You can
enable it by passing terminate:ctrl_alt_bksp to XkbOptions.

> Swapping Caps Lock with Left Control

To swap Caps Lock with Left Control key, add ctrl:swapcaps to
XkbOptions. Run the following command to see similar options along with
their descriptions:

    $ grep -E "(ctrl|caps):" /usr/share/X11/xkb/rules/base.lst

> Enabling mouse keys

Mouse keys is now disabled by default and has to be manually enabled by
passing keypad:pointerkeys to XkbOptions. This will make the
Shift+NumLock shortcut toggle mouse keys.

> Configuring compose key

The compose key, when pressed in sequence with other keys, produces a
unicode character. For example, in most configurations pressing
compose_key ' e produces é. This is especially useful if you need to
type in a different language then the one for which the keyboard layout
was designed (such as typing in French, Italian and German on an
American keyboard).

For example, to make the right Alt key a compose key, pass compose:ralt
to XkbOptions.

You can use other keys as compose keys, they are listed in
/usr/share/X11/xkb/rules/base.lst and start with compose:. To get the
full list of available options, run the following command:

    $ grep "compose:" /usr/share/X11/xkb/rules/base.lst

Key combinations

The default combinations for the compose keys depend on the locale and
are stored in /usr/share/X11/locale/used_locale/Compose, where
used_locale is for example en_US.UTF-8.

You can define your own compose key combinations by copying the default
file to ~/.XCompose and editing it. The compose key works with any of
the thousands of valid Unicode characters, including those outside the
Basic Multilingual Plane.

However, GTK does not use XIM by default and therefore does not follow
~/.XCompose keys. This can be fixed by forcing GTK to use XIM by adding
export GTK_IM_MODULE=xim and/or export XMODIFIERS="@im=none" to
~/.xprofile.

Tip:XIM is very old, you might have better luck with other input
methods: SCIM, uim, IBus etc. See Internationalization#Input methods in
Xorg for details.

> Currency sign on other key

Most European keyboards have a Euro sign (€) printed on on the 5 key. To
access it with, for example, ALT+5, use the lv3:lalt_switch and
eurosign:5 options.

The Rupee sign (₹) can be used the same way with rupeesign:4.

Other settings
--------------

> Adjusting typematic delay and rate

The typematic delay indicates the amount of time (typically in
miliseconds) a key needs to be pressed in order for the repeating
process to begin. After the repeating process has been triggered, the
character will be repeated with a certain frequency (usually given in
Hz) specified by the typematic rate. These values can be changed using
the xset command:

    $ xset r rate delay [rate]

For example to set a typematic delay to 200ms and a typematic rate to
30Hz, use the following command (use xinitrc to make it permanent):

    $ xset r rate 200 30

Issuing the command without specifying the delay and rate will reset the
typematic values to their respective defaults; a delay of 660ms and a
rate of 25Hz:

    $ xset r rate

Retrieved from
"https://wiki.archlinux.org/index.php?title=Keyboard_Configuration_in_Xorg&oldid=296899"

Categories:

-   Keyboards
-   X Server

-   This page was last modified on 11 February 2014, at 21:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
