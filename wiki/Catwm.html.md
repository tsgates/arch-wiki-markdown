Catwm
=====

Contents
--------

-   1 About
-   2 Installation
    -   2.1 Method 1
    -   2.2 Method 2
    -   2.3 Starting catwm when X is started
-   3 Configuration
    -   3.1 Add Custom Keybindings
    -   3.2 Set Volume Up/Down Hotkeys
    -   3.3 Set Next/Previous Song Hotkeys
-   4 Troubleshooting
    -   4.1 My volume hotkeys do not work!

About
-----

Catwm is a small, light weight window manager created by pyknite. It was
first announced in this
(https://bbs.archlinux.org/viewtopic.php?id=100215) forum post.

Installation
------------

> Method 1

Install catwm-git form the AUR.

> Method 2

If for some reason method one fails, try this one. Visit the official
github page and download each file.

Before you compile catwm, you may want to skip to the Configuration
section to configure it.

Then, while in the directory as the downloaded files, run the following
as a non-root user:

    $ make

Then, run the following as root:

    # make install
    # make clean

> Starting catwm when X is started

Add the following to your ~/.xinitrc:

    exec /usr/bin/catwm

Configuration
-------------

Catwm uses it's config.h file for configuration. By default, some
hotkeys are already set (Note: the default MOD key is the Alt key):

-   MOD + h (decrease the size of a current window)
-   MOD + l (increase the size of a current window)
-   MOD + x (close current window)
-   MOD + Tab (change to next window)
-   MOD + k (change to previous window)
-   MOD + j (change to next window)
-   MOD + Shift + k (move current window up)
-   MOD + Shift + j (move current window down)
-   MOD + Enter (change master to current window)
-   MOD + Space (switch mode/maximize)
-   MOD + c (lock - requires slock)
-   MOD + p (open dmenu - requires dmenu)
-   MOD + Shift + Return (open urxvt - requires urxvt)
-   MOD + Left (previous desktop)
-   MOD + Right (next desktop)
-   MOD + 0-9 (change to desktop #)
-   MOD + q (quit catwm)

> Add Custom Keybindings

To add custom keybindings, you must edit config.h and recompile catwm.
That's why it is important to set them up on the initial installation to
avoid having to do this again. I'll show you a scenario in which you
would need to add a keybinding to open the thunar filemanager with
MOD+t.

  
 First, you must add a line such as the following underneath the
already-defined const char*s (Note: You can name it whatever you want.
In this case, I named it thunarcmd):

    const char* thunarcmd[] = {"thunar", NULL};

I'll explain this a little more in detail. The part after the const
char* and before the [] is the title, which is thunarcmd. Inside the
curly brackets is where you enter the command to be executed. Each
command fragment that is seperated by a space is it's own value. What I
mean by that is that the command sequence ncmpcpp next would be entered
as {"ncmpcpp", "next", NULL}. The NULL value must be included at the end
of each hotkey.

  
 To actually register the hotkey with the window manager, you must look
below that at the struct named keys[]. This is where catwm stores all of
it's keybindings. An example entry for the thunarcmd[] we made above
would be:

    { MOD,     XK_t,     spawn,     {.com = thunarcmd}},

-   The first element specifies the first sequence that is pressed (MOD
    for the modkey only, MOD|ShiftMask for the modkey and then the
    shiftkey).
-   The second element specifies the actual key that is pressed to
    differenciate it from other similar hotkeys. In this case, we set it
    to t, which has "XK_" in front of it because that's how Xorg reads
    key presses. Just remember to include "XK_" in front of it and
    you'll be fine. Some examples of these include XK_a for the a key,
    XK_Space for the space bar, and XK_1 for the 1 key. Note that these
    are case-sensitive, so XK_a is not the same as XK_A. So for this
    example, the entire hotkey senquence that needs to be pressed is
    MOD+t.
-   The third element just specifies the function spawn(), which has
    been written to pass the command to the shell for execution. You do
    not really need to know what spawn is for, so simply include it for
    things like this.
-   The final element inside the brackets specifies which char that was
    previously defined to use. In our case, it was thunarcmd[]. so we
    would do {.com = thunarcmd}. The .com stands for command.

    { MOD, XK_Down, spawn, {.com = voldown}},
    { MOD, XK_Up, spawn, {.com = volup}},

That would set hotkeys that make Mod+Down lower the volume and Mod+Up
raise the volume according to whatever volup and voldown are set to.

To change what percentage the volume is incremented/decremented by, edit
voldown and volup. For example, to make it 2% increments/decrements, you
would do:

    const char* voldown[] = {"amixer","set","PCM","2\%-",NULL};
    const char* volup[] = {"amixer","set","PCM","2\%+",NULL};

> Set Next/Previous Song Hotkeys

NOTE: This requires mpd, and mpd software such as ncmpcpp or mpc,
capable of changing songs from the command line.

You must set hotkeys in config.h to point to next and prev. Here is an
example:

    { MOD|ShiftMask, XK_Right, spawn, {.com = next}},
    { MOD|ShiftMask, XK_Left, spawn, {.com = prev}},

This would set MOD+Shift+Right to go to the next song and MOD+Shift+Left
to go to the previous song.

Troubleshooting
---------------

> My volume hotkeys do not work!

Make sure you have the right device defined in volup and voldown. Two
common ones are "Master" and "PCM".

    const char* voldown[] = {"amixer","set","Master","5\%-",NULL};
    const char* volup[] = {"amixer","set","Master","5\%+",NULL};

    const char* voldown[] = {"amixer","set","PCM","5\%-",NULL};
    const char* volup[] = {"amixer","set","PCM","5\%+",NULL};

If both of those do not work, try to use one of the devices outputted by
the amixer command. Also make sure you have the alsa-utils package
installed.

If all of that still doesn't work, check to see if the device is not
muted in alsamixer.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Catwm&oldid=237974"

Category:

-   Tiling WMs

-   This page was last modified on 3 December 2012, at 14:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
