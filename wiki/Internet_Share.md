Internet Share
==============

This article explains how to share the internet connection from one
machine to other(s).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Static IP address                                            |
|     -   2.2 Enable packet forwarding                                     |
|     -   2.3 Enable NAT                                                   |
|     -   2.4 Assigning ip addresses to the client pc(s)                   |
|         -   2.4.1 Manually adding an ip                                  |
|                                                                          |
| -   3 Troubleshooting                                                    |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Requirements
------------

-   The machine acting as server should have an additional network
    device
-   That network device should be connected to the machines that are
    going to receive internet access. They can be one or more machines.
    To be able to share internet to several machies a switch is
    required. If you are sharing to only one machine, a crossover cable
    is sufficient

Note:If one of the two computers has a gigabit ethernet card, a
crossover cable is not necessary and a regular ethernet cable should be
enough

Configuration
-------------

Using Udev#Setting static device names, name the network device
connected to the other computer(s) as net0 and the network device
connected to the internet as internet0.

> Static IP address

Assign an static IPv4 address to the interface connected to the other
machines. The first 3 bytes of this address cannot be exactly the same
as those of another interface.

    # ip link set up dev net0
    # ip addr add 139.96.30.100/24 dev net0 # arbitrary address

To have your static ip assigned at boot, you can use netcfg.

> Enable packet forwarding

Enter this command to temporaly enable packet forwarding:

    sysctl net.ipv4.ip_forward=1

Edit /etc/sysctl.conf and add this line, which will make the previous
change persistent after a reboot.

    net.ipv4.ip_forward=1

If you are using ipv6, use these lines:

    net.ipv6.conf.default.forwarding=1
    net.ipv6.conf.all.forwarding=1

> Enable NAT

Install the package iptables from the official repositories.

Use iptables to enable NAT:

    # iptables -t nat -A POSTROUTING -o internet0 -j MASQUERADE
    # iptables-save > /etc/iptables/iptables.rules
    # systemctl start iptables

Note: Of course, this also works with a mobile broadband connection
(usually called ppp0 on PC1)

You can set iptables.service to auto start a boot.

Read the iptables article for more information.

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

    ip addr add 139.96.30.120/24 dev eth0
    ip link set up dev eth0
    ip route add default via 139.96.30.100 dev eth0

Add a nameserver:

    echo "nameserver <nameserver ip>" >> /etc/resolv.conf

You can figure out the address of the nameserver by looking into the
/etc/resolv.conf of the server, if its Internet connection is already
established. If you don't have a nameserver, you can use Google Public
DNS which is relatively fast. Its addresses are 8.8.8.8 and 8.8.4.4.

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

-   Sharing ppp connection with wlan interface
-   Simple stateful firewall
-   Router
-   USB 3G Modem

Retrieved from
"https://wiki.archlinux.org/index.php?title=Internet_Share&oldid=251036"

Category:

-   Networking
