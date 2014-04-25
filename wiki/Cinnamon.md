Cinnamon
========

Related articles

-   Nemo
-   GNOME
-   MATE
-   Desktop environment
-   Display manager

Cinnamon is a Linux desktop which provides advanced innovative features
and a traditional user experience. The desktop layout is similar to
GNOME Panel (GNOME 2); however, the underlying technology was forked
from GNOME Shell (GNOME 3). The emphasis is put on making users feel at
home and providing them with an easy to use and comfortable desktop
experience. As of version 2.0, Cinnamon is a complete desktop
environment and not merely a frontend for GNOME like GNOME Shell and
Unity.

Contents
--------

-   1 Installation
-   2 Starting Cinnamon
    -   2.1 Graphical log-in
    -   2.2 Starting Cinnamon manually
-   3 Configuration
    -   3.1 Cinnamon Settings
        -   3.1.1 Bluetooth support in cinnamon-settings and the panel
    -   3.2 Installing applets/extensions
-   4 Tips and tricks
    -   4.1 Creating custom applets/themes
    -   4.2 Default desktop background wallpaper path
    -   4.3 Show Home, Filesystem desktop icons
    -   4.4 Workspaces
    -   4.5 Hide desktop icons
-   5 Troubleshooting
    -   5.1 QGtkStyle unable to detect the current theme
    -   5.2 Pressing power buttons suspend the system
    -   5.3 Laptop lid power management settings are ignored
    -   5.4 Volume level is not saved
    -   5.5 Applets not working
    -   5.6 cinnamon-settings: No module named Image

Installation
------------

Cinnamon can be installed with the package cinnamon, available in the
official repositories.

Starting Cinnamon
-----------------

> Graphical log-in

Simply choose Cinnamon or Cinnamon (Software Rendering) session from
your favourite display manager. Cinnamon is the 3D accelerated version,
which should be normally used. If you experience problems with your
video driver (e.g. artifacts or crashing), try the Cinnamon (Software
Rendering) session, which disables 3D acceleration.

> Starting Cinnamon manually

If you prefer to start Cinnamon manually from the console, add the
following line to your ~/.xinitrc file:

    ~/.xinitrc

     exec cinnamon-session

If the Cinnamon (Software Rendering) session is required, use
cinnamon-session-cinnamon2d instead of cinnamon-session.

After the exec command is placed, Cinnamon can be launched by typing
startx. See xinitrc for details.

Note:Versions before Cinnamon 1.9 used the GNOME session manager. For
versions of Cinnamon currently in the official repositories, use
cinnamon-session instead of gnome-session-cinnamon.

Configuration
-------------

Cinnamon is quite easy to configure — a lot of the configuration that
most people will want can be done graphically. Its usability can be
customized with applets and extensions, and also it supports theming.

> Cinnamon Settings

Simply run the following command:

    $ cinnamon-settings

Each settings panel can be accessed directly with the following
commands:

    $ cinnamon-settings panel
    $ cinnamon-settings calendar
    $ cinnamon-settings themes
    $ cinnamon-settings applets
    $ cinnamon-settings windows
    $ cinnamon-settings fonts
    $ cinnamon-settings hotcorner

and so on.

Bluetooth support in cinnamon-settings and the panel

Warning:cinnamon-bluetooth is incompatible with GNOME 3.10. See the
Bluetooth article for alternatives.

A GNOME bluetooth frontend for Cinnamon Panel and Cinnamon Settings is
available in the AUR under the name cinnamon-bluetooth.

> Installing applets/extensions

The difference between an applet and an extension is that an applet is
basically an addition to a panel, whereas an extension can completely
change the Cinnamon experience and can do much more than an applet.

There are quite a few packages in the AUR (AUR package search for
cinnamon). The process described here is a generic installation process.

Installing applets in Cinnamon is relatively easy. First visit Cinnamon
Applets to see all of the current applets. Download the zip file for the
desired applet, and extract to ~/.local/share/cinnamon/applets/ or
/usr/share/cinnamon/applets. Then run

    $ cinnamon-settings applets

to bring up the graphical applets manager. If the applet does not show
up, press Alt+F2 and type r and press Enter. This will restart cinnamon
and likely, the new applet.

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

> Show Home, Filesystem desktop icons

By default Cinnamon starts with desktop icons enabled but with no
desktop icons on screen. To show desktop icons for the home folder, the
filesystem, the trash, mounted volumes and network servers open Cinnamon
settings and click on desktop. Enable the checkboxes of the icons you
want to see on screen.

> Workspaces

A workspace pager can be added to the panel. Right click the panel and
choose the option 'Add applets to the panel.' Add the 'Workspace switch
applet to the panel. To change its position right click on the panel and
change the 'Panel edit mode' on/off switch to on. Click and drag the
switcher to the desired position and turn the panel edit mode off when
finished.

By default there are 2 workspaces. To add more move the mouse cursor
into the top left corner to enter 'Expose mode.' Click the plus sign
button on the right of the screen to add more workspaces.

> Hide desktop icons

The desktop icons rendering feature is enabled in nemo by default. To
disable this feature, change the setting with the following command:

    $ gsettings set org.nemo.desktop show-desktop-icons false

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

    $ mkdir ~/.icons
    $ ln -s /usr/share/icons/Adwaita ~/.icons/default

This sets the cursor theme to Adwaita located in
/usr/share/icons/Adwaita.

> Pressing power buttons suspend the system

This is the default behaviour. To show the shutdown menu for example,
change the setting for the respective button:

    $ gsettings set org.gnome.settings-daemon.plugins.power button-power 'interactive'

> Laptop lid power management settings are ignored

Note:This workaround is no longer needed with cinnamon-settings-daemon
version 2.0.8-4.

If your system ignores the laptop lid close action, which set in Power
Management tool, you have to edit the file /etc/systemd/login.conf and
uncomment/modify the following two lines:

    HandleLidSwitch=ignore
    LidSwitchIgnoreInhibited=no

> Volume level is not saved

The volume level is not be saved after reboot. The volume will be at 0
but not muted. Installing alsa-utils will solve the problem.

> Applets not working

If audio or network applets don't work the user may be required to be
added to the relevant groups (audio, network):

    $ gpasswd -a [user] [group]

> cinnamon-settings: No module named Image

If cinnamon-settings does not start with the message that it cannot find
a certain module, e.g. the Image module, it is likely that it uses
outdated compiled files which refer to no longer existing file
locations. In this case remove all *.pyc files in
/usr/lib/cinnamon-settings and its sub-folders.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cinnamon&oldid=305775"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 02:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
