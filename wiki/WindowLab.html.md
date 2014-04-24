WindowLab
=========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Introduction
------------

From the WindowLab Homepage:

    What is WindowLab?
    WindowLab is a small and simple window manager of novel design.

    It has a click-to-focus but not raise-on-focus policy, a window resizing 
    mechanism that allows one or many edges of a window to be changed in one 
    action, and an innovative menubar that shares the same part of the screen 
    as the taskbar. Window titlebars are prevented from going off the edge of 
    the screen by constraining the mouse pointer, and when appropriate the 
    pointer is also constrained to the taskbar/menubar in order to make target 
    menu items easier to hit.

Check the homepage out at: http://www.nickgravgaard.com/windowlab/

Installation
------------

Install windowlab from Official repositories.

Configuration
-------------

Note: The following information is outdated, but could still be useful.

Setting up WindowLab in Arch Linux is very simple, and is done just like
it's done in other distros. Download the latest version from the
homepage, unpack it somewhere, your home-dir, /download, /usr/programs
or where you choose to put these kinds of things. Edit stuff in
windowlab.h to change colors, fonts and settings. (Yes, this is compiled
into the binary. Fast but not very beautiful. This is one thing
FonsterLab intends to change.) Then simply make and make install it. To
use it with startx, add a exec windowlab to your .xinitrc. If you use a
display manager, add the line to .xsession instead. The best thing would
probably be to symlink one to the other. The entire installation is
described in commands below.

    $ cd $HOME
    $ wget ~http://www.nickgravgaard.com/windowlab/windowlab-1.32.tar
    $ tar xvf windowlab-1.32.tar
    $ cd windowlab-1.32
    $ vim windowlab.h
    $ make
    $ su
    Password:
    # make install
    # exit
    $ cd ..
    $ rm .xsession
    $ ln -s .xinitrc .xsession
    $ echo exec windowlab > .xinitrc

Please note that the above commands will change if you're using a newer
version of WindowLab, and these are written from the top of my head, so
there are probably errors. Use <TAB> to autocomplete, it helps.

For information on how to use the rather strange window manager, check
the homepage. And do not think you'll figure it out, you won't. It's
very nice when you know it though.

Read also:  
 FonsterLab

* * * * *

Is this a kind of Advertising or what?  
 SB: Actually I was updating the Compaq Armada M700, and didn't know a
lot about phpWiki, so I ended up creating new pages, and couldn't keep
myself from writing stuff in them :D

Retrieved from
"https://wiki.archlinux.org/index.php?title=WindowLab&oldid=301383"

Category:

-   Stacking WMs

-   This page was last modified on 24 February 2014, at 11:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
