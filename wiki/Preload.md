Preload
=======

preload is a program written by Behdad Esfahbod which runs as a daemon
and records statistics about usage of programs using Markov chains;
files of more frequently-used programs are, during a computer's spare
time, loaded into memory. This results in faster startup times as less
data needs to be fetched from disk. preload is often paired with
prelink.

Installation
------------

Install preload from the AUR. You may now start the systemd service
preload, and/or enable it in order to start at boot.

Configuration
-------------

The configuration file is located in /etc/conf.d/preload, it contains
default settings that should be suitable for regular users. The cycle
option lets you configure how often to ping the preload system to update
its model of which applications and libraries to cache.

See also
--------

-   http://en.wikipedia.org/wiki/Preload_(software)
-   http://techthrob.com/2009/03/02/drastically-speed-up-your-linux-system-with-preload/
-   Improve boot performance

Retrieved from
"https://wiki.archlinux.org/index.php?title=Preload&oldid=300459"

Category:

-   System administration

-   This page was last modified on 23 February 2014, at 15:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
