Wireshark
=========

Wireshark is a free and open-source packet analyzer. It is used for
network troubleshooting, analysis, software and communications protocol
development, and education. Originally named Ethereal, in May 2006 the
project was renamed Wireshark due to trademark issues.

Contents
--------

-   1 Installation
-   2 Capturing as normal user
-   3 A few capturing techniques
    -   3.1 Filtering TCP packets
    -   3.2 Filtering UDP packets
    -   3.3 Filter packets to a specific IP Address

Installation
------------

The wireshark package has been split into the CLI version and GTK
frontend, which depends on the CLI.

CLI version can be installed with the package wireshark-cli, available
in the official repositories.

GTK frontend can be installed with the package wireshark-gtk, available
in the official repositories.

Capturing as normal user
------------------------

Running Wireshark as root is insecure.

Arch Linux uses method from Wireshark wiki to separate privileges. When
wireshark-cli is installed, install script sets /usr/bin/dumpcap
capabilities.

    $ getcap /usr/bin/dumpcap

    /usr/bin/dumpcap = cap_net_admin,cap_net_raw+eip

/usr/bin/dumpcap is the only process that has privileges to capture
packets. /usr/bin/dumpcap can only be run by root and members of the
wireshark group.

To use wireshark as a normal user, add user to the wireshark group:

    # gpasswd -a "username" wireshark

Another way is to use sudo to temporarily change group to wireshark. The
following line allows all users in the wheel group to run programs with
GID set to wireshark GID:

    %wheel ALL=(:wireshark) /usr/bin/wireshark, /usr/bin/tshark

Then run wireshark with

    $ sudo -g wireshark wireshark

A few capturing techniques
--------------------------

There are a number of different ways to capture exactly what you are
looking for in Wireshark, by applying filters.

Note:To learn the filter syntax, see man pcap-filter(7).

> Filtering TCP packets

If you want to see all the current TCP packets, type tcp into the
"Filter" bar.

> Filtering UDP packets

If you want to see all the current UDP packets, type udp into the
"Filter" bar.

> Filter packets to a specific IP Address

-   If you would like to see all the traffic going to a specific
    address, enter ip.dst == 1.2.3.4, replacing 1.2.3.4 with the IP
    address the outgoing traffic is being sent to.

-   If you would like to see all the incoming traffic for a specific
    address, enter ip.src == 1.2.3.4, replacing 1.2.3.4 with the IP
    address the incoming traffic is being sent to.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wireshark&oldid=287298"

Categories:

-   Security
-   Networking

-   This page was last modified on 8 December 2013, at 21:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
