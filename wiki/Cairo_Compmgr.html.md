Cairo Compmgr
=============

Summary help replacing me

Describes the installation and usage of Cairo Composite Manager.

Related articles

Xcompmgr

Xorg

Cairo Composite Manager is a versatile and extensible composite manager
which uses cairo for rendering. Plugins can be used to add some cool
effects to your desktop. It's capable of, but not limited to, rendering
of drop shadows, setting window transparency, menu and window
animations, and applying decorations.

Like Xcompmgr, it does not replace an existing window manager, which
makes it ideal for users of lightweight window managers, like Openbox
and Fluxbox, who seek a more elegant desktop.

Installation
------------

Cairo Compmgr is no longer available in the official repositories. The
development version is available as cairo-compmgr-git from the AUR.

There are no errors on compile with removed gconf, and it runs fine.
However, it is not possible to remove dependency on vala as it will not
compile in that case. If you remove gconf, you need to remove the last 3
lines in PKGBUILD, the ones mentioning gconf.

Configuration
-------------

To start Cairo Composite Manager, simply run:

    $ cairo-compmgr 

If it runs for a few seconds and then crashes taking the terminal with
it, open the Cairo Composite Manager and disable the 'Freeze' plugin:

    $ cairo-compmgr --configure

To have it load every time you start X, you can add it to your
~/.xinitrc :

    cairo-compmgr &

Once started, Cairo Composite Manager installs itself in your systray
and you can configure it by by right-clicking the systray icon.

If you just want Xcompmgr's behaviour, you can disable a lot of the
plugins straightaway. Be patient while Cairo Composite Manager unloads a
plugin, it might stall your screen for a moment.

Additional Resources
--------------------

-   Xcompmgr -- A simple composite manager capable of drop shadows and
    primitive transparency
-   Compiz -- A composite and window manager offering a rich 3D
    accelerated desktop environment
-   Wikipedia:Compositing window manager

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cairo_Compmgr&oldid=280681"

Categories:

-   X Server
-   Eye candy

-   This page was last modified on 31 October 2013, at 13:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
