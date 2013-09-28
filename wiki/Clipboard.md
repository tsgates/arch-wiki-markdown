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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 History                                                            |
| -   2 Background                                                         |
| -   3 Clipboard Managers                                                 |
| -   4 Resources                                                          |
+--------------------------------------------------------------------------+

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

Clipboard Managers
------------------

There is a variety of clipboard managers available, and several desktop
environments come with their own clipboard manager or have a clipboard
manager intended for them (Glipper for GNOME and Clipman for Xfce);
however, there are several DE-agnostic clipboard managers such as
Parcellite (GTK+) and autocutsel (command-line), both of which are
available in [community] and can be run as daemons.

Resources
---------

-   List of clipboard manager packages

-   Cut-and-paste in X

-   X Selections, Cut Buffers, and Kill Rings.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Clipboard&oldid=244008"

Category:

-   X Server
