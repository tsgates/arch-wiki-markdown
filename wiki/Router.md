Router
======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: No more rc.conf, 
                           no more eth0,1,2         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article is a tutorial for turning a computer into an internet
gateway/router. It focuses on security, since the gateway is connected
directly to the Internet. It should not run any services available to
the outside world. Towards the LAN, it should only run gateway specific
services. It should not run httpd, ftpd, samba, nfsd, etc. as those
belong on a server in the LAN as they introduce security flaws.

This article does not attempt to show how to set up a shared connection
between 2 PCs using cross-over cables. For a simple internet sharing
solution, see Internet Share.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware Requirements                                              |
| -   2 Conventions                                                        |
| -   3 Installation                                                       |
|     -   3.1 Partitioning                                                 |
|     -   3.2 Post-Installation                                            |
|                                                                          |
| -   4 Network interface configuration                                    |
|     -   4.1 Persistent naming                                            |
|     -   4.2 IP configuration                                             |
|                                                                          |
| -   5 ADSL connection                                                    |
|     -   5.1 Configuration: rp-pppoe                                      |
|                                                                          |
| -   6 DNS and DHCP                                                       |
| -   7 Connection sharing                                                 |
|     -   7.1 iptables                                                     |
|     -   7.2 Shorewall                                                    |
|         -   7.2.1 Shorewall configuration                                |
|                                                                          |
| -   8 Cleanup                                                            |
| -   9 Logrotate                                                          |
| -   10 Optional additions                                                |
|     -   10.1 UPnP                                                        |
|     -   10.2 Remote administration                                       |
|     -   10.3 Caching web proxy                                           |
|     -   10.4 Time server                                                 |
|     -   10.5 Content filtering                                           |
|     -   10.6 Traffic shaping                                             |
|         -   10.6.1 Traffic shaping with shorewall                        |
|                                                                          |
|     -   10.7 Intrusion detection and prevention with snort               |
|                                                                          |
| -   11 See also                                                          |
+--------------------------------------------------------------------------+

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
    computer it will probably have the name eth0, eth1, etc.
-   extern1: the network card connected to the external network (or
    WAN). It will probably have the name eth0, eth1, etc.

Installation
------------

Note: For a full installation guide, see the Official Arch Linux Install
Guide.

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
partition - it is where databases, logs and long-term caches are stored.
If you have a lot of RAM, mounting /tmp as tmpfs is a good idea, so
making a disk partition for it during the initial install is
unnecessary. Note that /tmp is mounted as tmpfs by default in Arch.

> Post-Installation

After creation of non-root account you are recommended to install sudo
and disable root login.

Network interface configuration
-------------------------------

> Persistent naming

When you let udev handle loading the modules, you will notice your NIC's
switch names: one boot your LAN NIC is eth0, the other boot it is eth1,
etc. (This might not be true, see PredictableNetworkInterfaceNames, and
Network_Configuration#Device_names)

To fix this problem, read Network_Configuration#Device_names.

> IP configuration

Now you will need to configure the network interfaces. The best way to
do so is using netcfg profiles, instead of the regular network daemon.
You will need to create two profiles.

-   /etc/network.d/extern0-profile

    CONNECTION='ethernet'
    DESCRIPTION='Public Interface.'
    INTERFACE='extern0'
    IP='dhcp'

-   /etc/network.d/intern0-profile

    CONNECTION='ethernet'
    DESCRIPTION='Private Interface.'
    INTERFACE='intern0'
    IP='static'
    ADDR='10.0.0.1'
    NETMASK='255.255.255.0'
    BROADCAST='10.0.0.255'

Note:The example configuration above assumes a full subnet. If you are
building the gateway for a small amount of people, you will want to
change the netmask and broadcast to accommodate a smaller range.

Next up is to set up the interfaces.

-   Define the profiles in /etc/conf.d/netcfg:

    NETWORKS=(extern0-profile intern0-profile)

-   Replace the network daemon with net-profiles in /etc/rc.conf:

    DAEMONS=( ... net-profiles ... )

-   If using systemd, net-profiles.service is a symlink to
    netcfg.service. So you may do:

    # systemctl enable net-profiles.service

or if that fails:

    # systemctl enable netcfg.service

ADSL connection
---------------

Using rp-pppoe, we can connect an ADSL modem to the extern1 of the
firewall and have Arch manage the connection. Make sure you put the
modem in bridged mode though, otherwise the modem will act as a router
too.

    # pacman -S rp-pppoe

> Configuration: rp-pppoe

    /usr/sbin/pppoe-setup 

The questions are all documented. You can select "no firewall" because
we will let Shorewall / iptables handle that part.

DNS and DHCP
------------

We will use dnsmasq, a DNS and DHCP daemon for the LAN. It was
specifically designed for small sites.

First, install dnsmasq:

    # pacman -S dnsmasq

Now, dnsmasq needs to be configured. To do this:

Edit /etc/dnsmasq.conf and add the following lines

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

    # /etc/rc.d/dnsmasq start

and add the daemon to the DAEMONS list in /etc/rc.conf.

Connection sharing
------------------

Time to tie the two network interfaces to each other.

> iptables

Simple stateful firewall documents the setup of an iptables firewall and
NAT.

> Shorewall

Shorewall, an iptables frontend, can be used as an easier alternative.

    # pacman -S shorewall

Shorewall configuration

See Shorewall for Shorewall configuration.

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
from within the LAN. However, some applications such as MSN require this
to function correctly.

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

Install and configure DansGuardian if you need a content filtering
solution.

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
-   Internet Share

Retrieved from
"https://wiki.archlinux.org/index.php?title=Router&oldid=254865"

Categories:

-   Networking
-   Security
