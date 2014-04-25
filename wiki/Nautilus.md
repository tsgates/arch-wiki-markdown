Nautilus
========

Related articles

-   GNOME
-   File manager functionality
-   Nemo
-   Thunar
-   PCManFM

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

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Desktop Management
    -   2.2 Change default item view
    -   2.3 Remove folders from the places sidebar
    -   2.4 Always show text-entry location
    -   2.5 Plugins
    -   2.6 Create an empty document in Nautilus 3.6 and above
    -   2.7 Use delete key to move to trash in Nautilus 3.6 and above
-   3 Troubleshooting
    -   3.1 Nautilus can't browse my windows network shares
    -   3.2 Nautilus can't browse my apple network shares
    -   3.3 Nautilus is no longer the default file manager

Installation
------------

Install nautilus from the Official Repositories.

Note:Nautilus does not depend on the gnome-shell package, but it does
require gnome-desktop.

Nautilus is part of the gnome group.

Configuration
-------------

Nautilus is simple to configure graphically, but not all options are
available in the preferences menu. More options are available with
dconf-editor under org.gnome.nautilus.

> Desktop Management

Nautilus, by default, no longer controls your background/desktop in
gnome-shell. If you need icons on your desktop you can easily configure
nautilus to handle the desktop.

Install the package gnome-tweak-tool and run the program. Click on the
"Desktop" tab and set the "Icons on Desktop" slider to "on". You may
have to restart nautilus by running killall nautilus; nautilus or if you
are running Gnome, press ALT+F2, type r, and press Enter.

Alternatively you can use dconf-editor to change the same setting.
Expand org > gnome > desktop and click on background. Tick the option
labelled show-desktop-icons.

Note:Nautilus will manage the desktop when using the GNOME Classic
session.

> Change default item view

You can change the default view for the items by setting the
default-folder-viewer variable, e.g. for the list view:

    $ gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'

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

http://www.nautilus-actions.org/ || nautilus-actions

-   Nautilus Terminal — Terminal embedded in Nautilus. It is always open
    in the current folder, and follows the navigation.

http://projects.flogisoft.com/nautilus-terminal/ || nautilus-terminal

-   Open in Terminal — A nautilus plugin for opening terminals in
    arbitrary local paths

http://ftp.gnome.org/pub/GNOME/sources/nautilus-open-terminal ||
nautilus-open-terminal

-   Send to Menu — Nautilus context menu for sending files.

http://download.gnome.org/sources/nautilus-sendto/ || nautilus-sendto

-   Sound Converter — Nautilus extension to convert audio files formats

http://code.google.com/p/nautilus-sound-converter/ ||
nautilus-sound-converter

-   Seahorse Nautilus — PGP encryption and signing for nautilus

http://git.gnome.org/browse/seahorse-nautilus/ || seahorse-nautilus

> Create an empty document in Nautilus 3.6 and above

Gnome 3.6 brought changes to Nautilus. The option to create an empty
document has been removed from the right-click menu in Nautilus. To get
this option back one has to create a ~/Templates/  folder in your home
folder and place an empty file inside the folder through your favourite
Terminal by touch ~/Templates/new or by using any other file manager.
Then just restart Nautilus.

On non-English installations, the templates directory might have another
name. One can find the actual directory with the following command:
xdg-user-dir TEMPLATES.

> Use delete key to move to trash in Nautilus 3.6 and above

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

> Nautilus can't browse my apple network shares

Nautilus relies on gvfs-afp and avahi for this functionality, they can
be Installed from the Official Repositories. Note that in addition to
installing avahi, it needs to be started too, using

    # systemctl start avahi-daemon

and/or

    # systemctl enable avahi-daemon

> Nautilus is no longer the default file manager

If Nautilus is not recognised as the default file manager, set Nautilus
as default handler for the mime type inode/directory

    $ xdg-mime default nautilus.desktop inode/directory

Alternatively, add the following line under the [Default Applications]
section in the ~/.local/share/applications/mimeapps.list file:

    inode/directory=nautilus.desktop

Tip:If you want the change to be systemwide run the command above as
root or create a mimeapps.list file in /usr/share/applications and add
the line there instead.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nautilus&oldid=296691"

Categories:

-   File managers
-   GNOME

-   This page was last modified on 9 February 2014, at 18:51.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
