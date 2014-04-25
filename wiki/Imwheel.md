imwheel
=======

Related articles

-   Xorg
-   Mouse_acceleration

imwheel is a tool for tweaking mouse wheel behavior, on a per-program
basis. It can map mousewheel input to keyboard input, increase
mousewheel speed, and has support for modifier keys.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Getting the window class string
    -   2.2 Edit your configuration file
    -   2.3 Run imwheel

Installation
------------

imwheel is available from AUR imwheel or directly from The sourceforge
page. Therefore, you can install it with the command : yaourt imwheel

Configuration
-------------

The official HTML documentation (manpage) is available in the official
website.

imwheel matches window class strings with regular expressions for
deciding which windows to apply tweaks to.

> Getting the window class string

Run xprop to get the class string. The program will exit when a window
is clicked.

    xprop WM_CLASS | grep -o '"[^"]*"' | head -n 1

So for the document viewer zathura, this will return the following:

    "zathura"

> Edit your configuration file

Create or edit ~/.imwheelrc. In this configuration file lines can be
added for each program you want to tweak mousewheel behavior for. The
following example will increase the mousewheel speed for the document
viewer zathura:

    # Speed up scrolling for the document viewer
    "^zathura$"
        None, Up, Button4, 4
        None, Down, Button5, 4

> Run imwheel

Run imwheel simply like so:

    imwheel

The program will print its PID and run in the background. You may wish
to run imwheel in a startup script.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Imwheel&oldid=296113"

Category:

-   X Server

-   This page was last modified on 4 February 2014, at 04:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
