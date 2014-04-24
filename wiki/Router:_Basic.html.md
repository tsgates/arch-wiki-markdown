Router: Basic
=============

  

Contents
--------

-   1 DRAFT
-   2 Description
-   3 Ethernet Devices
    -   3.1 Installation
    -   3.2 Names
    -   3.3 IP Settings
-   4 LAN Setup
    -   4.1 dnsmasq
    -   4.2 Static-Route
-   5 IP Masquerading and Firewall
    -   5.1 Kernel Settings
    -   5.2 Shorewall

DRAFT
=====

This article is a draft. It may be more helpful/secure to use Router
until this article is more complete.

Description
===========

If you'd like to build a router to forward connections to LAN client(s),
you'll need the details of creating a basic router. A router is required
in order to connect multiple machines to the Internet using the a single
global IP address. This is almost always the case for residential
Internet access. The Arch Linux machine will fulfill several roles
required to connect machines in a local network to the Internet:

-   Firewall - Block unauthorized packets but allow authorized traffic
-   IP Masquerading - Manipulate IP addresses as packets cross between
    internal network and Internet
-   DHCP Server - Manage IP addresses of machines in the internal
    network
-   DNS Server - Accept DNS lookups from local machines and forward them
    to the Internet
-   Gateway - Translate between protocols of the internal network and
    your Internet Service Provide (optional)

Ethernet Devices
================

Installation
------------

You'll need to have at least two Network Card Interfaces (NIC's) on the
computer you plan to use as a router. Once installed see that they are
recognized by the kernel:

    $ ip a

If the NIC(s) do not show up, then either 1) the kernel module (driver)
will need be loaded, 2) the kernel will need to be rebuilt with support
for the hardware, or 3) the kernel may not have support for the driver
yet.

If there is a kernel module for you NIC, the generic Arch Linux kernel
will likely have support for it. You can add it by:

    modprobe <device-module>

If there is support in the kernel, but not in the Arch kernel take a
look at Kernel Compilation with ABS.

Names
-----

Udev is the device manager for Arch Linux and can be used to manually
choose names for each ethernet device. This should be done to make sure
that each physical network connection always has the same name, and also
for convenience during later configuration steps.

Create a Udev rule /etc/udev/rules.d/10-network.rules

    SUBSYSTEM=="net", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="wan"
    SUBSYSTEM=="net", ATTR{address}=="ff:ee:dd:cc:bb:aa", NAME="lan"

You can easily find the address of an existing device:

    udevadm info -a -p /sys/class/net/<device> | grep address

Just use the output as the second field in the rules file. Next time
Udev assigns device names it will use these. This article assumes "wan"
connects to the Internet and that "lan" connects to the local network.

IP Settings
-----------

Each ethernet device's IP configuration needs to be set in /etc/rc.conf:

    wan="dhcp"
    lan="lan 192.168.0.0 netmask 255.255.255.0 broadcast 192.168.0.255"
    INTERFACES=(wan lan)

The device wan will request a dynamic IP address from the ISP. The
device lan will use a static IP address. Later on dnsmasq will be
configured used to grant dhcp leases to other local machines in the same
subnet, i.e. with address in the range 192.168.0.1-192.168.0.255 (but
not 192.168.0.0 because the router has that local address).

LAN Setup
=========

For connecting to/from your LAN client(s), you can have to either add to
the router a DHCP server (which will build the LAN client's routes for
you) or define a static-route(s) manually. There might be problems is
both methods are used.

dnsmasq
-------

Install dnsmasq

    # pacman -S dnsmasq

Edit the dnsmasq configuration file /etc/dnsmasq.conf:

    # Only listen to routers' LAN NIC.  Doing so opens up tcp/udp port 53 to
    # localhost and udp port 67 to world:
    interface=lan

    # dnsmasq will open tcp/udp port 53 and udp port 67 to world to help with
    # dynamic interfaces (assigning dynamic ips). Dnsmasq will discard world
    # requests to them, but the paranoid might like to close them and let the 
    # kernel handle them:
    bind-interfaces

    # Dynamic range of IPs to make available to LAN pc
    dhcp-range=192.168.0.1,192.168.0.255,12h

    # If you’d like to have dnsmasq assign static IPs, bind the LAN computer's
    # NIC MAC address:
    dhcp-host=aa:bb:cc:dd:ee:ff,192.168.0.1

Static-Route
------------

To assign a static-route (for example on a Arch Linux LAN client):

    eth0="eth0 192.168.0.100 netmask 255.255.255.0 broadcast 192.168.0.255"
    gateway="default gw 192.168.0.7"
    ROUTES=(gateway)

IP Masquerading and Firewall
============================

Kernel Settings
---------------

The kernel will need to be told it's allowed to forward packets to/from
the LAN clients:

    echo 1 > /proc/sys/net/ipv4/ip_forward

To permanently set this, enable ip forwarding in
/etc/sysctl.d/40-ip-forward.conf:

    net.ipv4.ip_forward=1

Shorewall
---------

See Shorewall.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Router:_Basic&oldid=282632"

Category:

-   Networking

-   This page was last modified on 13 November 2013, at 12:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
