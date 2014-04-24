IPv6
====

Related articles

-   IPv6 - Tunnel Broker Setup

In Arch Linux, IPv6 is enabled by default. If you are looking for
information regarding IPv6 tunnels, you may want to look at IPv6 -
Tunnel Broker Setup.

Contents
--------

-   1 Privacy extensions
-   2 Neighbor discovery
-   3 Static address
-   4 IPv6 on Comcast
-   5 Disable IPv6
    -   5.1 Disable functionality
    -   5.2 Other programs
-   6 See also

Privacy extensions
------------------

To enable Privacy Extensions for Stateless Address Autoconfiguration in
IPv6 according to RFC 4941, reproduce the following steps:

Add these lines to /etc/sysctl.d/40-ipv6.conf:

    # Enable IPv6 Privacy Extensions
    net.ipv6.conf.all.use_tempaddr = 2
    net.ipv6.conf.default.use_tempaddr = 2
    net.ipv6.conf.nic0.use_tempaddr = 2
    ...
    net.ipv6.conf.nicN.use_tempaddr = 2

Where nic0 to nicN are your Network Interface Cards (the "all" or
"default" parameters do not apply to nic's that already exist when the
sysctl settings are applied).

After a reboot, at the latest, Privacy Extensions should be enabled.

Neighbor discovery
------------------

Pinging the multicast address ff02::1 results in all hosts in link-local
scope responding. An interface has to be specified. With a ping to the
multicast address ff02::2 only routers will respond.

    $ ping6 ff02::1%eth0

If you add an option -I your-global-ipv6, link-local hosts will respond
with their link-global scope addresses. The interface can be omitted in
this case.

    $ ping6 -I 2001:4f8:fff6::21 ff02::1

Static address
--------------

Sometime using static address can improve security. For example, if your
local router uses Neighbor Discovery or radvd (RFC 2461), your interface
will automatically be assigned an address based its MAC address (using
IPv6's Stateless Autoconfiguration). This may be less than ideal for
security since it allows a system to be tracked even if the network
portion of the IP address changes.

To assign a static IP address using netctl, look at the example profile
in /etc/netctl/examples/ethernet-static. The following lines are
important:

    /etc/netctl/examples/ethernet-static

    ...
    # For IPv6 static address configuration
    IP6=static
    Address6=('1234:5678:9abc:def::1/64' '1234:3456::123/96')
    Routes6=('abcd::1234')
    Gateway6='1234:0:123::abcd'

IPv6 on Comcast
---------------

dhcpcd -4 or dhcpcd -6 worked using a Motorola SURFBoard 6141 and a
Realtek RTL8168d/8111d. Either would work, but would not run dual stack:
both protocols and addresses on one interface. (The -6 command would not
work if -4 ran first, even after resetting the interface. And when it
did, it gave the NIC a /128 address.) Try these commands:

    dhclient -4 enp3s0
    dhclient -P -v enp3s0

The -P argument grabs a lease of the IPv6 prefix only. -v writes to
stdout what is also written to /var/lib/dhclient/dhclient6.leases:

    Bound to *:546
    Listening on Socket/enp3s0
    Sending on   Socket/enp3s0
    PRC: Confirming active lease (INIT-REBOOT).
    XMT: Forming Rebind, 0 ms elapsed.
    XMT:  X-- IA_PD a1:b2:cd:e2
    XMT:  | X-- Requested renew  +3600
    XMT:  | X-- Requested rebind +5400
    XMT:  | | X-- IAPREFIX 1234:5:6700:890::/64

IAPREFIX is the necessary value. Substitute ::1 before the CIDR slash to
make the prefix a real address:

    ip -6 addr add 1234:5:6700:890::1/64  dev enp3s0

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
/etc/sysctl.d/40-ipv6.conf:

    # Disable IPv6
    net.ipv6.conf.all.disable_ipv6 = 1
    net.ipv6.conf.interface0.disable_ipv6 = 1
    ...
    net.ipv6.conf.interfaceN.disable_ipv6 = 1

Note that you must list all of the targeted interfaces explicitly, as
disabling "all" does not apply to interfaces that are already "up" when
sysctl settings are applied.

Note 2, if disabling IPv6 by sysctl, you should comment out the IPv6
hosts in your /etc/hosts-file.

    #<ip-address>	<hostname.domain.org>	<hostname>
    127.0.0.1	localhost.localdomain	localhost
    #::1		localhost.localdomain	localhost

otherwise there could be some connection errors because hosts are
resolved to their IPv6 address which is not reachable.

> Other programs

Disabling IPv6 functionality in the kernel does not prevent other
programs from trying to use IPv6. In most cases, this is completely
harmless, but if you find yourself having issues with that program, you
should consult the program's manual pages for a way to disable that
functionality.

For example, dhcpcd will continue to harmlessly attempt to perform IPv6
router solicitation. To disable this, as stated in the dhcpcd.conf man
page, add the following to /etc/dhcpcd.conf:

    noipv6rs

See also
--------

-   IPv6 - kernel.org Documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=IPv6&oldid=299734"

Category:

-   Networking

-   This page was last modified on 22 February 2014, at 04:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
