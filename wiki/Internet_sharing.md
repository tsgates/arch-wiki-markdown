Internet sharing
================

This article explains how to share the internet connection from one
machine to other(s).

Contents
--------

-   1 Requirements
-   2 Configuration
    -   2.1 Static IP address
    -   2.2 Enable packet forwarding
    -   2.3 Enable NAT
    -   2.4 Assigning ip addresses to the client pc(s)
        -   2.4.1 Manually adding an ip
-   3 Troubleshooting
-   4 See also

Requirements
------------

-   The machine acting as server should have an additional network
    device.
-   That network device should be connected to the machines that are
    going to receive internet access. They can be one or more machines.
    To be able to share internet to several machines a switch is
    required. If you are sharing to only one machine, a crossover cable
    is sufficient.

Note:If one of the two computers has a gigabit ethernet card, a
crossover cable is not necessary and a regular ethernet cable should be
enough

Configuration
-------------

This section assumes, that the network device connected to the client
computer(s) is named net0 and the network device connected to the
internet as internet0.

Tip:You can rename your devices to this scheme using Udev#Setting static
device names.

> Static IP address

Assign an static IPv4 address to the interface connected to the other
machines. The first 3 bytes of this address cannot be exactly the same
as those of another interface.

    # ip link set up dev net0
    # ip addr add 139.96.30.100/24 dev net0 # arbitrary address

To have your static ip assigned at boot, you can use netctl.

> Enable packet forwarding

Check the current packet forwarding settings;

    # sysctl -a | grep forward

Enter this command to temporarily enable packet forwarding:

    # sysctl net.ipv4.ip_forward=1

Edit /etc/sysctl.d/30-ipforward.conf to make the previous change
persistent after a reboot.

    /etc/sysctl.d/30-ipforward.conf

    net.ipv4.ip_forward=1
    net.ipv6.conf.default.forwarding=1
    net.ipv6.conf.all.forwarding=1

> Enable NAT

Install the package iptables from the official repositories. Use
iptables to enable NAT:

    # iptables -t nat -A POSTROUTING -o internet0 -j MASQUERADE
    # iptables -A FORWARD -i net0 -o internet0 -j ACCEPT
    # iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

Note:Of course, this also works with a mobile broadband connection
(usually called ppp0 on PC1).

Read the iptables article for more information (especially saving the
rule and applying it automatically on boot). There is also an excellent
guide on iptables Simple stateful firewall.

> Assigning ip addresses to the client pc(s)

If you are planning to regularly have several machines using the
internet shared by this machine, then is a good idea to install a dhcp
server.

You can read the dhcpd wiki article, to add a dhcp server. Then, install
the dhcpcd client on every client pc.

If you are not planing to use this setup regularly, you can manually add
an ip to each client instead.

Manually adding an ip

Instead of using dhcp, on each client pc, add an ip address and the
default route:

    # ip addr add 139.96.30.120/24 dev eth0
    # ip link set up dev eth0
    # ip route add default via 139.96.30.100 dev eth0

Configure a DNS server for each client, see resolv.conf for details.

That's it. The client PC should now have Internet.

Troubleshooting
---------------

If you are able to connect the two PCs but cannot send data (for
example, if the client PC makes a DHCP request to the server PC, the
server PC receives the request and offers an IP to the client, but the
client does not accept it, timing out instead), check that you don't
have other Iptables rules interfering.

See also
--------

-   Ad-hoc networking
-   Sharing PPP Connection
-   Simple stateful firewall
-   Router
-   USB 3G Modem

Retrieved from
"https://wiki.archlinux.org/index.php?title=Internet_sharing&oldid=302034"

Category:

-   Networking

-   This page was last modified on 25 February 2014, at 13:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
