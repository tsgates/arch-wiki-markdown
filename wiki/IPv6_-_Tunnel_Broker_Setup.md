IPv6 - Tunnel Broker Setup
==========================

Hurricane Electric offers a free tunnel broker service that is
relatively painless to use under Arch if you wish to add IPv6
connectivity to an IPv4-only host.

These instructions work for SixXS tunnels as well.

Contents
--------

-   1 Registering for a tunnel
-   2 Setting up SiXxs tunnel
-   3 Systemd script
-   4 Using the tunneling with dynamic IPv4 IP

Registering for a tunnel
------------------------

It is not that hard to do. Feel free to fill in the directions here if
something seems tricky, but otherwise just go the tunnel broker site and
complete the registration.

Setting up SiXxs tunnel
-----------------------

First, you need to have aiccu, radvd and iproute2 installed.

Now edit /etc/aiccu.conf and fill in your data. If you have several
tunnels, you need to also supplement the tunnel_id option in the file.
The following is an example for a dynamic ayiay tunnel.

    username <username>
    password <password>
    protocol tic
    server tic.sixxs.net
    ipv6_interface sixxs
    automatic true
    requiretls true
    pidfile /var/run/aiccu.pid
    defaultroute true
    makebeats true
    behindnat true

Test the configuration now with:

    # systemctl start aiccu

If it works, enable it:

    # systemctl enable aiccu

Configuring radvd and LAN side IP of the router: See Router.

Systemd script
--------------

    /etc/systemd/system/he-ipv6.service

    [Unit]
    Description=he.net IPv6 tunnel
    After=network.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/sbin/ip tunnel add he-ipv6 mode sit remote 209.51.161.14 local <local IPv4> ttl 255
    ExecStart=/sbin/ip link set he-ipv6 up mtu 1480
    ExecStart=/sbin/ip addr add ''local_IPv6''/64 dev he-ipv6
    ExecStart=/sbin/ip -6 route add ::/0 dev he-ipv6
    ExecStop=/sbin/ip -6 route del ::/0 dev he-ipv6
    ExecStop=/sbin/ip link set he-ipv6 down
    ExecStop=/sbin/ip tunnel del he-ipv6

    [Install]
    WantedBy=multi-user.target

Using the tunneling with dynamic IPv4 IP
----------------------------------------

The simplest way of using tunelling with a dynamic IPv4 IP is to set up
a cronjob that is going to periodically update your current address. To
do that open crontab -e and add, in a new line:

    */10 * * * * wget -O /dev/null https://USERNAME:PASSWORD@ipv4.tunnelbroker.net/ipv4_end.php?tid=TUNNELID >> /dev/null 2>&1

Which should also make wget quiet and not bothering you with emails
about its activity. Please replace USERNAME, PASSWORD and TUNNELID by
the details of your account and tunnel. I would recommend running the
command on its own first, to check if it works. To do that run:

    wget https://USERNAME:PASSWORD@ipv4.tunnelbroker.net/ipv4_end.php?tid=TUNNELID

Retrieved from
"https://wiki.archlinux.org/index.php?title=IPv6_-_Tunnel_Broker_Setup&oldid=296801"

Category:

-   Networking

-   This page was last modified on 11 February 2014, at 01:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
