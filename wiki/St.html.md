st
==

st is a simple terminal implementation for X by suckless. It is intended
to serve as a lightweight replacement xterm and urxvt. It currently
supports 256 colors, most VT10X escape sequences, UTF8, X11 copy/paste,
antialiased fonts (using fontconfig), fallback fonts, resize, shortcuts
via config.h, and line drawing.

Installation
------------

Download the st or st-git package from the AUR.

Configuration
-------------

st is configured through its config.h file. A sample config.def.h file
is included with the source.

Consider maintaining your own PKGBUILD with sources and md5sums for your
own configuration file.

Weird glitches/Visual bugs
--------------------------

Vim: Background colour of the text in Vim will not fill in anything that
wasn't a character.

Solution: set TERM variable to screen-256color in your config.h file.

Retrieved from
"https://wiki.archlinux.org/index.php?title=St&oldid=302570"

Category:

-   Terminal emulators

-   This page was last modified on 1 March 2014, at 01:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
