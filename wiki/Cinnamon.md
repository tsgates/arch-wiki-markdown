Cinnamon
========

Summary

This article covers basic installation procedures and configuration
methods in Cinnamon.

Related

GNOME: GNOME is the framework that Cinnamon is based on.

MATE: Another fork of GNOME that is geared towards a GNOME 2 experience.

Cinnamon is a Linux desktop which provides advanced innovative features
and a traditional user experience. The desktop layout is similar to
GNOME 2; however, the underlying technology was forked from GNOME Shell.
The emphasis is put on making users feel at home and providing them with
an easy to use and comfortable desktop experience.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Starting Cinnamon                                            |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Cinnamon Settings                                            |
|     -   2.2 Installing applets/extensions                                |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Creating custom applets/themes                               |
|     -   3.2 Default desktop background wallpaper path                    |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 QGtkStyle unable to detect the current theme                 |
|     -   4.2 Pressing power buttons suspend the system                    |
|     -   4.3 Icons do not show on the desktop                             |
|     -   4.4 Volume level is not saved                                    |
|     -   4.5 Applets not working                                          |
+--------------------------------------------------------------------------+

Installation
------------

Cinnamon can be installed with the package cinnamon, available in the
official repositories.

To get a complete desktop interface, install at least the following
additional packages:

-   cinnamon-control-center: provides access to various hardware and
    system settings within cinnamon-settings.
-   cinnamon-screensaver: provides a lock screen functionality.
-   nemo: Cinnamon's official file manager.

> Starting Cinnamon

Graphical log-in

Simply choose Cinnamon or Cinnamon 2D session from your favourite
display manager. Cinnamon is the 3D accelerated version, which should be
normally used. If you experience problems with your video driver (e.g.
artifacts or crashing), try the Cinnamon 2D session, which disables 3D
acceleration.

Starting Cinnamon manually

If you prefer to start Cinnamon manually from the console, add the
following line to your ~/.xinitrc file:

    ~/.xinitrc

     exec gnome-session-cinnamon

After the exec command is placed, Cinnamon can be launched by typing
startx. See xinitrc for details.

Configuration
-------------

Cinnamon is quite easy to configure - a lot of the configuration that
most people will want can be done graphically. Its usability can be
customized with applets and extensions, and also it supports theming.

> Cinnamon Settings

Simply run the following command:

    cinnamon-settings

Each settings panel can be accessed directly with the following
commands:

    cinnamon-settings panel
    cinnamon-settings calendar
    cinnamon-settings themes
    cinnamon-settings applets
    cinnamon-settings windows
    cinnamon-settings fonts
    cinnamon-settings hotcorner

so on.

> Installing applets/extensions

Note:Previously, cinnamon-extensions-git and cinnamon-themes-git were
used to install some themes and extensions, but they are now deprecated
(see here). Instead, visit http://cinnamon-spices.linuxmint.com/.

The difference between an applet and an extension is that an applet is
basically an addition to a panel, whereas an extension can completely
change the Cinnamon experience and can do much more than an applet.

There are quite a few packages in the AUR (AUR package search for
cinnamon). The process described here is a generic installation process.

Installing applets in Cinnamon is relatively easy. First visit Cinnamon
Applets to see all of the current applets. Download the zip file for the
desired applet, and extract to ~/.local/share/cinnamon/applets/ or
/usr/share/cinnamon/applets. Then run

    cinnamon-settings applets

to bring up the graphical applets manager. If the applet does not show
up, press Alt+F2 and type r and press enter. This will restart
gnome-shell and likely, the new applet.

The process is analogous for extensions, with the only difference being
that directories titled "applets" can be changed to "extensions".

Tips and tricks
---------------

> Creating custom applets/themes

The official tutorial on creating an applet can be found here, and on
creating a custom theme can be found here.

> Default desktop background wallpaper path

When you add a wallpaper from a custom path in Cinnamon Settings,
Cinnamon copies it to ~/.cinnamon/background. Thus, with every change of
your wallpaper you would have to add your updated wallpaper again from
the settings menu or copy / symlink it manually to
~/.cinnamon/background.

Troubleshooting
---------------

> QGtkStyle unable to detect the current theme

Installing libgnome-data solves the problem partially, and QGtkStyle
will detect the current GTK+ theme. However, to set the same icon and
cursor theme, users must specify them explicitly.

The icon theme for Qt apps can be configured by the following command:

    $ gconftool-2 --set --type string /desktop/gnome/interface/icon_theme Faenza-Dark

This sets the icon theme to Faenza-Dark located in
/usr/share/icons/Faenza-Dark.

The cursor theme for Qt apps can be selected by creating a symbolic
link:

    $ mkdir ~/==.icons
    $ ln -s /usr/share/icons/Adwaita ~/.icons/default

This sets the cursor theme to Adwaita located in
/usr/share/icons/Adwaita.

> Pressing power buttons suspend the system

This is the default behaviour. To show the shutdown menu for example,
change the setting for the respective button:

    $ gsettings set org.gnome.settings-daemon.plugins.power button-power 'interactive'

> Icons do not show on the desktop

The desktop icons rendering feature is enabled in nemo, and disabled in
nautilus by default. To enable this feature, change the setting for
nemo:

    $ gsettings set org.nemo.desktop show-desktop-icons true

And for nautilus:

    $ gsettings set org.gnome.desktop.background show-desktop-icons true

Make sure to not enable both settings, otherwise the desktop icons will
be not rendered. The feature can be disabled by calling the commands
above, but replace 'true' with 'false'.

> Volume level is not saved

The volume level is not be saved after reboot. The volume will be at 0
but not muted. Installing alsa-utils will solve the problem.

> Applets not working

If audio or network applets don't work the user may be required to be
added to the relevant groups (audio, network):

    $ gpasswd -a [user] [group]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cinnamon&oldid=255782"

Category:

-   Desktop environments
