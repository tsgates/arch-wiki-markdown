Default applications
====================

Related articles

-   Desktop environment
-   Window manager

Default applications can be set for use with particular file types (e.g.
the Firefox web browser for HTML files). Where undertaken, files may be
opened and/or edited with the desired application much faster and more
conveniently. There are also numerous methods to configure default
applications in Linux. This page will explain the most common methods:
File Managers, MIME types, and environment variables.

Contents
--------

-   1 Using File Managers
-   2 Using MIME types and desktop entries
    -   2.1 gnome-defaults-list
    -   2.2 perl-file-mimeinfo
    -   2.3 xdg-open
    -   2.4 Custom file associations
    -   2.5 Maintaining settings for multiple desktop environments
-   3 Using environment variables
-   4 Troubleshooting
    -   4.1 Applications don't appear in the Open With... context menu
        (of a file manager)

Using File Managers
-------------------

Tip:This is the recommended method for less experienced users

Most file managers will allow for specific applications to be set as the
defaults for various file types. New defaults may also be set at any
time. For example, to set a default application using thunar, the native
file manager for XFCE:

-   right-click the file-type desired
-   Select Open with another application
-   Select the desired application
-   Ensure that the Use as default for this kind of file check-box is
    ticked
-   Click the Open button.

The general process will be very similar for most other popular file
managers, including PCManFM and spacefm.

Using MIME types and desktop entries
------------------------------------

The modern method to start applications is using Desktop Entries. This
way, programs can advertise which kind of files (to be exact: what MIME
types) they can open. For instance, gimp.desktop states
MimeType=image/bmp;image/gif;....

The recommended way of specifying the preferred (default) applications
for MIME types is via the files called mimeapps.list which may be stored
in the directories
$XDG_DATA_HOME/applications (usually ~/.local/share/applications) for
high user-level preferences and
$XDG_DATA_DIRS/applications (usually /usr/local/share/applications and /usr/share/applications)
for lower system-level preferences. A mimeapps.list file may have either
or both of the following sections, for example:

    [Added Associations]
    text/html=firefox.desktop;chromium.desktop;opera-browser.desktop;
    image/jpeg=viewnior.desktop;gpicview.desktop;

    [Removed Associations]
    text/html=midori.desktop;google-chrome.desktop;
    image/jpeg=feh.desktop;

where the [Added Associations] section specifies preferred (default)
applications in decreasing order of preference for the specified MIME
type. The [Removed Associations] section removes any associations made
in lower level applications directories.

An older way of specifying preferred (default) applications is via files
called defaults.list may be stored in the same applications directories.
These files are now generally only used for read-only special purposes,
and mimeapps.list files are now favoured instead. A defaults.list file
has the following section, for example:

    [Default Applications]
    text/html=firefox.desktop;chromium.desktop;opera-browser.desktop;
    image/jpeg=viewnior.desktop;gpicview.desktop;

Note that Arch Linux itself does not provide any system-wide preferences
for associations, but other distributions and specific desktop
environments may, via mimeapps.list and/or defaults.list files. Your
choice of preferred (default) applications can be conveniently set by
several file managers (for example, SpaceFM, Thunar or PCManFM), or you
can edit the file ~/.local/share/applications/mimeapps.list yourself as
a user. You may also try the "official" utility xdg-mime to set
preferred applications, but your mileage to success may vary depending
on your desktop environment, or lack of desktop environment.

> gnome-defaults-list

gnome-defaults-list is available from the AUR, and contains a list of
file-types and programs specific to the Gnome desktop. The list is
installed to /etc/gnome/defaults.list.

Open this file with a text editor. Here you can replace a given
application with the name of the program of your choice. For example,
the media-player totem can be replaced with another, such as vlc. Save
the file to ~/.local/share/applications/defaults.list.

> perl-file-mimeinfo

perl-file-mimeinfo is available from the official repositories. It can
be invoked by using the following command:

    $ mimeopen -d /path/to/file

You are asked which application to use when opening /path/to/file:

    Please choose a default application for files of type text/plain
           1) notepad  (wine-extension-txt)
           2) Leafpad  (leafpad)
           3) OpenOffice.org Writer  (writer)
           4) gVim  (gvim)
           5) Other...

Your answer becomes the default handler for that type of file. Mimeopen
is installed as /usr/bin/perlbin/vendor/mimetype.

> xdg-open

xdg-open is a desktop-independent tool for starting default
applications. Many applications invoke the xdg-open command internally.
xdg-open uses xdg-mime to query
~/.local/share/applications/mimeapps.list (among other things; if you
use a mainstream DE like GNOME, KDE or LXDE, xdg-open might try using
their specific tools before xdg-mime) to find the MIME type of the file
that is to be opened and the default application associated with that
MIME type.

See xdg-open for more information.

> Custom file associations

The following method creates a custom mime type and file association
manually. This is useful if your desktop does not have a mime type/file
association editor installed. In this example, a fictional multimedia
application 'foobar' will be associated with all *.foo files. This will
only affect the current user.

-   First, create the file
    ~/.local/share/mime/packages/application-x-foobar.xml:

    $ mkdir -p ~/.local/share/mime/packages
    $ cd ~/.local/share/mime/packages
    $ touch application-x-foobar.xml

-   Then edit ~/.local/share/mime/packages/application-x-foobar.xml and
    add this text:

    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/x-foobar">
            <comment>foo file</comment>
            <icon name="application-x-foobar"/>
            <glob-deleteall/>
            <glob pattern="*.foo"/>
        </mime-type>
    </mime-info>

Note that you can use any icon, including one for another application.

-   Next, edit or create the file
    ~/.local/share/applications/foobar.desktop to contain something
    like:

    [Desktop Entry]
    Name=Foobar
    Exec=/usr/bin/foobar
    MimeType=application/x-foobar
    Icon=foobar
    Terminal=false
    Type=Application
    Categories=AudioVideo;Player;Video;
    Comment=

Note that Categories should be set appropriately for the application
type (in this example, a multimedia app).

-   Now update the applications and mime database with:

    $ update-desktop-database ~/.local/share/applications
    $ update-mime-database    ~/.local/share/mime

Programs that use mime types, such as file managers, should now open
*.foo files with foobar. (You may need to restart your file manager to
see the change.)

> Maintaining settings for multiple desktop environments

The OnlyShowIn field of a .desktop file may be useful; see this page. I
haven't tried setting this field yet; please update this wiki page if
you have any info about using OnlyShowIn.

Using environment variables
---------------------------

Most non-graphical programs use Environment variables, such as EDITOR or
BROWSER. These can be set in your terminal's autostart file (e.g.
~/.bashrc):

    ~/.bashrc

    export EDITOR="nano"
    export BROWSER="firefox"

Troubleshooting
---------------

> Applications don't appear in the Open With... context menu (of a file manager)

Sometimes, a certain application will not appear in the right-click Open
With... dialog. To fix this problem, locate the .desktop file in
/usr/share/applications, edit it as root, and add %U to the end of the
Exec= line. For example, Kile currently has this problem; you need to
edit /usr/share/applications/kde4/kile.desktop and change the line
reading Exec=kile to read Exec=kile %U. Also, please file a bug against
the upstream project if you notice this problem.

You may also have to edit the MimeType list in the .desktop file if you
install extensions that allow an application to handle additional MIME
types.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Default_applications&oldid=303911"

Category:

-   Desktop environments

-   This page was last modified on 10 March 2014, at 15:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
