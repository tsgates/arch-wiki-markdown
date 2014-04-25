Saitek Cyborg R.A.T.3 Mouse
===========================

The Saitek Cyborg R.A.T.3 Mouse is a 7 buttons USB gaming mouse sold by
Mad Catz. This article explains how to make it work with any desktop
manager.

Contents
--------

-   1 Installation
-   2 Issues
-   3 Solution
-   4 See also

Installation
------------

No driver installation is required. The mouse should be detected at boot
or whenever it is hot-plugged.

Issues
------

After being plugged, the mouse will seems to work, but you may
experience different issues :

-   You can't move windows around when grabbing the window's title bar.
    (happens with Openbox and other Window manager)
-   You can't click on buttons.
-   You can't get the focus on windows.
-   You can't open menus, even with keyboard shortcuts.
-   Display doesn't refresh (using Xcompmgr or Cairo Compmgr)

Solution
--------

With root privileges, create and edit the file
/etc/X11/xorg.conf.d/50-vmmouse.conf (see xorg).

Add the following content :

    Section "InputDevice"
        Identifier     "Mouse0"
        Driver         "evdev"
        Option         "Name" "Saitek Cyborg R.A.T.3 Mouse"
        Option         "Vendor" "06a3"
        Option         "Product" "0ccc"
        Option         "Protocol" "auto"
        Option         "Device" "/dev/input/event4"
        Option         "Emulate3Buttons" "no"
        Option         "Buttons" "7"
        Option         "ZAxisMapping" "4 5"
        Option         "ButtonMapping" "1 2 3 4 5 6 7 0 0 0 0 0 0 0"
        Option         "Resolution" "3200"
    EndSection

After restarting your X server, the mouse should be fully functional,
including the two lateral buttons. If not, or if you need more
informations about configuring gaming mice, see All Mouse Buttons
Working.

See also
--------

-   http://ubuntuforums.org/showthread.php?t=2126385

Retrieved from
"https://wiki.archlinux.org/index.php?title=Saitek_Cyborg_R.A.T.3_Mouse&oldid=301252"

Category:

-   Mice

-   This page was last modified on 24 February 2014, at 11:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
