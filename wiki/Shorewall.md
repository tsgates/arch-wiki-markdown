Shorewall
=========

The Shoreline Firewall, more commonly known as "Shorewall", is
high-level tool for configuring Netfilter.

You describe your firewall/gateway requirements using entries in a set
of configuration files. Shorewall reads those configuration files and
with the help of the iptables utility, Shorewall configures Netfilter to
match your requirements.

Shorewall can be used on a dedicated firewall system, a multi-function
gateway/router/server or on a standalone GNU/Linux system. Shorewall
does not use Netfilter's ipchains compatibility mode and can thus take
advantage of Netfilter's connection state tracking capabilities.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 /etc/shorewall/interfaces                                    |
|     -   2.2 /etc/shorewall/policy                                        |
|     -   2.3 /etc/shorewall/rules                                         |
|         -   2.3.1 SSH                                                    |
|         -   2.3.2 Port forwarding (DNAT)                                 |
|                                                                          |
|     -   2.4 /etc/shorewall/shorewall.conf                                |
|                                                                          |
| -   3 Start                                                              |
+--------------------------------------------------------------------------+

Installation
------------

shorewall is available in the official repositories.

Configuration
-------------

These settings are based on the two-interface documentation on the
shorewall website.

Use the some example configuration files that come with the shorewall
package

    # cp /usr/share/shorewall/Samples/two-interfaces/* /etc/shorewall/

> /etc/shorewall/interfaces

Change the interface settings to match the names used for our ethernet
devices and to allow dhcp traffic on the local network. Edit
/etc/shorewall/interfaces

original

    net     eth0            detect          dhcp,tcpflags,nosmurfs,routefilter,logmartians
    loc     eth1            detect          tcpflags,nosmurfs,routefilter,logmartians

new

    net     wan            detect          dhcp,tcpflags,nosmurfs,routefilter,logmartians
    loc     lan            detect          dhcp,tcpflags,nosmurfs,routefilter,logmartians

> /etc/shorewall/policy

Change the policy file to allow the router (this machine) to access the
Internet. Edit /etc/shorewall/policy

original

    ###############################################################################
    #SOURCE         DEST            POLICY          LOG LEVEL       LIMIT:BURST

    loc             net             ACCEPT
    net             all             DROP            info
    # THE FOLLOWING POLICY MUST BE LAST
    all             all             REJECT          info

new

    ###############################################################################
    #SOURCE         DEST            POLICY          LOG LEVEL       LIMIT:BURST
    $FW             net             ACCEPT
    loc             net             ACCEPT
    net             all             DROP            info
    # THE FOLLOWING POLICY MUST BE LAST
    all             all             REJECT          info

> /etc/shorewall/rules

DNS lookups are handled (actually forwarded) by dnsmasq, so shorewall
needs to allow those connections. Add these lines to
/etc/shorewall/rules

    #       Accept DNS connections from the local network to the firewall
    #
    DNS(ACCEPT)     loc              $FW

SSH

OPTIONAL: You can add these lines if you want to be able to SSH into the
router from computers on the Internet

    #       Accept SSH connections from the internet for administration
    #
    SSH(ACCEPT)     net             $FW         TCP      <SSH port used>

Port forwarding (DNAT)

-   /etc/shorewall/rules : here is an example for a webserver on our LAN
    with IP 10.0.0.85. You can reach it on port 5000 of our "external"
    IP.

    DNAT        net        loc:10.0.0.85:80        tcp        5000

> /etc/shorewall/shorewall.conf

When you are finished making above changes, enable shorewall by a change
in it's config file /etc/shorewall/shorewall.conf:

original

    STARTUP_ENABLED=No

new

    STARTUP_ENABLED=Yes

See man page for more info.

Start
-----

    # systemctl enable shorewall
    # systemctl start shorewall

Retrieved from
"https://wiki.archlinux.org/index.php?title=Shorewall&oldid=254867"

Category:

-   Firewalls
