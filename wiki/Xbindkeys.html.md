Xbindkeys
=========

Xbindkeys is a program that enables us to bind commands to certain keys
or key combinations on the keyboard. Xbindkeys works with multimedia
keys and is window manager / DE independent, so if you switch much,
xbindkeys is very handy.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Xbindkeysrc
    -   2.2 GUI method
-   3 Usage
-   4 Simulating multimedia keys
-   5 Troubleshooting

Installation
------------

Install Xbindkeys with the package xbindkeys, available in the official
repositories.

For those who prefer a GUI, there is the xbindkeys_config package in the
AUR.

Configuration
-------------

Create a file named .xbindkeysrc in your home directory:

    $ touch ~/.xbindkeysrc

Alternatively, you can create a sample file by invoking

    $ xbindkeys -d > ~/.xbindkeysrc

Now you can either edit ~/.xbindkeysrc to set keybindings, or you can do
that with the GUI.

> Xbindkeysrc

To see the format of a configuration file entry, enter the following
command:

    $ xbindkeys -k

A blank window will pop up. Press the key(s) to which you wish to assign
a command and xbindkeys will output a handy snippet that can be entered
into ~/.xbindkeysrc. For example, while the blank window is open, press
Alt+o to get the following output (results may vary):

    "(Scheme function)"
        m:0x8 + c:32
        Alt + o

The first line represents a command. The second contains the state (0x8)
and keycode (32) as reported by xev. The third line contains the keysyms
associated with the given keycodes. To use this output, copy either one
of the last two lines to ~/.xbindkeysrc and replace "(Scheme function)"
with the command you wish to perform. Here is an example configuration
file that binds Fn key combos on a laptop to pamixer commands that
adjust sound volume. Note that pound (#) symbols can be used to create
comments.

    # Increase volume
    "pamixer --increase 5"
       XF86AudioRaiseVolume

    # Decrease volume
    "pamixer --decrease 5"
       m:0x0 + c:122

or

    "pamixer --decrease 5"
       XF86AudioLowerVolume

Tip:Use xbindkeys -mk to keep the key prompt open for multiple
keypresses. Press q to quit.

> GUI method

If you installed the xbindkeys_config package, just run:

    $ xbindkeys_config

Usage
-----

Once you're done configuring your keys, edit your ~/.xinitrc and place

    xbindkeys

before the line that starts your window manager or DE.

Simulating multimedia keys
--------------------------

The XF86Audio* and other multimedia keys [1] are pretty-much
well-recognized by the major DEs. For keyboards without such keys, you
can simulate their effect with other keys

    # Decrease volume on pressing Super-minus
    "amixer set Master playback 1-"
       m:0x50 + c:20
       Mod2+Mod4 + minus

However, to actually call the keys themselves you can use tools like
xdotool [2] (its in official repositories) and xmacro [3] (in the AUR).
Unfortunately since you'd already be holding down some modifier key
(Super or Shift, for example), X will see the result as
Super-XF86AudioLowerVolume which won't do anything useful. Here's a
script based on xmacro and xmodmap from the xorg-server-utils package
for doing this[4].

    #!/bin/sh
    echo 'KeyStrRelease Super_L KeyStrRelease minus' 

This works for calling XF86AudioLowerVolume once (assuming you are using
Super+minus), but repeatedly calling it without releasing the Super key
(like tapping on a volume button) does not work. If you would like it to
work that way, add the following line to the bottom of the script.

    echo 'KeyStrPress Super_L' | xmacroplay :0

With this modified script, if you press the key combination fast enough
your Super_L key will remain 'on' till the next time you hit it, which
may result in some interesting side-effects. Just tap it again to remove
that state, or use the original script if you want things to 'just work'
and do not mind not multi-tapping on volume up/down.

These instructions are valid for pretty much any one of the XF86
multimedia keys (important ones would be XF86AudioRaiseVolume,
XF86AudioLowerVolume, XF86AudioPlay, XF86AudioPrev, XF86AudioNext).

Troubleshooting
---------------

If, for any reason, a hotkey you already set in ~/.xbindkeysrc doesn't
work, open up a terminal and type the following:

    $ xbindkeys -n

By pressing the non-working key, you will be able to see any error
xbindkeys encounter (e.g: mistyped command/keycode,...).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xbindkeys&oldid=300522"

Categories:

-   Keyboards
-   X Server

-   This page was last modified on 23 February 2014, at 15:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
