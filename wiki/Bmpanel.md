Bmpanel
=======

BMPanel (BitMap Panel) is a lightweight, NETWM compliant panel for X11
Window System, which contains a desktop switcher, taskbar, system tray
and clock. The application is inspired by simplicity of fspanel. BMPanel
has a modern look and feel, while keeping itself tiny and small.

Installation
------------

bmpanel can be found in the AUR and installed using an AUR helper or
makepkg. However, BMPanel is not maintained anymore, it is recommended
to try bmpanel2-git.

Themes
------

Themes must be installed in the ~/.bmpanel/themes (respectively
~/.local/share/bmpanel2/themes for bmpanel2) directory. If it does not
exist the directory must be created.

To get themes, download them from here and extract them to
~/.bmpanel/themes or install the bmpanel-themes package. Altering design
of the theme can be done by adapting the
~/.bmpanel/themes/<THEME_NAME>/theme file. More information on this can
be found here.

BMPanel2 themes are available in the bmpanel2-themes package. Further
information about available themes can be found here.

Starting bmpanel
----------------

To start bmpanel automatically after the login you need to write this to
your ~/.xinitrc file:

    # Starting bmpanel
    /usr/bin/bmpanel theme_name &

or:

    /usr/bin/bmpanel2 --theme=theme_name &

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bmpanel&oldid=239827"

Category:

-   Desktop environments
