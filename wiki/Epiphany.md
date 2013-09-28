Epiphany
========

  

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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Flash                                                              |
| -   3 Manage Web Apps                                                    |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

To install Epiphany from the repositories, run:

    # pacman -S epiphany

To install Epiphany extensions:

    # pacman -S epiphany-extensions

If you want to save login passwords, install gnome-keyring:

    # pacman -S gnome-keyring

If you are using another desktop environment (DE) other than GNOME, you
will probably have to create directory ~/.gnome2/epiphany. To do so,
type:

    $ mkdir -p ~/.gnome2/epiphany

Flash
-----

Adobe Flash Player is a little buggy and an external utility like
nspluginwrapper has to be used.

    $ pacman -S nspluginwrapper flashplugin
    $ nspluginwrapper -v -n -a -i

Note:As of epiphany 3.8 this is no longer needed.

For 64-bit machines, you'll need to install lib32-flashplugin from the
AUR instead of flashplugin.

Epiphany should now be able to echo flash content.

Manage Web Apps
---------------

Since version 3.0, Epiphany can add "web app" launchers to GNOME Shell.
You can manage and remove them by typing "about:applications" into the
Epiphany address bar.

See also
--------

The appearance of Epiphany's menu entry may vary depending on the DE, so
please see their articles for further information:

-   GNOME
-   KDE
-   Xfce

Retrieved from
"https://wiki.archlinux.org/index.php?title=Epiphany&oldid=254242"

Category:

-   Web Browser
