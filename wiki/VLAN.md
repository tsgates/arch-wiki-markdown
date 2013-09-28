VLAN
====

Virtual LANs give you the ability to sub-divide a LAN. Linux can accept
VLAN tagged traffic and presents each VLAN ID as a different network
interface (eg: eth0.100 for VLAN ID 100)

Summary

This article explains how to configure a VLAN using iproute2 and netcfg

Related

Network

Netcfg

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Configuration                                                      |
|     -   1.1 Create the VLAN device                                       |
|     -   1.2 Add an IP                                                    |
|     -   1.3 Turning down the device                                      |
|     -   1.4 Removing the device                                          |
|     -   1.5 Starting at boot                                             |
|                                                                          |
| -   2 Troubleshooting                                                    |
|     -   2.1 udev renames the virtual devices                             |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Configuration
-------------

Previously Arch Linux used vconfig to setup VLANs. This had been
superseded by the ip command. Make sure you have iproute2 installed.

In the following examples, lets assume the interface is eth0, the
assigned name is eth0.100 and the vlan id is 100.

> Create the VLAN device

Add the VLAN with the following command:

    # ip link add link eth0 name eth0.100 type vlan id 100

Run ip link to confirm that it has been created.

This interface behaves like a normal interface. All traffic routed to it
will go through the master interface (in this example, eth0) but with a
VLAN tag. Only VLAN aware devices can accept them if configured
correctly else the traffic is dropped.

Using a name like eth0.100 is just convention and not enforced; you can
alternatively use eth0_100 or something descriptive like IPTV

> Add an IP

Now add an IPv4 address to the just created vlan link, and activate the
link:

    # ip addr add 192.168.100.1/24 brd 192.168.100.255 dev eth0.100
    # ip link set dev eth0.100 up

> Turning down the device

To cleanly shutdown the setting before you remove the link, you can do:

    # ip link set dev eth0.100 down

> Removing the device

Removing a VLAN interface is significantly less convoluted

    # ip link delete eth0.100

> Starting at boot

You can use the following parameters in netcfg profiles to have VLANs
configured automatically:

    /etc/network.d/my-network

    # vlan specific part:
    CONNECTION="vlan"
    VLAN_PHYS_DEV="eth0"
    VLAN_ID="100"
    INTERFACE="eth0.100"

    # general IP configuration:
    IP="static"
    ADDR="192.168.100.1"
    NETMASK="255.255.255.0"
    GATEWAY="192.168.100.254"

Enable the daemon netcfg@my-network. Read Daemons for more details.

Troubleshooting
---------------

> udev renames the virtual devices

An annoyance is that udev may try to rename virtual devices as they are
added, thus ignoring the name configured for them (in this case
eth0.100).

For instance, if the following commands are issued:

    # ip link add link eth0 name eth0.100 type vlan id 100
    # ip link show 

This could generate the following output:

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
        link/ether aa:bb:cc:dd:ee:ff brd ff:ff:ff:ff:ff:ff
    3: rename1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state DOWN 
        link/ether aa:bb:cc:dd:ee:ff brd ff:ff:ff:ff:ff:ff

udev has ignored the configured virtual interface name eth0.100 and
autonamed it rename1.

The solution is to edit /etc/udev/rules.d/network_persistent.rules and
append DRIVERS=="?*" to the end of the physical interface's
configuration line.

For example, for the interface aa:bb:cc:dd:ee:ff (eth0):

    /etc/udev/rules.d/network_persistent.rules

    SUBSYSTEM=="net", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="eth0", DRIVERS=="?*"

A reboot should mean that VLANs configure correctly with the names
assigned to them.

See also
--------

-   Post about using POST_UP and PRE_DOWN

Retrieved from
"https://wiki.archlinux.org/index.php?title=VLAN&oldid=249881"

Category:

-   Networking
