Xmodmap
=======

Summary

A general overview of modifying keymaps and pointer mappings with
xmodmap.

Related

Xorg

Extra Keyboard Keys

Extra Keyboard Keys in Xorg

Extra Keyboard Keys in Console

Xmodmap is a utility for modifying keymaps and pointer button mappings
in Xorg.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Keymap table                                                       |
| -   3 Custom table                                                       |
|     -   3.1 Test changes                                                 |
|                                                                          |
| -   4 Special keys/signals                                               |
| -   5 Reverse Scrolling                                                  |
| -   6 Accents on US keyboards                                            |
| -   7 Additional resources                                               |
+--------------------------------------------------------------------------+

Introduction
------------

The Linux kernel generates a code each time a key is pressed on a
keyboard. That code is compared to a table of keycodes defining a figure
that is then displayed.

This process is complicated by Xorg, which starts its own table of
keycodes. Each keycode can belong to a keysym. A keysym is like a
function, started by typing a key. Xmodmap allows you to edit these
keycode-keysym relations.

xkeycaps provides a graphical front-end to xmodmap, you can install it
from the official repositories.

Keymap table
------------

Print the current keymap table formatted into expressions:

    $ xmodmap -pke

    keycode  57 = n N

Each keymap is followed by the keysyms it is mapped to. The above
example indicates that the keycode 57 is mapped to the lowercase n,
while the uppercase N is mapped to keycode 57 and Shift.

Each keysym column in the table corresponds to a particular key
combination:

1.  Key
2.  Shift+Key
3.  mode_switch+Key
4.  mode_switch+Shift+Key
5.  AltGr+Key
6.  AltGr+Shift+Key

Not all keysyms have to be set, but if you want to assign a latter
keysym without assigning earlier ones set them to NoSymbol.

You can check which keymap corresponds to a key on your keyboard with
xev.

Tip:There are predefined descriptive keycodes that make mapping
additional keys easier (e.g. XF86AudioMute, XF86Mail). Those keycodes
can be found in: /usr/include/X11/XF86keysym.h

Custom table
------------

You can create your own map and store it in your home directory (i.e.
~/.Xmodmap). Print the current keymap table into a configuration file:

    xmodmap -pke > ~/.Xmodmap

Make the desired changes to ~/.Xmodmap and then test the new
configuration with:

    xmodmap ~/.Xmodmap

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Some desktop     
                           environments such as     
                           GNOME should             
                           automatically detect the 
                           file and ask you if you  
                           want to use it.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

To activate your custom table when starting Xorg add the following:

    ~/.xinitrc

    if [ -f $HOME/.Xmodmap ]; then
        /usr/bin/xmodmap $HOME/.Xmodmap
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

The natural scrolling feature available in OS X Lion can be mimicked
with xmodmap. Since the synaptics driver uses the buttons 4/5/6/7 for
up/down/left/right scrolling, you simply need to swap the order of how
the buttons are declared in ~/.Xmodmap.

Open ~/.Xmodmap and append the following line to the file:

    pointer = 1 2 3 5 4 7 6 8 9 10 11 12

Note how the 4 and 5 have been reversed.

Then update xmodmap:

    xmodmap ~/.Xmodmap

To return to regular scrolling simply reverse the order of the 4 and 5
or delete the line altogether. For more information check Peter
Hutterer's post, Natural scrolling in the synaptics driver, or the
Reverse scrolling direction ala Mac OS X Lion? forum thread.

Accents on US keyboards
-----------------------

The following is an example configuration:

    AltGr + e -> é
    AltGr + r -> è
    AltGr + a -> à
    AltGr + u -> ù
    AltGr + i -> ì
    AltGr + o -> ò
    AltGr + c -> ç
    AltGr + [ -> «
    AltGr + ] -> »
    AltGr + ; -> dead diaresis (ï, ü, etc.)
    AltGr + 6 -> dead circumflex (î, ê, etc.) 

This is an xmodmap file which remaps keys to match the above example.

    clear Mod1
    clear Mod2
    !  us.map with a few redefinitions
    keycode   9 = Escape Escape
    keycode  10 = 1 exclam
    keycode  11 = 2 at at
    keycode  12 = 3 numbersign
    keycode  13 = 4 dollar dollar
    keycode  14 = 5 percent currency
    keycode  15 = 6 asciicircum dead_circumflex
    keycode  16 = 7 ampersand braceleft
    keycode  17 = 8 asterisk bracketleft
    keycode  18 = 9 parenleft bracketright
    keycode  19 = 0 parenright braceright
    keycode  20 = minus underscore backslash
    keycode  21 = equal plus
    keycode  22 = BackSpace Delete
    keycode  23 = Tab Tab
    keycode  24 = q
    keycode  25 = w
    keycode  26 = e E eacute
    keycode  27 = r R egrave
    keycode  28 = t
    keycode  29 = y
    keycode  30 = u U ugrave
    keycode  31 = i I igrave
    keycode  32 = o O ograve
    keycode  33 = p
    keycode  34 = bracketleft braceleft guillemotleft
    keycode  35 = bracketright braceright guillemotright
    keycode  36 = Return
    keycode  37 = Control_L
    keycode  38 = a A agrave
    keycode  39 = s
    keycode  40 = d
    keycode  41 = f
    keycode  42 = g
    keycode  43 = h
    keycode  44 = j
    keycode  45 = k
    keycode  46 = l
    keycode  47 = semicolon colon dead_diaeresis
    keycode  48 = apostrophe quotedbl
    keycode  49 = grave asciitilde dead_grave
    keycode  50 = Shift_L
    keycode  51 = backslash bar
    keycode  52 = z
    keycode  53 = x
    keycode  54 = c C ccedilla
    keycode  55 = v
    keycode  56 = b
    keycode  57 = n
    keycode  58 = m
    keycode  59 = comma less apostrophe
    keycode  60 = period greater quotedbl
    keycode  61 = slash question
    keycode  62 = Shift_R
    keycode  63 = KP_Multiply
    keycode  64 = Alt_L Meta_L
    keycode  65 = space space
    keycode  66 = Caps_Lock
    keycode  67 = F1 F11
    keycode  68 = F2 F12
    keycode  69 = F3 F13
    keycode  70 = F4 F14
    keycode  71 = F5 F15
    keycode  72 = F6 F16
    keycode  73 = F7 F17
    keycode  74 = F8 F18
    keycode  75 = F9 F19
    keycode  76 = F10 F20
    keycode  77 = Num_Lock
    keycode  78 = Scroll_Lock
    keycode  79 = KP_7
    keycode  80 = KP_8
    keycode  81 = KP_9
    keycode  82 = KP_Subtract
    keycode  83 = KP_4
    keycode  84 = KP_5
    keycode  85 = KP_6
    keycode  86 = KP_Add
    keycode  87 = KP_1
    keycode  88 = KP_2
    keycode  89 = KP_3
    keycode  90 = KP_0
    keycode  94 = less greater bar
    keycode  95 = F11 F11
    keycode  96 = F12 F12
    keycode 108 = KP_Enter
    keycode 109 = Control_R
    keycode 112 = KP_Divide
    keycode 113 = Mode_switch
    keycode 114 = Break
    keycode 110 = Find
    keycode  98 = Up
    keycode  99 = Prior
    keycode 100 = Left
    keycode 102 = Right
    keycode 115 = Select
    keycode 104 = Down
    keycode 105 = Next
    keycode 106 = Insert
    keycode 116 = Mode_switch
    ! right windows-menu key, redefined as Compose key
    keycode 117 = Multi_key
    add Mod1 = Alt_L
    add Mod2 = Mode_switch

Additional resources
--------------------

-   Current man page at X.Org Foundation
-   Multimediakeys with .Xmodmap HOWTO by Christian Weiske
-   Mapping unsupported keys with xmodmap by Pascal Bleser
-   Multimedia Keys article on the Gentoo Wiki
-   How to retrieve scancodes by Marvin Raaijmakers
-   List of Keysyms Recognised by Xmodmap on LinuxQuestions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xmodmap&oldid=253910"

Categories:

-   Input devices
-   X Server
