Netatalk
========

Netatalk is a free, open-source implementation of the Apple Filing
Protocol (AFP). It allows Unix-like operating systems to serve as file
servers for Macintosh computers.

Contents
--------

-   1 Installation
    -   1.1 Choosing Features
-   2 Configuration
    -   2.1 Netatalk
    -   2.2 Netatalk-ddp
        -   2.2.1 System
        -   2.2.2 Volumes
-   3 IP Tables
-   4 Enable Bonjour/Zeroconf

Installation
------------

Netatalk v3 is availabe as netatalk in the AUR.

The older version of netatalk, v2, is distributed as netatalk-ddp and
supports the Apple Macintosh network protocols, including AppleTalk
(ATalk), Apple Filing Protocol (AFP), and Printer Access Protocol (PAP).

> Choosing Features

With the deprecation of DDP (and therefore ATalk, PAP, timelord, and
a2boot), netatalk also dropped these features in netatalk>=3.0. The
legacy 2.x branch with DDP support is still available in the AUR as
netatalk-ddp. DDP is only necessary to support Mac OS <= 9, but OS X <=
10.3 will also benefit from the integration of SLP since it does not
fully support Bonjour/Zeroconf. DDP would network older Macs which ran
on AppleTalk instead of TCP/IP, and timelord and a2boot were for
time-synchronization and Apple II booting. PAP may still be necessary
for users with LaserWriter printers without TCP/IP support.

-   Install netatalk if you only need the "modern" features cnid_metad
    and afpd, with Bonjour/Zeroconf support only.
-   Install netatalk-ddp to build the full complement of legacy features
    with SLP support.

Configuration
-------------

Enable and/or start netatalk.service using systemd.

Besides the configuration files that are installed (and checked during
upgrade), netatalk may generate two files
/etc/netatalk/afp_signature.conf or
/var/state/netatalk/afp_signature.conf which holds the system UUID, and
/etc/netatalk/afp_voluuid.conf or /var/state/netatalk/afp_voluuid.conf
which holds volume UUIDs for TimeMachine. These files may remain after
package removal and should be kept in most cases to disambiguate the
services broadcast over the local network.

> Netatalk

Note:Users moving from 2.x to 3.x should be aware that CNID data is no
longer stored in .AppleDB directories alongside the hosted data, but in
/var/state/netatalk/CNID. To upgrade a share, remove any .AppleDB
directories and rebuild with dbd -r <path>.

Netatalk 3.x uses a single configuration file, /etc/afp.conf. See
man afp.conf and the following example (make sure processes have write
access to afpd.log):

    /etc/afp.conf

    [Global]
     mimic model = TimeCapsule6,106
     log level = default:warn
     log file = /var/log/afpd.log
     hosts allow = 192.168.1.0/16

    [Homes]
     basedir regex = /home

    [TimeMachine]
     path = /mnt/timemachine
     valid users = tmuser
     time machine = yes

    [Shared Media]
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
"https://wiki.archlinux.org/index.php?title=Netatalk&oldid=285823"

Category:

-   Networking

-   This page was last modified on 1 December 2013, at 20:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
