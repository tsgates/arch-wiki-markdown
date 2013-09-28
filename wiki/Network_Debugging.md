Network Debugging
=================

Summary

Basic network debugging

Related

VLAN

This article handles the steps needed for basic network troubleshooting.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 iproute2                                                           |
| -   2 Network Interfaces                                                 |
| -   3 Link status                                                        |
| -   4 IP address                                                         |
| -   5 Route table                                                        |
| -   6 DNS Servers                                                        |
| -   7 Ping & Tracepath/Traceroute                                        |
+--------------------------------------------------------------------------+

iproute2
--------

Many users are familiar with tools like ifconfig and route, but the
related package (net-tools) has been deprecated for a while. All its
functionalities can now be found in the replacement iproute2 package,
included in a standard Arch Linux core installation and required by
tools like netcfg and networkmanager.

Network Interfaces
------------------

The first step in troubleshooting network issues will be to identify
which network interfaces are present on the system. This can be done by
issuing the command:

    $ ip a

This will provide an output among the lines of:

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
       inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
       link/ether 70:5a:b6:8a:a0:87 brd ff:ff:ff:ff:ff:ff
       inet 192.168.1.143/24 brd 192.168.1.255 scope global eth0
       inet6 fe80::725a:b6ff:fe8a:a087/64 scope link 
          valid_lft forever preferred_lft forever
    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
       link/ether 00:26:82:5a:6f:d9 brd ff:ff:ff:ff:ff:ff
       inet 192.168.1.148/24 brd 192.168.1.255 scope global wlan0
       inet6 fe80::226:82ff:fe5a:6fd9/64 scope link 
          valid_lft forever preferred_lft forever

Link status
-----------

In the overview of ip a, the link status will already be displayed. But
it can also be displayed by running:

    $ ip link show dev eth0

This will provide an output among the lines of:

    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
       link/ether 70:5a:b6:8a:a0:87 brd ff:ff:ff:ff:ff:ff

Bringing up an interface can be done by issueing:

    # ip link set dev eth0 up

IP address
----------

In the overview provided by ip a, the ip address will already be
displayed. But it can also be displayed by running:

    $ ip addr show dev eth0

This will provide an output among the lines of:

     2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
       link/ether 70:5a:b6:8a:a0:87 brd ff:ff:ff:ff:ff:ff
       inet 192.168.1.143/24 brd 192.168.1.255 scope global eth0
       inet6 fe80::725a:b6ff:fe8a:a087/64 scope link 
          valid_lft forever preferred_lft forever

Adding a temporary ip address:

    # ip addr add 192.168.1.143/24 dev eth0

Removing an ip address:

    # ip addr del 192.168.1.143/24 dev eth0

Route table
-----------

The route table can be displayed by running:

    $ ip route show

Route table for a specific interface:

    $ ip route show dev eth0

This will provide an output among the lines of:

    default via 192.168.1.1  proto static 
    192.168.1.0/24  proto kernel  scope link  src 192.168.1.143

Configuring the default gateway:

    # ip route add 0/0 via 192.168.1.1 dev eth0

Removing the default gateway:

    # ip route del 0/0 via 192.168.1.1 dev eth0

DNS Servers
-----------

Dns is responsible for converting hostnames to an ip address. When
connectivity towards ip addresses is working, but the system is unable
to connect to a hostname; there is a fair chance that this will be
related to the dns configuration. The configuration can be displayed by
running:

    $ cat /etc/resolv.conf

This will provide an output among the lines of:

    domain example.com
    search example.com
    nameserver 192.168.1.1

-   The rule 'nameserver' is the relevant section. Configuring multiple
    nameservers is supported.
-   The 'domain' and 'search' rules are optional.
-   Often the 'nameserver' is the same as your default gateway.
-   In case of doubt there is always the possibility to use the Google
    DNS servers as your default DNS servers:

    nameserver 8.8.8.8
    nameserver 8.8.4.4

Testing your dns configuration can be done through the host command
(from the dnsutils package):

    $ host www.archlinux.org 8.8.4.4

The above command will perform a dns lookup of www.archlinux.org using
the 8.8.4.4 dns server and provide output among the lines of:

    Using domain server:
    Name: 8.8.4.4
    Address: 8.8.4.4#53
    Aliases: 

    www.archlinux.org is an alias for gudrun.archlinux.org.
    gudrun.archlinux.org has address 66.211.214.131

As an alternative there is also the dig command.

Ping & Tracepath/Traceroute
---------------------------

The ping command can help test connectivity towards a specific host.

The first step would be verifying connectivity towards the default
gateway (replace the ip address with your own default gateway):

    $ ping -c4 192.168.1.1

When erasing the "-c4" parameter, the ping will continue endlessly. It
can be aborted by hitting "Control-C".

    PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
    64 bytes from 192.168.1.1: icmp_req=1 ttl=64 time=0.193 ms
    64 bytes from 192.168.1.1: icmp_req=2 ttl=64 time=0.190 ms
    64 bytes from 192.168.1.1: icmp_req=3 ttl=64 time=0.192 ms
    64 bytes from 192.168.1.1: icmp_req=4 ttl=64 time=0.189 ms

    --- 192.168.1.1 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 2999ms
    rtt min/avg/max/mdev = 0.165/0.184/0.193/0.014 ms

The output above indicated the default gateway is reachable. When
instead a "Destination Host Unreachable" message is displayed,
doublecheck the ip address, netmask and default gateway config. This
message can also be displayed when ICMP traffic is not permitted towards
the default gateway (blocked by a firewall, router,...).

The next step is verifying connectivity towards the configured dns
server(s). When no reply is received, tracepath or traceroute can be
used to verify the routing towards said server and get an idea of where
the issue lies.

    $ traceroute 8.8.4.4

Traceroute also used ICMP to determine the path and hence there can be
"no reply" answers as well when ICMP traffic is blocked.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Network_Debugging&oldid=239025"

Category:

-   Networking
