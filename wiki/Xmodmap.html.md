xmodmap
=======

Related articles

-   Xorg
-   Extra Keyboard Keys
-   Extra Keyboard Keys in Xorg
-   Extra Keyboard Keys in Console

xmodmap is a utility for modifying keymaps and pointer button mappings
in Xorg.

xmodmap is not directly related to XKB, it uses different (pre-XKB)
ideas on how keycodes are processed within Xorg. Generally it is not
recommended to use xmodmap, except maybe for the simplest tasks. See X
KeyBoard extension if you have special demands on layout configuration.

Contents
--------

-   1 Introduction
-   2 Installation
-   3 Keymap table
-   4 Custom table
    -   4.1 Activate your custom table
    -   4.2 Test changes
-   5 Special keys/signals
-   6 Reverse Scrolling
-   7 Templates
    -   7.1 Spanish
    -   7.2 Turn CapsLock into Control, and LeftControl into Hyper
-   8 See also

Introduction
------------

On a Linux system using Xorg, there are two types of keyboard values:
keycodes and keysyms.

 Keycode 
    The keycode is the numeric representation received by the Linux
    kernel when a keyboard key or a mouse button is pressed.

 Keysym 
    The keysym is the value assigned to the keycode. For example, when
    you press the A key on the keyboard, it generates keycode 73.
    Keycode 73 is mapped to the keysym 0×61 which corresponds to the
    letter a in the ASCII table.
    The keysyms are managed by Xorg in a table of keycodes defining the
    keycode-keysym relations which is called the keymap table. The
    command xmodmap can be used to show/modify that key table.

Installation
------------

In order to use xmodmap, you need to install the xorg-xmodmap package
from the official repositories.

Optionally, install also xkeycaps which provides a graphical front-end
to xmodmap.

Keymap table
------------

Print the current keymap table formatted into expressions:

    $ xmodmap -pke

    keycode  57 = n N

Each keycode is followed by the keysym it is mapped to. The above
example indicates that the keycode 57 is mapped to the lowercase n,
while the uppercase N is mapped to keycode 57 plus Shift.

Each keysym column in the table corresponds to a particular combination
of modifier keys:

1.  Key
2.  Shift+Key
3.  mode_switch+Key
4.  mode_switch+Shift+Key
5.  AltGr+Key
6.  AltGr+Shift+Key

Not all keysyms have to be set, but if you want to assign a latter
keysym without assigning earlier ones, set them to NoSymbol.

You can check which keycode corresponds to a key on your keyboard with
the xev utility, see Extra Keyboard Keys#In Xorg for details.

Tip:There are predefined descriptive keysyms for multimedia keys, e.g.
XF86AudioMute or XF86Mail. These keysyms can be found in
/usr/include/X11/XF86keysym.h. Many multimedia programs are designed to
work with these keysyms out-of-the-box, without the need to configure
any third-party application.

Custom table
------------

You can create your own map and store it in a configuration file in your
home directory (i.e. ~/.Xmodmap):

    xmodmap -pke > ~/.Xmodmap

Make the desired changes to ~/.Xmodmap and then test the new
configuration with:

    xmodmap ~/.Xmodmap

> Activate your custom table

If you are using GDM, XDM or KDM, there is no need to source your
~/.Xmodmap manually as these display managers source that file if it is
present, whereas startx does not. Therefore, to activate your custom
table when starting Xorg, add the following:

    ~/.xinitrc

    if [ -s ~/.Xmodmap ]; then
        xmodmap ~/.Xmodmap
    fi

Alternatively, edit the global startup script /etc/X11/xinit/xinitrc.

> Test changes

You can also make temporary changes for the current session. For
example:

    xmodmap -e "keycode  46 = l L l L lstroke Lstroke lstroke"
    xmodmap -e "keysym a = e E"

Special keys/signals
--------------------

You can also also edit the keys: Shift, Ctrl, Alt and Super (there
always exists a left and a right one (Alt_R=AltGr)).

For example this can be useful if your right Control key is not working
like your left one but you would like it to.

At first you have to delete/clear the signals that should be edited. In
the beginning of your ~/.Xmodmap:

    !clear Shift
    !clear Lock
    clear Control
    !clear Mod1
    !clear Mod2
    !clear Mod3
    clear Mod4
    !clear Mod5
    keycode   8 =
    ...

Remember, ! is a comment so only Control and Mod4 (Standard: Super_L
Super_R) get cleared.

Write the new signals at the end of ~/.Xmodmap

    keycode 255 =
    !add Shift   = Shift_L Shift_R
    !add Lock    = Caps_Lock
    add Control = Super_L Super_R
    !add Mod1    = Alt_L Alt_R
    !add Mod2    = Mode_switch
    !add Mod3    =
    add Mod4    = Control_L Control_R
    !add Mod5    =

The Super keys have now been exchanged with the Ctrl keys.

If you get the following error message
X Error of failed request:  BadValue (integer parameter out of range for operation)
it means the key you are trying to add is already in another modifier,
so remove it using "remove MODIFIERNAME = KEYSYMNAME". Running xmodmap
gives you a list of modifiers and keys that are assigned to them.

Reverse Scrolling
-----------------

The natural scrolling feature available in OS X Lion (mimicking
smartphone or tablet scrolling) can be replicated with xmodmap. Since
the synaptics driver uses the buttons 4/5/6/7 for up/down/left/right
scrolling, you simply need to swap the order of how the buttons are
declared in ~/.Xmodmap.

Open ~/.Xmodmap and append the following line to the file:

    pointer = 1 2 3 5 4 7 6 8 9 10 11 12

Note how the 4 and 5 have been reversed.

Then update xmodmap:

    xmodmap ~/.Xmodmap

To return to regular scrolling simply reverse the order of the 4 and 5
or delete the line altogether. For more information check Peter
Hutterer's post, Natural scrolling in the synaptics driver, or the
Reverse scrolling direction ala Mac OS X Lion? forum thread.

Templates
---------

> Spanish

    keycode  24 = a A aacute Aacute ae AE ae
    keycode  26 = e E eacute Eacute EuroSign cent EuroSign
    keycode  30 = u U uacute Uacute downarrow uparrow downarrow
    keycode  31 = i I iacute Iacute rightarrow idotless rightarrow
    keycode  32 = o O oacute Oacute oslash Oslash oslash
    keycode  57 = n N ntilde Ntilde n N n
    keycode  58 = comma question comma questiondown dead_acute dead_doubleacute dead_acute
    keycode  61 = exclam section exclamdown section dead_belowdot dead_abovedot dead_belowdot
    !Maps the Mode key to the Alt key
    keycode 64 = Mode_switch

> Turn CapsLock into Control, and LeftControl into Hyper

Laptop users may find that using CapsLock as Control is so useful.

The Hyper key can be used by programs like Emacs, i3, openbox,... as a
modifier.

    clear      lock 
    clear   control
    clear      mod1
    clear      mod2
    clear      mod3
    clear      mod4
    clear      mod5
    keycode      66 = Control_L
    keycode      37 = Hyper_L
    add     control = Control_L Control_R
    add        mod1 = Alt_L Alt_R Meta_L
    add        mod2 = Num_Lock
    add        mod3 = Hyper_L
    add        mod4 = Super_L Super_R
    add        mod5 = Mode_switch ISO_Level3_Shift

See also
--------

-   Current man page at X.Org Foundation
-   Multimediakeys with .Xmodmap HOWTO by Christian Weiske
-   Mapping unsupported keys with xmodmap by Pascal Bleser
-   Multimedia Keys article[dead link 2013-10-05] on the Gentoo Wiki
-   List of Keysyms Recognised by Xmodmap on LinuxQuestions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xmodmap&oldid=300458"

Categories:

-   Keyboards
-   X Server

-   This page was last modified on 23 February 2014, at 15:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
