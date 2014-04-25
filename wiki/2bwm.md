2bwm
====

Warning:2bwm is still in alpha stage and should be used cautiously. At
the moment, 2bwm is only for advanced users.

2bwm is a fast floating WM, with the particularity of having 2 borders,
written over the XCB library and derived from mcwm written by Michael
Cardell. In 2bwm everything is accessible from the keyboard but a
pointing device can be used for move, resize and raise/lower. The name
has recently changed from mcwm-beast to 2bwm.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Starting 2bwm
-   3 Using 2bwm
    -   3.1 General commands
    -   3.2 Window controls
    -   3.3 Move, resize and teleport a window
    -   3.4 Workspaces
    -   3.5 Mouse controls
-   4 Tips & Tricks
    -   4.1 Starting 2bwm over a terminal
    -   4.2 Get the current workspace number using a script
    -   4.3 Easy to remember outer border colours
    -   4.4 Top left squares
-   5 Links

Installation
------------

2bwm can be installed from the AUR with or without using an AUR helper.
Although the installation process can be automatic, if directly building
from the AUR, it is highly recommended to read and edit the "config.h"
file in the source directory.

Configuration
-------------

> Starting 2bwm

2bwm generally starts from a script, either from startx or from a login
manager such as XDM.

If it starts from the console, a .xinitrc file is needed. Here's a
complete example:

     #!/bin/sh
     
     # Set a nice background.
     xsetroot -solid grey20

     # Load resources.
     xrdb -load ~/.Xresources

     # Start window manager in the background. If it dies, X still lives.
     2bwm &

     # Start a terminal in the foreground. If this dies, X dies.
     exec urxvt

2bwm used to have startup options. They have been removed because
editing the config file was more convenient.

Using 2bwm
----------

After the launch of 2bwm, a mouse cursor, a background, and a terminal
will be the only thing on the screen (as specified in the .xinitrc). To
open a terminal, using the default configuration, hit Super+Enter (Super
Key aka Windows key/Mod4). Use the terminal as desired, for example to
start a program with program_name &, however it is easier and more
convenient to use a menu to launch programs, for instance dmenu or 9menu
(available in the aur).

> General commands

-   Super+Ctrl+q – exit 2bwm
-   Super+Ctrl+r – restart 2bwm
-   Super+w – start the menu
-   Super+Enter – start a terminal
-   Super+Arrows (+shift) – move the cursor (with shift fast).

> Window controls

Using the Super Key combined with one of the key below on a specific
focused window:

-   q – close window.
-   Tab or Shift+Tab – go to the next window in the current workspace
    window ring.
-   f – fix a window, making it visible on all workspaces (toggles).
-   a – make a window unkillable by Super+q (toggles).
-   r – raise or lower (toggles).
-   i – iconify (or hide) a window from the display.

> Move, resize and teleport a window

Using the Super Key combined with one of the key below on a specific
focused window:

-   x – maximize (toggles).
-   m – maximize vertically (toggles).
-   Shift+m – maximize horizontally (toggles).
-   Shift+H (+Ctrl) – resize left (with Ctrl slow).
-   Shift+J (+Ctrl) – resize down (with Ctrl slow).
-   Shift+K (+Ctrl) – resize up (with Ctrl slow).
-   Shift+L (+Ctrl) – resize right (with Ctrl slow).
-   Home – grow keeping aspect.
-   End – shrink keeping aspect.
-   h (+Ctrl) – move left (with Ctrl slow)
-   j (+Ctrl) – move down (with Ctrl slow)
-   k (+Ctrl) – move up (with Ctrl slow)
-   l (+Ctrl) – move right (with Ctrl slow)
-   y – move to the upper left corner of monitor.
-   u – move to the upper right corner of monitor.
-   b – move to the lower left corner of monitor.
-   n – move to the lower right corner of monitor.
-   g – move to the center of monitor.
-   Shift+y/Shift+u/Shift+b/Shift+n – move to the left/right/bottom/top
    while maxvert/maxhor and half max horizontal/vertical.

> Workspaces

-   0-9 – go to workspace n, 0-9.
-   Shift+0-9 – send to workspace n.
-   c or v – go to next/previous workspace.
-   , or . – move window to previous/next monitor.

> Mouse controls

By holding the Super Key, the mouse buttons act as follows:

-   Button 1 on a window – move window
-   Button 3 on a window – resize window
-   Button 3 + Ctrl on the desktop – start the menu specified in
    config.h.

Note that all functions activated from the keyboard work on the
currently focused window regardless of the position of the mouse cursor.
Of course, changing workspaces has nothing to do with the focused
window.

You may change the keyboard mappings from config.h.

Tips & Tricks
-------------

> Starting 2bwm over a terminal

It is wise, if starting 2bwm like in the later .xinitrc, where we
background the wm and exec a terminal emulator (such as rxvt-unicode),
to immediately make the terminal that maintain the X session unkillable
(Super+a by default). It will diminish the chance of killing this
terminal and the X session at the same time. Putting a window in
unkillable mode will also change the outer border colour and make it
noticeable from other normal window. Beware that with some
configurations, in urxvt, the outer border will not appear. A user
reported the issue to be related to the following line in his
.Xresources (or .Xdefaults) file:

    URxvt.depth: 32

Setting the depth to any value smaller than 32 fixes the issue. Note
that you can also omit the line.

> Get the current workspace number using a script

The following command yields the current workspace:

    xprop -root _NET_CURRENT_DESKTOP | sed -e 's/_NET_CURRENT_DESKTOP(CARDINAL) = //'

> Easy to remember outer border colours

A simple trick to remember the meaning of the outer border colours would
be by setting, for example, "fixed" to blue, "unkillable" to red, and
"fixed + unkillable" to purple. The mix of blue and red create purple!

> Top left squares

Setting borders[0] to a negative number will make the outer border turn
into a square located in the top-left corner of the full-border. The
colours set for the outer borders now stick to the square.

Links
-----

-   2bwm - the GitHub repository for 2bwm

Retrieved from
"https://wiki.archlinux.org/index.php?title=2bwm&oldid=306087"

Category:

-   Stacking WMs

-   This page was last modified on 20 March 2014, at 17:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
