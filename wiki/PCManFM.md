PCManFM
=======

Related articles

-   LXDE
-   Openbox
-   File manager functionality
-   Thunar
-   Nautilus
-   Nemo

From the project home page:

PCMan File Manager (PCManFM) is a file manager application developed by
Hong Jen Yee from Taiwan which is meant to be a replacement for
Nautilus, Konqueror and Thunar. Released under the GNU General Public
License, PCManFM is free software. PCManFM is the standard file manager
in LXDE, which is also developed by the same author in conjunction with
other developers.

Contents
--------

-   1 Installation
-   2 Desktop management
    -   2.1 Desktop preferences
    -   2.2 Creating new icons
-   3 Daemon mode
-   4 Autostarting
-   5 Additional features and functionality
-   6 Tips and tricks
    -   6.1 One click for open folders and files
    -   6.2 Open or Extract Archives with PCManFM
-   7 Troubleshooting
    -   7.1 No "Applications"
    -   7.2 No icons
    -   7.3 No "Previous/Next Folder" functionality with mouse buttons
    -   7.4 --desktop parameter not working or crashing X-server
    -   7.5 Terminal emulator advanced configuration not saved
    -   7.6 Make PCManFM remember your preferred Sort Files settings
    -   7.7 "Not authorized" errors when accessing/mounting USB drives
    -   7.8 Operation not supported

Installation
------------

pcmanfm is available in the official repositories.

It's recommended to install gvfs for trash support, mounting with udisk
and remote filesystems.

Notable variants are:

-   pcmanfm-git - Development version.
-   pcmanfm-qt - New Qt implementation.
-   pcmanfm-qt-git - New Qt implementation, development version.

Desktop management
------------------

The command to allow PCManFM to set wallpapers and enable the use of
desktop icons is:

    pcmanfm --desktop

The native desktop menu of the window manager will be replaced with that
provided by PCManFM. However, it can easily be restored from the PCManFM
menu itself by selecting Desktop preferences and then enabling the
Right click shows WM menu option in the Desktop tab.

> Desktop preferences

If using the native desktop menu provided by a window manager, enter the
following command to set or amend desktop preferences at any time:

    $ pcmanfm --desktop-pref

It is worthwhile to consider adding this command to a keybind and/or the
native desktop menu for easy access.

> Creating new icons

User content such as text files, documents, images and so forth can be
dragged and dropped directly onto the desktop. To create shortcuts for
applications it will be necessary to copy their .desktop files to the
~/Desktop directory itself. Do not drag and drop the files there as they
will be moved completely. The syntax of the command to do so is:

    cp /usr/share/applications/<name of application>.desktop ~/Desktop

For example - where installed - to create a desktop shortcut for
lxterminal, the following command would be used:

    cp /usr/share/applications/lxterminal.desktop ~/Desktop

For those who used the Xdg user directories program to create their
$HOME directories no further configuration will be required.

Daemon mode
-----------

The session or autostart command to run PCManFM as a daemon / background
process (i.e. to automount removable media such as CD/DVDs and USB
flash-drives) is:

    pcmanfm -d

Autostarting
------------

How PCManFM may be autostarted as a daemon process or to manage the
desktop for a standalone window manager will depend on the window
manager itself. For example, to enable management of the desktop for
Openbox, the following command would be added to the
~/.config/openbox/autostart file:

    pcmanfm --desktop &

Review the relevant wiki article and/or official home page for a
particular installed or intended window manager. Should a window manager
not provide an autostart file, PCManFM may be alternatively autostarted
by editing one or both of the following files:

-   xinitrc: When using the SLiM display manager or Startx command
-   xprofile: When using a display manager such as LXDM or LightDM

Additional features and functionality
-------------------------------------

Less experienced users should be aware that a file manager alone -
especially when installed in a standalone Window manager such as Openbox
- will not provide the features and functionality users of full desktop
environments such as Xfce and KDE will be accustomed to. Review the file
manager functionality article for further information.

Tips and tricks
---------------

> One click for open folders and files

Open PCManFM in file explorer mode, go to Edit > Preferences > General >
Behavior, and select Open files with a simple click. This option works
with desktop icons too.

> Open or Extract Archives with PCManFM

Install file-roller or xarchiver from the official repositories.

Open PCManFM in file explorer mode, go to Edit > Preferences > Advanced,
select Archiver Integration and select your installed archiver.

Troubleshooting
---------------

> No "Applications"

You can try this method: Delete all files in the $HOME/.cache/menus
directory, and run PCManFM again.

PCManFM requires the environment variable XDG_MENU_PREFIX to be set. The
value of the variable should match the beginning of a file present in
the /etc/xdg/menus/ directory. E.g. you can set the value in your
.xinitrc file with the line:

    export XDG_MENU_PREFIX="lxde-"

See these threads for more informations: [1], and especially this post
from the Linux Mint forums: [2]

> No icons

If you are using a WM instead of a DE and you have no icons for folders
and files, specify a GTK+ icon theme.

If you have e.g. oxygen-icons installed, edit ~/.gtkrc-2.0 or
/etc/gtk-2.0/gtkrc and add the following line:

    gtk-icon-theme-name = "oxygen"

Note:All instances of PCManFM have to be restarted for changes to apply!

Else, use an different one (gnome, hicolor, and locolor do not work). To
list all installed icon themes:

    $ ls ~/.icons/ /usr/share/icons/

If none of them is suitable, install one. To list all installable icon
packages:

    $ pacman -Ss icon-theme

Tip:For an alternative GUI solution, install lxappearance and apply an
icon theme from there.

> No "Previous/Next Folder" functionality with mouse buttons

A method to fix this is with Xbindkeys.

Install xbindkeys and edit ~/.xbindkeysrc to contain the following:

    # Sample .xbindkeysrc for a G9x mouse.
    "/usr/bin/xvkbd -text '\[Alt_L]\[Left]'"
     b:8
    "/usr/bin/xvkbd -text '\[Alt_L]\[Right]'"
     b:9

Actual button codes can be obtained with package xorg-xev.

Add:

    xbindkeys &

to your ~/.xinitrc to execute xbindkeys on log-in.

> --desktop parameter not working or crashing X-server

Make sure you have ownership and write permissions on ~/.config/pcmanfm.

Setting the wallpaper either by using the --desktop-pref parameter or
editing ~/.config/pcmanfm/default/pcmanfm.config solves the problem.

> Terminal emulator advanced configuration not saved

Make sure you have rights on libfm configuration file:

    $ chmod -R 755 ~/.config/libfm
    $ chmod 777 ~/.config/libfm/libfm.conf

> Make PCManFM remember your preferred Sort Files settings

You can use View > Sort Files to change the order in which PCManFM lists
the files, but PCManFM won't remember that the next time you start it.
To make it remember, go to Edit > Preferences and close. That will write
your current sort_type and sort_by values into
~/.config/pcmanfm/LXDE/pcmanfm.conf.

> "Not authorized" errors when accessing/mounting USB drives

See the no password to access partitions and removable media section of
the File manager functionality article.

> Operation not supported

If you get this error while trying to use automount, network or rubbish
bin features, try launching pcmanfm with

    $ dbus-launch pcmanfm

If that does not help you might not have the necessary dependencies
(gvfs, gamin, udisks2, maybe others). This probably only affects non-DE
environments.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PCManFM&oldid=301203"

Category:

-   File managers

-   This page was last modified on 24 February 2014, at 11:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
