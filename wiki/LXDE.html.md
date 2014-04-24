LXDE
====

Related articles

-   Desktop environment
-   Display manager
-   Window manager
-   Openbox
-   PCManFM
-   LXDM

From project home page:

The "Lightweight X11 Desktop Environment" is an extremely
fast-performing and energy-saving desktop environment. Maintained by an
international community of developers, it comes with a beautiful
interface, multi-language support, standard keyboard short cuts and
additional features like tabbed file browsing. LXDE uses less CPU and
less RAM than other environments. It is especially designed for cloud
computers with low hardware specifications, such as, netbooks, mobile
devices (e.g. MIDs) or older computers.

Contents
--------

-   1 Installation
-   2 Starting the desktop
    -   2.1 Graphical log-in
    -   2.2 Console
-   3 Tips and tricks
    -   3.1 Application menu editing
    -   3.2 Auto mount
    -   3.3 Autostart programs
        -   3.3.1 Openbox autostarting
        -   3.3.2 Desktop files
        -   3.3.3 Autostart files
    -   3.4 Bindings
    -   3.5 Cursors
    -   3.6 Digital clock applet time
    -   3.7 Font settings
    -   3.8 Keyboard layout
        -   3.8.1 Add the “Keyboard Layout Switcher” to the panel
    -   3.9 Screen locking
    -   3.10 Disabling screen blanking without installing a graphical
        screensaver
    -   3.11 lxpanel icons
    -   3.12 Network Management
    -   3.13 PCManFM
    -   3.14 Replacing the default window manager
    -   3.15 Shutdown, reboot, suspend and hibernate options
        (LXSession-logout)
-   4 Troubleshooting
    -   4.1 SSH key management
    -   4.2 NTFS with Chinese characters
    -   4.3 KDM and LXDE Session
    -   4.4 GTK+ warnings with lxsession 0.4.1
-   5 See also

Installation
------------

LXDE is considered modular, meaning that you have considerable choice
over which packages you need to install. The minimum required packages
which you have to install to run LXDE are lxde-common and openbox (or
another window manager).

Most users will wish to install the full desktop which can be installed
by installing the lxde group from the official repositories. The LXDE
desktop is comprised of the following packages (plus any dependencies):

-   gpicview - Lightweight image viewer
-   libfm - Library for file management
-   lxappearance - Utility to configure themes, icons and fonts for GTK+
    applications
-   lxappearance-obconf - Plugin for LXAppearance to configure Openbox
-   lxde-common - Default settings for integrating different LXDE
    components
-   lxde-icon-theme - Icon theme for LXDE
-   lxdm - Lightweight display manager
-   lxinput - Small program to configure keyboard and mouse for LXDE
-   lxlauncher - Application launcher mainly for netbooks
-   lxmenu-data - Collection of files intended to adapt freedesktop.org
    menu specification
-   lxmusic - Lightweight XMMS2 client
-   lxpanel - Desktop panel for LXDE
-   lxpolkit - Simple polkit authentication agent for LXDE
-   lxrandr - Screen manager
-   lxsession - Standard-compliant X11 session manager with shutdown,
    reboot and suspend support
-   lxshortcut - Small program used to edit application shortcuts
-   lxtask - Lightweight task manager
-   lxterminal - Lightweight terminal emulator
-   menu-cache - Daemon which automatically generates the menu for LXDE
-   openbox - Lightweight, standard-compliant and highly-configurable
    window manager typically used with LXDE
-   pcmanfm - Default lightweight file manager for LXDE which also
    provides desktop integration

Starting the desktop
--------------------

> Graphical log-in

LXDM is the default display manager for LXDE and is installed as part of
the lxde group. It is still in the early stages of development.

Other display managers such as LightDM and GDM also work well with LXDE.

> Console

To use startx, you will need to define LXDE in your ~/.xinitrc file:

    exec startlxde

If you want to run startx at boot automatically, take a look at the
Starting X at boot guide.

See xinitrc for details, such as preserving the logind session.

Tips and tricks
---------------

> Application menu editing

The application menu works by resolving the .desktop files located in
/usr/share/applications. Many desktop environments run programs that
supersede these settings to allow customization of the menu. LXDE has
yet to create an application menu editor but you can manually build them
yourself if you are so inclined. Third party menu editor can be found in
AUR - lxmed

To add or edit a menu item, create or link to the .desktop file in
/usr/share/applications, /usr/local/share/applications, or
~/.local/share/applications. (The latter two have the advantage of
putting your application outside of directories governed by pacman.)
Consult the desktop entry specification on freedesktop.org for
structures of .desktop files.

To remove items from the menu, instead of deleting the .desktop files,
you can edit the file and add the following line in the file:

    NoDisplay=true

To expedite the process for a good number of files you can put it in a
loop. For example:

    $ cd /usr/share/applications
    $ for i in program1.desktop program2.desktop ...; do cp /usr/share/applications/$i \
    /home/user/.local/share/applications/; echo "NoDisplay=true" >> \
    /home/user/.local/share/applications/$i; done

This will work for all applications except KDE applications. For these,
the only way to remove them from the menu is to log into KDE itself and
use it's menu editor. For every item that you do not want displayed,
check the 'Show only in KDE' option. If adding NoDisplay=True will not
work, you can add ShowOnlyIn=XFCE.

> Auto mount

Please consult the File_manager_functionality#Auto-Mount_Removable_Media
article for information regarding automounting.

> Autostart programs

There are a number of different ways to autostart applications in LXDE
as described below.

Openbox autostarting

By default, Openbox is the window manager for LXDE, so Openbox
autostarting affects LXDE as well. See the main article for more
details: Openbox#autostart.

Desktop files

First you can link a program's .desktop in /usr/share/applications/ file
to ~/.config/autostart/. For example, to execute lxterminal
automatically at startup:

    $ ln -s /usr/share/applications/lxterminal.desktop ~/.config/autostart/

Once .desktop files have been added you can manipulate them with the GUI
configuration tool lxsession-edit.

Autostart files

You can also autostart applications by using a
~/.config/lxsession/LXDE/autostart file. This file is not a shell
script, but each line represents a command to be executed. If a line
begins with a @ symbol, the command following the @ will be
automatically re-executed if it crashes. For example, to execute
lxterminal and leafpad automatically at startup:

    ~/.config/lxsession/LXDE/autostart

    @lxterminal
    @leafpad

Note:The commands do not end with a & symbol.

There is also a global autostart file at
/etc/xdg/lxsession/LXDE/autostart. If both files are present, all
entries in both files will be executed.

> Bindings

Mouse and key bindings (i.e. keyboard shortcuts) are implemented with
Openbox and are described in detail here. LXDE users should follow these
instructions to edit the file ~/.config/openbox/lxde-rc.xml.

An optional GUI for editing the key bindings is obkey available in the
AUR. The default edit for obkey is rc.xml, but you can direct it to the
LXDE configuration as follows:

    $ obkey ~/.config/openbox/lxde-rc.xml

More information on obkey is here.

> Cursors

Main article: Cursor Themes.

lxappearance provides functionality to change cursor themes.

> Digital clock applet time

You can right click on the digital clock applet on the panel and set how
it displays the current time. For example, to display standard time
instead of military time in the format of HH:MM:SS:

    %I:%M

And in YYYY/MM/DD HH:MM:SS format:

    %Y/%m/%d %H:%M:%S

If you wish to display standard time with and AM/PM:

    %I:%M %p

See the man page on strftime (3) for more options.

> Font settings

To set the main font, you can use lxappearance. For other fonts you will
need to use the Openbox configuration tool obconf.

> Keyboard layout

See Keyboard Configuration in Xorg for generic instructions.

See #Autostart programs for a way to automatically start setxkbmap in
LXDE.

Add the “Keyboard Layout Switcher” to the panel

1.  Right-click on your taskbar
2.  Choose “Add/Remove panel items”
3.  Choose “Add”
4.  Choose “Keyboard layout switcher”

> Screen locking

It is recommended that you use xscreensaver for screen locking in LXDE.
To start it click on the Screensaver option in the settings section of
the LXDE menu and when asked if you want to run the daemon click yes.
Xscreensaver will be added to the /etc/xdg/lxsession/LXDE/autostart file
automatically meaning that it will be started every time you log in with
no manual intervention required. Please consult the Xscreensaver wiki
article for more information on configuration.

> Disabling screen blanking without installing a graphical screensaver

If you do not want to install a graphical screensaver you can still
disable screen blanking by adding these lines below to ~/.xinitrc before
the exec command.

    xset s off &
    xset -dpms &

> lxpanel icons

Default icons used by lxpanel are stored in /usr/share/pixmaps and any
custom icons you want lxpanel to use need to be saved there as well.

You can change default icons for applications by taking the following
steps:

1.  Save the new icon to /usr/share/pixmaps
2.  Use a text editor to open the .desktop file of the program whose
    icon you want to change in /usr/share/applications.
3.  Change

    Icon=/default/icon/.png

to:

    Icon=/name/of/new/icon/added/to/pixmaps/.png

> Network Management

It is recommended that you use NetworkManager for connecting to and
managing networks in LXDE.

> PCManFM

PCManFM is the standard file manager in LXDE.

> Replacing the default window manager

Openbox, the default window manager of LXDE, can be easily replaced by
other window managers, such as fvwm, icewm, dwm, metacity, xfwm4,
compiz, etc.

LXDE will attempt to use the window manager defined in the user
lxsession configuration file ~/.config/lxsession/LXDE/desktop.conf. If
it does not exist, it will then attempt to use the window manager
defined in the global configuration file
/etc/xdg/lxsession/LXDE/desktop.conf.

Within one of these files replace the openbox-lxde command with the
window manager of your choice. For example:

    [Session]
    window_manager=openbox-lxde

For metacity:

    window_manager=metacity

For compiz:

    window_manager=compiz ccp --indirect-rendering

> Shutdown, reboot, suspend and hibernate options (LXSession-logout)

Ensure that the package upower is installed. Then simply choose the
required option from the logout dialogue which can be accessed from the
panel.

Troubleshooting
---------------

> SSH key management

A very lightweight solution to ssh key management can be found by using
keychain. See the using keychain article for details.

> NTFS with Chinese characters

For a storage device with an NTFS filesystem, you will need to install
the NTFS-3G package. Generally, PCManFM works well with NTFS
filesystems, however there is one bug affecting NTFS users that if you
have files or directories on an NTFS filesystem, the names of which
contain non-latin characters (e.g. Chinese characters) may disappear
when opening (or auto-mounting) the NTFS volume. This happens because
the lxsession mount-helper is not correctly parsing the policies and
locale options. There is a workaround for this:

Create a new /usr/local/bin/mount.ntfs-3g with a new Bash script
containing:

    #!/bin/bash
    /usr/bin/ntfs-3g $1 $2 -o locale=en_US.UTF-8

And then make it executable:

    # chmod +x /usr/local/bin/mount.ntfs-3g

> KDM and LXDE Session

As of KDE 4.3.3, KDM will not recognize the LXDE desktop session. To fix
it:

    # cp /usr/share/xsessions/LXDE.desktop /usr/share/apps/kdm/sessions/

> GTK+ warnings with lxsession 0.4.1

When starting GTK+2 programs you may get the following message:

    GTK+ icon them is not properly set

This usually means you do not have an XSETTINGS manager running. Desktop
environment like GNOME or XFCE automatically execute their XSETTING
managers like gnome-settings-daemon or xfce-mcs-manager. This is caused
by the migration of lxde-settings-daemon config files into lxsession. If
you made customizations to these config files, you are in need of
merging those config files:

-   /usr/share/lxde/config
-   ~/.config/lxde/config

into

-   /etc/xdg/lxsession/LXDE/desktop.conf
-   ~/.config/lxsession/LXDE/desktop.conf

Alternatively, you can use lxappearance from the community repository to
fix this.

See also
--------

-   LXDE wiki entry related to Arch Linux
-   LXDE project (Sourceforge)
-   LXDE forum
-   The Latest lx* Packages

Retrieved from
"https://wiki.archlinux.org/index.php?title=LXDE&oldid=305949"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 17:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
