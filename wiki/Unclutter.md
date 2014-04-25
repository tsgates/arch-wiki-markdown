Unclutter
=========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Unclutter hides your X mouse cursor when you do not need it, to prevent
it from getting in the way. You have only to move the mouse to restore
the mouse cursor. Unclutter is very useful in tiling window managers
where you do not need the mouse often.

Contents
--------

-   1 Installation
-   2 Usage
-   3 Known Bugs
    -   3.1 Misbehaviour of the mouse cursor
-   4 See also

Installation
------------

Install unclutter from the official repositories.

Usage
-----

Use your .xinitrc file or WM/DE to start unclutter, for .xinitrc add:

    unclutter &

If you experience issues when using unclutter in conjunction with a
tiling window manager (such as xmonad), hhp from the xmonad-utils
package is a useful and lightweight alternative.

Known Bugs
----------

> Misbehaviour of the mouse cursor

Unclutter could cause unusual mouse behaviour in some SDL Games. The
mouse cursor might be reset to some positions in the screen because of
this problem. The details can be found here.

There are two known workarounds for this. You can either add
SDL_VIDEO_X11_DGAMOUSE=0 to your environment variables which does not
work for all games or run unclutter with -grab option. However, it is
important to note that the grab option may cause some applications such
as gksu to not work properly.

See also
--------

http://linuxappfinder.com/package/unclutter - Unclutter on Linux App
Finder

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unclutter&oldid=275305"

Category:

-   X Server

-   This page was last modified on 13 September 2013, at 12:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
