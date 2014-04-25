Xdg user directories
====================

Related articles

-   xdg-menu
-   xdg-open

User directories are a set of common user directories located within the
$HOME directory, including Documents, Downloads, Music, and Desktop.
Identified by unique icons within a file manager, they will commonly be
automatically sourced by numerous programs and applications.
xdg-user-dirs is a program that will automatically generate these
directories. See the freedesktop.org website for further information.

Tip:This program will be especially helpful for those who wish to use a
file manager to manage their desktop for a Window manager such as
Openbox, as it will also automatically create a ~/Desktop directory.

Contents
--------

-   1 Installation
-   2 Creating default directories
-   3 Creating custom directories
-   4 Querying configured directories

Installation
------------

Install package xdg-user-dirs from Official repositories.

Creating default directories
----------------------------

To create a full suite of localized default user directories within the
$HOME directory, enter the following command:

    $ xdg-user-dirs-update

Tip:To force the creation of English-named directories,
LC_ALL=C xdg-user-dirs-update can be used.

When executed, it will also automatically:

-   Create a local ~/.config/user-dirs.dirs configuration file: used by
    applications to find and use home directories specific to an
    account.
-   Create a global /etc/xdg/user-dirs.defaults configuration file: used
    by applications to find and use home directories generally.
-   Create a local ~/.config/user-dirs.locale configuration file: used
    to set the language according to the locale in use.

Creating custom directories
---------------------------

Note:As with any configuration file, local settings will always override
global settings. It will also be necessary to manually create any new
custom directories.

Both the local ~/.config/user-dirs.dirs and global
/etc/xdg/user-dirs.defaults configuration files use the following format
to point to user directories:

    XDG_DIRNAME_DIR="$HOME/directory_name"

A complete configuration file may also contain multiple entries:

    XDG_DESKTOP_DIR="$HOME/Desktop"
    XDG_DOWNLOAD_DIR="$HOME/Downloads"
    XDG_TEMPLATES_DIR="$HOME/Templates"
    XDG_PUBLICSHARE_DIR="$HOME/Public"
    XDG_DOCUMENTS_DIR="$HOME/Documents"
    XDG_MUSIC_DIR="$HOME/Music"
    XDG_PICTURES_DIR="$HOME/Pictures"
    XDG_VIDEOS_DIR="$HOME/Videos"

As xdg-user-dirs will source the local configuration file to point to
the appropriate user directories, it is therefore possible to edit it in
order specify custom folders. For example, in the following example, a
custom folder for the XDG_DOWNLOAD_DIR variable has been created called
Internet, and ~/.config/user-dirs.dirs has been edited accordingly:

    XDG_DOWNLOAD_DIR="$HOME/Internet"

When downloading files from a web-browser, the default folder used for
downloading will now be Internet. Alternatively, it is also possible to
specify custom folders using the command line. The syntax of this
command is:

    $ xdg-user-dirs-update --set XDG_NAME path/to/custom_folder

For example, the following command will produce the same results as the
above configuration file edit:

    $ xdg-user-dirs-update --set DOWNLOAD ~/Internet

The names of the xdg templates are DESKTOP, DOWNLOAD, TEMPLATES,
PUBLICSHARE, DOCUMENTS, MUSIC, PICTURES, and VIDEOS.

Querying configured directories
-------------------------------

Once set, any user directory can be viewed with xdg-user-dir. For
example, the following command will specify the location of the
Templates directory, which of course corresponds to the
XDG_TEMPLATES_DIR variable in the local configuration file:

    $ xdg-user-dir TEMPLATES

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xdg_user_directories&oldid=301655"

Category:

-   Desktop environments

-   This page was last modified on 24 February 2014, at 12:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
