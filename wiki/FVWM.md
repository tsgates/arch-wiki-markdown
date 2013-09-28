FVWM
====

FVWM is a stable, powerful, efficient, and ICCCM-compliant multiple
virtual desktop window manager for the X Window system. It requires some
effort to learn to use it well, since it is almost entirely configured
by editing configuration files with a text editor, but those who persist
end up with a desktop environment that works exactly the way they want
it to work. Development is active, and support is excellent. And for
those who wonder, FVWM means Feeble Virtual Window Manager.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing FVWM                                                    |
| -   2 Starting FVWM                                                      |
| -   3 Bringing Out its Power                                             |
| -   4 References                                                         |
+--------------------------------------------------------------------------+

Installing FVWM
---------------

Install the package fvwm which is available in the official
repositories.

You can also install fvwm-patched from the AUR, or if you have
archlinuxfr (see Unofficial user repositories) added to your
/etc/pacman.conf it can be installed with pacman like a regular package.

Starting FVWM
-------------

FVWM will automatically be listed in kdm/gdm in the sessions menu.
Otherwise, add

    exec fvwm2 

or

    exec fvwm

to your user's .xinitrc.

See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

Bringing Out its Power
----------------------

When you start FVWM for the first time, you will get something that
looks very blank. When you left-click on the desktop, you will be able
to select a very basic configuration for FVWM. Chose the modules you
want and you are ready to get started. You will undoubtedly want to do
more to create your desktop, so here are some tips:

-   Although it is outdated, the Zensites FVWM beginners guide[1] helps
    to understand how FVWM functions and how to build your basic setup.

-   The Gentoo Linux Wiki has a useful guide on configuration.[2]

-   The FVWM homepage[3] includes documentation[4], a FAQ [5], and links
    to a Wiki[6]) and the FVWM forums[7].

-   The best way to come up with the desktop you want is probably to
    check out the configurations in the FVWM forum[8] or at
    Box-Look.org,[9] choose one you like, install it, and modify it to
    taste.

-   As you work with what other people have done, you may find it
    helpful to look at the tips on configuration files by Thomas Adam,
    the most active FVWM developer.[10]

-   A page[11] in the Internet Archive is outdated, but seems to be the
    only significant online documentation for fvwm-patched.

-   FVWM-Crystal, which is also in the Arch repositories as package
    fvwm-crystal, is an add-on that makes FVWM much easier to configure,
    although the easier configuration allows much less flexibility than
    direct editing of configuration files.

-   XdgMenu is a useful utility for generating menus.

-   Fvwm plays well with xcompmgr for simple compositing effects.

-   Useful applications are similar to those suggested for Openbox or
    Fluxbox.

References
----------

1.  Zensites FVWM beginners guide.
2.  Gentoo Wiki configuration guide.
3.  FVWM Homepage.
4.  FVWM Homepage documentation.
5.  FVWM Homepage FAQ.
6.  FVWM Wiki.
7.  FVWM Forums.
8.  Configurations in the FVWM forum.
9.  Box-Look.
10. Thomas Adam on common mistakes in configuration files.
11. Fvwm Patches in the Internet Archive.

Retrieved from
"https://wiki.archlinux.org/index.php?title=FVWM&oldid=239179"

Category:

-   Stacking WMs
