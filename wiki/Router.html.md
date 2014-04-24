Router
======

This article is a tutorial for turning a computer into an internet
gateway/router. It focuses on security, since the gateway is connected
directly to the Internet. It should not run any services available to
the outside world. Towards the LAN, it should only run gateway specific
services. It should not run httpd, ftpd, samba, nfsd, etc. as those
belong on a server in the LAN as they introduce security flaws.

This article does not attempt to show how to set up a shared connection
between 2 PCs using cross-over cables. For a simple internet sharing
solution, see Internet sharing.

Contents
--------

-   1 Hardware Requirements
-   2 Conventions
-   3 Installation
    -   3.1 Partitioning
    -   3.2 Post-Installation
-   4 Network interface configuration
    -   4.1 Persistent naming and Interface renaming
    -   4.2 IP configuration
-   5 ADSL connection/PPPoE
    -   5.1 PPPoE configuration
-   6 DNS and DHCP
-   7 Connection sharing
    -   7.1 iptables
    -   7.2 Shorewall
-   8 IPv6
    -   8.1 Router Advertisement and Stateless Autoconfiguration (SLAAC)
        -   8.1.1 Firewall tweaks
    -   8.2 Global Unicast Addresses
        -   8.2.1 Static WAN IPv6
        -   8.2.2 Acquiring WAN IPv6 via DHCPv6-PD
        -   8.2.3 PPPoE and IPv6
-   9 Cleanup
-   10 Logrotate
-   11 Optional additions
    -   11.1 UPnP
    -   11.2 Remote administration
    -   11.3 Caching web proxy
    -   11.4 Time server
    -   11.5 Content filtering
    -   11.6 Traffic shaping
        -   11.6.1 Traffic shaping with shorewall
    -   11.7 Intrusion detection and prevention with snort
-   12 See also

Hardware Requirements
---------------------

-   At least 1 GB of hard drive space. The base install will take up
    around 500MB of space and if you want to use a caching web proxy,
    you will need to reserve space for the cache as well.
-   At least two physical network interfaces: a gateway connects two
    networks with each other. You will need to be able to connect those
    networks to the same physical computer. One interface must connect
    to the external network, while the other connects to the internal
    network.
-   A hub, switch or UTP cable: You need a way to connect the other
    computers to the gateway

Conventions
-----------

Conventions in this guide will be to use non-realistic interface names,
to avoid confusion about which interface is which.

-   intern0: the network card connected to the LAN. On an actual
    computer it will probably have the name enp2s0, enp1s1, etc.
-   extern1: the network card connected to the external network (or
    WAN). It will probably have the name enp2s0, enp1s1, etc.

Installation
------------

Note: For a full installation guide, see the Installation guide.

A fresh install of Arch Linux is the easiest to start from, as no
configuration changes have been made and there is a minimal amount of
packages installed. This is helpful when attempting to reduce security
risk.

> Partitioning

For security purposes, /var, /tmp and /home should be separate from the
/ partition. This prevents disk space from being completely used up by
log files, daemons or the unprivileged user. It also allows different
mount options for those partitions. If you have already partitioned your
drive, the gparted livecd can be used to resize, move, or create new
partitions.

Your home and root partitions can be much smaller than a regular install
since this is not a desktop machine. /var should be the largest
partition—it is where databases, logs and long-term caches are stored.
If you have a lot of RAM, mounting /tmp as tmpfs is a good idea, so
making a disk partition for it during the initial install is
unnecessary. Note that /tmp is mounted as tmpfs by default in Arch.

> Post-Installation

After creation of non-root account you are recommended to install sudo
and disable root login.

Network interface configuration
-------------------------------

> Persistent naming and Interface renaming

Systemd automatically chooses unique interface names for all your
interfaces. These are persistent and will not change when you reboot. If
you would like to rename interface to user friendlier names read Network
configuration#Device_names.

> IP configuration

Now you will need to configure the network interfaces. The best way to
do so is using netctl profiles. You will need to create two profiles.

Note:If you will be connecting to the Internet only via PPPoE (you have
one WAN port) you do not need to setup or enable the extern0-profile.
See below for more information on configuring PPPoE.

-   /etc/netctl/extern0-profile

    Description='Public Interface.'
    Interface=extern0
    Connection=ethernet
    IP='dhcp'

-   /etc/netctl/intern0-profile

    Description='Private Interface'
    Interface=intern0
    Connection=ethernet
    IP='static'
    Address=('10.0.0.1/24')

Note:The example configuration above assumes a full subnet. If you are
building the gateway for a small amount of people, you will want to
change the CIDR suffix to accommodate a smaller range. For example /27
will give you 10.0.0.1 to 10.0.0.30. You can find many CIDR calculators
online.

Next up is to set up the interfaces with netctl.

    # netctl enable extern0-profile
    # netctl enable intern0-profile

ADSL connection/PPPoE
---------------------

Using rp-pppoe, we can connect an ADSL modem to the extern1 of the
firewall and have Arch manage the connection. Make sure you put the
modem in bridged mode though (either half-bridge or RFC1483), otherwise
the modem will act as a router too.

    # pacman -S rp-pppoe

It should be noted that if you use only PPPoE to connect to the internet
(ie. you do not have other WAN port, except for the one that connects to
your modem) you do not need to set up the extern0-profile as the
external pseudo-interface will be ppp0.

> PPPoE configuration

You can use netctl to setup the pppoe connection. To get started

    # cp /etc/netctl/examples/pppoe /etc/netctl/

and start editing. For the interface configuration choose the interface
that connects to the modem. If you only connect to the internet through
PPPoE this will probably be extern0. Fill in the rest of the fields with
your ISP information. See the pppoe section in netctl.profile man page
for more information on the fields.

DNS and DHCP
------------

We will use dnsmasq, a DNS and DHCP daemon for the LAN. It was
specifically designed for small sites. To get it, install dnsmasq from
the official repositories.

Dnsmasq needs to be configured to be a DHCP server. To do this:

Edit /etc/dnsmasq.conf:

    interface=intern0 # make dnsmasq listen for requests only on intern0 (our LAN)
    expand-hosts      # add a domain to simple hostnames in /etc/hosts
    domain=foo.bar    # allow fully qualified domain names for DHCP hosts (needed when
                      # "expand-hosts" is used)
    dhcp-range=10.0.0.2,10.0.0.255,255.255.255.0,1h # defines a DHCP-range for the LAN: 
                      # from 10.0.0.2 to .255 with a subnet mask of 255.255.255.0 and a
                      # DHCP lease of 1 hour (change to your own preferences)

Somewhere below, you will notice you can also add "static" DHCP leases,
i.e. assign an IP-address to the MAC-address of a computer on the LAN.
This way, whenever the computer requests a new lease, it will get the
same IP. That is very useful for network servers with a DNS record. You
can also deny certain MAC's from obtaining an IP.

Now start dnsmasq:

    # systemctl start dnsmasq.service

Connection sharing
------------------

Time to tie the two network interfaces to each other.

> iptables

Simple stateful firewall documents the setup of an iptables firewall and
NAT.

> Shorewall

Shorewall, an iptables frontend, can be used as an easier alternative.
See Shorewall for detailed configuration.

IPv6
----

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with IPv6.       
                           Notes: Merge into the    
                           main article, the topic  
                           is not specific to       
                           router configuration.    
                           The wording should be    
                           probably changed along   
                           the way. (Discuss)       
  ------------------------ ------------------------ ------------------------

Useful reading: IPv6 and the Wikipedia IPv6 entry.

You can use your router in IPv6 mode even if you do not have an IPv6
address from your ISP. Unless you disable IPv6 all interfaces should
have been assigned a unique fe80::/10 address.

For internal networking the block fc00::/7 has been reserved. These
addresses are guaranteed to be unique and non-routable from the open
internet. Addresses that belong to the fc00::/7 block are called Unique
Local Addresses. To get started generate a ULA /64 block to use in your
network. For this example we will use fd00:aaaa:bbbb:cccc::/64. Firstly
we must assign a static IPv6 on the internal interface. Modify the
intern0-profile we created above to include the following line

    IPCustom=('-6 addr add fd00:aaaa:bbbb:cccc::1/64 dev intern0')

This will add the ULA to the internal interface. As far as the router
goes, this is all you need to configure.

> Router Advertisement and Stateless Autoconfiguration (SLAAC)

To properly hand out IPv6s to the network clients we will need to use an
advertising daemon. The standard tool for this job is radvd and is
available in official repositories. Configuration of radvd is fairly
simple. Edit /etc/radvd.conf to include

    interface intern0 {
      AdvSendAdvert on;
      MinRtrAdvInterval 3;
      MaxRtrAdvInterval 10;
      prefix fd00:aaaa:bbbb:cccc::/64 {
        AdvOnLink on;
        AdvAutonomous on;
        AdvRouterAddr on;
      };
    };

The above configuration will tell clients to autoconfigure themselves
using addresses from the specified /64 block. Addresses on the clients
are uniquely generated using the MAC address of the connected interface
and are optionally mangled for security reasons if privacy extensions
are enabled (which is recommended to do). On the client side you need to
enable IP6=stateless in your active netctl profile. If you want a static
IP as well add

    IPCustom=('-6 addr add fd00:aaaa:bbbb:cccc::2/64 dev eth0')

Don't forget to enable radvd.service

Firewall tweaks

Stateless autoconfiguration works on the condition that IPv6 icmp
packets are allowed throughout the network. So some firewall tweaks are
required on both ends of the network for it to work properly. On the
client side all you need to do is allow the ipv6-icmp protocol on the
INPUT chain. If you are using Simple stateful firewall you only need to
add

    -A INPUT -p ipv6-icmp -j ACCEPT

You can limit it to internal network using -s fd00:aaaa:bbbb:cccc::/64
and/or -s fe80::/10 if you feel it is a security threat. Additionally
you must add the same rules to your router firewall but extending it to
the OUTPUT and FORWARD chains as well.

    -A INPUT -p ipv6-icmp -j ACCEPT
    -A OUTPUT -p ipv6-icmp -j ACCEPT
    -A FORWARD -p ipv6-icmp -j ACCEPT

Again, you can limit it to the internal network for the INPUT chain.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: More information 
                           on IPv6 firewalls        
                           required (Discuss)       
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Additional info  
                           on running DHCPv6 server 
                           instead of SLAAC         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Global Unicast Addresses

Static WAN IPv6

If your ISP or WAN network can access the IPv6 Internet you can assign
global link addresses to your router and propagate them through SLAAC to
your internal network. If you can use a Static IPv6 all you must do is
add it to your external profile and enable it the advertisement of the
global unicast block in radvd.conf.

In /etc/netctl/extern0-profile simply add the IPv6 and the IPv6 prefix
(usually /64) you have been provided

    IPCustom=('-6 addr add 2002:1:2:3:4:5:6:7/64 dev extern0')

and edit /etc/radvd.conf to include the new advertisement block.

    interface intern0 {
      AdvSendAdvert on;
      MinRtrAdvInterval 3;
      MaxRtrAdvInterval 10;
      prefix fd00:aaaa:bbbb:cccc::/64 {
        AdvOnLink on;
        AdvAutonomous on;
        AdvRouterAddr on;
      };
      prefix 2002:1:2:3::/64 {
        AdvOnLink on;
        AdvAutonomous on;
        AdvRouterAddr on;
      };
    };

In that way your internal network clients will also get a Global IPv6
address. This IP is routable from the open internet, so adjust your
firewalls. Please note that global and local IPv6s can co-exist on the
same interface without further configuration.

Acquiring WAN IPv6 via DHCPv6-PD

If your ISP handles out IPv6s using DHCPv6-PD you will need to use a
DHCPv6 client to get the IP from your ISP. Common such programs are
dibbler, wide-dhcpv6 and dhcpcd. ISC's dhclient should also work, but
documentation on prefix delegation is scarce.

For dibbler edit /etc/dibbler/client.conf

    log-mode short
    log-level 7
    iface "extern0" {
      ia
      pd
    }

Tip:Read manpage dibbler-client(8) for more information.

For wide-dhcpv6 edit /etc/wide-dhcpv6/dhcp6c.conf

    interface extern0 {
      send ia-pd 0;
    };
     
    id-assoc pd 0 {
      prefix-interface intern0 {
        sla-id 1;
        sla-len 8;
      };
    };

To enable/start wide-dhcpv6 client use the command

    # systemctl enable/start dhcp6c@extern0.service

Tip:Read manpages dhcp6c(8) and dhcp6c.conf(5) for more information.

For dhcpcd edit /etc/dhcpcd.conf. You might already be using dhcpcd for
IPv4 so just update your existing configuration. If you would like to
use it for IPv6 only uncomment the third line.

    duid
    noipv6rs
    #ipv6only
    interface extern0
    ia_pd 1 intern0

This configuration will ask for a prefix from WAN (interface extern0)
and delegate it to the internal interface (intern0).

Tip:Also read: manpages dhcpcd(8) and dhcpcd.conf(5).

Because the IPv6 prefix is now dynamic, we need to change radvd to
advertize any subnet instead of specific ones. With this configuration
radvd will pick any /64 prefix available on the internal interface and
propagate SLAAC IPv6s to the clients. Simply change /etc/radvd.conf to

    interface intern0 {
      AdvSendAdvert on;
      MinRtrAdvInterval 3;
      MaxRtrAdvInterval 10;
      prefix ::/64 {
        AdvOnLink on;
        AdvAutonomous on;
        AdvRouterAddr on;
        DeprecatePrefix on;
      };
    };

PPPoE and IPv6

If your ISP provides IPv6 via PPPoE you can enable it in your pppoe
netctl profile. Just add this to pppoe netctl profile

    PPPoEIP6=yes

and restart it. Also you must change any extern0 references to the
configuration files above to ppp0 instead since IPv6 is assigned to ppp
pseudo-interface instead of a real ethernet interface. Please note, that
depending on your modem IPv6 might not be available through half-bridge
so switch to full RFC1483 bridging instead.

Warning:dhclient does not support DHCP6-PD via PPP

Cleanup
-------

Now that the installation has been performed, it is necessary to remove
as many packages as possible. Since we are making a gateway, keeping
unneeded packages only "bloats" the system, and increases the number of
security risks.

First, check for obsolete/deprecated packages (likely after a fresh
install and massive series of updates):

    $ pacman -Qm

Review the list of explicitly installed packages that are not
dependencies and remove any that are unneeded. Having only needed
packages installed is an important security consideration.

    $ pacman -Qet

Completely remove the packages you do not need along with their
configuration files and dependencies:

    # pacman -Rsn package1 package2 package3

Logrotate
---------

You should review the logrotate configuration to make sure the box is
not brought down by lack of diskspace due to logging.

Logrotate is installed by default, so you will not have to install it.

Optional additions
------------------

> UPnP

The above configuration of shorewall does not include UPnP support. Use
of UPnP is discouraged as it may make the gateway vulnerable to attacks
from within the LAN. However, some applications require this to function
correctly.

To enable UPnP on your router, you need to install an UPnP Internet
gateway daemon (IGD). To get it, install miniupnpd from the official
repositories.

Read the Shorewall guide on UPnP for more information

> Remote administration

OpenSSH can be used to administer your router remotely. This is useful
for running it "headless" (no monitor or input devices).

> Caching web proxy

See Squid or Polipo for the setup of a web proxy to speed up browsing
and/or adding an extra layer of security.

> Time server

To use the router as a time server, see Network Time Protocol.

Then, configure shorewall or iptables to allow NTP traffic in and out.

> Content filtering

Install and configure DansGuardian or Privoxy if you need a content
filtering solution.

> Traffic shaping

Traffic shaping is very useful, especially when you are not the only one
on the LAN. The idea is to assign a priority to different types of
traffic. Interactive traffic (ssh, online gaming) probably needs the
highest priority, while P2P traffic can do with the lowest. Then there
is everything in between.

Traffic shaping with shorewall

Read Shorewall's Traffic Shaping/Control guide.

Here is my config as an example:

-   /etc/shorewall/tcdevices : here is where you define the interface
    you want to have shaped and its rates. I have got a ADSL connection
    with a 4MBit down/256KBit up profile.

    ppp0        4mbit        256kbit 

-   /etc/shorewall/tcclasses : here you define the minimum (rate) and
    maximum (ceil) throughput per class. You will assign each one to a
    type of traffic to shape.

    # interactive traffic (ssh)
    ppp0            1       full    full    0
    # online gaming
    ppp0            2       full/2  full    5
    # http
    ppp0            3       full/4  full    10
    # rest
    ppp0            4       full/6  full    15              default

-   /etc/shorewall/tcrules : this file contains the types of traffic and
    the class it belongs to.

    1       0.0.0.0/0       0.0.0.0/0       tcp     ssh
    2       0.0.0.0/0       0.0.0.0/0       udp     27000:28000
    3       0.0.0.0/0       0.0.0.0/0       tcp     http
    3       0.0.0.0/0       0.0.0.0/0       tcp     https

I have split it up my traffic in 4 groups:

1.  interactive traffic or ssh: although it takes up almost no
    bandwidth, it is very annoying if it lags due to leechers on the
    LAN. This get the highest priority.
2.  online gaming: needless to say you ca not play when your ping
    sucks. ;)
3.  webtraffic: can be a bit slower
4.  everything else: every sort of download, they are the cause of the
    lag anyway.

> Intrusion detection and prevention with snort

See Snort.

See also
--------

-   Simple stateful firewall
-   Internet sharing

Retrieved from
"https://wiki.archlinux.org/index.php?title=Router&oldid=302031"

Categories:

-   Networking
-   Security

-   This page was last modified on 25 February 2014, at 13:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
