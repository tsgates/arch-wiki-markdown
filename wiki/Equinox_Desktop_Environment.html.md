Equinox Desktop Environment
===========================

The Equinox Desktop Environment (EDE) is a DE designed to be simple,
extremely light-weight and fast.

It primarily offers the most basic things: A window manager (PekWM is
used by default), a simple GUI including a panel, a daemon watching
removable media and a notification daemon. Other than that there's not
much more than some configuration progams, a calculator, etc. Beginning
with version 2.0, EDE follows the FreeDesktop.org guidelines.

Unlike any other desktop environment, EDE² is based upon the FLTK
toolkit. It's especially fit for systems with little RAM or for users
who want to completely customize their system and need a GUI that is not
already bloated with functions and applications.

Contents
--------

-   1 Installation
    -   1.1 Installation (packages)
    -   1.2 Installation (AUR)
-   2 Starting the DE
-   3 Applications
    -   3.1 Some recommendations

Installation
------------

EDE is not very a very common piece of software. You usually have to
compile it yourself. For Arch Linux there are however pre-built packages
available via a custom repository.

> Installation (packages)

To enable EDE's repository, just add the following lines to your
/etc/pacman.conf:

    [ede]
    SigLevel = Optional
    Server = http://www.equinox-project.org/repos/arch/$arch

Next update the database files:

    # pacman -Syy

Now you can simply install EDE packages via pacman:

    # pacman -S ede

The repository offers EDE split into 4 packages:

-   edelib
-   ede-common
-   ede
-   ede-wallpapers (optional)

> Installation (AUR)

You can also build EDE yourself. Fortunately on Arch there are two
AUR-PKGBUILD files available that allow you to build it without much
hassle.

The first one is edelib which is a dependency for EDE, the other one ede
the actual DE.

Starting the DE
---------------

To bring up EDE you can either use a Display manager or use startx. If
you choose the later, just write the following to the .xinitrc of your
user:

     exec startede

Applications
------------

Since EDE is a bare-bone DE, you will have to add even the most common
applications like a file manager or an editor yourself. It's all your
freedom and choice.

Due to the nature of the DE, it obviously makes sense to install
light-weight software. There are however not that many FLTK applications
available so you will likely have to relay on a second toolkit like GTK+
for example.

> Some recommendations

-   File manager: PCManFM
-   Browser: Dillo or Midori
-   Editor: Leafpad
-   Terminal emulator: Xterm

Retrieved from
"https://wiki.archlinux.org/index.php?title=Equinox_Desktop_Environment&oldid=306059"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 17:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
