Configuring keyboard layouts in X
=================================

Note:If you are simply wishing to change the bindings of one or two keys
(for example, swap backspace and delete or rebind another key to perform
the function of one that is broken) you can also use Xmodmap.
Furthermore this approach will most likely not work with desktop
environment such as Gnome which manage the keyboard layout by their own.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Intro                                                              |
| -   2 Setting the layouts: the keyboard section in xorg.conf             |
| -   3 What to do when it doesn't work as expected?                       |
| -   4 Futher reading: assigning actions to extra keys                    |
+--------------------------------------------------------------------------+

Intro
-----

This page should describe howto configure the keyboard layouts for X
properly, and also some common pitfalls when trying to do so.

Note that this page deals with X only, if you want to set a proper
keyboard for the console, you should edit /etc/rc.conf (KEYMAP
variable), or you can do it manually with 'loadkeys'.

Instead of configuring xorg.conf you might as well use the hotplugging
capabilities of Xorg.

Setting the layouts: the keyboard section in xorg.conf
------------------------------------------------------

Let's do it by example: mine looks like this:

    Section "InputClass"
            Identifier      "IntegratedKeyboard"
            MatchIsKeyboard "on"
            MatchDevicePath "/dev/input/event*"
            Driver          "evdev"
            Option          "XkbModel"      "thinkpad60"
            Option          "XkbLayout"     "us,sk,de"
            Option          "XkbVariant"    "altgr-intl,qwerty,"
            Option          "XkbOptions"    "grp:menu_toggle,grp_led:caps"
    EndSection

Note that nowadays you should create a separate config file, like
/etc/X11/xorg.conf.d/90-keyboard-layouts.conf, and put this text there.

The outcome is the following: I have three keyboard layouts available
(us, sk and de) with my preferred variants; I can switch cyclically
between them by pressing the 'menu' key, and when one of the last two is
selected, my caps led is on (obviously, the caps led doesn't show if I
have capslock on anymore). Also, the extra multimedia keys on my
thinkpad will produce appropriate events.

Now some explanations for the variables:

-   XkbModel: selects the keyboard model. This has an influence only for
    some extra keys your keyboard might have. The safe fallback are
    "pc104" or "pc105". But for instance laptops usually have some extra
    keys, and sometimes to get them working (without messing up with
    xmodmap, see below) you can set a proper model. The list of models
    can be found in /usr/share/X11/xkb/rules/xorg
-   XkbLayout: sets the list of available layouts. The possibilities can
    be found in /usr/share/X11/xkb/symbols/* (each layout has a file
    there)
-   XkbVariant: specify variants for each of the layouts given in
    XkbLayout. For instance, the default sk variant is 'qwertz', so I
    had to specify 'qwerty' to get the one I wanted. The possibilities
    for variants can be found in /usr/share/X11/xkb/symbols/<layout> and
    they tend to have some commentary about what do they actually do.
    Warning: if you do specify some XkbVariant, you need to have as many
    commas in it as in XkbLayout, otherwise it may not work. For
    instance, if I just wanted sk-qwerty, and us and de with their
    default variants, I need to write 'XkbVariant ",qwerty,"' (notice
    the commas). Similarly, if you have multiple XkbVariant entries for
    one XkbLayout, you will have to enter the layout multiple times
    (e.g. "us,us" and "dvorak,basic").
-   XkbOptions: some extras. Here you can specify how do you want to
    switch the layouts, what led will be used for notification, a
    special way to enter the euro-sign, etc... For the possibilities,
    look at /usr/share/X11/xkb/rules/xorg and then for their
    descriptions in the appropriate file in /usr/share/X11/xkb/symbols/*

What to do when it doesn't work as expected?
--------------------------------------------

First try to narrow down the problem by removing most of the settings,
and adding them one-by-one to see when the problem occurs. Make sure
that the syntax is correct (ie the commas in 'XkbVariant').

Read the section on xmodmap and xev below for more ways to check what's
going on.

If you're still puzzled, try politely asking on the forums, with a good
description of the problem, and also the list of things that you tried.

Futher reading: assigning actions to extra keys
-----------------------------------------------

It's all here Extra_Keyboard_Keys and here Extra_Keyboard_Keys_in_Xorg.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Configuring_keyboard_layouts_in_X&oldid=248813"

Category:

-   Internationalization
