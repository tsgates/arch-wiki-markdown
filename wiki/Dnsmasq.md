dnsmasq
=======

dnsmasq provides services as a DNS cacher and a DHCP server. As a Domain
Name Server (DNS) it can cache DNS queries to improve connection speeds
to previously visited sites, and as a DHCP server dnsmasq can be used to
provide internal IP addresses and routes to computers on a LAN. Either
or both of these services can be implemented. dnsmasq is considered to
be lightweight and easy to configure; it is designed for personal
computer use or for use on a network with less than 50 computers. It
also comes with a PXE server.

Contents
--------

-   1 Installation
-   2 DNS Cache Setup
    -   2.1 DNS Addresses File
        -   2.1.1 resolv.conf
            -   2.1.1.1 More than three nameservers
        -   2.1.2 dhcpcd
        -   2.1.3 dhclient
        -   2.1.4 NetworkManager
            -   2.1.4.1 Other methods
-   3 DHCP server setup
-   4 Start the daemon
-   5 Test
    -   5.1 DNS Caching
    -   5.2 DHCP Server
-   6 Tips and tricks
    -   6.1 Prevent OpenDNS Redirecting Google Queries
    -   6.2 View leases

Installation
------------

Install dnsmasq from the official repositories.

DNS Cache Setup
---------------

To set up dnsmasq as a DNS caching daemon on a single computer edit
/etc/dnsmasq.conf and uncomment the listen-address directive, adding in
the localhost IP address:

    listen-address=127.0.0.1

To use this computer to listen on it's LAN IP address for other
computers on the network:

    listen-address=192.168.1.1    # Example IP

It is recommended that you use a static LAN ip in this case.

> DNS Addresses File

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           resolv.conf.             
                           Notes: Same topic. Also  
                           note that most of this   
                           can be done also         
                           natively in              
                           /etc/resolvconf.conf     
                           using the name_servers   
                           and name_servers_append  
                           options. (Discuss)       
  ------------------------ ------------------------ ------------------------

After configuring dnsmasq the DHCP client will need to prepend the
localhost address to the known DNS addresses in /etc/resolv.conf. This
causes all queries to be sent to dnsmasq before trying to resolve them
with an external DNS. After the DHCP client is configured the network
will need to be restarted for changes to take effect.

resolv.conf

One option is a pure resolv.conf configuration. To do this, just make
the first nameserver in /etc/resolv.conf point to localhost:

    /etc/resolv.conf

    nameserver 127.0.0.1
    # External nameservers
    ...

Now DNS queries will be resolved first with dnsmasq, only checking
external servers if dnsmasq cannot resolve the query. dhcpcd,
unfortunately, tends to overwrite /etc/resolv.conf by default, so if you
use DHCP it is a good idea to protect /etc/resolv.conf. To do this,
append nohook resolv.conf to the dhcpcd config file:

    /etc/dhcpcd.conf

    ...
    nohook resolv.conf

More than three nameservers

A limitation the way Linux handles DNS queries is that there can only be
a maximum of three nameservers used in resolv.conf. As a workaround, you
can make localhost the only nameserver in resolv.conf, and then create a
separate resolv-file for your external nameservers. First, create a new
resolv file for dnsmasq:

    /etc/resolv.dnsmasq.conf

    # Google's nameservers, for example
    nameserver 8.8.8.8
    nameserver 8.8.4.4

And then edit /etc/dnsmasq.conf to use your new resolv file:

    /etc/dnsmasq.conf

    ...
    resolv-file=/etc/resolv.dnsmasq.conf
    ...

dhcpcd

dhcpcd has the ability to prepend or append nameservers to
/etc/resolv.conf by creating (or editing) the /etc/resolv.conf.head and
/etc/resolv.conf.tail files respectively:

    echo "nameserver 127.0.0.1" > /etc/resolv.conf.head

dhclient

For dhclient, uncomment in /etc/dhclient.conf:

    prepend domain-name-servers 127.0.0.1;

NetworkManager

NetworkManager has the ability to start dnsmasq from its configuration
file. Add the option dns=dnsmasq to NetworkManager.conf in the [main]
section then disable the dnsmasq.service from being loaded by systemd:

    /etc/NetworkManager/NetworkManager.conf

    [main]
    plugins=keyfile
    dns=dnsmasq

Custom configurations can be created for dnsmasq by creating
configuration files in /etc/NetworkManager/dnsmasq.d/. For example, to
change the size of the DNS cache (which is stored in RAM):

    /etc/NetworkManager/dnsmasq.d/cache

    cache-size=1000

When dnsmasq is started by NetworkManager, the config file in this
directory is used instead of the default config file.

Tip:This method can allow you to enable custom DNS settings on
particular domains. For instance:
server=/example1.com/exemple2.com/xx.xxx.xxx.x change the first DNS
address to xx.xxx.xxx.xx while browsing only the following websites
example1.com, example2.com. This method is preferred to a global DNS
configuration when using particular DNS nameservers which lack of speed,
stability, privacy and security.

Other methods

Another option is in NetworkManagers' settings (usually by
right-clicking the applet) and entering settings manually. Setting up
will depending on the type of front-end used; the process usually
involves right-clicking on the applet, editing (or creating) a profile,
and then choosing DHCP type as 'Automatic (specify addresses).' The DNS
addresses will need to be entered and are usually in this form:
127.0.0.1, DNS-server-one, ....

DHCP server setup
-----------------

By default dnsmasq has the DHCP functionality turned off, if you want to
use it you must turn it on in (/etc/dnsmasq.conf). Here are the
important settings:

    # Only listen to routers' LAN NIC.  Doing so opens up tcp/udp port 53 to
    # localhost and udp port 67 to world:
    interface=<LAN-NIC>

    # dnsmasq will open tcp/udp port 53 and udp port 67 to world to help with
    # dynamic interfaces (assigning dynamic ips). Dnsmasq will discard world
    # requests to them, but the paranoid might like to close them and let the 
    # kernel handle them:
    bind-interfaces

    # Dynamic range of IPs to make available to LAN pc
    dhcp-range=192.168.111.50,192.168.111.100,12h

    # If you’d like to have dnsmasq assign static IPs, bind the LAN computer's
    # NIC MAC address:
    dhcp-host=aa:bb:cc:dd:ee:ff,192.168.111.50

Start the daemon
----------------

To have dnsmasq to load upon startup:

    # systemctl enable dnsmasq

To start dnsmasq immediately:

    # systemctl start dnsmasq

To see if dnsmasq started properly, check the system's journal:

    $ journalctl -u dnsmasq

The network will also need to be restarted so the the DHCP client can
create a new /etc/resolv.conf.

Test
----

> DNS Caching

To do a lookup speed test choose a website that has not been visited
since dnsmasq has been started (dig is part of the dnsutils package):

    $ dig archlinux.org | grep "Query time"

Running the command again will use the cached DNS IP and result in a
faster lookup time if dnsmasq is setup correctly.

> DHCP Server

From a computer that is connected to the one with dnsmasq on it,
configure it to use DHCP for automatic IP address assignment, then
attempt to log into the network normally.

Tips and tricks
---------------

> Prevent OpenDNS Redirecting Google Queries

To prevent OpenDNS from redirecting all Google queries to their own
search server, add to /etc/dnsmasq.conf:

    server=/www.google.com/<ISP DNS IP>

> View leases

    $ cat /var/lib/misc/dnsmasq.leases

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dnsmasq&oldid=304454"

Category:

-   Domain Name System

-   This page was last modified on 14 March 2014, at 14:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
