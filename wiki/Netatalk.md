Netatalk
========

Netatalk v3.0 is a free, open-source implementation of the Apple Filing
Protocol (AFP). It allows Unix-like operating systems to serve as file
servers for Macintosh computers.

The older version of netatalk, v2.2.3, is distributed as netatalk-ddp
and supports the Apple Macintosh network protocols, including AppleTalk
(ATalk), Apple Filing Protocol (AFP), and Printer Access Protocol (PAP).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Compiling                                                          |
|     -   1.1 Choosing Features                                            |
|                                                                          |
| -   2 Installation                                                       |
|     -   2.1 Netatalk-ddp Initscripts                                     |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Netatalk                                                     |
|     -   3.2 Netatalk-ddp                                                 |
|         -   3.2.1 System                                                 |
|         -   3.2.2 Volumes                                                |
|                                                                          |
| -   4 IP Tables                                                          |
| -   5 Enable Bonjour/Zeroconf                                            |
+--------------------------------------------------------------------------+

Compiling
---------

Use either the netatalk or netatalk-ddp packages available in AUR, which
have initscripts tailored for ArchLinux.

> Choosing Features

With the deprecation of DDP (ATalk, PAP, timelord, and a2boot were
removed in v3.0), netatalk has been divided into netatalk and
netatalk-ddp. DDP is only necessary to support Mac OS <= 9, but OS X <=
10.3 will also benefit from the integration of SLP since it does not
fully support Bonjour/Zeroconf. DDP would network older Macs which ran
on AppleTalk instead of TCP/IP, and timelord and a2boot were for
time-synchronization and Apple II booting. PAP may still be necessary
for users with LaserWriter printers without TCP/IP support.

A build of the netatalk AUR package will only build the "modern"
features cnid_metad and afpd, with Bonjour/Zeroconf support only.

To build the full complement of features with SLP support, build
netatalk-ddp instead.

Installation
------------

Install your finished package with pacman as usual, and remember to
systemctl enable netatalk.service.

Besides the configuration files that are installed (and checked during
upgrade), netatalk may generate two files
/etc/netatalk/afp_signature.conf or
/var/state/netatalk/afp_signature.conf which holds the system UUID, and
/etc/netatalk/afp_voluuid.conf or /var/state/netatalk/afp_voluuid.conf
which holds volume UUIDs for TimeMachine. These files may remain after
package removal and should be kept in most cases to disambiguate the
services broadcast over the local network.

> Netatalk-ddp Initscripts

Warning:This section is now outdated

To emulate the init functionality of the systems fully-supported by
netatalk, one initscript "netatalk" is responsible for starting and
stopping the individual daemons. The script checks for the binaries
available on the system, and starts them in a specific order, skipping
those that are already running. The stop process occurs in reverse. To
prevent ambiguity, only "netatalk" registers as a daemon with the
system, but is silent, it does not echo any messages. The individual
initscripts echo to the terminal, but do not register as daemons to
prevent confusion.

The individual scripts are provided for users who may want to manage the
daemons at runtime or add specific arguments, but do not worry, they
will obey the necessary dependencies for proper operation. If a daemon
is required by others, it will not stop until its children are not
running; if a daemon has dependencies it will not start until these are
met.

Configuration
-------------

> Netatalk

Netatalk 3.x uses a single configuration file, /etc/afp.conf, and a
single service, netatalk. Users moving from 2.x to 3.x should be aware
that CNID data is no longer stored in .AppleDB directories alongside the
hosted data, but in /var/state/netatalk/CNID. To upgrade a share, remove
any .AppleDB directories and rebuild with dbd -r <path>.

See man afp.conf and the following example (ensuring processes have
write access to afpd.log):

    /etc/afp.conf

    [Global]
    mimic model = TimeCapsule6,106
    log level = default:warn
    log file = /var/log/afpd.log
    hosts allow = 192.168.1.0/16

    [TimeMachine]
    path = /mnt/timemachine
    valid users = tmuser
    time machine = yes

    [media]
    path = /srv/share/media
    valid users = joe sam

Warning:Avoid using symbolic links in afp.conf

> Netatalk-ddp

System

Edit the afpd configuration file (/etc/netatalk/afpd.conf), and add a
line similar to

    /etc/netatalk/afpd.conf

    ...- -mimicmodel TimeCapsule6,106 -setuplog "default log_warn /var/log/afpd.log"

This tells netatalk to use the system's hostname, mimic a TimeCapsule,
and log warnings and errors to file.

Volumes

Edit the volumes configuration file /etc/netatalk/AppleVolumes.default,
and append the following to add a TimeMachine-like share

    /etc/netatalk/AppleVolumes.default

    ...<path_to_share> <sharename> allow:<username> options:usedots,upriv,tm

-   The volsizelimit:<limit_in_whole_mebibytes> argument can be useful
    here to limit the total space reported to TimeMachine.
-   If you wish to turn off "home" shares, change the ~ line to #~.

Warning:Avoid nesting volumes, and do not share directories by any other
protocol. All file changes must be made via afpd only

IP Tables
---------

If you use the iptables package for firewall services, consider adding
the following: (replace -I with -A as necessary)

    Bonjour/Zeroconf

    iptables -I INPUT -p udp --dport mdns -d 224.0.0.251 -j ACCEPT
    iptables -I OUTPUT -p udp --dport mdns -d 224.0.0.251 -j ACCEPT

    AFP

    iptables -I INPUT -p tcp --dport afpovertcp -j ACCEPT

    SLP

    iptables -I INPUT -p tcp --dport slp -j ACCEPT
    iptables -I OUTPUT -p tcp --dport slp -j ACCEPT
    iptables -I INPUT -p udp --dport slp -j ACCEPT
    iptables -I OUTPUT -p udp --dport slp -j ACCEPT

    AppleTalk

    iptables -I INPUT -p tcp -m multiport --dport at-rtmp,at-nbp,at-echo,at-zis -j ACCEPT
    iptables -I OUTPUT -p tcp -m multiport --dport at-rtmp,at-nbp,at-echo,at-zis -j ACCEPT

Enable Bonjour/Zeroconf
-----------------------

Bonjour/Zeroconf is now a requirement of netatalk and is compiled by
default. No configuration is necessary, netatalk will register its own
services using the dbus link. Make sure you set -mimicmodel to the
desired string (see
/System/Library/CoreServices/CoreTypes.bundle/Contents/Info.plist on a
Mac for a full list).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netatalk&oldid=256145"

Category:

-   Networking
