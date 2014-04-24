Stalonetray
===========

Stalonetray is a stand-alone freedesktop.org and KDE system tray for the
X Window System. It has full XEMBED support, minimal dependencies and
works with virtually any EWMH-compliant window manager. Window managers
that are reported to work well with stalonetray are: FVWM, Openbox,
Enlightenment, Ion3, Compiz, Xmonad and awesome.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Openbox
    -   2.2 Ion3
-   3 Troubleshooting
    -   3.1 Icons don't have the desired size
-   4 See also

Installation
------------

Install stalonetray from the official repositories. Once installed, copy
the stalonetrayrc file to your home directory. Note that you should do
this as a regular user.

    $ cp /etc/stalonetrayrc ~/.stalonetrayrc

Configuration
-------------

> Openbox

To run Stalonetray in Openbox, issue the command:

    $ stalonetray --dockapp-mode simple

To run Stalonetray on start up, add the following to
~/.config/openbox/autostart:

    stalonetray --dockapp-mode simple &

Alternatively, you can change the ~/.stalonetrayrc line:

    # dockapp-mode none

to:

    # dockapp-mode simple

Openbox now treats the tray as the dock, and you can adjust its position
by using the Openbox Configuration Tool. To run Stalonetray on start up,
add the following to ~/.config/openbox/autostart:

    stalonetray &

See also Stalonetray WM hints for OpenBox

> Ion3

To run Stalonetray in Ion3:

    $ stalonetray --kludges=force_icons_size,fix_window_pos

To include stalonetray in the statusbar, add the following to your
configuration file in ~/.ion3/:

    -- Create a statusbar
    mod_statusbar.create{
        screen=0,
        pos='bl',
        fullsize=true,
        systray=true,
        template="[ %date || %load || ... ] %systray%filler%systray_stalone",
    }

    defwinprop{class="stalonetray",instance="stalonetray",statusbar="systray_stalone"}
    defwinprop{instance="stalonetray",statusbar="systray_stalone"}
    defwinprop{class="stalonetray",statusbar="systray_stalone"}

See also Stalonetray WM hints for ion3

Troubleshooting
---------------

> Icons don't have the desired size

To force the size of the icons to be equal to icon_size, launch
stalonetray with the following arguments:

    stalonetray --icon-size=16 --kludges=force_icons_size

This will force the size of all icons to 16×16 pixels.

Alternatively, one could add the following to the configuration file:

    icon_size 16
    kludges force_icons_size

See also
--------

-   http://stalonetray.sourceforge.net/manpage.html - Stalonetray manual
    page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Stalonetray&oldid=282462"

Category:

-   Eye candy

-   This page was last modified on 12 November 2013, at 10:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
