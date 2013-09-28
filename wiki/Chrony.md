Chrony
======

This article describes how to set up and run Chrony, an alternative NTP
client and server that is roaming friendly and designed specifically for
systems that are not online all the time.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Telling chronyd an internet connection has been made         |
|                                                                          |
| -   3 Usage                                                              |
|     -   3.1 Starting chronyd                                             |
|     -   3.2 Synchronising chrony hardware clock from the system clock    |
|     -   3.3 Using NetworkManager to let chronyd go online                |
|                                                                          |
| -   4 Alternatives                                                       |
| -   5 See also                                                           |
| -   6 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

chrony is available from the official repositories.

Configuration
-------------

The first thing you define in your /etc/chrony.conf is the servers your
machine will synchronize to. NTP servers are classified in a
hierarchical system with many levels called strata: the devices which
are considered independent time sources are classified as stratum 0
sources; the servers directly connected to stratum 0 devices are
classified as stratum 1 sources; servers connected to stratum 1 sources
are then classified as stratum 2 sources and so on.

It has to be understood that a server's stratum cannot be taken as an
indication of its accuracy or reliability. Typically, stratum 2 servers
are used for general synchronization purposes: if you do not already
know the servers you are going to connect to, you should use the
pool.ntp.org servers (alternate link) and choose the server pool that is
closest to your location.

The following lines are just an example:

    server 0.pool.ntp.org
    server 1.pool.ntp.org
    server 2.pool.ntp.org
    server 3.pool.ntp.org

If your computer is not connected to the internet on startup, it is
recommended to use the offline option, to tell chrony not to try and
connect to the servers, until it has been given the go:

    server 0.pool.ntp.org offline
    server 1.pool.ntp.org offline
    server 2.pool.ntp.org offline
    server 3.pool.ntp.org offline

It may also be a good idea to either use IP addresses instead of host
names, or to map the hostnames to IP addresses in your /etc/hosts file,
as DNS resolving won't be available until you've made a connection.

To tell chronyd that a connection has been established, you need to be
able to log in with chronyc. You will have to configure chronyd with an
administrator password to be able to do this. Setting up an
administrator password is as simple as creating the file
/etc/chrony.keys with a single line:

    /etc/chrony.keys

    1 xyzzy

as well as adding the following line somewhere in /etc/chrony.conf:

    commandkey 1

The smallest useful configuration file (using IP addresses instead of a
hostname) would look something like:

    /etc/chrony.conf

    server 1.2.3.4 offline
    server 5.6.7.8 offline
    server 9.10.11.12 offline
    rtcfile /etc/chrony.rtc
    rtconutc
    keyfile /etc/chrony.keys
    commandkey 1
    driftfile /etc/chrony.drift

> Telling chronyd an internet connection has been made

For this to work, you'll need to configure the commandkey option in
/etc/chrony.conf as shown above. If you've done this, start chronyc and
enter the following commands if you are connected to the internet:

    chronyc> password xyzzy
    200 OK
    chronyc> online
    200 OK
    chronyc> exit

Chrony should now connect to the configured time servers and update your
clock if needed.

To tell chrony that you are not connected to the internet anymore,
execute the following:

    chronyc> password xyzzy
    200 OK
    chronyc> offline
    200 OK
    chronyc> exit

In conclusion, don't forget the user guide at
/usr/share/doc/chrony/chrony.txt, which is likely to answer any doubts
you could still have. It is also available online. See also the related
man pages: man {chrony|chronyc|chronyd|chrony.conf}).

Usage
-----

> Starting chronyd

The package provides chrony.service, see systemd for details.

> Synchronising chrony hardware clock from the system clock

During boot the initial time is read from the hardware clock (RTC) and
the system time is then set, and synchronised over a period of minutes
once the chrony daemon has been running for a while. If the hardware
clock is out of sync then the initial system time can be some minutes
away from the true time. If that is the case it may be necessary to
reset the hardware clock.

You can use chronyc to force the current system time to be synced to
hardware:

    # chronyc> password zyxxy
    Password:
    200 OK
    chronyc> trimrtc
    200 OK
    chronyc> quit

Then exit from chronyc and the RTC and system time should be within a
few microseconds of each other and should then be approximately correct
on boot and fully synchronise a short time later.

> Using NetworkManager to let chronyd go online

chronyd can be go into online/offline mode along with a network
connection through the use of NetworkManager's dispatcher scripts. You
can install networkmanager-dispatcher-chrony from the AUR.

Alternatives
------------

Alternatives to the Chrony, are NTPd, the reference implementation of
NTP, and OpenNTPD, part of the OpenBSD project and currently not
maintained for Linux.

See also
--------

-   Time (for more information on computer timekeeping)

External links
--------------

-   http://chrony.tuxfamily.org/
-   http://www.ntp.org/
-   http://support.ntp.org/
-   http://www.pool.ntp.org/
-   http://www.eecis.udel.edu/~mills/ntp/html/index.html
-   http://www.akadia.com/services/ntp_synchronize.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=Chrony&oldid=248886"

Category:

-   Networking
