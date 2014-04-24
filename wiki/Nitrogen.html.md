Nitrogen
========

Related articles

-   feh

Nitrogen is a fast and lightweight desktop background browser and setter
for X windows.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 Setting wallpaper
    -   2.2 Restoring wallpaper

Installation
------------

Nitrogen can be installed with the package nitrogen, available in the
official repositories.

Usage
-----

Run nitrogen --help for full details. The following examples will get
you started:

> Setting wallpaper

To view and set the desired wallpaper from a specific directory
recursively, run:

    $ nitrogen /path/to/image/directory/

To view and set the desired wallpaper from a specific directory
non-recursively, run:

    $ nitrogen --no-recurse /path/to/image/directory/

> Restoring wallpaper

To restore the chosen wallpaper during subsequent sessions, add the
following to your startup file (e.g. ~/.xinitrc,
~/.config/openbox/autostart, etc.):

    nitrogen --restore &

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nitrogen&oldid=290718"

Category:

-   Graphics and desktop publishing

-   This page was last modified on 29 December 2013, at 03:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
