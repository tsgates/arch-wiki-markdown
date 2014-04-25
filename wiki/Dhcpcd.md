dhcpcd
======

Related articles

-   Network configuration
-   Wireless network configuration
-   dhcpd

dhcpcd is a DHCP and DHCPv6 client. It is currently the most
feature-rich open source DHCP client, see the home page for the full
list of features.

Note:dhcpcd (DHCP client daemon) is not the same as dhcpd (DHCP (server)
daemon).

Contents
--------

-   1 Installation
-   2 Running
-   3 Configuration
    -   3.1 DHCP static route(s)
    -   3.2 DHCP Client Identifier
    -   3.3 Speed up DHCP by disabling ARP probing
-   4 Tips and tricks
    -   4.1 Remove old DHCP lease
-   5 Troubleshooting
    -   5.1 Client ID
    -   5.2 Check DHCP problem by releasing IP first
    -   5.3 Problems with incompliant routers
    -   5.4 dhcpcd, systemd & wpa_supplicant
-   6 Hooks

Installation
------------

The dhcpcd package is available in the official repositories. It is part
of the base group, so it is likely already installed on your system.

You might be interested in dhcpcd-ui, which is a GTK+ frontend for the
dhcpcd daemon (and optionally wpa_supplicant). It features a
configuration dialogue and the ability to enter a pass phrase for
wireless networks.

Running
-------

dhcpcd is usually controlled via the provided service file
dhcpcd@.service, which takes the interface name as an argument (see
systemd#Using units for details):

    # systemctl start dhcpcd@interface.service
    # systemctl enable dhcpcd@interface.service

To start dhcpcd manually, simply run the following command:

    # dhcpcd interface

    dhcpcd: version 5.1.1 starting
    dhcpcd: interface: broadcasting for a lease
    ...
    dhcpcd: interface: leased 192.168.1.70 for 86400 seconds

Configuration
-------------

The main configuration is done in /etc/dhcpcd.conf, see dhcpcd.conf(5)
for details. Some of the frequently used options are highlighted below.

> DHCP static route(s)

If you need to add a static route client-side, create a new dhcpcd
hook-script in /usr/lib/dhcpcd/dhcpcd-hooks. The example shows a new
hook-script which adds a static route to a VPN subnet on 10.11.12.0/24
via a gateway machine at 192.168.192.5:

    /usr/lib/dhcpcd/dhcpcd-hooks/40-vpnroute

    ip route add 10.11.12.0/24 via 192.168.192.5

The 40 prefix means that it is the final hook-script to run when dhcpcd
starts.

> DHCP Client Identifier

The DHCP client may be uniquely identified in different ways by the
server:

-   hostname (or the hostname value sent by the client),
-   MAC address of the network interface controller through which the
    connection is being made, linked to this is the third,
-   Identity Association ID (IAID), which is an abstraction layer to
    differentiate different use-cases and/or interfaces on a single
    host,
-   DHCP Unique Identifier (DUID).

For a further description, see RFC 3315.

It depends on the DHCP-server configuration which options are optional
or required to request a DHCP IP lease. If the dhcpcd default
configuration fails to obtain an IP, the following options are available
to use in dhcpcd.conf:

-   hostname sends the hostname set in /etc/hostname
-   clientid sends the MAC address as identifier
-   IAID <interface> derives the IAID for the interface <interface> to
    use for DHCP discovery. Both have to be used together, but more
    frequently the next option is used:
-   duid triggers using a combination of DUID and IAID as identifier.

The DUID value is set in /etc/dhcpcd.duid.

Care must be taken on a network running Dynamic DNS to ensure that all
three are unique. If duplicate DUID values are presented to the DNS
server, e.g. in the case where a virtual machine has been cloned and the
hostname and MAC have been made unique but the DUID has not been
changed, then the result will be that as each client with the duplicated
DUID requests a lease the server will remove the predecessor from the
DNS record.

> Speed up DHCP by disabling ARP probing

dhcpcd contains an implementation of a recommendation of the DHCP
standard (RFC2131 section 2.2) to check via ARP if the assigned IP
address is really not taken. This seems mostly useless in home networks,
so you can save about 5 seconds on every connect by adding the following
line to /etc/dhcpcd.conf:

    noarp

This is equivalent to passing --noarp to dhcpcd, and disables the
described ARP probing, speeding up connections to networks with DHCP.

Tips and tricks
---------------

> Remove old DHCP lease

The file /var/lib/dhcpcd/dhcpcd-interface.lease, where interface is the
name of the interface on which you have a lease, contains the actual
DHCP lease reply sent by the DHCP server. It is used to determine the
last lease from the server, and its mtime attribute is used to determine
when it was issued. This last lease information is then used to request
the same IP address previously held on a network, if it is available. If
you do not want that, simply delete this file.

Troubleshooting
---------------

> Client ID

If you are on a network with DHCPv4 that filters Client IDs based on MAC
addresses, you may need to change the following line:

    /etc/dhcpcd.conf

    # Use the same DUID + IAID as set in DHCPv6 for DHCPv4 Client ID as per RFC4361. 
    duid

To:

    /etc/dhcpcd.conf

    # Use the hardware address of the interface for the Client ID (DHCPv4).
    clientid

Else, you may not obtain a lease since the DHCP server may not read your
DHCPv6-style Client ID correctly. See RFC 4361 for more information.

> Check DHCP problem by releasing IP first

Problem may occur when DHCP get wrong IP assignment. For example when
two routers are tied together through VPN. The router that is connected
to me by VPN may assigning IP address. To fix it. On a console, as root,
release IP address:

    # dhcpcd -k

Then request a new one:

    # dhcpcd

Maybe you had to run those two commands many times.

> Problems with incompliant routers

For some (incompliant) routers, you will not be able to connect properly
unless you comment the line

    require dhcp_server_identifier

in /etc/dhcpcd.conf. This should not cause issues unless you have
multiple DHCP servers on your network (not typical); see this page for
more information.

> dhcpcd, systemd & wpa_supplicant

archlinux dhcpcd package is delivered with a client configuration script
to run wpa_supplicant (/lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant).

When you manage wpa_supplicant daemon with systemd this can result in
unexpected behavior e.g.

-   you stop wpa_supplicant via systemd and dhcpcd starts wpa_supplicant
    via hook
-   dhcpcd starts wpa_supplicant daemon during boot (this can result in
    systemd-udevd error: "error changing net interface name wlan0 to
    wlp4s0: Device or resource busy" and can prevent "Predictable
    Network Interface Names" )

To disable the wpa_supplicant hook, add nohook wpa_supplicant into
dhcpcd.conf.

Hooks
-----

dhcpcd executes all scripts found in /usr/lib/dhcpcd/dhcpcd-hooks/ in a
lexical order. See dhcpcd(5) and dhcpcd-run-hooks(8) for details.

> Note:

-   Each script can be disabled using the nohook option in dhcpcd.conf.
-   The env option can be used to set an environment variable for all
    hooks. For example, you can force the hostname hook to always set
    the hostname with env force_hostname=YES.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: describe (at     
                           least some) provided     
                           hooks, e.g.              
                           10-wpa_supplicant        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dhcpcd&oldid=305640"

Category:

-   Networking

-   This page was last modified on 19 March 2014, at 18:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
