Twm
===

Twm is a window manager for X11. It is a small program, being built
against Xlib rather than using a widget library, and as such, it is very
light on system resources. Though simple, it is highly configurable;
fonts, colours, border widths, title bar buttons, etc. can all be set by
the user.

Contents
--------

-   1 Twm creation and name
-   2 Installation
-   3 Start twm with X
-   4 Configuration (editing your .twmrc)
-   5 Resources
-   6 References

> Twm creation and name

Twm was written by Tom LaStrange, a developer who was frustrated by the
limitations of uwm (Ultrix Window Manager)[[1], the only window manager
around when X11 was first released. Twm supplanted uwm as the default
window manager supplied with X11 from the X11R4 release in 1989[2].

Twm has stood for Tom's Window Manager, Tab Window Manager and more
recently Timeless Window Manager[3].

Installation
------------

Twm is part of the Arch Linux official repositories and is provided by
the package xorg-twm.

Start twm with X
----------------

In order for twm to be run as your window manager, edit the file
~/.xinitrc so the final line is:

    exec twm

If you now type:

    startx

at the command prompt, X will start using twm as its window manager.

If you would like to configure X (and twm) to start on boot (or when you
login), read the wiki page Start X at Login to find out how.

Configuration (editing your .twmrc)
-----------------------------------

By default, twm looks very dated and unintuitive. By editing the file
~/.twmrc, you can customize twm to make it more friendly.

Resources
---------

-   The twm man page gives full details of the commands which can be
    used in your ~/.twmrc file. It can be viewed online[4] or accessed
    once twm is installed by typing the following at a command prompt:

    man twm

-   Many ~/.twmrc files have been posted online[5]. The site xwinman[6]
    has several ~/.twmrc files with screenshots which might provide
    inspiration. A Google search for "twmrc" can be used to find new
    ideas[7].
-   More information about twm can be found on the twm Wikipedia
    page[8].
-   There is a patched version, not in the repositories, with updated
    features such as transparency. A description and build script is
    available on the xorg mailing list.[9] It can be tried out by
    installing xcompmgr, running the build script, putting the resulting
    twm and dot.twmrc files in a convenient directory, and editing the
    ~/.xinitrc file so that the last two lines are

    xcompmgr -o 0.3  -c -r 8 -t -10 -l -12 &
    /path-to-directory/twm -visual TrueColor -depth 32 -f /path-to-directory/dot.twmrc

References
----------

1.  Proffitt, Brian. "From the Desktop: Tom LaStrange Speaks!",
    LinuxPlanet, February 6, 2001. Retrieved October 22, 2009.
2.  "UWM (computing)", Wikipedia. Retrieved October 22, 2009.
3.  "Twm", Wikipedia. Retrieved October 22, 2009.
4.  "Twm man page", linux.die.net. Retrieved October 22, 2009.
5.  "Sample twmrc", custompc.plus.com. Retrieved August 12, 2013.
6.  "Window Managers for X: TWM/VTWM", xwinman.org. Retrieved October
    22, 2009.
7.  "Google search for twmrc", google.com. Retrieved October 22, 2009.
8.  Kask, Eeri. "TWM -- Revised Edition -- Again", lists.x.org, January
    3, 2010.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Twm&oldid=305765"

Category:

-   Stacking WMs

-   This page was last modified on 20 March 2014, at 02:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
