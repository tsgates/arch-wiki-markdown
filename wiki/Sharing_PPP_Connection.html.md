Sharing PPP Connection
======================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Internet    
                           Sharing.                 
                           Notes: Just a specific   
                           case of the topic        
                           described there.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Requirements
-   2 Installing
-   3 Sharing via wired ethernet
    -   3.1 Network bridge
-   4 Sharing via WLAN
-   5 Sharing script
-   6 See also

Requirements
------------

Before proceeding, you must make sure:

1.  You must have a working PPP connection.
2.  You must have an extra Ethernet interface card in your computer with
    which to share your connection.

Installing
----------

The following packages must be installed from the official repositories
for both Wired and Wireless sharing:

-   iptables: for controlling packets in your network.
-   dnsmasq: for acting as a DHCP and DNS caching server.
-   bridge-utils: for setting up a network bridge.

Depending on whether you want to share a wireless or wired connection,
you also have to install:

-   wired: iproute2 or net-tools (this article uses iproute2 since
    net-tools is deprecated).
-   wireless: iw or wireless_tools (this article uses iw since
    wireless_tools is deprecated).

Sharing via wired ethernet
--------------------------

-   Set the PPP connection up.

You can assign an IP address to the interface as usual, by running (as
root):

    # ip addr add 192.168.0.254 dev eth0

-   Set the kernel to router mode. This is done by running:

    # sysctl net.ipv4.ip_forward=1

-   Configure dnsmasq. Make the following changes to /etc/dnsmasq.conf
    (uncomment if necessary):

    /etc/dnsmasq.conf

    domain-needed
    bogus-priv
    interface=eth0 # change to your chosen interface
    dhcp-range=192.168.0.1,192.168.0.100,12h

-   Start the dnsmasq daemon.
-   Finally, set firewall to forward connections to and from the
    Internet for clients connecting to your WLAN. This is done by
    issuing:

    # iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE

In the above the ppp0 interface is the used PPP interface, you can
substitute it for yours if needed.

-   You are done! Happy surfing!

Warning:The previous configuration has no security options enabled. If
you are using a firewall, you should adapt this documentation to suit
your needs. Same applies also to setting up keys for WLAN interface.

> Network bridge

Let's assume your PPP connection is on eth0, and you want to share the
connection on eth1 and eth2.

    # ip addr add 0.0.0.0 dev eth1  # remove IP from eth0
    # ip link set eth1 up           # ensure the interface is up

    # ip addr add 0.0.0.0 dev eth2  # remove IP from eth1
    # ip link set eth2 up           # ensure the interface is up

    # brctl addbr br0               # create br0 node
    # brctl addif br0 eth1          # add eth0 to bridge br0
    # brctl addif br0 eth2          # add eth1 to bridge br0

    # ip addr add 192.168.0.254 dev br0

change your interface in dnsmasq.conf to br0:

    interface=br0 

and restart the dnsmasq daemon.

Now you should be able to connect to the internet using eth1 or eth2.

Sharing via WLAN
----------------

Warning:These instructions create unencrypted ad-hoc network. See Ad-hoc
networking#WPA supplicant for method using WPA1 encryption. For better
security, create an access point secured by WPA2.

-   Set up the PPP connection.
-   Set up the WLAN connection: choose an SSID and select Ad-hoc as
    network type. In the following it is assumed that you are using the
    wlan0 interface.

Set the wlan0 interface up address for example 192.168.0.254. Setting up
the interface is usually done by running:

    # iw wlan0 set type ibss
    # iw wlan0 ibss join MyFreeWlan

After that you can assign an IP address to the interface as usual, by
running:

    # ip addr add 192.168.0.254 dev wlan0

Please note that different wlan cards may be configured differently and
one should adapt this documentation accordingly.

-   Set the kernel to router mode. This is done by running:

    # echo 1 > /proc/sys/net/ipv4/ip_forward

-   Configure dnsmasq. Make the following changes to /etc/dnsmasq.conf
    (uncomment if necessary):

    etc/dnsmasq.conf

    domain-needed
    bogus-priv
    interface=wlan0    # change to your interface
    dhcp-range=192.168.0.1,192.168.0.100,12h

-   Start the dnsmasq daemon.
-   Finally, set firewall to forward connections to and from the
    Internet for clients connecting to your WLAN. This is done by
    issuing:

    # iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE

In the above the ppp0 interface is assumed to be the used PPP interface,
you can substitute it for yours if needed.

-   You are done! Happy surfing!

Warning:The previous configuration has no security options enabled! If
you are using firewall, you should adapt this documentation to suit your
needs. Same applies also to setting up keys for wlan interface.

Sharing script
--------------

A quick script for sharing eth0 over wlan0 on an ad-hoc network.

    ethoverwlan.sh

    #!/bin/bash

    iw wlan0 set type ibss
    iw wlan0 ibss join proxywlan
    ip addr add 192.168.0.254 dev wlan0
    ip link set wlan0 up
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    echo 1 > /proc/sys/net/ipv4/ip_forward

See also
--------

-   Simple stateful firewall
-   Router
-   Wireless network configuration
-   USB 3G Modem
-   Share your 3G Internet connection over wifi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sharing_PPP_Connection&oldid=297855"

Category:

-   Networking

-   This page was last modified on 15 February 2014, at 15:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
