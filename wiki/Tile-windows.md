Tile-windows
============

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Related articles

-   fluxbox
-   openbox

The Tile-windows application is a tool which allows for the tiling of
windows within non-tiling window manager. It is similar in nature to the
application PyTyle. As an alternative one can use a native tiling window
manager, as explained in the article Window manager#tiling window
managers.

Installation
------------

tile-windows can be installed from from the AUR.

Configuration
-------------

For fluxbox and openbox etc, you need to use:

    $ tile -m

This will follow fluxbox rules to choose only some of the windows to
tile, not all of them.

For GNOME and net-wm etc. you should use:

    $ tile -w

A config file exists in the /etc/tile/rc directory. You may want to make
a copy to your home folder like: /home/yourname/.tile/rc Do NOT change
/etc/tile/rc , because it will not work until you copy it to your .tile
folder.

Then make some changes like change multi-desktop from off to workspace
if you are using fluxbox:

    # Multiple Desktop support.. netwm (GNOME/etc), workspace (*Box/Oroborus/etc), off. Default: off
    # multi-desktop netwm|workspace|off
    multi-desktop workspace

Also you can ignore some of the windows by:

    # X11 Atom / String Value pairs to ignore for calculations and re-placement. No Defaults
    # Syntax: avoid Atom(STRING) value
    avoid WM_NAME Bottom Panel
    avoid WM_NAME Desktop
    avoid WM_CLASS FrontPanel

To find out the application you want to ignore in tiling, run this
command in your terminal:

    $> xprop WM_CLASS

When you mouse become a cross, click on the application window, then
xprop will give you the WM_NAME and WM_CLASS. I add one line like this
for tilda, my pop up command tool:

    avoid WM_CLASS Tilda

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tile-windows&oldid=301205"

Category:

-   Tiling WMs

-   This page was last modified on 24 February 2014, at 11:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
