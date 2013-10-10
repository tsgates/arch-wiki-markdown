Nautilus
========

> Summary

This article covers installation, configuration, and general usage tips
for Nautilus.

> Related

GNOME: Desktop Environment that encompasses Nautilus

Thunar: Xfce4's default file manager.

Nautilus Guide - official GNOME guide on using Nautilus.

Nautilus is the default file manager for GNOME. From the Gnome website:
The Nautilus file manager provides a simple and integrated way to manage
your files and applications. You can use the file manager to do the
following:

-   Create folders and documents
-   Display your files and folders
-   Search and manage your files
-   Run scripts and launch applications
-   Customize the appearance of files and folders
-   Open special locations on your computer
-   Write data to a CD or DVD
-   Install and remove fonts

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Desktop Management                                           |
|     -   2.2 Remove folders from the places sidebar                       |
|     -   2.3 Always show text-entry location                              |
|     -   2.4 Plugins                                                      |
|     -   2.5 Nautilus 3.6 create an empty document                        |
|     -   2.6 Nautilis 3.6 use delete key to move to trash                 |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Nautilus can't browse my windows network shares              |
+--------------------------------------------------------------------------+

Installation
------------

Install nautilus from the Official Repositories.

Note:Nautilus does not require the entire gnome-shell package, but it
does require gnome-desktop. Some may find this nice because gnome-shell
is a bit more of an undertaking to install.

Nautilus is part of the gnome group.

Configuration
-------------

Nautilus is simple to configure graphically, but not all potential
configurations can be done via the preferences menu in nautilus. More
options are available with dconf-editor under org.gnome.nautilus.

> Desktop Management

Nautilus, by default, no longer controls your background/desktop in
gnome-shell. If you like having icons on your desktop or enjoy the neat
click-and-drag rectangle when you're bored, you can easily configure
nautilus to handle the desktop.

Install the package gnome-tweak-tool and run it. Click on the "Desktop"
list item, and click the "Have file manager handle the desktop" slider
to "on". You may have to restart nautilus by running
killall nautilus; nautilus or if you are running Gnome, press ALT+F2,
type r, and press Enter.

> Remove folders from the places sidebar

The displayed folders are specified in ~/.config/user-dirs.dirs and can
be altered with any editor. An execution of xdg-user-dirs-update will
change them again, thus it may be advisable to set the file permissions
to read-only.

> Always show text-entry location

The standard Nautilus toolbar shows a button bar interface for path
navigation. To enter path locations using the keyboard, you must expose
the location text-entry field. This is done by pressing Ctrl+l

To make the location text-entry field always present, use gsettings as
shown.

    $ gsettings set org.gnome.nautilus.preferences always-use-location-entry true

Note:After changing this setting, you will not be able to expose the
button bar. Only when the setting is false can both forms of location
navigation be employed.

> Plugins

Some programs can add extra functionality to Nautilus. Here are a few
packages in the official repositories that do just that.

-   Nautilus Actions — Configures programs to be launched when files are
    selected in Nautilus

http://gnome.org || nautilus-actions

-   Open in Terminal — A nautilus plugin for opening terminals in
    arbitrary local paths

http://ftp.gnome.org/pub/GNOME/sources/nautilus-open-terminal ||
nautilus-open-terminal

-   Send to Menu — Nautilus context menu for sending files.

http://download.gnome.org/sources/nautilus-sendto/ || nautilus-sendto

-   Sound Converter — Nautilus extension to convert audio files formats

http://code.google.com/p/nautilus-sound-converter/ ||
nautilus-soundconverter

-   seahorse-nautilus — PGP encryption and signing for nautilus

http://git.gnome.org/browse/seahorse-nautilus/ || seahorse-nautilus

> Nautilus 3.6 create an empty document

Gnome 3.6 brings new changes to Nautilus. Some features are dropped in
favour of easy maintainence of Nautilus. Creating an empty document
option has been removed from the default menu in Nautilus. One has to
create a ~/Templates/  folder in your home folder and place an empty
file inside the folder through your favourite Terminal by
touch ~/Templates/new or by using any other file manager. Restart
nautilus to get back the function of creating an empty document from
Nautilus menu.

> Nautilis 3.6 use delete key to move to trash

By default Nautilus now no longer uses the delete key to move files to
trash. If you want to get that feature back make the following changes
in ~/.config/nautilus/accels:

    - ; (gtk_accel_path "<Actions>/DirViewActions/Trash" "<Primary>Delete")
    + (gtk_accel_path "<Actions>/DirViewActions/Trash" "Delete")

Troubleshooting
---------------

> Nautilus can't browse my windows network shares

Nautilus relies on gvfs-smb for this functionality, it can be Installed
from the Official Repositories

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nautilus&oldid=254322"

Category:

-   File managers
