llpp
====

llpp is a lightweight, fast and featureful PDF viewer based on MuPDF.

Contents
--------

-   1 Installation
-   2 Usage
-   3 Configuration
-   4 Tips and Tricks
    -   4.1 Reload File
    -   4.2 Remote Interface
-   5 See also

Installation
------------

llpp can be installed from the AUR using the stable llpp, or the latest
repo version llpp-git.

Usage
-----

llpp uses keyboard shortcuts and the mouse to navigate through a
document. Pressing the h key will bring up a help page where all other
key bindings are described.

Check out the following page for a complete list of the key and mouse
bindings.

Configuration
-------------

llpp uses a configuration file to store settings: ~/.config/llpp.conf.
This file stores: 1) application defaults, and 2) file-by-file user
preferences (e.g. the last page viewed).

Tips and Tricks
---------------

> Reload File

A document can be reloaded in three ways:

-   Pressing the r key
-   Sending a HUP signal to the llpp process

    # killall -SIGHUP llpp

-   Using the "remote" interface (see below)

> Remote Interface

The following commands will setup the remote interface and use it to
reload the file "image.pdf".

    # mkfifo /tmp/llpp.remote
    # llpp -remote /tmp/llpp.remote image.pdf & disown
    # sleep 1
    # echo reload >/tmp/llpp.remote

There are eight remote commands:

-   reload - reload
-   quit - quit
-   goto <page-number> <x-coordinate> <y-coordinate> - goto
-   goto1 <page-number> <relative-y-coordinate> - goto
-   gotor <file-name> <page-number> - goto other document
-   gotord <file-name> <remote-destination> - goto named destination
    within the other document
-   rect <pageno> <color> <x0> <y0> <x1> <y1> - draw a rectangle
-   activatewin - raise and switch to llpp's window

See also
--------

-   llpp git repo

Retrieved from
"https://wiki.archlinux.org/index.php?title=Llpp&oldid=305586"

Category:

-   Graphics and desktop publishing

-   This page was last modified on 19 March 2014, at 12:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
