vnStat
======

vnStat is a lightweight network traffic monitor. It keeps a network
traffic log on selectable interfaces. Through the command line the
network traffic statistics can be shown.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Setting the interfaces                                       |
|     -   2.2 Updating method                                              |
|         -   2.2.1 Cron                                                   |
|         -   2.2.2 Service                                                |
|         -   2.2.3 Daemon                                                 |
|                                                                          |
|     -   2.3 Global settings                                              |
|                                                                          |
| -   3 Usage                                                              |
| -   4 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

The vnStat package is available in [community]:

    # pacman -S vnstat

Configuration
-------------

> Setting the interfaces

First introduce every interface that needs to be logged to vnStat. For
example a wired interface:

    # vnstat -u -i eth0

Or a wireless interface:

    # vnstat -u -i wlan0

When introducing an interface for the first time there will be an error
message saying 'unable to read database'. If this message is followed by
an info message saying 'a new database has been created' the interface
is successfully introduced. If this is not the case check that the
specified interface is valid.

> Updating method

After introducing the interface(s) set one of the update methods.

Warning: Only use one of the methods, do not use them at the same time!

Cron

The first method is using Cron. A sample of Cron usage is provided with
vnStat at /usr/share/doc/vnstat/examples/vnstat.cron.

Service

The second way is using systemd (and the provided service):

    # systemctl start vnstat.service

Daemon

The third way of updating is using a daemon provided by vnStat. Add
vnstat to your daemons in rc.conf#Daemons.

    DAEMONS=(... network vnstat ...)

> Global settings

Other settings, like settings to control the daemon, can be done in
/etc/vnstat.conf.

Usage
-----

Query the network traffic:

    # vnstat -q

Viewing live network traffic usage:

    # vnstat -l

For all the other options, use:

    # vnstat --help

Or for a complete list, use:

    # vnstat --longhelp

See Also
--------

VnStat Custom WebUI

Retrieved from
"https://wiki.archlinux.org/index.php?title=VnStat&oldid=247279"

Category:

-   Networking
