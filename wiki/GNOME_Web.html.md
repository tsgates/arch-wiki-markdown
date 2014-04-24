GNOME Web
=========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Epiphany is a simple web browser primarily intended for the GNOME
desktop which works acceptably with other desktop environments as well.

Contents
--------

-   1 Installation
-   2 Flash
-   3 Manage Web Apps
-   4 Fix Pixelated Fonts
-   5 See also

Installation
------------

To install Epiphany from the repositories, run:

    # pacman -S epiphany

If you want to save login passwords, install gnome-keyring:

    # pacman -S gnome-keyring

If you are using another desktop environment (DE) other than GNOME, you
will probably have to create directory ~/.gnome2/epiphany. To do so,
type:

    $ mkdir -p ~/.gnome2/epiphany

Flash
-----

Install package flashplugin from official repositories. Then Epiphany
should be able to echo flash content.

Manage Web Apps
---------------

Since version 3.0, Epiphany can add "web app" launchers to GNOME Shell.
You can manage and remove them by typing "about:applications" into the
Epiphany address bar.

Fix Pixelated Fonts
-------------------

Some websites such as github.com tend to use bitmap font from X11, named
Clean.

Easy fix is to disable bitmap fonts, run:

    # ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

See also
--------

The appearance of Epiphany's menu entry may vary depending on the DE, so
please see their articles for further information:

-   GNOME
-   KDE
-   Xfce

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNOME_Web&oldid=300056"

Categories:

-   GNOME
-   Web Browser

-   This page was last modified on 23 February 2014, at 08:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
