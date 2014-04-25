GNOME Flashback
===============

Related articles

-   GNOME
-   Desktop environment
-   Window manager

GNOME Flashback (previously called GNOME fallback mode) is a shell for
GNOME 3. The desktop layout and the underlying technology is similar to
GNOME 2. It doesn't use 3D acceleration at all, so it's generally faster
and less CPU intensive than GNOME Shell with llvmpipe.

Warning:GNOME Flashback is not compatible with GNOME 3.10. See: [1]

Contents
--------

-   1 Installation
-   2 Starting
    -   2.1 Graphical log-in
    -   2.2 Manually
-   3 Configuration
    -   3.1 Customizing GNOME Panel
    -   3.2 Alternative window manager
-   4 Using GNOME Panel with a standalone window manager
-   5 Troubleshooting
    -   5.1 Mouse cursor is not visible
-   6 Known issues
-   7 See also

Installation
------------

GNOME Flashback can be installed with the package gnome-panel, available
in AUR. In order to login, you have to install the following packages as
well:

-   gnome-screensaver
-   gnome-session
-   gnome-settings-daemon-compat
-   gnome-themes-standard
-   metacity
-   notification-daemon
-   polkit-gnome

You can also install the following packages which provide some
additional applets for the GNOME Panel:

-   gnome-applets
-   byzanz
-   indicator-applet
-   netspeed-applet
-   sensors-applet
-   window-picker-applet

To get a complete desktop environment, it's recommended to install the
gnome group which contains applications required for the standard GNOME
experience.

Starting
--------

> Graphical log-in

Simply choose GNOME Flashback session from your favourite display
manager.

> Manually

If you prefer to start GNOME Flashback manually from the console, add
the following line to your ~/.xinitrc file:

    ~/.xinitrc

     exec gnome-session --session=gnome-flashback

After the exec command is placed, GNOME Flashback can be launched by
typing startx. See xinitrc for details.

Configuration
-------------

GNOME Flashback shares most of its settings with GNOME. See Customizing
GNOME appearance for more details.

> Customizing GNOME Panel

-   To configure the panel, hold down the Alt key, and right-click on it
    in an empty area.
-   To move an applet on the panel, hold down the Alt key, and grab it
    with middle-button.

Note:If you are using GNOME Panel with a standalone window manager, the
Alt+right-click combination will not work. You must use
Super+Alt+right-click instead.

> Alternative window manager

You can use an alternative window manager with GNOME by creating two
files:

Note:Xmonad is used as an example, but this works for other window
managers.

    /usr/share/gnome-session/sessions/gnome-xmonad.session

    [GNOME Session]
    Name=GNOME xmonad
    RequiredComponents=gnome-panel;gnome-settings-daemon;gnome-screensaver;xmonad;notification-daemon;polkit-gnome-authentication-agent-1;gnome-fallback-background-helper;gnome-fallback-media-keys-helper;gnome-fallback-mount-helper;

    /usr/share/xsessions/gnome-xmonad.desktop

    [Desktop Entry]
    Name=GNOME xmonad
    Comment=This session logs you into GNOME with the traditional panel
    Exec=gnome-session --session=gnome-xmonad
    TryExec=gnome-session
    Icon=
    Type=Application

The next time you log in, you should have the ability to choose GNOME
xmonad as your session.

If there isn't a .desktop file for the window manager, you'll need to
create one. Example for wmii:

    /usr/share/applications/wmii.desktop

    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=wmii
    TryExec=wmii
    Exec=wmii

For more information, see this article on running awesome as the window
manager in GNOME.

Using GNOME Panel with a standalone window manager
--------------------------------------------------

The GNOME Flashback experience is primarily provided by GNOME Panel. The
other components are only required for the Flashback session itself. If
you would like to use GNOME Panel without the Flashback session you can
just install the gnome-panel package and autostart the panel with a
standalone window manager such as Openbox.

For example: if you want to use GNOME Panel with Openbox add
gnome-panel & to the ~/.config/openbox/autostart file.

See your window manager's wiki page as well as the Autostarting page for
further instruction.

Tip:You may find that if you are starting GNOME Panel with a standalone
window manager your 'Applications' menu is empty. To correct this, run
the following command as root:
cp /etc/xdg/menus/gnome-applications.menu /etc/xdg/menus/applications.menu

Troubleshooting
---------------

> Mouse cursor is not visible

When used with GNOME 3.10 the mouse cursor is not visible. As a
workaround, in the dconf-editor expand: org -> gnome -> settings-daemon
-> plugins and click on 'cursor.' Uncheck the box labelled active.

Known issues
------------

-   The Logout and Shutdown dialogues do nothing.
-   The clock applet crashes when opening its settings.
-   The desktop background image is sometimes blanked out.
-   The panel won't resize properly when the screen resolution changed.

See also
--------

-   GNOME Flashback Website

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNOME_Flashback&oldid=305907"

Category:

-   GNOME

-   This page was last modified on 20 March 2014, at 17:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
