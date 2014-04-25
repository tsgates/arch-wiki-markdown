HiDPI
=====

HiDPI, also known as Retina, is simply a name for screens with high
resolution. The examples are Apple MacBooks labeled "with Retina", as
well as some ultrabooks (e.g. Lenovo Yoga 2 Pro).

Not all software behaves well in high-resolution mode yet. Here are
listed most common tweaks which make work on a HiDPI screen more
pleasant.

Contents
--------

-   1 Desktop environments (DEs)
    -   1.1 GNOME 3
    -   1.2 XFCE
-   2 Browsers
    -   2.1 Firefox
    -   2.2 Chromium / Google Chrome
-   3 Mail clients
    -   3.1 Thunderbird
-   4 Skype

Desktop environments (DEs)
--------------------------

> GNOME 3

GNOME seems to be supporting HiDPI since 3.10. The support isn't
particularly great, though.

For now (Jan 7 2014) to correctly enable HiDPI in gnome you need latest
version of cairo-git, and rebuild gtk with this version of cairo.

> XFCE

Go to Settings Editor (you can find it in Settings Manager), and change
the DPI parameter in xsettings -> Xft. The value of 180 seems to work
well on Retina screens.

Browsers
--------

> Firefox

Open Firefox advanced preferences page (about:config) and set parameter
layout.css.devPixelsPerPx to 2 (or find the one that suits you better; 2
is a good choice for Retina screens).

> Chromium / Google Chrome

No support yet. Watch this thread:
https://code.google.com/p/chromium/issues/detail?id=143619. In the
meantime try setting default page zoom level to 200% (although it isn't
the most elegant solution).

Mail clients
------------

> Thunderbird

See Firefox. To access about:config, go to Edit → Preferences → Advanced
→ Config editor.

Skype
-----

Skype is a Qt program, and needs to be configured separately. You can't
change the DPI setting for it, but at least you can change font size.
Install extra/qt4 and run qtconfig-qt4 to do it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HiDPI&oldid=298456"

Category:

-   Graphics

-   This page was last modified on 17 February 2014, at 03:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
