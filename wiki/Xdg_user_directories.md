Xdg user directories
====================

User directories are a set of common directories such as downloads
directory, music directory, documents directory, and so on. These
directories can have special identifying icons and used internally by
many applications such as Nautilus and Thunar to determine where to look
for files to be passed to the Create Document context menu, whereas the
desktop directory is used by Xfdesktop to find .desktop files to be
shown on the Desktop.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 The config file                                              |
|     -   2.2 xdg-user-dirs-update                                         |
|                                                                          |
| -   3 xdg-user-dir                                                       |
| -   4 External Resource                                                  |
+--------------------------------------------------------------------------+

Installation
------------

install package xdg-user-dirs from Official Repositories.

Configuration
-------------

> The config file

xdg-user-dirs uses two files for configuration:

-   For all users : /etc/xdg/user-dirs.defaults.
-   For one specific user: ~/.config/user-dirs.dirs.

Its format is as follows:

     XDG_DIRNAME_DIR="$HOME/Dirname"

A complete file might contain multiple entries:

     XDG_DESKTOP_DIR="$HOME/Desktop"
     XDG_DOWNLOAD_DIR="$HOME/Downloads"
     XDG_TEMPLATES_DIR="$HOME/Templates"
     XDG_PUBLICSHARE_DIR="$HOME/Public"
     XDG_DOCUMENTS_DIR="$HOME/Documents"
     XDG_MUSIC_DIR="$HOME/Music"
     XDG_PICTURES_DIR="$HOME/Pictures"
     XDG_VIDEOS_DIR="$HOME/Videos"

Pointing any of the above variables to $HOME disables the respective
directory (it won't be automatically created).

> xdg-user-dirs-update

xdg-user-dirs-update is a desktop-independent tool for configuring the
location of certain user directories. It is run very early in the login
phase. This program reads a configuration file, and a set of default
directories. It then creates localized versions of these directories in
the users home directory and sets up a config file in
$(XDG_CONFIG_HOME)/user-dirs.dirs (XDG_CONFIG_HOME defaults to
~/.config) that applications can read to find these directories.

As an example, command

    xdg-user-dirs-update --set TEMPLATES ~/.templates

will set the template directory to the specified directory with respect
to the current user's $HOME:

     XDG_TEMPLATES_DIR="$HOME/.templates"

If you want to revert to English, run the following:

    $ LC_ALL=C xdg-user-dirs-update

xdg-user-dir
------------

Once set, any user directory can be viewed with xdg-user-dir. For
example:

    $ xdg-user-dir TEMPLATES

will show the template directory, which of course corresponds to the
XDG_TEMPLATES_DIR variable in the config file.

External Resource
-----------------

-   xdg-user-dirs - freedesktop.org

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xdg_user_directories&oldid=240295"

Category:

-   Desktop environments
