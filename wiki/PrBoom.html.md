PrBoom
======

PrBoom is a cross-platform version of the classic 3D first person
shooter Doom from id Software. Originally written for Microsoft Windows,
PrBoom has since been ported to Linux and many other platforms. It
offers a number of enhancements over the original game, including OpenGL
rendering and high video resolutions, while attempting to remain true to
the original Doom in terms of play. You will need the original Doom
data, unless you install the FreeDoom package (see below).

Contents
--------

-   1 Installation
-   2 Use
-   3 Net
-   4 Music
-   5 Data

Installation
------------

PrBoom is available from the standard repos:

    # pacman -S prboom

Use
---

To use prboom with an IWad file with default settings (unless you
already have ~/.prboom/prboom.cfg edited):

    # prboom -iwad /path/to/file

To change window resolution (you must disable fullscreen in options
ingame):

    # prboom -width 800 -height 600 -iwad /path/to/file 

A full list of settings can be found in the man pages.

Net
---

To start a server:

    # prboom-game-server

By default it listens on port 5030, so to join the game:

    # prboom -net localhost:5030 -iwad /path/to/file

Music
-----

If music is not working, then follow these steps.

    # pacman -S timidity++ timidity-freepats

Edit /etc/timidity++/timidity.cfg , and add:

    dir /usr/share/timidity/freepats
    source /etc/timidity++/freepats/freepats.cfg

Please note that freepats is an incomplete soundfont ; therefore it will
not play every instrument used by Doom and Doom 2. You should consider
installing an alternative soundfont.

Data
----

If you do not have the original Doom data available to play PrBoom, you
can install the freedoom package from the AUR.

This will place the data in the correct directory, so you can just start
PrBoom and frag away!

Retrieved from
"https://wiki.archlinux.org/index.php?title=PrBoom&oldid=211331"

Category:

-   Gaming

-   This page was last modified on 27 June 2012, at 04:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
