PPTP Server
===========

The Point-to-Point Tunneling Protocol (PPTP) is a method for
implementing virtual private networks. PPTP uses a control channel over
TCP and a GRE tunnel operating to encapsulate PPP packets.

This entry will show you on how to create a PPTP server in Arch.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 iptables firewall configuration                              |
|     -   2.2 ufw firewall configuration                                   |
|                                                                          |
| -   3 Start up                                                           |
|     -   3.1 Using initscript                                             |
|     -   3.2 Using systemd                                                |
|                                                                          |
| -   4 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Installation
------------

Install pptpd, available in the Official Repositories.

Configuration
-------------

Now, edit the file /etc/pptpd.conf

    /etc/pptpd.conf

    option /etc/ppp/pptpd-options
    localip 172.16.36.1
    remoteip 172.16.36.2-254

Now, edit the file /etc/ppp/pptpd-options

    /etc/ppp/pptpd-options

    name pptpd
    refuse-pap
    refuse-chap
    refuse-mschap
    require-mschap-v2
    require-mppe-128
    proxyarp
    lock
    nobsdcomp
    novj
    novjccomp
    nologfd
    ms-dns 8.8.8.8
    ms-dns 8.8.4.4

Now we must add my users & passwords in /etc/ppp/chap-secrets

    /etc/ppp/chap-secrets

    <username>     pptpd     <password>   *

Now, enable IP Forwarding by editing /etc/sysctl.conf

    /etc/sysctl.conf

    net.ipv4.ip_forward=1

Now apply the changes made to sysctl.conf

    # sysctl -p

> iptables firewall configuration

Configure your iptables settings to enable access for PPTP Clients

    iptables -A INPUT -i ppp+ -j ACCEPT
    iptables -A OUTPUT -o ppp+ -j ACCEPT

    iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
    iptables -A INPUT -p 47 -j ACCEPT
    iptables -A OUTPUT -p 47 -j ACCEPT

    iptables -F FORWARD
    iptables -A FORWARD -j ACCEPT

    iptables -A POSTROUTING -t nat -o eth0 -j MASQUERADE
    iptables -A POSTROUTING -t nat -o ppp+ -j MASQUERADE

Now save the new iptables rules with:

    # rc.d save iptables

For systemd users after editing the rules:

    # iptables-save > /etc/iptables/iptables.rules

Read Iptables for more information.

> ufw firewall configuration

Configure your ufw settings to enable access for PPTP Clients.

You must change default forward policy in /etc/default/ufw

    /etc/default/ufw

    DEFAULT_FORWARD_POLICY=”ACCEPT”

Now change /etc/ufw/before.rules, add following code after header and
before *filter line

    /etc/ufw/before.rules

    # nat Table rules
    *nat
    :POSTROUTING ACCEPT [0:0]

    # Allow traffic from clients to eth0
    -A POSTROUTING -s 172.16.36.0/24 -o eth0 -j MASQUERADE

    # don.t delete the .COMMIT. line or these nat table rules won.t be processed
    COMMIT

Open pptp port 1723

    ufw allow 1723

Restart ufw for good measure

    ufw disable
    ufw enable

Start up
--------

Now you can start your PPTP Server by this command and enjoy

> Using initscript

    # rc.d start pptpd

You can use this script to auto install pptpd server.

> Using systemd

The service unit file is now provided with the pptpd package.

Start the PPTP server.

    # systemctl start pptpd.service

If you want to start your PPTP server while system startup, you could
enable it in systemd.

    # systemctl enable pptpd.service

Troubleshooting
---------------

If you keep getting error 619 on the client side, search for the logwtmp
option in /etc/pptpd.conf and comment it out. When this is enabled, wtmp
will be used to record client connections and disconnections.

    #logwtmp

Retrieved from
"https://wiki.archlinux.org/index.php?title=PPTP_Server&oldid=234346"

Category:

-   Virtual Private Network
