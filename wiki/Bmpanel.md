Bmpanel
=======

BMPanel (BitMap Panel) is a lightweight, NETWM compliant panel for X11
Window System, which contains a desktop switcher, taskbar, system tray
and clock. The application is inspired by simplicity of fspanel. BMPanel
has a modern look and feel, while keeping itself tiny and small.

Installation
------------

BMPanel is available as bmpanel2 in the AUR. If you prefer the legacy
version not mantained anymore install bmpanel.

Themes
------

BMPanel2 themes are available in the bmpanel2-themes package. Further
information about available themes can be found here. Here you can find
more themes. Extract them to ~/.local/share/bmpanel2/themes
(respectively ~/.bmpanel/themes for bmpanel legacy). Altering design of
the theme can be done by adapting the
~/.local/share/bmpanel2/themes/theme name/theme file (respectively
~/.bmpanel/themes/theme name/theme). More information on this can be
found here.

Starting bmpanel
----------------

To start BMPanel automatically after the login you need to write this to
your ~/.xinitrc file:

    bmpanel theme_name &

or:

    bmpanel2 --theme=theme_name &

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bmpanel&oldid=282545"

Categories:

-   Application launchers
-   Eye candy

-   This page was last modified on 13 November 2013, at 07:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
