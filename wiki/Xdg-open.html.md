xdg-open
========

xdg-open is a desktop-independent tool for configuring the default
applications of a user. Many applications invoke the xdg-open command
internally.

Inside a desktop environment (e.g. GNOME, KDE, or Xfce), xdg-open simply
passes the arguments to that desktop environment's file-opener
application (gvfs-open, kde-open, or exo-open, respectively), which
means that the associations are left up to the desktop environment. When
no desktop environment is detected (for example when one runs a
standalone window manager, e.g. Openbox), xdg-open will use its own
configuration files.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Examples
        -   2.1.1 get mime type
        -   2.1.2 Get default application
        -   2.1.3 Set the default file-browser
        -   2.1.4 Set the default PDF viewer
        -   2.1.5 Set the default browser
-   3 Drop-in replacements and useful tools
    -   3.1 xdg-open replacements
    -   3.2 run-mailcap
    -   3.3 mimetype
    -   3.4 Environment variables
-   4 See also

Installation
------------

xdg-open is part of the xdg-utils package available in the official
repositories. xdg-open is for use inside a desktop session only. It is
not recommended to use xdg-open as root.

Configuration
-------------

xdg-open uses the configuration file mentioned in Default Applications.
You can edit this file by using xdg-mime.

> Examples

get mime type

To get mime type of photo.jpg:

    $ xdg-mime query filetype photo.jpg

    photo.jpg
        image/jpeg

Get default application

To get default .desktop file starter for image/jpeg mime type:

    $ xdg-mime query default image/jpeg

    gpicview.desktop;

Set the default file-browser

To make Thunar the default file browser, i.e. the default application
for opening folders:

    $ xdg-mime default Thunar.desktop inode/directory

Set the default PDF viewer

To use xpdf as the default PDF viewer:

    $ xdg-mime default xpdf.desktop application/pdf

Set the default browser

To set the default application for http(s):// links (replace
browser.desktop by your browser's .desktop, e.g. firefox.desktop or
chromium.desktop):

    $ xdg-mime default browser.desktop x-scheme-handler/http
    $ xdg-mime default browser.desktop x-scheme-handler/https

or:

    $ xdg-mime default browser.desktop text/html

To test if this was applied successfully, try to open an URL with
xdg-open as follows:

    $ xdg-open https://archlinux.org

Drop-in replacements and useful tools
-------------------------------------

> xdg-open replacements

  Name/Package   Description                                                                                                                                                                                                                    Based on                                                                             Configuration file
  -------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ ------------------------------------------------------------------------------------ -------------------------------------------------------------------------------------------------------
  busking-git    A simple, regex-based xdg-open replacement.                                                                                                                                                                                    perl-file-mimeinfo                                                                   custom
  expro          Opens objects in associated applications by matching regular expressions against object name or MIME-type.                                                                                                                     file (but alternatives can be configured)                                            custom
  linopen        An intelligent and suckless replacement for xdg-open.                                                                                                                                                                          file                                                                                 custom
  mimeo          Open files by MIME-type or file name using regular expressions. It can be used on its own or through xdg-utils-mimeo.                                                                                                          file                                                                                 standard mimeapps.list or defaults.list; custom is optional
  mimi-git       A working replacement for xdg-open.                                                                                                                                                                                            file                                                                                 custom
  fyr            Manages menus of application launchers, either executables or desktop files. Also opens files and URIs with launchers, desktop files, or applications associated by MIME-type. Can use a wrapper script to replace xdg-open.   file and/or perl-file-mimeinfo; other alternatives and fallbacks can be configured   XDG standard mimeapps.list and mimeinfo.cache (and the older defaults.list) to determine associations

> run-mailcap

The .mailcap file format used by the mutt mail program is way easier to
read and write. The run-mailcap package from the AUR provides a
executable that could be easily symlinked to /usr/bin/xdg-open, but that
parser is unable to handle directories or links. The simplest solution
would be to install mimeo from the AUR too and create a
/usr/bin/xdg-open with the following content:

    #!/bin/sh
    run-mailcap $1 || mimeo $1

Then use the defaults.list at ~/.local/share/applications/ to associate
URLs and folders with applications and the .mailcap file for normal
mimetypes.

> mimetype

mimetype in perl-file-mimeinfo package can display some mimetype-related
information about a file.

For example:

    $ mimetype file.ext

returns the mimetype of a file,

    $ mimetype -d file.extension

returns a description of that mimetype.

When xdg-open fails to detect one of the desktop environments it knows
about, it normally falls back to using file -i, which uses only file
contents to determine the mimetype, resulting in some file types not
being detected correctly. With mimetype available, xdg-open will use
that instead, with better detection results, as mimetype uses the
information in the shared mime info database.

> Environment variables

Some environment variables, such as BROWSER, DE, and DESKTOP_SESSION,
will change the behaviour of the default xdg-open. See Environment
variables for more information.

See also
--------

-   Default applications - Desktop-specific instructions/overview of
    alternatives to xdg-open
-   Environment variables

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xdg-open&oldid=301126"

Category:

-   Desktop environments

-   This page was last modified on 24 February 2014, at 11:11.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
