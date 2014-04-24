Clipboard
=========

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 History
-   2 Background
-   3 List of clipboard managers
-   4 See also

History
-------

In X10, "cut buffers" were introduced. These were limited buffers that
stored arbitrary text and were used by most applications. However, they
were inefficient and implementation of them varied, so selections were
introduced. Cut buffers are long deprecated, and although some
applications (such as xterm) may have legacy support for them, it is
both not likely and not recommended that they be used.

Background
----------

The ICCCM (Inter-Client Communication Conventions Manual) standard
defines three "selections": PRIMARY, SECONDARY, and CLIPBOARD. Despite
the naming, all three are basically "clipboards". Rather than the old
"cut buffers" system where arbitrary applications could modify data
stored in the cut buffers, only one application may control or "own" a
selection at one time. This prevents inconsistencies in the operation of
the selections. However, in some cases, this can produce strange
outcomes, such as a bidirectional shared clipboard with Windows (which
uses a single-clipboard system) in a virtual machine.

Of the three selections, users should only be concerned with PRIMARY and
CLIPBOARD. SECONDARY is only used inconsistently and was intended as an
alternate to PRIMARY. Different applications may treat PRIMARY and
CLIPBOARD differently; however, there is a degree of consensus that
CLIPBOARD should be used for Windows-style clipboard operations, while
PRIMARY should exist as a "quick" option, where text can be selected
using the mouse or keyboard, then pasted using the middle mouse button
(or some emulation of it). This can cause confusion and, in some cases,
inconsistent or undesirable results from rogue applications.

List of clipboard managers
--------------------------

-   Anamnesis — Clipboard manager that stores all the clipboard history
    and offers an interface to do a full-text search. It has both a
    commandline and GUI mode available.

http://anamnesis.sourceforge.net/ || anamnesis

-   ClipIt — Fork of Parcellite with additional features and bugfixes.

http://sourceforge.net/projects/gtkclipit/ || clipit

-   Clipman — A clipboard manager for Xfce. It keeps the clipboard
    contents around while it is usually lost when you close an
    application. It is able to handle text and images, and has a feature
    to execute actions on specific text selections by matching them
    against regular expressions.

http://goodies.xfce.org/projects/panel-plugins/xfce4-clipman-plugin ||
xfce4-clipman-plugin

-   CopyQ — Clever clipboard manager with searchable and editable
    history, custom actions on items and command line support.

https://github.com/hluk/CopyQ || copyq

-   Glipper — Clipboard manager for the GNOME desktop with many features
    and plugin support.

https://launchpad.net/glipper || glipper

-   GPaste — Clipboard management system that aims at being a new
    generation Parcellite, with a modular structure split in a couple of
    libraries and a daemon for adaptability. Offers a GNOME Shell
    extension and a CLI interface.

https://github.com/Keruspe/GPaste || gpaste

-   Klipper — Full featured clipboard manager for the KDE desktop.

http://userbase.kde.org/Klipper || kdebase-workspace

-   loliclip — Clipboard synchronizer developed for window manager
    users. Development ceased in favour of xcmenu.

https://github.com/Cloudef/xcmenu || loliclip

-   Parcellite — Lightweight yet feature-rich clipboard manager.

http://parcellite.sourceforge.net/ || parcellite

-   Pasteall — Clipboard monitor simple and functional.

https://github.com/LaraCraft304/Pasteall || pasteall

-   xcmenu — Clipboard synchronizer developed for window manager users.

https://github.com/Cloudef/xcmenu || xcmenu-git

See also
--------

-   Cut-and-paste in X
-   X Selections, Cut Buffers, and Kill Rings.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Clipboard&oldid=305975"

Category:

-   X Server

-   This page was last modified on 20 March 2014, at 17:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
