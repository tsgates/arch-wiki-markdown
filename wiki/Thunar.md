Thunar
======

Summary

This article discusses every aspect of the file manager named Thunar.

Related

Xfce: Thunar is installed with a nominal installation of xfce4.

Nautilus: Thunar is not the only file manager. There are many. For
example, Nautilus is the file manager for gnome.

Thunar is a file manager that is designed to be fast, lightweight, and
easy-to-use. It can be installed by itself or as part of the xfce4
group.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Automounting                                                       |
| -   3 Thunar Volume Manager                                              |
|     -   3.1 Installation                                                 |
|     -   3.2 Configuration                                                |
|                                                                          |
| -   4 Tips and Tricks                                                    |
|     -   4.1 Using Thunar to browse remote locations                      |
|     -   4.2 Starting in Daemon Mode                                      |
|     -   4.3 Setting the Icon Theme                                       |
|     -   4.4 Solving problem with slow cold start                         |
|                                                                          |
| -   5 Other plugins and addons                                           |
|     -   5.1 Thunar Archive Plugin                                        |
|     -   5.2 Thunar Media Tags Plugin                                     |
|     -   5.3 Thunar thumbnails                                            |
|     -   5.4 Thunar Shares                                                |
|                                                                          |
| -   6 Custom actions                                                     |
|     -   6.1 Scan for viruses                                             |
|     -   6.2 Link to Dropbox                                              |
|                                                                          |
| -   7 Links and References                                               |
+--------------------------------------------------------------------------+

Installation
------------

Install the thunar package which is available in the official
repositories.

If you are running Xfce4, you probably already have Thunar installed.

Automounting
------------

Thunar uses gvfs for automounting, see GVFS for details on getting it
working.

Thunar Volume Manager
---------------------

While Thunar can support automatic mounting and unmounting of removable
media, the Thunar Volume Manager allows extended functionality, such as
automatically running commands or automatically opening a Thunar window
for mounted media.

Installation

Thunar Volume Manager can be installed from the package thunar-volman in
the official repositories.

Configuration

It can also be configured to execute certain actions when cameras and
audio players are connected. After installing the plugin:

1.  Launch Thunar and go to Edit -> Preferences
2.  Under the 'Advanced' tab, check 'Enable Volume Management'
3.  Click configure and check the following items:
    -   Mount removable drives when hot-plugged.
    -   Mount removable media when inserted.

4.  Also make desired changes (see the example below)

Here's an example setting for making Amarok play an audio CD.

     Multimedia - Audio CDs: amarok --cdplay %d

Tips and Tricks
---------------

> Using Thunar to browse remote locations

Since Xfce 4.8 (Thunar 1.2) it is possible to browse remote locations
(such as FTP servers or Samba shares) directly in Thunar, similar to the
functionality found in GNOME and KDE. The gvfs and gvfs-smb packages are
required to enable this functionality. Both packages are available in
the official repositories.

After a restart of Xfce an additional "Network" entry is added to
Thunar's side bar and remote locations can be opened by using the
following URI schemes in the location dialog (opened with Ctrl+L):
smb://, ftp://, ssh://

> Starting in Daemon Mode

Thunar may be run in daemon mode. This has several advantages, including
a faster startup for Thunar, as well as Thunar running in the background
and only opening a window when necessary (for instance, when a flash
drive is inserted).

One option is to autostart it using .xinitrc or an autostart script
(such as Openbox's autostart). It is up to you to decide the best way to
start it, and this option can be run from a script or run directly as a
command in the terminal.

To run Thunar in daemon mode, simply add to your autostart script or run
from the terminal:

    $ thunar --daemon &

> Setting the Icon Theme

When using Thunar outside of Gnome or Xfce, certain packages and
configurations that control which icons are used may be missing. Window
Managers like Awesome and Xmonad do not come with XSettings managers,
which is where Thunar looks first for it's icon setting. It is possible
to install and run xfce-mcs-manager from a startup script if many Xfce4
and Gnome applications are going to be used. The gtk-icon-theme-name
setting for gtk2 can be set for a user by adding something like the
following to ~/.gtkrc-2.0:

     gtk-icon-theme-name = "Tango"

Of course, just installing the gnome-icon-theme package will give Thunar
an icon theme to use other than the default paper icon for all items.

    # pacman -S gnome-icon-theme

> Solving problem with slow cold start

Some people still have problems with Thunar taking a long time to start
for the first time. This is due to gvfs checking the network, preventing
Thunar from starting until gvfs finishes its operations. To change this
behaviour, edit /usr/share/gvfs/mounts/network.mount and change
AutoMount=true to AutoMount=false.

Other plugins and addons
------------------------

Many of these packages belong to the xfce4-goodies group. If you've
installed the group, you probably have these packages already.

> Thunar Archive Plugin

The Thunar Archive Plugin allows you to create and extract archive files
using contextual menu items. It does not create or extract archives
directly, but instead acts as a frontend for other programs such as File
Roller, Ark, or Xarchiver. It is available through the
thunar-archive-plugin package in the official repositories.

> Thunar Media Tags Plugin

The Thunar Media Tags Plugin allows you to view detailed information
about media files. It also has a bulk renamed and allows editing of
media tags. It supports ID3 (the MP3 file format's system) and
Ogg/Vorbis tags. It is available through the thunar-media-tags-plugin
package.

> Thunar thumbnails

Thunar relies on an external program called tumbler to generate
thumbnails. It is available through the tumbler package.

To generate video thumbnails, you also need to install
ffmpegthumbnailer.

> Thunar Shares

The Thunar Shares Plugin allows you to quickly share a folder using
Samba from Thunar without requiring root access. It is available through
the thunar-shares-plugin package in the AUR.

See Samba#Creating user share path for configuration directions.

Custom actions
--------------

This section covers useful custom actions which can be accessed through
Edit -> Configure custom actions. More examples are listed in the thunar
wiki.

> Scan for viruses

To use this action you need to have clamav and clamtk installed.

Name

Command

File patterns

Appears if selection contains

Scan for virus

clamtk %F

*

Select all

  

> Link to Dropbox

Name

Command

File patterns

Appears if selection contains

Link to Dropbox

ln -s %f /path/to/DropboxFolder

*

Directories, other files

Please note that when using many custom actions to symlink files and
folder to a particular place, it might be useful to put them into the
Send To folder of the context menu to avoid that the menu itself gets
bloated. This is fairly easy to achieve and requires a .desktop file in
~/.local/share/Thunar/sendto for each action to perform. Say we want to
put the above dropbox symlink action into Send To, we create a
dropbox_folder.desktop with the following content. The new applied
action will be active after restarting Thunar.

    [Desktop Entry]
    Type=Application
    Version=1.0
    Encoding=UTF-8
    Exec=ln -s %f /path/to/DropboxFolder
    Icon=/usr/share/icons/dropbox.png
    Name=Dropbox

Links and References
--------------------

-   Thunar project page.
-   Thunar Volume Manager project page.
-   Thunar Archive Plugin project page.
-   Thunar Media Tags Plugin project page.
-   Thunar Shares Plugin project page.
-   This list of plugins.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Thunar&oldid=255573"

Category:

-   File managers
