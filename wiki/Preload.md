Preload
=======

preload is a program written by Behdad Esfahbod which runs as a daemon
and records statistics about usage of programs using Markov chains;
files of more frequently-used programs are, during a computer's spare
time, loaded into memory. This results in faster startup times as less
data needs to be fetched from disk. preload is often paired with
prelink.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running the daemon                                                 |
|     -   2.1 Systemd                                                      |
|     -   2.2 rc.conf (deprecated)                                         |
|                                                                          |
| -   3 Configuration                                                      |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

preload is available through pacman. In Arch Linux, just issue the
command:

    # pacman -S preload

Running the daemon
------------------

> Systemd

Start directly with (as root)

    # systemctl start preload.service

To start preload at system boot, type as root

    # systemctl enable preload.service

> rc.conf (deprecated)

Start directly with

    # /etc/rc.d/preload start

To start preload at system boot, add it to the DAEMONS section in
/etc/rc.conf:

    DAEMONS =(... preload ...)

Configuration
-------------

The configuration file is /etc/preload.conf, it contains default
settings that should be suitable for regular users. The cycle option
lets you configure how often to ping the preload system to update its
model of which applications and libraries to cache.

See also
--------

-   http://en.wikipedia.org/wiki/Preload_(software)
-   http://techthrob.com/2009/03/02/drastically-speed-up-your-linux-system-with-preload/
-   Readahead

Retrieved from
"https://wiki.archlinux.org/index.php?title=Preload&oldid=237407"

Category:

-   System administration
