PCManFM
=======

PCManFM is "an extremely fast, lightweight, yet feature-rich file
manager with tabbed browsing". Source: PCManFM on sourceforge. PCManFM
is the default file manager of the LXDE (Lightweight X11 Desktop
Environment).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Volume handling                                                    |
|     -   2.1 Auto Mounting USB external storage devices                   |
|     -   2.2 Mounting with udisks                                         |
|     -   2.3 Trash support, browsing network shares, and automounting     |
|         with gvfs                                                        |
|                                                                          |
| -   3 Tips & troubleshooting                                             |
|     -   3.1 No "Applications"                                            |
|     -   3.2 No icons?                                                    |
|     -   3.3 NTFS Read/Write Support                                      |
|     -   3.4 gnome-open opens "Find" dialog instead of the directory      |
|     -   3.5 No "Previous/Next Folder" functionality with mouse buttons   |
|     -   3.6 One click for open folders and files                         |
|     -   3.7 --desktop parameter not working / crashing X-server          |
|     -   3.8 Terminal emulator advanced configuration not saved           |
|     -   3.9 Make PCManFM remember your preferred Sort Files settings     |
|     -   3.10 "Not authorized" errors when accessing/mounting USB drives  |
|                                                                          |
| -   4 Available Versions                                                 |
|     -   4.1 PCManFM2                                                     |
|     -   4.2 PCManFM-Mod                                                  |
|     -   4.3 PCManFM_with_Search                                          |
+--------------------------------------------------------------------------+

Installation
------------

Run the following command to install:

    # pacman -S pcmanfm

You will also require gamin (a replacement for FAM, which required a
daemon) to pick up events such as file and directories changes:

    # pacman -S gamin

Volume handling
---------------

PCManFM is able to mount and unmount devices, both manually and
automatically. This feature is offered as an alternative to CLI tools
such as pmount. There are various 'up-to-date' versions of PCManFM (see
below), and different volume handling strategies can be chosen.

> Auto Mounting USB external storage devices

To auto mount USB external storage devices only simply install gvfs:

    # pacman -S gvfs

If they do not auto mount after installing, try rebooting your system
and try again.

> Mounting with udisks

The current release of PCManFM is able to handle volumes through udisks.
If you want to use this feature, make sure the D-Bus daemon is installed
and running. See the D-Bus page for details.

> Trash support, browsing network shares, and automounting with gvfs

To resolve the "Operation not supported" error when clicking on Trash
Can, you must do the following steps:  

1. Install package gvfs  
 2. Start pcmanfm only using the following command: dbus-launch
pcmanfm  

To browse network shares:  
 1. Install packages gvfs gvfs-smb gvfs-afp  
 2. Start pcmanfm only using the following command: dbus-launch
pcmanfm  
 3. Type smb://<server name>/<share name> to access Windows / CIFS /
Samba file shares  
 4. Type afp://<server name>/<share name> to access AFP file shares

Tips & troubleshooting
----------------------

> No "Applications"

    # pacman -S gnome-menus

You can try this method: Delete all files in the $HOME/.cache/menus
directory, and run PCManFM again.

PCManFM requires the environment variable "XDG_MENU_PREFIX" to be set.
The value of the variable should match the beginning of a file present
in the "/etc/xdg/menus/" directory. In case you have installed the
"gnome-menus" package, you can set the value in your .xinitrc file with
the line :

    $ export XDG_MENU_PREFIX=gnome-

See these threads for more informations : [1], and especially this post
from the Linux Mint Forums [2]

> No icons?

If you are using a WM instead of a DE and you have no icons for folders
and files, specify a gtk icon theme:

Edit ~/.gtkrc-2.0 or /etc/gtk-2.0/gtkrc and add the following line:

    gtk-icon-theme-name = "oxygen"

Note:All instances of PCManFM have to be restarted for changes to apply!

If you do not have oxygen-icons installed, use an different one (gnome,
hicolor, and locolor do not work). To list all installed icon themes:

    ls ~/.icons /usr/share/icons/

If none of them is suitable, install one. To list all installable icon
packages:

    pacman -Ss icon-theme

Tip:For an alternative GUI solution, install lxappearance and apply an
icon theme from there.

> NTFS Read/Write Support

Install ntfs-3g (See NTFS-3G):

    # pacman -S ntfs-3g

> gnome-open opens "Find" dialog instead of the directory

Remove or rename the file /usr/share/applications/pcmanfm-find.desktop.
If you're running pcmanfm-mod from AUR, remove or rename the file
/usr/share/applications/pcmanfm-mod-find.desktop.

> No "Previous/Next Folder" functionality with mouse buttons

A method to fix this is with Xbindkeys:

Install xbindkeys:

    # pacman -S xbindkeys

Edit ~/.xbindkeysrc to contain the following:

    # Sample .xbindkeysrc for a G9x mouse.
    "/usr/bin/xvkbd -text '\[Alt_L]\[Left]'"
     b:8
    "/usr/bin/xvkbd -text '\[Alt_L]\[Right]'"
     b:9

Actual button codes can be obtained with package xorg-xev

Add

    xbindkeys &

to your ~/.xinitrc to execute xbindkeys on log-in.

> One click for open folders and files

Open PCManFM in file explorer mode, and go to: Edit > Preferences and in
geral > behavior select Open files with a simple click

this option work in the pcmanfm --desktop too

> --desktop parameter not working / crashing X-server

Make sure you have ownership and write permissions on ~/.config/pcmanfm

Setting the wallpaper either by using the --desktop-pref parameter or
editing ~/.config/pcmanfm/default/pcmanfm.config solves the problem.

> Terminal emulator advanced configuration not saved

Make sure you have rights on libfm configuration file:

    # chmod -R 755 ~/.config/libfm
    # chmod 777 ~/.config/libfm/libfm.conf

> Make PCManFM remember your preferred Sort Files settings

You can use View | Sort Files to change the order in which PCManFM lists
the files, but PCManFM won't remember that the next time you start it.
To make it remember, go to Edit | Preferences and Close. That will write
your current sort_type and sort_by values into
~/.config/pcmanfm/LXDE/pcmanfm.conf.

> "Not authorized" errors when accessing/mounting USB drives

In various WM (in use with PolicyKit), You might receive an "Not
authorized" errors when trying to access e.g. an USB drive.

If not existing, create (including the directory actions, which ain't
existing by default in there)
/etc/polkit-1/actions/org.freedesktop.udisks2.pkla to contain the
following:

    [Storage Permissions]
    Identity=unix-group:storage
    Action=org.freedesktop.udisks2.filesystem-mount;org.freedesktop.udisks2.modify-device
    ResultAny=yes
    ResultInactive=yes
    ResultActive=yes

Available Versions
------------------

There are several versions of PCManFM currently available:

> PCManFM2

This is the package in Arch's extra repository as "pcmanfm". The current
git test version of it is available in the AUR as pcmanfm-git. More
information is available on the LXDE Forum.

> PCManFM-Mod

PCManFM-Mod adds user-definable commands, other features, and bugfixes
to the legacy version of the PCManFM file manager v0.5.2. This version
builds and installs as "pcmanfm-mod" and will run independently of other
versions of PCManFM you have installed on your system. This legacy
version is still desired by some due to more stability than the newer
0.9.x rewrite in progress, less Gnome dependencies, and the use of HAL
rather than gnome-vfs. PCManFM-Mod is available in the AUR as
pcmanfm-mod and as pcmanfm-mod-prov (latter provides pcmanfm). More
information is available at IgnorantGuru's Blog.

> PCManFM_with_Search

Latest PCmanFM version with search dialog in the AUR as
pcmanfm_with_search.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PCManFM&oldid=250685"

Category:

-   File managers
