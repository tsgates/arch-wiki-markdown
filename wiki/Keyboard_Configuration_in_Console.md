Keyboard Configuration in Console
=================================

Related articles

-   Keyboard Configuration in Xorg
-   Extra Keyboard Keys

Note:This article covers only basic configuration without modifying
layouts, mapping extra keys etc. See Extra Keyboard Keys for these
advanced topics.

Keyboard mappings (keymaps) for virtual console, console fonts and
console maps are provided by the kbd package (it should already be
installed), which also provides many low-level tools for managing
virtual console.

Contents
--------

-   1 Viewing keyboard settings
-   2 Setting keyboard layout
    -   2.1 Persistent configuration
    -   2.2 Temporary configuration
-   3 Other settings
    -   3.1 Changing console font
    -   3.2 Adjusting typematic delay and rate

Viewing keyboard settings
-------------------------

You can use the following command to view keyboard configuration:

    $ localectl status

       System Locale: LANG=en_GB.utf8
                      LC_COLLATE=C
           VC Keymap: cz-qwertz
          X11 Layout: cz

Setting keyboard layout
-----------------------

Unlike XKB keyboard layout, which is composed of multiple components,
the keyboard layout for virtual console has only one component. Usually
one keymap file corresponds to one keyboard layout (the include
statement can be used to share common parts and a keymap file can
contain multiple layouts with some key combination used for switching).
The keymap files are stored in /usr/share/kbd/keymaps/ directory tree.
You can use the following command to list all available keymaps:

    $ localectl list-keymaps

The naming conventions of console keymaps are not very strict, but
usually the name consists of a 2-letter country code and a variant,
separated by slash (-) or underscore (_).

> Persistent configuration

High-level configuration can be done in /etc/vconsole.conf, which is
read by systemd on start-up. The KEYMAP variable is used for specifying
keymap. If the variable is empty or not set, the us keymap is used as
default value. See man 5 vconsole.conf for all options. For example:

    /etc/vconsole.conf

    KEYMAP=cz-qwertz
    ...

For convenience, localectl may be used to set console keymap. It will
change the KEYMAP variable in /etc/vconsole.conf and set the keymap for
current session. For example:

    $ localectl set-keymap --no-convert keymap

See man 1 localectl for details.

> Temporary configuration

Of course it is possible to set a keymap just for current session. This
is useful for testing different keymaps, solving problems etc.

The loadkeys tool is used for this purpose, it is used internally by
systemd when loading the keymap configured in /etc/vconsole.conf. It can
be used very simply for this purpose:

    # loadkeys keymap

See man 1 loadkeys details.

Other settings
--------------

> Changing console font

The kbd package provides tools to change virtual console font and font
mapping. The fonts are saved in /usr/share/kbd/consolefonts/ directory.

The configuration is done in vconsole.conf using the FONT and FONT_MAP
variables:

    /etc/vconsole.conf

    ...
    FONT=Lat2-Terminus16
    FONT_MAP=8859-2

If the FONT variable is empty or not set, the kernel built-in font is
used as default. See man 5 vconsole.conf for details.

> Adjusting typematic delay and rate

The typematic delay indicates the amount of time (typically in
miliseconds) a key needs to be pressed in order for the repeating
process to begin. After the repeating process has been triggered, the
character will be repeated with a certain frequency (usually given in
Hz) specified by the typematic rate. These values can be changed using
the kbdrate command:

    # kbdrate [-d delay] [-r rate]

For example to set a typematic delay to 200ms and a typematic rate to
30Hz, use the following command:

    # kbdrate -d 200 -r 30

Issuing the command without specifying the delay and rate will reset the
typematic values to their respective defaults; a delay of 250ms and a
rate of 11Hz:

    # kbdrate

Retrieved from
"https://wiki.archlinux.org/index.php?title=Keyboard_Configuration_in_Console&oldid=287571"

Category:

-   Keyboards

-   This page was last modified on 11 December 2013, at 00:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
