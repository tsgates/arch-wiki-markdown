PPTP VPN client setup with pptpclient
=====================================

pptpclient is a program implementing the Microsoft PPTP protocol. As
such, it can be used to connect to a Microsoft VPN network (or any
PPTP-based VPN) provided by a school or workplace.

Contents
--------

-   1 Installing PPTP Client
-   2 Configure
    -   2.1 Configure using pptpsetup
    -   2.2 Configure by hand
        -   2.2.1 Edit The options File
        -   2.2.2 Edit The chap-secrets File
        -   2.2.3 Name Your Tunnel
-   3 Connect
    -   3.1 Routing
        -   3.1.1 Split Tunneling
        -   3.1.2 Route All Traffic
        -   3.1.3 Route All Traffic by /etc/ppp/ip-up.d
        -   3.1.4 Split Tunneling based on port by /etc/ppp/ip-up.d
-   4 Disconnect
-   5 Making A VPN Daemon and Connecting On Boot
-   6 Remarks
-   7 See also

Installing PPTP Client
----------------------

Install pptpclient from the official repositories.

Configure
---------

To configure pptpclient you will need to collect the following
information from your network administrator:

-   The IP address or hostname of the VPN server.
-   The username you will use to connect.
-   The password you will use to connect.
-   The authentication (Windows) domain name. This is not necessary for
    certain networks.

You must also decide what to name the tunnel.

> Configure using pptpsetup

You can configure and delete tunnels by running the pptpsetup tool as
root. For example:

    pptpsetup --create my_tunnel --server vpn.example.com --username alice --password foo --encrypt
    pptpsetup --delete my_tunnel

You can #Connect after a tunnel has been configured.

> Configure by hand

You can also edit all necessary configuration files by hand, rather than
relying on pptpsetup.

Edit The options File

The /etc/ppp/options file sets security options for your VPN client. If
you have trouble connecting to your network, you may need to relax the
options. At a minimum, this file should contain the options lock,
noauth, nobsdcomp and nodeflate.

    /etc/ppp/options

    # Lock the port
    lock
    # We don't need the tunnel server to authenticate itself
    noauth
    # Turn off compression protocols we know won't be used
    nobsdcomp
    nodeflate
    # We won't do PAP, EAP, CHAP, or MSCHAP, but we will accept MSCHAP-V2
    # (you may need to remove these refusals if the server is not using MPPE)
    refuse-pap
    refuse-eap
    refuse-chap
    refuse-mschap

Edit The chap-secrets File

The /etc/ppp/chap-secrets file contains credentials for authenticating a
tunnel. Make sure no one except root can read this file, as it contains
sensitive information.

    chmod 0600 /etc/ppp/chap-secrets

Edit the file. It has the following format:

    /etc/ppp/chap-secrets

    <DOMAIN>\\<USERNAME> PPTP <PASSWORD> *

Replace each bracketed term with an appropriate value. Omit <DOMAIN>\\
if your connection does not require a domain.

Note:Place your password in double quotation marks (") if it contains
special characters such as $.

Warning:This file contains passwords in plain text. Guard it well!

Name Your Tunnel

The /etc/ppp/peers/<TUNNEL> file contains tunnel-specific configuration
options. <TUNNEL> is the name you wish to use for your VPN connection.
The file should look like this:

    /etc/ppp/peers/<TUNNEL>

    pty "pptp <SERVER> --nolaunchpppd"
    name <DOMAIN>\\<USERNAME>
    remotename PPTP
    require-mppe-128
    file /etc/ppp/options
    ipparam <TUNNEL>

Again, omit <DOMAIN>\\ if your connection does not require a domain.
<SERVER> is the remote address of the VPN server, <DOMAIN> is the domain
your user belongs to, <USERNAME> is the name you will use to connect to
the server, and <TUNNEL> is the name of the connection.

Note:remotename PPTP is used to find <PASSWORD> in the
/etc/ppp/chap-secrets File.

Note:If you do not need MPPE support, you should remove the
require-mppe-128 option from this file and from /etc/ppp/options

Connect
-------

To make sure that everything is configured properly, as root execute:

    # pon <TUNNEL> debug dump logfd 2 nodetach

If everything has been configured correctly, the pon command should not
terminate. Once you are satisfied that it has connected successfully,
you can terminate the command.

Note:As an additional verification you can run ip addr show and ensure
that a new device, ppp0, is available.

To connect to your VPN normally, simply execute:

    # pon <TUNNEL>

Where <TUNNEL> is the name of the tunnel you established earlier. Note
that this command should be run as root.

> Routing

Once you have connected to your VPN, you should be able to interact with
anything available on the VPN server. To access anything on the remote
network, you need to add a new route to your routing table.

Note:Depending on your configuration, you may need to re-add the routing
information every time you connect to your VPN.

For more information on how to add routes, you can read this article
which has many more examples: PPTP Routing Howto

Split Tunneling

Packets with a destination of your VPN's network should be routed
through the VPN interface (usually ppp0). To do this, you create the
route:

    # ip route add 192.168.10.0/24 dev ppp0

This will route all the traffic with a destination of 192.168.10.*
through your VPN's interface, (ppp0).

Route All Traffic

It may be desirable to route all traffic through your VPN connection.
You can do this by running:

    # ip route add default dev ppp0

Note:Routing all traffic through the VPN may result in slower over all
connection speed because your traffic will be routed through the remote
VPN before being routed normally.

Route All Traffic by /etc/ppp/ip-up.d

Note:All scripts in /etc/ppp/ip-up.d/ will called when the VPN
connection is established.

    /etc/ppp/ip-up.d/01-routes.sh

    #!/bin/bash

    # This script is called with the following arguments:
    # Arg Name
    # $1 Interface name
    # $2 The tty
    # $3 The link speed
    # $4 Local IP number
    # $5 Peer IP number
    # $6 Optional ``ipparam'' value foo

    ip route add default via $4

Make sure the script is executable.

Split Tunneling based on port by /etc/ppp/ip-up.d

Note:All scripts in /etc/ppp/ip-up.d/ will called when the VPN
connection is established.

    /etc/ppp/ip-up.d/01-routebyport.sh

    #!/bin/bash

    # This script is called with the following arguments:
    # Arg Name
    # $1 Interface name
    # $2 The tty
    # $3 The link speed
    # $4 Local IP number
    # $5 Peer IP number
    # $6 Optional ``ipparam'' value foo

    echo 0 > /proc/sys/net/ipv4/conf/$1/rp_filter
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo 1 > /proc/sys/net/ipv4/ip_dynaddr

    ip route flush table vpn
    ip route add default via $5 dev $1 table vpn

    # forward only IRC ports over VPN
    iptables -t mangle -A OUTPUT -p tcp -m multiport --dports 6667,6697 -j MARK --set-mark 0x1
    iptables -t nat    -A POSTROUTING -o $1 -j MASQUERADE

    ip rule  add fwmark 0x1 pri 100 lookup vpn
    ip rule  add from $4 pri 200 table vpn
    ip route flush cache

Make sure the script is executable and that the vpn table is added to
/etc/iproute2/rt_tables

    201 vpn

Disconnect
----------

Execute the following to disconnect from a VPN:

    # poff <TUNNEL>

<TUNNEL> is the name of your tunnel.

Making A VPN Daemon and Connecting On Boot
------------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: recent changes   
                           to systemd. see          
                           https://wiki.archlinux.o 
                           rg/index.php/Systemd/Ser 
                           vices                    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

You can create a simple daemon for your VPN connection by creating an
appropriate /etc/rc.d/* script:

Note:As always, <TUNNEL> is the name of your tunnel. <ROUTING COMMAND>
is the command you use to add the appropriate route to the routing
table.

Note:The stop functionality of this script will not work if the updetach
and persist arguments are passed to /usr/bin/pon when pon is started.
The reason for this is that the /usr/bin/poff script contains a bug when
determining the PID of the specified pppd process if arguments were
passed to pon.

To resolve this issue, you can patch your /usr/bin/poff file by making
the following changes on line 93:

    -PID=`ps axw | grep "[ /]pppd call $1 *\$" | awk '{print $1}'`
    +PID=`ps axw | grep "[ /]pppd call $1" | awk '{print $1}'`

    /etc/rc.d/name-of-your-vpn

    #!/bin/bash

    . /etc/rc.conf
    . /etc/rc.d/functions

    DAEMON=<TUNNEL>-vpn
    ARGS=

    [ -r /etc/conf.d/$DAEMON ] && . /etc/conf.d/$DAEMON


    case "$1" in
     start)
       stat_busy "Starting $DAEMON"
       pon <TUNNEL> updetach persist &>/dev/null && <ROUTING COMMAND> &>/dev/null
       if [ $? = 0 ]; then
         add_daemon $DAEMON
         stat_done
       else
         stat_fail
         exit 1
       fi
       ;;
     stop)
       stat_busy "Stopping $DAEMON"
       poff <TUNNEL> &>/dev/null
       if [ $? = 0 ]; then
         rm_daemon $DAEMON
         stat_done
       else
         stat_fail
         exit 1
       fi
       ;;
     restart)
       $0 stop
       sleep 1
       $0 start
       ;;
     *)
       echo "usage: $0 {start|stop|restart}"  
    esac

Note:We call pon in the script with two additional arguments: updetach
and persist. The argument updetach makes pon block until the connection
has been established. The other argument, persist, makes the network
automatically reconnect in the event of a failure. To connect at boot
add @<TUNNEL>-vpn to the end of your DAEMONS array in /etc/rc.conf.

Remarks
-------

You can find more information about configuring pptpclient at their
website: pptpclient website. The contents of this article where adapted
from their Ubuntu How-To which also provides some hints on how to do
things such as connecting on boot. These examples should be easy to
adapt into daemons or other scripts to help automate your configuration.

See also
--------

PPTP Server

Retrieved from
"https://wiki.archlinux.org/index.php?title=PPTP_VPN_client_setup_with_pptpclient&oldid=305717"

Category:

-   Virtual Private Network

-   This page was last modified on 20 March 2014, at 01:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
