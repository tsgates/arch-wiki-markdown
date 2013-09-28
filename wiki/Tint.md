Tint
====

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Tint2.      
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
|     -   1.1 Features                                                     |
|     -   1.2 Requirements                                                 |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 PKGBUILD from AUR                                            |
|     -   2.2 Compiling from source                                        |
|     -   2.3 Other Installation Methods                                   |
|                                                                          |
| -   3 Running Tint                                                       |
| -   4 Other Resources                                                    |
+--------------------------------------------------------------------------+

Introduction
------------

From the project's homepage:

ttm is a simple panel/taskbar intentionally made for openbox3, but
should also work with other window managers. It's still in early
development so please report bugs :)

> Features

-   background button-border effect (see screenshot)
-   font shadow
-   option to center tasks
-   option to change panel width/height
-   tasks do now squeeze (more or less) when they hit panel edge
-   middle-click closes window
-   left-click toggles shade

> Requirements

In order to grab the latest (svn) snapshot of tint's source code, you'll
need to install subversion (a versioning system):

    # pacman -S subversion

Installation
------------

Tint is available from the standard repositories:

    # pacman -S tint2

> PKGBUILD from AUR

Tint's PKGBUILD is now available in AUR. Build it with Makepkg and
install with pacman.

The config file will be created on tint's first run at
.config/tint/tintrc

> Compiling from source

Open your favourite terminal and enter:

    $ svn checkout http://ttm.googlecode.com/svn/trunk/ ttm
    $ cd ./ttm/src
    $ make
    $ sudo make install

Now copy the sample config:

    $ cd ..
    $ mkdir -p ~/.config/tint/
    $ cp config_sample ~/.config/tint/tintrc

> Other Installation Methods

Edit your /etc/pacman.conf and add:

    [rfad]
    # Repository made by haxit | Contact: requiem [at] archlinux.us for package suggestions!
    Server = http://web.ncf.ca/ey723/archlinux/repo/

And then run the following:

    pacman -S tint

Running Tint
------------

You should now be able to launch tint as you would any other application
(e.g. Alt+F2 -> tint). To run it at startup, you can add it to the
~/.xinitrc, or ~/.config/openbox/autostart file, for example:

    xscreensaver -no-splash &
    eval `cat $HOME/.fehbg` &
    conky &
    visibility &
    tint &
    exec openbox-session

Other Resources
---------------

Tint 0.6 Documentation (PDF)

Tint2 0.7 Documentation (PDF)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tint&oldid=216168"

Category:

-   Eye candy
