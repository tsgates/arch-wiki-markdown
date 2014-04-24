Enhanceio
=========

Contents
--------

-   1 Introduction
-   2 Installation
    -   2.1 Setting up the module and drives
    -   2.2 Getting information on caches

Introduction
------------

EnhanceIO makes it possible to use an SSD as a caching device for any
other type of block device storage (HDD, Network, you name it) with
almost zero configuration. Based on Flashcache is it much simpler to set
up. Unlike Bcache there is no need to convert file systems.

Warning:As always be careful and read the documentation carefully before
attempting to use EnhanceIO, do not confuse your HDD and SDD and make
sure the SSD does not have any important data on it.

Installation
------------

Install enhanceio-git from the AUR.

Note:Throughout the page, /dev/sda will be used to indicate the slow
drive and /dev/sdb will be used to indicate the fast drive. Be sure to
change these examples to match your setup.

> Setting up the module and drives

The EnhanceIO command line interface (eio_cli) is used to manage your
setup. Set up caching on your fast ssd for your slow hdd like so:

    # eio_cli create -d /dev/sda -s /dev/sdb -c my_first_enhanceio

This will use the default options which are safe, if you want to enhance
speed even further you might want to add -m wb to enable WriteBack mode
instead of WriteThrough. This might put data itegrity at risk though.

The cache drive is persistent now, which means even after a reboot it
will still be used. If you want to deactive it first set the cache into
read-only mode to not lose any yet unwritten blocks

    # eio_cli edit -c my_first_enhanceio -m ro

Then wait until

    $ grep nr_dirty /proc/enhanceio/enchanceio_test/stats

returns 0. Now all the blocks have been written to your slow hdd and
it's safe to delete the caching device:

    # eio_cli delete -c my_first_enhanceio

> Getting information on caches

To get basic information on caches in use try

    # eio_cli info

To get detailed information use

    $ cat /proc/enhanceio/my_first_enhanceio/stats

Tip:After initiating EnhanceIO I felt that my system had become more
sluggish, this seems to be due to building up the cache first. Use your
system like you normally would and open up those applications you would
want to start quickly, maybe give it another reboot and observe how
things fly.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Enhanceio&oldid=301934"

Category:

-   File systems

-   This page was last modified on 24 February 2014, at 20:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
