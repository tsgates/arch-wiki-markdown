dnsmasq
=======

dnsmasq provides services as a DNS cacher and a DHCP server. As a Domain
Name Server (DNS), it can cache DNS queries to improve connection speed
to previously visited sites. As a DHCP server, dnsmasq can be used to
provide internal IP addresses and routes to computers on a LAN. Either
or both of these services can be implemented. dnsmasq is considered to
be lightweight and easy to configure; it is designed for personal
computer use or for use on a network with less than 50 computers. It
also comes with a PXE server.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 DNS Cache Setup                                                    |
|     -   2.1 DNS Addresses File                                           |
|         -   2.1.1 dhcpcd                                                 |
|         -   2.1.2 dhclient                                               |
|         -   2.1.3 NetworkManager                                         |
|             -   2.1.3.1 Other methods                                    |
|             -   2.1.3.2 Custom Configuration                             |
|                                                                          |
| -   3 DHCP Server Setup                                                  |
| -   4 Start the daemon                                                   |
| -   5 Test                                                               |
|     -   5.1 DNS Caching                                                  |
|     -   5.2 DHCP Server                                                  |
|                                                                          |
| -   6 Tips and tricks                                                    |
|     -   6.1 Prevent OpenDNS Redirecting Google Queries                   |
|     -   6.2 View leases                                                  |
+--------------------------------------------------------------------------+

Installing
----------

Install dnsmasq from the official repositories.

DNS Cache Setup
---------------

To set up dnsmasq as a DNS caching daemon on a single computer edit
/etc/dnsmasq.conf and uncomment the localhost listening address:

    listen-address=127.0.0.1

To use this computer to act as a default DNS specify the fixed IP
address of the network:

    listen-address=<192.168.1.1>  # Example IP

> DNS Addresses File

After configuring dnsmasq the DHCP client will need to prepend the
localhost address to the known DNS addresses in /etc/resolv.conf. This
causes all queries to be sent to dnsmasq before trying to resolve them
with an external DNS. After the DHCP client is configured the network
will need to be restarted for changes to take effect.

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
section then disable dnsmasq from loading as a daemon:

    /etc/NetworkManager/NetworkManager.conf

    [main]
    plugins=keyfile
    dns=dnsmasq

For permanent caching add a config directory for dnsmasq and set the
cache number of nameservers (default: 150?):

    mkdir /etc/NetworkManager/dnsmasq.d
    echo "cache-size=1000" | sudo tee /etc/NetworkManager/dnsmasq.d/cache

Other methods

If using the dnsmasq daemon, then it is necessary to add the localhost
address to resolv.conf (which NetworkManager will be overriding).

Since the upgrade of NetworkManager to 0.7, Arch Linux now calls dhcpcd
directly instead of the common default with dhclient. Because of the
arguments set with dhcpcd, it no longer sources the
/etc/resolv.conf.head, and /etc/resolv.conf.tail settings for insertion
of name servers. Several options are available.

The first option would be to add a script to the NetworkManager
dispatcher to prepend localhost to resolv.conf:

    /etc/NetworkManager/dispatcher.d/localhost-prepend

    #!/bin/bash                                       
    # Prepend localhost to resolv.conf for dnsmasq

    if [[ ! $(grep 127.0.0.1 /etc/resolv.conf) ]]; then
      sed -i '1s|^|nameserver 127.0.0.1\n|' /etc/resolv.conf
    fi

and make it executable:

    # chmod +x /etc/NetworkManager/dispatcher.d/localhost-prepend

The second option be to go into NetworkManagers' settings (usually by
right-clicking the applet) and entering settings manually. Setting up
will depending on the type of front-end used; the process usually
involves right-clicking on the applet, editing (or creating) a profile,
and then choosing DHCP type as 'Automatic (specify addresses).' The DNS
addresses will need to be entered and are usually in this form:
127.0.0.1, DNS-server-one, ....

Lastly, NetworkManager with dhclient can be used
(networkmanager-dhclient).

Custom Configuration

As of NetworkManager 0.9.6, custom configurations can be created for
dnsmasq by creating configuration files in
/etc/NetworkManager/dnsmasq.d/

DHCP Server Setup
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

To stand dnsmasq immediately:

    # systemctl start dnsmasq

To see if dnsmasq started properly, check the log; dnsmasq sends its
messages to /var/log/messages.log. The network will also need to be
restarted so the the DHCP client can create a new /etc/resolv.conf.

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
"https://wiki.archlinux.org/index.php?title=Dnsmasq&oldid=250555"

Category:

-   Domain Name System
