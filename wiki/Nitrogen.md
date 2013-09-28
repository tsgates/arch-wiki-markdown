Nitrogen
========

Nitrogen is a fast and lightweight desktop background browser and setter
for X windows.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
|     -   2.1 Setting wallpaper                                            |
|     -   2.2 Restoring wallpaper                                          |
+--------------------------------------------------------------------------+

Installation
------------

Nitrogen is available in the official repositories:

    # pacman -S nitrogen

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
"https://wiki.archlinux.org/index.php?title=Nitrogen&oldid=236060"

Category:

-   Graphics and desktop publishing
