Thunar
======

Related articles

-   Xfce
-   File manager functionality
-   Nautilus
-   PCManFM
-   Nemo

From the project home page:

Thunar is a new modern file manager for the Xfce Desktop Environment.
Thunar has been designed from the ground up to be fast and easy-to-use.
Its user interface is clean and intuitive, and does not include any
confusing or useless options by default. Thunar is fast and responsive
with a good start up time and folder load time.

Contents
--------

-   1 Installation
    -   1.1 Automounting
    -   1.2 Plugins and addons
-   2 Thunar Volume Manager
    -   2.1 Installation
    -   2.2 Configuration
-   3 Tips and tricks
    -   3.1 Automounting of large external drives
    -   3.2 Using Thunar to browse remote locations
    -   3.3 Starting in daemon mode
    -   3.4 Solving problem with slow cold start
    -   3.5 Hide Shortcuts in Side Pane
-   4 Custom actions
    -   4.1 Search for files and folders
    -   4.2 Scan for viruses
    -   4.3 Link to Dropbox
-   5 See also

Installation
------------

Install the thunar package which is available in the official
repositories. It is part of the xfce4 group, so if you are running
Xfce4, you probably already have Thunar installed.

> Automounting

Thunar uses GVFS for automounting. See also File manager functionality
for more details.

> Plugins and addons

-   Thunar Archive Plugin — Plugin which allows you to create and
    extract archive files using contextual menu items. It does not
    create or extract archives directly, but instead acts as a frontend
    for other programs such as File Roller (file-roller), Ark
    (kdeutils-ark) or Xarchiver (xarchiver). Part of xfce4-goodies.

http://goodies.xfce.org/projects/thunar-plugins/thunar-archive-plugin ||
thunar-archive-plugin

-   Thunar Media Tags Plugin — Plugin which allows you to view detailed
    information about media files. It also has a bulk renamed and allows
    editing of media tags. It supports ID3 (the MP3 file format's
    system) and Ogg/Vorbis tags. Part of xfce4-goodies.

http://goodies.xfce.org/projects/thunar-plugins/thunar-media-tags-plugin
|| thunar-media-tags-plugin

-   Thunar Shares Plugin — Plugin which allows you to quickly share a
    folder using Samba from Thunar without requiring root access. See
    also how to configure directions.

http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin ||
thunar-shares-plugin

-   Thunar Volume Manager — Automatic management of removeable devices
    in Thunar. Part of xfce4.

http://goodies.xfce.org/projects/thunar-plugins/thunar-volman ||
thunar-volman

-   Tumbler — External program to generate thumbnails. Also install
    ffmpegthumbnailer to enable video thumbnailing.

http://git.xfce.org/xfce/tumbler/tree/README || tumbler

-   RAW Thumbnailer — A lightweight and fast raw image thumbnailer that
    is needed to displane raw thumbnails.

https://code.google.com/p/raw-thumbnailer/ || raw-thumbnailer

-   libgsf — The GNOME Structured File Library is a utility library for
    reading and writing structured file formats. Install if you need
    support for odf thumbnails

http://directory.fsf.org/wiki/Libgsf || libgsf

Thunar Volume Manager
---------------------

While Thunar can support automatic mounting and unmounting of removable
media, the Thunar Volume Manager allows extended functionality, such as
automatically running commands or automatically opening a Thunar window
for mounted media.

> Installation

Thunar Volume Manager can be installed from the package thunar-volman in
the official repositories.

> Configuration

It can also be configured to execute certain actions when cameras and
audio players are connected. After installing the plugin:

1.  Launch Thunar and go to Edit > Preferences
2.  Under the 'Advanced' tab, check 'Enable Volume Management'
3.  Click configure and check the following items:
    -   Mount removable drives when hot-plugged.
    -   Mount removable media when inserted.

4.  Also make desired changes (see the example below)

Here's an example setting for making Amarok play an audio CD.

     Multimedia - Audio CDs: amarok --cdplay %d

Tips and tricks
---------------

> Automounting of large external drives

If Thunar refuses to mount large removable media (size > 1TB) although
thunar-volman and gvfs has been installed, then try installing a
different automounter such as udevil or udiskie. The latter should be
preferred as it uses udisks2 and thus is compatible with gvfs. To start
udiskie with udisks2 support, add the following line to your autostart
file:

    udiskie -2 &

> Using Thunar to browse remote locations

Since Xfce 4.8 (Thunar 1.2) it is possible to browse remote locations
(such as FTP servers or Samba shares) directly in Thunar. To enable this
functionality ensure that gvfs, gvfs-smb and sshfs packages are
installed. A 'Network' entry is visible in Thunar's side bar and remote
locations can be opened by using the following URI schemes in the
location dialog (opened with Ctrl+l): smb://, ftp://, ssh://, sftp:// &
followed by the server hostname or IP address.

There is no URI scheme for NFS shares, but Thunar can issue a mount
command if you setup your fstab properly.

    /etc/fstab

    # nas1 server
    nas1:/c/home		/media/nas1/home	nfs	noauto,user,_netdev,bg  0 0

What's important here is the noauto which prevents the share from being
mounted until you click on it, user which allows any user to mount (an
unmount) the share, _netdev which makes network connectivity a
pre-requisite, and finally bg which puts the mounting operation the
background so if your server requires some spin-up time you won't have
to deal with time out messages and re-clicking until it works.

Tip:If you want to permanently store passphrases of remote filesystem
locations, you have to install GNOME Keyring.

> Starting in daemon mode

Thunar may be run in daemon mode. This has several advantages, including
a faster startup for Thunar, as well as Thunar running in the background
and only opening a window when necessary (for instance, when a flash
drive is inserted).

Make sure the command thunar --daemon is autostarted on login. See Xfce
and Autostarting for more details.

> Solving problem with slow cold start

Some people still have problems with Thunar taking a long time to start
for the first time. This is due to gvfs checking the network, preventing
Thunar from starting until gvfs finishes its operations. To change this
behaviour, edit /usr/share/gvfs/mounts/network.mount and change
AutoMount=true to AutoMount=false.

> Hide Shortcuts in Side Pane

There is a hidden menu to hide Shortcuts in the Side Pane.

Right click in the Side Pane where there are no shortcuts, like on the
DEVICES section label. Then you will get a pop-up menu where you can
uncheck items you do not want displayed.

Custom actions
--------------

This section covers useful custom actions which can be accessed through
Edit -> Configure custom actions and which are stored in
~/.config/Thunar/uca.xml. More examples are listed in the thunar wiki.
Furthermore, this blog post provides a comprehensive collection of
custom actions.

> Search for files and folders

To use this action you need to have catfish installed.

Name

Command

File patterns

Appears if selection contains

Search

catfish --fileman=thunar --path=%f

*

Directories

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
put the above Dropbox symlink action into Send To, we create a
dropbox_folder.desktop with the following content. The new applied
action will be active after restarting Thunar.

    [Desktop Entry]
    Type=Application
    Version=1.0
    Encoding=UTF-8
    Exec=ln -s %f /path/to/DropboxFolder
    Icon=/usr/share/icons/dropbox.png
    Name=Dropbox

See also
--------

-   Thunar project page
-   Thunar Volume Manager project page
-   This list of plugins

Retrieved from
"https://wiki.archlinux.org/index.php?title=Thunar&oldid=304777"

Category:

-   File managers

-   This page was last modified on 16 March 2014, at 07:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
