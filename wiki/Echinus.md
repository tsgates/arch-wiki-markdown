echinus
=======

Summary help replacing me

Information on installing and configuring echinus

> Related

dmenu

echinus is a simple and lightweight tiling and floating window manager
for X11. Started as a dwm fork with easier configuration, echinus became
a full-featured reparenting window manager with EWMH support.

Unlike dwm, echinus does not need to be re-compiled after changes have
been made to the config. It supports Xft (freetype) out of the box and
has the option of configurable titlebars.

Contents
--------

-   1 Installing
-   2 Configuring
    -   2.1 Rules
-   3 Starting echinus
-   4 Using echinus
    -   4.1 Panels & Pagers
-   5 Resources
    -   5.1 Screenshots

Installing
----------

echinus is in AUR. You might also want to install ourico, a lightweight
EWMH taskbar, originally designed for echinus (also in AUR), and dmenu.

After successfully installing, copy all files from /etc/xdg/echinus to
~/.echinus(for user).

Configuring
-----------

echinus is configured in one simple text file, in Xresources format:
~/.echinus/echinusrc. Details for all of the configuration options are
in /usr/share/doc/echinus/README. A section of a sample config file
looks like:

    Echinus*selected.border: #404040
    Echinus*selected.button: #d3d7cf
    Echinus*selected.bg: #262626
    Echinus*selected.fg: #d3d7cf

> Rules

Rules can be set up to spawn applications in specific tags. The
following rule, for example, would open firefox in the "web" tag:

    Echinus*rule0: firefox.* web 0 1

Opening applications in a terminal requires that you explicitly set the
-title tag when spawning them so that echinus can manage them:

    Echinus*spawn0: CA + m = urxvtc -title mutt -e mutt

Similarly, when spawning dmenu, you will need to declare the requisite
properties, like so:

    Echinus*spawn1: Menu = dmenu_run -fn "-*-dina-medium-r-*-*-*-100-*-*-*-*-*-*" -nb "#1A1A1A" -nf "#696969" -sb "#1A1A1A" -sf "#D3D7Cf"

Starting echinus
----------------

To start echinus with startx or the SLIM login manager, simply append
the following to ~/.xinitrc:

    exec echinus

Using echinus
-------------

After making changes to echinusrc, you can reload the config without
recompiling by restarting echinus, with Alt + Shift + q. This
keybinding, and any other, can be customized to suit your preference or
muscle-memory.

Further details for manipulating windows are in the manpage and the
README.

> Panels & Pagers

echinus supports some parts of EWMH - the following are known to work:

-   tint2
-   fbpanel
-   ipager
-   ourico

Resources
---------

-   echinus website
-   GitHub repository

> Screenshots

-   http://www.flickr.com/photos/jasonwryan/5270660692/lightbox/
-   http://plhk.ru/gallery/echinus-0.4.6.png
-   http://plhk.ru/gallery/profont.png
-   http://plhk.ru/gallery/echinus027.png

Retrieved from
"https://wiki.archlinux.org/index.php?title=Echinus&oldid=273615"

Category:

-   Dynamic WMs

-   This page was last modified on 1 September 2013, at 10:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
