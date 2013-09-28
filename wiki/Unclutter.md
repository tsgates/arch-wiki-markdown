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
the mouse cursor. Unclutter is very usefull in tiling wm's where you do
not need the mouse often.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Known Bugs                                                         |
|     -   3.1 Misbehaviour of the mouse cursor                             |
|                                                                          |
| -   4 References                                                         |
+--------------------------------------------------------------------------+

Installation
------------

Unclutter is in [community]:

    # pacman -S unclutter

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
this problem. The details can be found here

There are two known workarounds for this. You can either add
"SDL_VIDEO_X11_DGAMOUSE=0" to your environment variables or run
unclutter with "-grab" option

References
----------

unclutter -- Linux App Finder

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unclutter&oldid=250569"

Category:

-   X Server
