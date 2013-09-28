Stalonetray
===========

Stalonetray is a stand-alone freedesktop.org and KDE system tray for the
X Window System. It has full XEMBED support, minimal dependencies and
works with virtually any EWMH-compliant window manager. Window managers
that are reported to work well with stalonetray are: FVWM, Openbox,
Enlightenment, Ion3, Compiz and Xmonad.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Openbox                                                      |
|     -   2.2 Ion3                                                         |
|                                                                          |
| -   3 Other resources                                                    |
+--------------------------------------------------------------------------+

Installation
------------

Stalonetray is available from the community repository:

    # pacman -S stalonetray

Once installed, copy the stalonetrayrc file to your home directory. Note
that you should do this as a regular user.

    $ cp /etc/stalonetrayrc ~/.stalonetrayrc

Configuration
-------------

> Openbox

To run stalonetray in Openbox, you need to run:

    # stalonetray --dockapp-mode simple

Alternatively, you can change the line:

    # dockapp-mode none 

to

    # dockapp-mode simple 

in your .stalonetrayrc file. Openbox now treats the tray as the dock,
and you can adjust its position by using the Openbox Configuration Tool.

To run Stalonetray on start up, add the following to
~/.config/openbox/autostart:

    stalonetray &

If the dockapp-mode is not specified in ~/.stalonetrayrc, add the
following instead:

    stalonetray --dockapp-mode simple &

See also Stalonetray WM hints for OpenBox

> Ion3

To run stalonetray in Ion3:

     stalonetray --kludges=force_icons_size,fix_window_pos

To include stalonetray in the statusbar, add the following to your
configuration file in ~/.ion3/ :

    -- Create a statusbar
    mod_statusbar.create{
        screen=0,
        pos='bl',
        fullsize=true,
        systray=true,
        template="[ %date || %load || ... ] %systray%filler%systray_stalone",
    }

    defwinprop{class="stalonetray",instance="stalonetray",statusbar="systray_stalone"}
    defwinprop{instance="stalonetray",statusbar="systray_stalone"}
    defwinprop{class="stalonetray",statusbar="systray_stalone"}

See also Stalonetray WM hints for ion3

Other resources
---------------

-   stalonetray man page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Stalonetray&oldid=224924"

Category:

-   X Server
