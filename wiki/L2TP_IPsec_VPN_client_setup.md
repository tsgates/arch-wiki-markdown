L2TP/IPsec VPN client setup
===========================

L2TP/IPsec is a secure Virtual Private Network solution that is well
supported on many different platforms.

This article aims to describe in a HOWTO like fashion how to configure
and use a L2TP/IPsec client on Arch Linux. This article will cover the
installation and setup of several software packages. One of the packages
is only available in the AUR, so knowledge of how to build and install
AUR packages on your system is required, as I will not cover how to do
that.

This guide is primarly for clients connecting to a Windows Server
machine. It uses some setting that are specific to the Microsoft
implementation of L2TP/IPsec.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 OpenSwan                                                     |
|     -   2.2 xl2tpd                                                       |
|                                                                          |
| -   3 Routing                                                            |
|     -   3.1 Routing traffic to a single IP address through the tunnel    |
|     -   3.2 Routing all traffic through the tunnel                       |
|                                                                          |
| -   4 Troubleshooting                                                    |
| -   5 Tips and Tricks                                                    |
|     -   5.1 Script start up and shut down                                |
|     -   5.2 A further script                                             |
|     -   5.3 AUR link for the OpenSwan package                            |
|                                                                          |
| -   6 External links                                                     |
| -   7 Acknowledgements                                                   |
+--------------------------------------------------------------------------+

Installation
------------

Install xl2tpd from the repos and ipsec-openswan from the AUR.

Configuration
-------------

> OpenSwan

Edit /etc/ipsec.conf: It should contain the following lines:

      config setup
           virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12
           nat_traversal=yes
           protostack=netkey
           oe=no
      # Replace eth0 with your network interface
           plutoopts="--interface=eth0"
      conn L2TP-PSK
           authby=secret
           pfs=no
           auto=add
           keyingtries=3
           dpddelay=30
           dpdtimeout=120
           dpdaction=clear
           rekey=yes
           ikelifetime=8h
           keylife=1h
           type=transport
      # Replace IP address with your local IP (private, behind NAT IP is okay as well)
           left=192.168.1.101
           leftnexthop=%defaultroute
           leftprotoport=17/1701
      # Replace IP address with your VPN server's IP
           right=68.68.32.79
           rightprotoport=17/1701

This file contains the basic information to establish a secure IPsec
tunnel to the VPN server. It enables NAT Traversal for if your machine
is behind a NAT'ing router (most people are), and various other options
that are necessary to connect correctly to the remote IPsec server. The
next file contains your pre-shared key (PSK) for the server.

Create the file /etc/ipsec.secrets: It should contain the following
line:

    192.168.1.101 68.68.32.79 : PSK "your_pre_shared_key"

Remember to replace the local (192.168.1.101) and remote (68.68.32.79)
IP addresses with the correct numbers for your location. The pre-shared
key will be supplied by the VPN provider and will need to be placed in
this file in cleartext form.

At this point the IPsec configuration is complete and we can move on to
the L2TP configuration.

> xl2tpd

Edit /etc/xl2tpd/xl2tpd.conf: It should resemble the following:

      [lac vpn-connection]
      lns = 68.68.32.79
      ppp debug = yes
      pppoptfile = /etc/ppp/options.l2tpd.client
      length bit = yes

This file configures xl2tpd with the connection name, server IP
address(which again, please remember to change to your servers address)
and various options that will be passed to pppd once the tunnel is set
up.

Now modify /etc/ppp/options.l2tpd.client:

     ipcp-accept-local
     ipcp-accept-remote
     refuse-eap
     require-mschap-v2
     noccp
     noauth
     idle 1800
     mtu 1410
     mru 1410
     defaultroute
     usepeerdns
     debug
     lock
     connect-delay 5000
     name your_vpn_username
     password your_password

Place your assigned username and password for the VPN server in this
file. A lot of these options are for interoperability with Windows
Server L2TP servers.

This concludes the configuration of the applicable software suites to
connect to a L2TP/IPsec server. To start the connection do the
following:

     /etc/rc.d/openswan start
     /etc/rc.d/xl2tpd start
     ipsec auto --up L2TP-PSK
     echo "c vpn-connection" > /var/run/xl2tpd/l2tp-control

At this point the tunnel is up and you should be able to see the
interface for it if you type:

    $ ip link

You should see a pppX device that represents the tunnel. Right now,
nothing is going to get routed through it. You need to add some routing
rules to make it work right:

Routing
-------

> Routing traffic to a single IP address through the tunnel

This is as easy as adding a routing rule to your kernel table:

     # ip route add xxx.xxx.xxx.xxx via yyy.yyy.yyy.yyy dev eth0

Replace xxx.xxx.xxx.xxx with the specific ip address of the server that
you wish to communicate with through the tunnel, then replace
yyy.yyy.yyy.yyy with the remote IP your PPP connection. The remote IP of
a PPP connection can be discovered by issuing:

     # ip a

and reading the P-t-P address for the PPP interface that corresponds to
your tunnel.

> Routing all traffic through the tunnel

This is a lot more complex, but all your traffic will travel through the
tunnel. Start by adding a special route for the actual VPN server
through your current gateway:

     # ip route add 68.68.32.79 via 192.168.1.1 dev eth0

This will ensure that once the default gateway is changed to the ppp
interface that your network stack can still find the VPN server by
routing around the tunnel. If you miss this step you will lose
connectivity to the Internet and the tunnel will collapse. Now add a
default route that routes to the PPP remote end:

     # ip route add default via yyy.yyy.yyy.yyy dev eth0

The remote PPP end can be discovered by following the step in the
previous section. Now to ensure that ALL traffic is routing through the
tunnel, delete the original default route:

     # ip route delete default via 192.168.1.1 dev eth0

To restore your system to the previous state, you can reboot or reverse
all of the above steps.

Troubleshooting
---------------

Issue: I get a message from pppd saying "Failed to authenticate
ourselves to peer" and I've verified my password is correct. What could
be wrong?

Solution: If you see the following in your /var/log/daemon.log:

    Dec 20 15:14:03 myhost pppd[26529]: rcvd [CHAP Challenge id=0x1 <some_or_another_hash>, name = "SonicWALL"]
    Dec 20 15:14:03 myhost pppd[26529]: sent [CHAP Response id=0x1 <some_or_another_hash>, name = "your_vpn_username"]
    Dec 20 15:14:03 myhost pppd[26529]: rcvd [LCP EchoRep id=0x0 magic=0x45c269c6]
    Dec 20 15:14:03 myhost pppd[26529]: rcvd [CHAP Failure id=0x1 ""]
    Dec 20 15:14:03 myhost pppd[26529]: CHAP authentication failed
    Dec 20 15:14:03 myhost pppd[26529]: CHAP authentication failed
    Dec 20 15:14:03 myhost pppd[26529]: sent [LCP TermReq id=0x3 "Failed to authenticate ourselves to peer"]
    Dec 20 15:14:03 myhost pppd[26529]: rcvd [LCP TermReq id=0x2]
    Dec 20 15:14:03 myhost pppd[26529]: sent [LCP TermAck id=0x2]
    Dec 20 15:14:03 myhost pppd[26529]: rcvd [LCP TermAck id=0x3]

then you are authenticating against a SonicWALL LNS that does not know
how to handle CHAP-style authentication correctly.

The solution to this is to add the following to your options.l2tp.client
file:

       refuse-chap

This will cause the SonicWALL to default to the next authentication
mechanism, namely MSCHAP-v2. This should authenticate successfully, and
from this point xl2tpd should successfully construct a tunnel between
you and the remote L2TP server.

Tips and Tricks
---------------

> Script start up and shut down

You can create some scripts either in your home directory or
elsewhere(remember where you put them) to bring up the tunnel then shut
it back down.

First, a utility script to automatically discover PPP distant ends:
getip.sh

      #!/bin/bash
      
      /sbin/ifconfig $1 | grep "P-t-P" | gawk -F: '{print $2}' | gawk '{print $1}'

Next, the script to bring the tunnel up. This will replace the default
route, so all traffic will pass via the tunnel: startvpn.sh

      
      #!/bin/bash
      
      /etc/rc.d/openswan start
      sleep 2                                                   #delay to ensure that IPsec is started before overlaying L2TP
      /etc/rc.d/xl2tpd start
      /usr/sbin/ipsec auto --up L2TP-PSK                        
      /bin/echo "c vpn-connection" > /var/run/xl2tpd/l2tp-control     
      sleep 2                                                   #delay again to make that the PPP connection is up.
      PPP_GW_ADD=`./getip.sh ppp0`
      
      ip route add 68.68.32.79 via 192.168.1.1 dev eth0
      ip route add default via $PPP_GW_ADD
      ip route del default via 192.168.1.1

Finally, the shutdown script, it simply reverses the process: stopvpn.sh

      #!/bin/bash
      
      /usr/sbin/ipsec auto --down L2TP-PSK
      /bin/echo "d vpn-connection" > /var/run/xl2tpd/l2tp-control
      /etc/rc.d/xl2tpd stop
      /etc/rc.d/openswan stop
      
      ip route del 68.68.32.79 via 192.168.1.1 dev eth0
      ip route add default via 192.168.1.1

> A further script

Above script really help me work. And notice the script use fixed ip,
and someone like me may change net vpn addr, i'd like to put my further
script below(not sure how to add attachment, so just raw ):

    #!/bin/bash
    if [ $# != 1 ] ; then
    	echo "Usage: (sudo) sh $0 {init|start|stop}" 
    	exit 1;
    fi

    VPN_ADDR=XXX
    IFACE=wlan0

    function getIP(){
    	/sbin/ifconfig $1 |grep "inet "|awk '{print $2}'
    }

    function getGateWay(){
    	/sbin/route -n |grep -m 1 "^0\.0\.0\.0" |awk '{print $2}'
    }
    function getVPNGateWay(){
    	/sbin/route -n |grep -m 1 "$VPN_ADDR" |awk '{print $2}'
    }

    GW_ADDR=$(getGateWay)  

    function init(){
    	cp ./options.l2tpd.client /etc/ppp/
    	cp ./ipsec.conf /etc/
    	cp ./ipsec.secrets /etc/
    	cp ./xl2tpd.conf /etc/xl2tpd/
    }

    function start(){
    	sed -i "s/^lns =.*/lns = $VPN_ADDR/g" /etc/xl2tpd/xl2tpd.conf
    	sed -i "s/plutoopts=.*/plutoopts=\"--interface=$IFACE\"/g" /etc/ipsec.conf
    	sed -i "s/left=.*$/left=$(getIP $IFACE)/g" /etc/ipsec.conf
    	sed -i "s/right=.*$/right=$VPN_ADDR/g" /etc/ipsec.conf
    	sed -i "s/^.*: PSK/$(getIP $IFACE) $VPN_ADDR : PSK/g" /etc/ipsec.secrets
    	/etc/rc.d/openswan start
    	sleep 2    #delay to ensure that IPsec is started before overlaying L2TP

    	/etc/rc.d/xl2tpd start
    	/usr/sbin/ipsec auto --up L2TP-PSK                        
    	/bin/echo "c vpn-connection" > /var/run/xl2tpd/l2tp-control     
    	sleep 2    #delay again to make that the PPP connection is up.

    	route add $VPN_ADDR gw $GW_ADDR $IFACE
    	route add default gw $(getIP ppp0)
    	route delete default gw $GW_ADDR
    }

    function stop(){
    	/usr/sbin/ipsec auto --down L2TP-PSK
    	/bin/echo "d vpn-connection" > /var/run/xl2tpd/l2tp-control
    	/etc/rc.d/xl2tpd stop
    	/etc/rc.d/openswan stop
    	
    	VPN_GW=$(getVPNGateWay)
    	route delete $VPN_ADDR gw $VPN_GW $IFACE
    	route add default gw $VPN_GW
    }

    $1
    exit 0

> AUR link for the OpenSwan package

OpenSwan can be found in the AUR.

External links
--------------

-   http://openswan.org/
-   http://www.xelerance.com/software/xl2tpd/
-   http://strongvpn.com/forum/viewtopic.php?pid=1844/

Acknowledgements
----------------

I would like to thank phaoost from the StrongVPN forums for his initial
guide to setup L2TP/IPsec on Linux, for without, this article would
certainly not be possible.

Retrieved from
"https://wiki.archlinux.org/index.php?title=L2TP/IPsec_VPN_client_setup&oldid=249171"

Category:

-   Virtual Private Network
