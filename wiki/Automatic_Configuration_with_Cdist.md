Automatic Configuration with Cdist
==================================

This page describes how to automatically configure archlinux using
cdist.

Contents
--------

-   1 Introduction
-   2 Preperation
-   3 How to use the types
-   4 Type overview
-   5 Managed Desktop (__nico_managed_desktop)
-   6 Notebook (__nico_notebook)
-   7 Dos gaming station (__nico_dosbox)
-   8 Multimedia Support (__nico_media)
-   9 User based network configuration (__nico_network_user_based)

Introduction
------------

Cdist is a configuration management system. The author of cdist is also
using Archlinux as a target distribution and has some re-usable example
configurations online.

Preperation
-----------

Get the cdist repository with Nicos modications:

    git://git.schottelius.org/cdist-nico

If you want to start brewing your own configuration tree, it is
recommended to get the clean upstream version:

    git://git.schottelius.org/cdist

(you should probably read the documentation on the first in any case)

How to use the types
--------------------

Edit cdist/conf/manifest/init, add your hostname and use the types as
seen on the present hosts. Afterwards run

    ./bin/cdist config -v your-host-name

And then the your-host-name will be configured.

Type overview
-------------

The following types are present and have been tested on Archlinux
systems.

Managed Desktop (__nico_managed_desktop)
----------------------------------------

This type is mainly focussed to create a computer usable by non-geeks.

Features:

-   User can shutdown, suspend the computer (pm-utils)
-   Graphical user login (slim)
-   LXDE Desktop environment
-   Office suite (Libreoffice)
-   Browser (chromium)
-   User can configure network (using wicd)

Notebook (__nico_notebook)
--------------------------

This is the highly personal tuned notebook configuration. Used every 2-3
years when changing the notebook. It contains everything necessary to
work (highy biased opinion there).

Some features:

-   LaTeX, i3, mplayer, nfs, wireshark, ...

Dos gaming station (__nico_dosbox)
----------------------------------

This type contains a dosbox installation + some sample games. If you
don't know what dos is, you don't need this type.

Multimedia Support (__nico_media)
---------------------------------

Ever searched for tool X to do multimedia action Y? It's probably
included in here.

Features:

-   Image viewer
-   Image manipulation
-   Drawing
-   Video playback
-   CD/DVD backup

User based network configuration (__nico_network_user_based)
------------------------------------------------------------

This type allows the user to manage the network using wicd. Included are
the cli and gui versions.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Automatic_Configuration_with_Cdist&oldid=235940"

Category:

-   System administration

-   This page was last modified on 18 November 2012, at 23:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
