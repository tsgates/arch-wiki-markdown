SpaceFM
=======

Related articles

-   Display manager
-   File manager functionality
-   Window manager

Forked from PCManFM, SpaceFM is a lightweight, highly configurable,
desktop-indpendent multi-panel tabbed file and desktop manager. It
features a built-in virtual file system, a udev or HAL-based device
manager, a customisable menu system, and Bash integration. More
information can be found at the official SpaceFM website.

Contents
--------

-   1 Installation
-   2 File searches
-   3 Desktop management
    -   3.1 Desktop preferences
    -   3.2 Creating new icons
-   4 Daemon mode
-   5 Autostarting
-   6 Additional features and functionality
    -   6.1 Mounting remote hosts

Installation
------------

spacefm is available from the official repositories.

File searches
-------------

SpaceFM provides a built-in file search feature similar to catfish,
which can be utilised with the following command:

    $ spacefm -f

Desktop management
------------------

The command to allow SpaceFM to set wallpapers and enable the use of
desktop icons is:

    spacefm --desktop

The native desktop menu of the window manager will be replaced with that
provided by SpaceFM. However, it can easily be restored from the SpaceFM
menu itself by selecting Desktop preferences and then enabling the
Right click shows WM menu option in the Desktop tab.

> Desktop preferences

If using the native desktop menu provided by a window manager, enter the
following command to set or amend desktop preferences at any time:

    $ spacefm --desktop-pref

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

The session or autostart command to run SpaceFM as a daemon / background
process (i.e. to automount removable media such as CD/DVDs and USB
flash-drives) is:

    spacefm -d

Autostarting
------------

How SpaceFM may be autostarted as a daemon process or to manage the
desktop for a standalone window manager will depend on the window
manager itself. For example, to enable management of the desktop for
Openbox, the following command would be added to the
~/.config/openbox/autostart file:

    spacefm --desktop &

Review the relevant wiki article and/or official home page for a
particular installed or intended window manager. Should a window manager
not provide an autostart file, SpaceFM may be alternatively autostarted
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

> Mounting remote hosts

SpaceFM supports mounting remote hosts via udevil. In order to add a
remote host add the access URL into the URL bar. A terminal window
should pop up showing the mounting process which is useful for error
tracing. An overview of the supported remote hosts can be found in the
udevil help. For example to mount a remote FTP server one would enter:

    ftp://user:pass@sys.domain/share

Retrieved from
"https://wiki.archlinux.org/index.php?title=SpaceFM&oldid=301370"

Category:

-   File managers

-   This page was last modified on 24 February 2014, at 11:34.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
