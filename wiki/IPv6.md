IPv6
====

Summary

This article covers IPv6, and basics of configuring different IPv6
related things like static IP adresses.

Related

IPv6 - Tunnel Broker Setup

In Arch Linux, IPv6 is enabled by default. If you are looking for
information regarding IPv6 tunnels, you may want to look at IPv6 -
Tunnel Broker Setup.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Privacy Extensions                                                 |
| -   2 Neighbor Discovery                                                 |
| -   3 Static Address                                                     |
| -   4 Disable IPv6                                                       |
|     -   4.1 Disable functionality                                        |
|     -   4.2 Other programs                                               |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Privacy Extensions
------------------

To enable Privacy Extensions for Stateless Address Autoconfiguration in
IPv6 according to RFC 4941, reproduce the following steps:

Add these lines to /etc/sysctl.conf:

    # Enable IPv6 Privacy Extensions
    net.ipv6.conf.all.use_tempaddr = 2
    net.ipv6.conf.default.use_tempaddr = 2
    net.ipv6.conf.<nic0>.use_tempaddr = 2
    ...
    net.ipv6.conf.<nicN>.use_tempaddr = 2

Where <nic0> to <nicN> are your nic's (the "all" or "default" parameters
do not apply to nic's that already exist when the sysctl settings are
applied).

After a reboot, at the latest, Privacy Extensions should be enabled.

Neighbor Discovery
------------------

Pinging the multicast address ff02::1 results in all hosts in link-local
scope responding. An interface has to be specified. With a ping to the
multicast address ff02::2 only routers will respond.

    $ ping6 ff02::1%eth0

If you add an option -I <your-global-ipv6>, link-local hosts will
respond with their link-global scope addresses. The interface can be
omitted in this case.

    $ ping6 -I 2001:4f8:fff6::21 ff02::1

Static Address
--------------

Sometime using static address can improve security. For example, if your
local router uses Neighbor Discovery or radvd (RFC 2461), your interface
will automatically be assigned an address based its MAC address (using
IPv6's Stateless Autoconfiguration). This may be less than ideal for
security since it allows a system to be tracked even if the network
portion of the IP address changes.

To assign a static address (for example 2001:470:1000:1000::5/64):

Add your static IP using netcfg. Follow the netcfg article. When copying
an example use ethernet-static and modify it like so:

    CONNECTION='ethernet'
    DESCRIPTION='ipv6+ipv4 eth0'
    INTERFACE='eth0'

    IP=static
    ADDR=192.168.1.5
    NETMASK=24
    ROUTES=
    GATEWAY=192.168.1.1

    IP6=static
    ADDR6=(2001:470:1000:1000::5/64)
    GATEWAY6=2001:470:1000:1000::1

Disable IPv6
------------

Note:The Arch kernel has IPv6 support built in directly [1], therefore a
module cannot be blacklisted.

> Disable functionality

Adding ipv6.disable=1 to the kernel line disables the whole IPv6 stack,
which is likely what you want if you are experiencing issues. See Kernel
parameters for more information.

Alternatively, adding ipv6.disable_ipv6=1 instead will keep the IPv6
stack functional but will not assign IPv6 addresses to any of your
network devices.

One can also avoid assigning IPv6 addresses to specific network
interfaces by adding the following sysctl config to
/etc/sysctl.d/ipv6.conf:

    # Disable IPv6
    net.ipv6.conf.all.disable_ipv6 = 1
    net.ipv6.conf.<interface0>.disable_ipv6 = 1
    ...
    net.ipv6.conf.<interfaceN>.disable_ipv6 = 1

Note that you must list all of the targeted interfaces explicitly, as
disabling "all" does not apply to interfaces that are already "up" when
sysctl settings are applied.

Note 2, if disabling IPv6 by sysctl, you should comment out the IPv6
hosts in your /etc/hosts-file.

    #<ip-address>	<hostname.domain.org>	<hostname>
    127.0.0.1	localhost.localdomain	localhost
    #::1		localhost.localdomain	localhost

otherwise there could be some connection errors because hosts are
resolved to there IPv6 address which is not reachable.

> Other programs

Disabling IPv6 functionality in the kernel does not prevent other
programs from trying to use IPv6. In most cases, this is completely
harmless, but if you find yourself having issues with that program, you
should consult the program's man page(s) for a way to disable that
functionality.

For example, dhcpcd will continue to harmlessly attempt to perform IPv6
router solicitation. To disable this, as stated in the dhcpcd.conf man
page, add the following to /etc/dhcpcd.conf:

    noipv6rs

See also
--------

-   IPv6 - kernel.org Documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=IPv6&oldid=248324"

Category:

-   Networking
