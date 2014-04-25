Bridge with netctl
==================

A bridge is a piece of software used to unite two or more network
segments. A bridge behaves like a virtual network switch, working
transparently (the other machines don't need to know or care about its
existence). Any real devices (e.g. eth0) and virtual devices (e.g. tap0)
can be connected to it.

This article explains how to create a bridge that contains at least an
ethernet device. This is useful for things like the bridge mode of QEMU,
setting a software based access point, etc.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Tips and tricks
    -   3.1 Manually adding/removing network devices
    -   3.2 Wireless interface on a bridge

Installation
------------

Install the netctl package from the official repositories.

Install the bridge-utils package from the official repositories.

Configuration
-------------

-   Copy /etc/netctl/examples/bridge to /etc/netctl/bridge.
-   In this example, we create a bridge called br0 which has real
    Ethernet adapter eth0 and (optionally) a tap device tap0 connected
    to it. Of course, edit br0, eth0 and tap0 to your needs.

    /etc/netctl/bridge

    Description="Example Bridge connection"
    Interface=br0
    Connection=bridge
    BindsToInterfaces=(eth0 tap0)
    IP=dhcp

Tip:If you are using static IP, see man pages of netctl, and also edit
/etc/resolv.conf if necessary.

-   You can bridge any combination of network devices editing
    BindsToInterfaces option.
-   If any of the bridged devices (e.g. eth0, tap0) had dhcpcd enabled,
    stop and disable the dhcpcd@eth0.service daemon. Or set IP=no to the
    netctl profiles.
-   Finally, start and enable your /etc/netctl/bridge.

Tips and tricks
---------------

> Manually adding/removing network devices

The bridge-utils package provides tool brctl to manipulate bridges. You
can use it to manually add or remove a device from a bridge:

    # brctl addif br0 eth1
    # brctl delif br0 eth0

See brctl(8)

> Wireless interface on a bridge

To add a wireless interface to a bridge, you first have to assign the
wireless interface to an access point or start an access point with
hostapd. Otherwise the wireless interface won't be added to the bridge.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bridge_with_netctl&oldid=303030"

Category:

-   Networking

-   This page was last modified on 3 March 2014, at 15:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
