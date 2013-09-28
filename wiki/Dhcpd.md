Dhcpd
=====

dhcpd is the Internet Systems Consortium DHCP Server. It is useful for
instance on a machine acting as a router on a LAN.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Tips and Tricks                                                    |
|     -   3.1 Listening on only one interface                              |
|                                                                          |
| -   4 Notes                                                              |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the dhcp package, available in the official repositories.

Configuration
-------------

Assign an static IPv4 address to the interface you want to use (usually
eth0). The first 3 bytes of this address cannot be exactly the same as
those of another interface.

    # ip link set up dev eth0
    # ip addr add 139.96.30.100/24 dev eth0 # arbitrary address

To have your static ip assigned at boot, you can use netcfg.

The default dhcpd.conf contains many uncommented examples, so relocate
it

    # mv /etc/dhcpd.conf /etc/dhcpd.conf.example

Edit the configuration file to contain:

    /etc/dhcpd.conf

    # Using the google's dns in the example.
    # Change it to 139.96.30.100 if you have a dns server installed
    option domain-name-servers 8.8.8.8;
    option subnet-mask 255.255.255.0;
    option routers 139.96.30.100;
    subnet 139.96.30.0 netmask 255.255.255.0 {
      range 139.96.30.150 139.96.30.250;
    }

Start, and optionally, enable for autostart on boot, the dhcpd4.service
daemon.

Read Daemons for more information.

Now, any computer you connect over ethernet will be assigned an IPv4
address (from 139.96.30.150 to 139.96.30.250 in this example).

Tips and Tricks
---------------

> Listening on only one interface

If your computer is already part of one or several networks, it could be
a problem if your computer starts giving ip addresses to machines from
the other networks.

In order to force the DHCP server to listen only on one of the network
interfaces, you need to specify it in the dhcpd command line.

This is done by editing the configuration file:

    /etc/conf.d/dhcp

    # Assuming the device of your lan is eth1
    DHCP4_ARGS="-q eth1"

Another step is to tell the routing table on which interface to listen
to for the 255.255.255.255 broadcasts:

    # ip route add 255.255.255.255 dev eth1

Now, the clients on eth1 will be managed by your DHCP server without
having any impact on any client / server on any other ntework interface.

Notes
-----

You will see configuration files, etc. related to dhcpcd. That one is
the DHCP client executable and has nothing to do with dhcpd.

See also
--------

-   Dhcpcd

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dhcpd&oldid=241614"

Category:

-   Networking
