PeerGuardian Linux
==================

PeerGuardian Linux (pgl) is a privacy oriented firewall application. It
blocks connections to and from hosts specified in huge block lists
(thousands or millions of IP ranges). pgl is based on the Linux kernel
netfilter framework and iptables.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Server
    -   2.2 LAN
-   3 Starting up

Installation
------------

There are two AUR packages to choose from: pgl-cli includes only the
daemon and CLI tools, while pgl comes complete with a GUI (written using
Qt).

Configuration
-------------

-   /etc/pgl/blocklists.list contains a list of URL for retrieving the
    various block lists.
-   /etc/pgl/pglcmd.conf, empty by default, overrides the default
    settings present in /usr/lib/pgl/pglcmd.defaults.
-   /etc/pgl/allow.p2p lists custom IP ranges that will not be filtered.

The default lists in /etc/pgl/blocklists.list block many potentially
legitimate IP address. Users are encouraged to exercise best judgment
and the information available at I-Blocklist.

It is recommended to disable the filtering of HTTP connections by adding
the following to /etc/pgl/pglcmd.conf:

    /etc/pgl/pglcmd.conf

    WHITE_TCP_OUT="http https"

Some program might not be able to reach the outside world. For instance,
users of MSN for instant messaging, will need to add port 1863 to the
white list:

    /etc/pgl/pglcmd.conf

    WHITE_TCP_OUT="http https msnp"

Conversely, one could white list all the ports except the ones used by
the program to be blocked. The following example only use the block
lists to stop incoming traffic on ports 53 (DNS) and 80 (HTTP):

    /etc/pgl/pglcmd.conf

    WHITE_TCP_IN="0:79 81:65535"
    WHITE_UDP_IN="0:52 54:65535"

> Server

systemd initialization of the system means that it's quite possible for
a server to be briefly unprotected, prior to pgl launch. To ensure
adequate protection, create a service file named after the original
server (i.e. /etc/systemd/system/httpd.service and paste the following:

    /etc/systemd/system/httpd.service

    .include /usr/lib/systemd/system/httpd.service

    [Unit]
    Wants=pgl.service
    After=pgl.service

> LAN

By default, pgl blocks traffic on the local IPv4 addresses. To disable
this behavior, edit /etc/pgl/pglcmd.conf to add an exception using the
WHITE_IP_* setting:

    /etc/pgl/pglcmd.conf

    WHITE_IP_OUT="192.168.0.0/24"

    /etc/pgl/pglcmd.conf

    WHITE_IP_IN="192.168.0.0/24"

For further information, please refer to the # Whitelist IPs # section
of /usr/lib/pgl/pglcmd.defaults.

Starting up
-----------

Once comfortable with the configuration of both the daemon and lists,
start the pgl service. To make sure that pgl works as intended, issue
this command:

    # pglcmd test

To start pgl automatically at boot, enable the pgl service.

Retrieved from
"https://wiki.archlinux.org/index.php?title=PeerGuardian_Linux&oldid=281660"

Category:

-   Firewalls

-   This page was last modified on 6 November 2013, at 09:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
