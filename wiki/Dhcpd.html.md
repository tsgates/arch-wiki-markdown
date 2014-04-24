dhcpd
=====

Related articles

-   dhcpcd

dhcpd is the Internet Systems Consortium DHCP Server. It is useful for
instance on a machine acting as a router on a LAN.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Tips and Tricks
    -   3.1 Listening on only one interface
        -   3.1.1 Configuring dhcpd
        -   3.1.2 Service file
-   4 See also

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

To have your static ip assigned at boot, see Network
configuration#Static IP address.

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

Start the dhcpd daemon with dhcpd4.service using systemctl. Optionally,
enable it to start automatically on boot.

Now, any computer you connect over ethernet will be assigned an IPv4
address (from 139.96.30.150 to 139.96.30.250 in this example).

Tips and Tricks
---------------

> Listening on only one interface

If your computer is already part of one or several networks, it could be
a problem if your computer starts giving ip addresses to machines from
the other networks. It can be done by either configuring dhcpd or
starting it as a daemon with systemctl.

Configuring dhcpd

In order to exclude an interface, you must create an empty declartion
for the subnet that will be configured on that interface.

This is done by editing the configuration file (for example):

    /etc/dhcpd.conf

    # No DHCP service in DMZ network (192.168.2.0/24)
    subnet 192.168.2.0 netmask 255.255.255.0 {
    }

Service file

There is no service files provided by default to use dhcpd only on one
interface so yo need to create one:

     /etc/systemd/system/dhcpd4@.service

    [Unit]
    Description=IPv4 DHCP server on %I
    Wants=network.target
    After=network.target

    [Service]
    Type=forking
    PIDFile=/run/dhcpd4.pid
    ExecStart=/usr/bin/dhcpd -4 -q -pf /run/dhcpd4.pid %I
    KillSignal=SIGINT

    [Install]
    WantedBy=multi-user.target

Now you can start dhcpd as a daemon which only listen to a specific
interface, for exemple eth0.

    # systemctl start dhcpd4@eth0.service

See also
--------

-   Dhcpcd

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dhcpd&oldid=305641"

Category:

-   Networking

-   This page was last modified on 19 March 2014, at 18:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
