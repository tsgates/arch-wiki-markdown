Xephyr
======

Xephyr is a nested X server that runs as an X application

Installation
------------

xorg-server-xephyr is available from official repositories. Install it
with pacman.

Execution
---------

If you wish to run a nested X window, you'll need to specify a display.

    $ Xephyr -br -ac -noreset -screen 800x600 :1

This will launch a new Xephyr window with a DISPLAY of ":1". In order to
launch an application in that window, you would need to specify that
display.

    $ DISPLAY=:1 xterm

If you want to launch another WM, spectrwm for example, you would type:

    $ DISPLAY=:1 spectrwm

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xephyr&oldid=292680"

Category:

-   X Server

-   This page was last modified on 13 January 2014, at 10:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
