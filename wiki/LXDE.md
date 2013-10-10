LXDE
====

> Summary

LXDE is a GPL-licensed open source desktop environment for Unix and
other POSIX-compliant platforms, such as Linux. This article covers its
installation, configuration, and troubleshooting.

LXDE uses the GTK+ toolkit.

> Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

From LXDE.org | Lightweight X11 Desktop Environment:

The "Lightweight X11 Desktop Environment" is an extremely
fast-performing and energy-saving desktop environment. Maintained by an
international community of developers, it comes with a beautiful
interface, multi-language support, standard keyboard short cuts and
additional features like tabbed file browsing. LXDE uses less CPU and
less RAM than other environments. It is especially designed for cloud
computers with low hardware specifications, such as, netbooks, mobile
devices (e.g. MIDs) or older computers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Starting the Desktop                                               |
|     -   2.1 Display Managers                                             |
|     -   2.2 Console                                                      |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Application Menu Editing                                     |
|     -   3.2 Auto Mount                                                   |
|     -   3.3 Autostart Programs                                           |
|     -   3.4 Bindings                                                     |
|     -   3.5 Cursors                                                      |
|         -   3.5.1 Custom folder icons in $HOME                           |
|                                                                          |
|     -   3.6 Digital clock applet time                                    |
|     -   3.7 Font Settings                                                |
|     -   3.8 Keyboard layout                                              |
|         -   3.8.1 Using udev                                             |
|         -   3.8.2 Other way                                              |
|         -   3.8.3 Add the “Keyboard Layout Switcher” to our taskbar      |
|                                                                          |
|     -   3.9 Gnome-screensaver with LXDE                                  |
|     -   3.10 Disabling screen blanking without installing GUI            |
|         screensaver                                                      |
|     -   3.11 lxpanel Icons                                               |
|     -   3.12 LXNM                                                        |
|     -   3.13 PCManFM                                                     |
|     -   3.14 Replacing Window Managers                                   |
|     -   3.15 Shutdown, Reboot, Suspend and Hibernate Options (           |
|         LXSession-logout)                                                |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 SSH Key Management                                           |
|     -   4.2 NTFS with Chinese Characters                                 |
|     -   4.3 KDM and LXDE Session                                         |
|     -   4.4 GTK+ Warnings with lxsession 0.4.1                           |
|                                                                          |
| -   5 Resources                                                          |
+--------------------------------------------------------------------------+

Installation
------------

LXDE is considered modular, meaning that choosing a specific package for
a task is usually accomplishable; the minimal required packages which
you have to install to run LXDE are lxde-common, lxsession,
desktop-file-utils, and a window manager.

Install the LXDE group by doing:

    # pacman -S lxde

In the group these are the packages make available:

-   gpicview: A lightweight image viewer
-   libfm: A library for file management
-   lxappearance: A utility to configure themes, icons and fonts for
    GTK+ applications
-   lxappearance-obconf: A plugin for LXAppearance to configure Openbox
-   lxde-common: The default settings for integrating different LXDE
    components
-   lxde-icon-theme: An icon theme for LXDE
-   lxdm: A lightweight display manager
-   lxinput: A small program to configure keyboard and mouse for LXDE
-   lxlauncher: An application launcher mainly for netbooks
-   lxmenu-data: A collection of files intended to adapt freedesktop.org
    menu specification
-   lxmusic: A lightweight XMMS2 client
-   lxpanel: A desktop panel for LXDE
-   lxrandr: A screen manager
-   lxsession: A standard-compliant X11 session manager with shutdown,
    reboot and suspend support
-   lxshortcut: A small program used to edit application shortcuts
-   lxtask: A lightweight task manager
-   lxterminal: A lightweight terminal emulator
-   menu-cache: A daemon which automatically generates the menu for LXDE
-   openbox: A lightweight, standard-compliant and highly-configurable
    window manager typically used with LXDE
-   pcmanfm: The default lightweight file manager for LXDE which also
    provides desktop integration

After the installation finishes, copy three files to the local
configuration directory as instructed by pacman:

    mkdir -p ~/.config/openbox
    cp /etc/xdg/openbox/{menu.xml,rc.xml,autostart} ~/.config/openbox

The program Gamin will need to be installed as well (a file and
directory monitoring tool). It runs on demand of programs and therefore
does not require a daemon like FAM does. If you already have FAM
installed, remove it from the DAEMONS array in /etc/rc.conf first and
stop the daemon, then install gamin:

    # pacman -S gamin

Also some lightweight applications typically used with LXDE are
available in the repositories:

    # pacman -S leafpad obconf epdfview

Starting the Desktop
--------------------

There are lots of ways to start a LXDE desktop.

> Display Managers

If you are using a display manager like GDM, KDM, or SLiM, switch the
session to LXDE. Please consult the display manager's wiki page for
instructions.

Instructions for using LXDM, an experimental display manager provided by
the LXDE project, are included in LXDM page.

If not using a display manager you would like to add

    export DESKTOP_SESSION=LXDE

to your ~/.bash_profile in order xdg-open to function properly.

> Console

To be able to start the desktop from the console, several other options
exist.

To use startx, you will need to define LXDE in your ~/.xinitrc file:

    exec startlxde

If you want to run startx at boot automatically, take a look at the
Starting X at boot guide.

For other tasks you'll want to be sure that dbus is running as a daemon.

See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

Tips and tricks
---------------

> Application Menu Editing

The application menu works by resolving the .desktop files located in
/usr/share/applications. Many desktop environments run programs that
supersede these settings to allow customization of the menu. LXDE has
yet to create an application menu editor but you can manually build them
yourself if you are so inclined. Third party menu editor can be found in
AUR - lxmed

To add or edit a menu item, create or link to the .desktop file in
/usr/share/applications. Consult the desktop entry specification on
freedesktop.org for structures of .desktop files.

To remove items from the menu, instead of deleting the .desktop files,
you can edit the file and add the following line in the file:

    NoDisplay=true.

To expedite the process for a good number of files you can put it in a
loop. For example:

    cd /usr/share/applications
    for i in program1.desktop program2.desktop ...; do cp /usr/share/applications/$i \
    /home/user/.local/share/applications/; echo "NoDisplay=true" >> \
    /home/user/.local/share/applications/$i; done

This will work for all applications except KDE applications. For these,
the only way to remove them from the menu is to log into KDE itself and
use it's menu editor. For every item that you do not want displayed,
check the 'Show only in KDE' option. If adding NoDisplay=True won't
work, you can add ShowOnlyIn=XFCE.

> Auto Mount

PCManFM#Volume_handling

> Autostart Programs

.desktop files

First you can link a program's .desktop in /usr/share/applications/ file
to ~/.config/autostart/. For example, to execute lxterminal
automatically at startup:

    $ ln -s /usr/share/applications/lxterminal.desktop ~/.config/autostart/

Once .desktop files have been added you can manipulate them with the GUI
configuration tool lxsession-edit.

autostart file

The second method is to use a ~/.config/lxsession/LXDE/autostart file.
This file is not a shell script, but each line represents a command to
be executed, if a line begins with a @ symbol, the command following the
@ will be automatically re-executed if it crashes. For example, to
execute lxterminal and leafpad automatically at startup:

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
instructions to edit the file ~/.config/openbox/lxde-rc.xml

An optional GUI for editing the key bindings is obkey available in the
AUR. The default edit for obkey is rc.xml, but you can direct it to the
LXDE configuration as follows:

    $ obkey ~/.config/openbox/lxde-rc.xml

More information on obkey is here.

> Cursors

Main article: X11 Cursors.

The latest lxappearance2-git in AUR provides functionality to change
cursor themes. If you do not want to install newer, experimental
lxappearance2, you'll have to define your cursor in your ~/.Xdefaults
file. See Configuring Cursor Themes.

A basic way is to add the cursor to the default theme. First you will
need to make the directory:

    # mkdir /usr/share/icons/default

Then you can specify to add to the icon theme the cursor. This will use
the xcursor-bluecurve pointer theme:

    /usr/share/icons/default/index.theme

    [icon theme]
    Inherits=Bluecurve

Custom folder icons in $HOME

Currently it looks like PCmanFM doesn't support this:

https://bbs.archlinux.org/viewtopic.php?pid=851397#p851397

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

> Font Settings

Most users of LXDE usually try to use GTK+ programs because GTK+ is the
backend for LXDE. To set the fonts, you can use lxappearance and set the
main font. For other fonts you will need to use the Openbox
configuration tool ObConf:

    # pacman -S obconf

> Keyboard layout

Using udev

When you use udev, the default input configuration is written to
/etc/X11/xorg.conf.d/10-evdev.conf under Section "InputClass". You can
edit it or create a new file /etc/X11/xorg.conf.d/10-keyboard.conf
following the example below, using a generic swiss keyboard, with a
french variant.

    Section "InputClass"
        Identifier        "evdev keyboard catchall"
        MatchIsKeyboard   "on"
        MatchDevicePath   "/dev/input/event*"
        Driver            "evdev"
        Option            "XkbModel" "pc104"
        Option            "XkbLayout" "fr"
        Option            "XknVariant" "ch"
    EndSection

You can find a list of all layout and variant options in
/usr/share/X11/xkb/rules/base.lst.

Other way

1 way: Add in /etc/xdg/lxsession/LXDE/autostart following line before
@lxpanel --profile LXDE:

    @setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:scroll us,ru

or ~/.config/lxsession/LXDE/autostart (for separate user):

    setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:scroll us,ru

2 way: Create /etc/xdg/autostart/setxkmap.desktop as following:

    [Desktop Entry]
    Version=1.0
    Encoding=UTF-8
    Name=Fix keyboard settings
    Exec=setxkbmap -rules xorg -layout "us,ru" -variant ",winkeys" -option "grp:alt_shift_toggle"
    Terminal=false
    Type=Application

3 way: Edit ~/.Xkbmap for current user or /etc/X11/Xkbmap for all system
add following line:

    -option grp:alt_shift_toggle,grp_led:scroll us,ru

4 way: Add folowing line in /etc/X11/xinit/xinitrc or ~/.xinitrc:

    setxkbmap -option grp:alt_shift_toggle,grp_led:scroll us,ru

5 way: Install fbxkb from AUR

6 way: Xorg#Switching_Between_Keyboard_Layouts

Add the “Keyboard Layout Switcher” to our taskbar

1.  Right-click on your taskbar
2.  Choose “Add / Remove Panel Items”
3.  Choose “Add”
4.  Choose “Keyboard Layout Switcher”

> Gnome-screensaver with LXDE

Install the needed packages:

    pacman -S gnome-screensaver gnome-session

Create a simple launcher for gnome-session to allow the screensaver to
work in ~/.config/autostart/gnome-session.desktop

    [Desktop Entry]
    Exec=/usr/bin/gnome-session

Now logout and log back in to enjoy gnome-screensaver.

> Disabling screen blanking without installing GUI screensaver

If you do not want to install GUI screensaver, to disable screen
blanking add these lines below to ~/.xinitrc before exec command.

    xset s off &
    xset -dpms &

> lxpanel Icons

Default icons used by lxpanel are stored in /usr/share/pixmaps and any
custom icons you want lxpanel to use need to be saved there as well.

You can change default icons for applications by taking the following
steps:

1.  Save the new icon to /usr/share/pixmaps
2.  Use a text editor to open the .desktop file of the program whose
    icon you want to change in /usr/share/applications.
3.  Change

    Icon=/default/icon/.png

to

    Icon=/name/of/new/icon/added/to/pixmaps/.png

> LXNM

Note:LXNM is no longer under active development. It's suggested to use
NetworkManager and nm-applet.

LXNM is a program based on scripts that attempts to manage the network
connections. It is script-based and strives to make networking
configuration as automatic as possible. It is not a full blown
networking system like NetworkManager. If you want greater control, Wicd
and Gnome's verions of NetworkManager works well with LXDE. You can
install LXNM from [community] repository:

    # pacman -S lxnm

The main script will need to be run as root. If you plan on consistently
using it, put it in your /etc/rc.conf. LXNM works with the network
status monitor applet in lxpanel. LXNM works well most of the time,
though at times it can take a while to get a connection.

> PCManFM

If you want to be able to access the Trash, mount volumes, and
folder/file tracking you'll want gvfs support:

    pacman -S polkit-gnome gvfs

polkit-gnome provides an authentication and will need to be started on
login:

    mkdir -p ~/.config/autostart
    cp /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop ~/.config/autostart

Arch's polkit-gnome-authentication-agent-1.desktop currently doesn't
exempt certain desktops. If you have trouble launching it remove the
line:

    OnlyShowIn=GNOME;XFCE;

PCManFM @ LXDE wiki

To read/write NTFS file system don't forget to install ntfs-3g:

    pacman -S ntfs-3g

> Replacing Window Managers

Openbox, the default window manager of LXDE, can be easily replaced by
other window managers, such as fvwm, icewm, dwm, metacity, compiz
...etc.

LXDE will attempt to use window manager from the user lxsession
configuration file ~/.config/lxsession/LXDE/desktop.conf. If it does not
exist, it will then attempt to use the global configuration file
/etc/xdg/lxsession/LXDE/desktop.conf.

Replace the openbox-lxde command with the window manager of your choice:

    [Session]
    window_manager=openbox-lxde

For metacity:

    window_manager=metacity

For compiz:

    window_manager=compiz ccp --indirect-rendering

> Shutdown, Reboot, Suspend and Hibernate Options ( LXSession-logout)

To have all Shutdown, Reboot, Suspend and Hibernate Options working you
need to have dbus running. You also need to have upower installed.

    # pacman -S upower

See xinitrc#Preserving the session for details on avoiding breaking the
logind/consolekit session.

Troubleshooting
---------------

> SSH Key Management

A very lightweight solution to ssh key management can be found by using
keychain. See the using keychain article for details.

> NTFS with Chinese Characters

For a storage device with an NTFS filesystem, you will need to install
the NTFS-3G package. Generally, PCManFM works well with NTFS
filesystems, however there is one bug affecting NTFS users that if you
have files or directories on an NTFS filesystem, the names of which
contain non-latin characters (e.g. Chinese characters) may disappear
when opening (or auto-mounting) the NTFS volume. This happens because
the lxsession mount-helper is not correctly parsing the policies and
locale options. There is a workaround for this:

Remove the /sbin/mount.ntfs-3g which is a symbolic link.

    # rm /sbin/mount.ntfs-3g

Create a new /sbin/mount.ntfs-3g with a new bash script containing:

    #!/bin/bash
    /bin/ntfs-3g $1 $2 -o locale=en_US.UTF-8

And then make it executable:

    # chmod +x /sbin/mount.ntfs-3g

Add or edit the following line to /etc/pacman.conf under the [options]
tag to prevent modification of this file in case of upgrading:

    NoUpgrade = sbin/mount.ntfs-3g

> KDM and LXDE Session

As of KDE 4.3.3, KDM will not recognize the LXDE desktop session. To fix
it:

    # cp /usr/share/xsessions/LXDE.desktop /usr/share/apps/kdm/sessions/

> GTK+ Warnings with lxsession 0.4.1

When starting GTK+2 programs you get the following message:

    GTK+ icon them is not properly set

    This usually means you do not have an XSETTINGS manager running. Desktop environment like GNOME or XFCE automatically execute their XSETTING managers like gnome-settings-daemon or xfce-mcs-manager. This is caused by the migration of lxde-settings-daemon config files into lxsession. If you made customizations to these config files, you are in need of merging those config files:

-   /usr/share/lxde/config
-   ~/.config/lxde/config

into

-   etc/xdg/lxsession/LXDE/desktop.conf
-   ~/.config/lxsession/LXDE/desktop.conf

Alternatively, you can use lxappearance from the community repository to
fix this.

Resources
---------

-   LXDE wiki entry related to Arch Linux
-   LXDE Project (Sourceforge)
-   LXDE Forum
-   The Latest lx* Packages
-   PCMan File Manager

Retrieved from
"https://wiki.archlinux.org/index.php?title=LXDE&oldid=255190"

Category:

-   Desktop environments
