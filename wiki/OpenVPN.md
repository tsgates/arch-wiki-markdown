OpenVPN
=======

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: (at least) add   
                           support for ipv6 and L2  
                           ethernet bridging        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article describes a basic installation and configuration of
OpenVPN, suitable for private and small business use. For more detailed
information, please see the official OpenVPN 2.2 man page and the
OpenVPN documentation.

OpenVPN is a robust and highly flexible VPN daemon. OpenVPN supports
SSL/TLS security, ethernet bridging, TCP or UDP tunnel transport through
proxies or NAT, support for dynamic IP addresses and DHCP, scalability
to hundreds or thousands of users, and portability to most major OS
platforms.

OpenVPN is tightly bound to the OpenSSL library, and derives much of its
crypto capabilities from it.

OpenVPN supports conventional encryption using a pre-shared secret key
(Static Key mode) or public key security (SSL/TLS mode) using client &
server certificates. OpenVPN also supports non-encrypted TCP/UDP
tunnels.

OpenVPN is designed to work with the TUN/TAP virtual networking
interface that exists on most platforms.

Overall, OpenVPN aims to offer many of the key features of IPSec but
with a relatively lightweight footprint.

OpenVPN was written by James Yonan and is published under the GNU
General Public License (GPL).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Install OpenVPN                                                    |
| -   2 Configure the system for TUN/TAP support                           |
| -   3 Connect to a VPN provided by a third party                         |
| -   4 Create a Public Key Infrastructure (PKI) from scratch              |
| -   5 A basic L3 IP routing configuration                                |
|     -   5.1 The server configuration file                                |
|     -   5.2 The client configuration file                                |
|     -   5.3 Testing the OpenVPN configuration                            |
|     -   5.4 Configure the MTU with Fragment and MSS                      |
|                                                                          |
| -   6 Starting OpenVPN                                                   |
|     -   6.1 Manual startup                                               |
|     -   6.2 Systemd service configuration                                |
|                                                                          |
| -   7 Advanced L3 IP routing                                             |
|     -   7.1 Prerequisites for routing a LAN                              |
|         -   7.1.1 IPv4 forwarding                                        |
|         -   7.1.2 Promiscuous LAN interface                              |
|         -   7.1.3 Routing tables                                         |
|                                                                          |
|     -   7.2 Connect the server LAN to a client                           |
|     -   7.3 Connect the client LAN to a server                           |
|     -   7.4 Connect both the client and server LANs                      |
|     -   7.5 Connect clients and client LANs                              |
|                                                                          |
| -   8 L2 Ethernet bridging                                               |
| -   9 Contributions that do not yet fit into the main article            |
|     -   9.1 Routing client traffic through the server                    |
|         -   9.1.1 Configure ufw for routing                              |
|         -   9.1.2 Using iptables                                         |
|                                                                          |
|     -   9.2 Configuring LDAP authorization                               |
|     -   9.3 Deprecated older wiki content                                |
|         -   9.3.1 Using PAM and passwords to authenticate                |
|         -   9.3.2 Using certs to authenticate                            |
|         -   9.3.3 Routing traffic through the server                     |
|         -   9.3.4 Setting up the Client                                  |
|             -   9.3.4.1 With password authentication                     |
|             -   9.3.4.2 Certs authentication                             |
|             -   9.3.4.3 DNS                                              |
|             -   9.3.4.4 Webmin                                           |
|                                                                          |
|         -   9.3.5 Connecting to the Server                               |
+--------------------------------------------------------------------------+

Install OpenVPN
---------------

Install openvpn from the official repositories.

Note:The software contained in this package supports both server and
client mode, so install it on all machines that need to create vpn
connections.

Configure the system for TUN/TAP support
----------------------------------------

OpenVPN requires TUN/TAP support. Make sure to load at boot the tun
module.

Read Kernel Modules for more information.

The default kernel is already properly configured, but if you use
another kernel make sure to enable the TUN/TAP module. If
$ zgrep CONFIG_TUN /proc/config.gz returns CONFIG_TUN=n, make the
following change to the kernel config file and rebuild the kernel.

    Kernel config file

     Device Drivers
      --> Network device support
        [M] Universal TUN/TAP device driver support

Connect to a VPN provided by a third party
------------------------------------------

To connect to a VPN provided by a third party, most of the following can
most likely be ignored. Use the certificates and instructions given by
your provider, for instance see: Airvpn.

Create a Public Key Infrastructure (PKI) from scratch
-----------------------------------------------------

If you are setting up OpenVPN from scratch, you will need to create a
Public Key Infrastructure (PKI).

Create the needed certificates and keys by following: Create a Public
Key Infrastructure Using the easy-rsa Scripts.

The final step of the key creation process is to copy the files needed
to the correct machines through a secure channel.

Note:The rest of this article assumes that the keys and certificates are
placed in /etc/openvpn.

The public ca.crt certificate is needed on all servers and clients. The
private ca.key key is secret and only needed on the key generating
machine.

A server needs server.crt, and dh2048.pem (public), and server.key and
ta.key (private).

A client needs client.crt (public), and client.key and ta.key (private).

A basic L3 IP routing configuration
-----------------------------------

Note:Unless otherwise explicitly stated, the rest of this article
assumes this basic configuration.

OpenVPN is an extremely versatile piece of software and many
configurations are possible, in fact machines can be both "servers" and
"clients", blurring the distinction between server and client.

What really distinguishes a server from a client (apart from the type of
certificate used) is the configuration file itself. The openvpn daemon
startup script reads all the .conf configuration files it finds in
/etc/openvpn on startup and acts accordingly. In fact if it finds more
than one configuration file, it will start one OpenVPN processes per
configuration file.

This article explains how to setup a server called elmer, and a client
that connects to it called bugs. More servers and clients can easily be
added, by creating more key/certificate pairs and adding more server and
client configuration files.

The OpenVPN package comes with a collection of example configuration
files for different purposes. The sample server and client configuration
files make an ideal starting point for a basic OpenVPN setup with the
following features:

-   Uses Public Key Infrastructure (PKI) for authentication.
-   Creates a VPN using a virtual TUN network interface (OSI L3 IP
    routing).
-   Listens for client connections on UDP port 1194 (OpenVPN's official
    IANA port number).
-   Distributes virtual addresses to connecting clients from the
    10.8.0.0/24 subnet.

For more advanced configurations, please see the official OpenVPN 2.2
man page and the OpenVPN documentation.

> The server configuration file

Copy the example server configuration file to /etc/openvpn/server.conf

    # cp /usr/share/openvpn/examples/server.conf /etc/openvpn/server.conf

Edit the following:

-   The ca, cert, key, and dh parameters to reflect the path and names
    of the keys and certificates. Specifying the paths will allow you to
    run the OpenVPN executable from any directory for testing purposes.
-   Enable the SSL/TLS HMAC handshake protection. Note the use of the
    parameter 0 for a server.
-   It is recommended to run OpenVPN with reduced privileges once it has
    initialized, do this by uncommenting the user and group directives.

    /etc/openvpn/server.conf

    ca /etc/openvpn/ca.crt
    cert /etc/openvpn/elmer.crt
    key /etc/openvpn/elmer.key

    dh /etc/openvpn/dh2048.pem
    .
    .
    tls-auth /etc/openvpn/ta.key 0
    .
    .
    user nobody
    group nobody

Note:Note that if the server is behind a firewall or a NAT translating
router, you will have to forward the OpenVPN UDP port (1194) to the
server.

> The client configuration file

Copy the example client configuration file to /etc/openvpn/client.conf

    # cp /usr/share/openvpn/examples/client.conf /etc/openvpn/client.conf

Edit the following:

-   The remote directive to reflect either the server's Fully Qualified
    Domain Name hostname (as known to the client) or its IP address.
-   Uncomment the user and group directives to drop privileges.
-   The ca, cert, and key parameters to reflect the path and names of
    the keys and certificates.
-   Enable the SSL/TLS HMAC handshake protection. Note the use of the
    parameter 1 for a client.

    /etc/openvpn/client.conf

    remote elmer.acmecorp.org 1194
    .
    .
    user nobody
    group nobody
    .
    .
    ca /etc/openvpn/ca.crt
    cert /etc/openvpn/bugs.crt
    key /etc/openvpn/bugs.key
    .
    .
    tls-auth /etc/openvpn/ta.key 1

> Testing the OpenVPN configuration

Run # openvpn /etc/openvpn/server.conf on the server, and
# openvpn /etc/openvpn/client.conf on the client. You should see
something similar to this:

    # openvpn /etc/openvpn/server.conf

    Wed Dec 28 14:41:26 2011 OpenVPN 2.2.1 x86_64-unknown-linux-gnu [SSL] [LZO2] [EPOLL] [eurephia] built on Aug 13 2011
    Wed Dec 28 14:41:26 2011 NOTE: OpenVPN 2.1 requires '--script-security 2' or higher to call user-defined scripts or executables
    Wed Dec 28 14:41:26 2011 Diffie-Hellman initialized with 2048 bit key
    .
    .
    Wed Dec 28 14:41:54 2011 bugs/95.126.136.73:48904 MULTI: primary virtual IP for bugs/95.126.136.73:48904: 10.8.0.6
    Wed Dec 28 14:41:57 2011 bugs/95.126.136.73:48904 PUSH: Received control message: 'PUSH_REQUEST'
    Wed Dec 28 14:41:57 2011 bugs/95.126.136.73:48904 SENT CONTROL [bugs]: 'PUSH_REPLY,route 10.8.0.1,topology net30,ping 10,ping-restart 120,ifconfig 10.8.0.6 10.8.0.5' (status=1)

    # openvpn /etc/openvpn/client.conf

    Wed Dec 28 14:41:50 2011 OpenVPN 2.2.1 i686-pc-linux-gnu [SSL] [LZO2] [EPOLL] [eurephia] built on Aug 13 2011
    Wed Dec 28 14:41:50 2011 NOTE: OpenVPN 2.1 requires '--script-security 2' or higher to call user-defined scripts or executables
    Wed Dec 28 14:41:50 2011 LZO compression initialized
    .
    .
    Wed Dec 28 14:41:57 2011 GID set to nobody
    Wed Dec 28 14:41:57 2011 UID set to nobody
    Wed Dec 28 14:41:57 2011 Initialization Sequence Completed

On the server, find the IP assigned to the tunX device:

    # ip addr show

    .
    .
    40: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN qlen 100
        link/none
        inet 10.8.0.1 peer 10.8.0.2/32 scope global tun0

Here we see that the server end of the tunnel has been given the IP
address 10.8.0.1.

Do the same on the client:

    # ip addr show

    .
    .
    37: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN qlen 100
        link/none
        inet 10.8.0.6 peer 10.8.0.5/32 scope global tun0

And the client side has been given the IP 10.8.0.6.

Now try pinging the interfaces.

On the server:

    # ping -c3 10.8.0.6

    PING 10.8.0.6 (10.8.0.6) 56(84) bytes of data.
    64 bytes from 10.8.0.6: icmp_req=1 ttl=64 time=238 ms
    64 bytes from 10.8.0.6: icmp_req=2 ttl=64 time=237 ms
    64 bytes from 10.8.0.6: icmp_req=3 ttl=64 time=205 ms

    --- 10.8.0.6 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2002ms
    rtt min/avg/max/mdev = 205.862/227.266/238.788/15.160 ms

On the client:

    # ping -c3 10.8.0.1

    PING 10.8.0.1 (10.8.0.1) 56(84) bytes of data.
    64 bytes from 10.8.0.1: icmp_req=1 ttl=64 time=158 ms
    64 bytes from 10.8.0.1: icmp_req=2 ttl=64 time=158 ms
    64 bytes from 10.8.0.1: icmp_req=3 ttl=64 time=157 ms

    --- 10.8.0.1 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2001ms
    rtt min/avg/max/mdev = 157.426/158.278/158.940/0.711 ms

You now have a working OpenVPN installation, and your client (bugs) will
be able to use services on the server (elmer), and vice versa.

Note:If using a firewall, make sure that ip packets on the TUN device
are not blocked.

> Configure the MTU with Fragment and MSS

Note:If you do not configure MTU then you will notice that small packets
like ping and DNS will work, however web browsing will not work.

Now it is time to configure the maximum segment size (MSS). In order to
do this we need to discover what is the smallest MTU along the path
between the client and server. In order to do this you can ping the
server and disable fragmentation. Then specify the max packetsize.

    # ping -c5 -M do -s 1500 elmer.acmecorp.org

    PING elmer.acmecorp.org (99.88.77.66) 1500(1528) bytes of data.
    From 1.2.3.4 (99.88.77.66) icmp_seq=1 Frag needed and DF set (mtu = 576)
    From 1.2.3.4 (99.88.77.66) icmp_seq=1 Frag needed and DF set (mtu = 576)
    From 1.2.3.4 (99.88.77.66) icmp_seq=1 Frag needed and DF set (mtu = 576)
    From 1.2.3.4 (99.88.77.66) icmp_seq=1 Frag needed and DF set (mtu = 576)
    From 1.2.3.4 (99.88.77.66) icmp_seq=1 Frag needed and DF set (mtu = 576)

    --- core.myrelay.net ping statistics ---
    0 packets transmitted, 0 received, +5 errors

We received an ICMP message telling us the MTU is 576 bytes. The means
we need to fragment the UDP packets smaller then 576 bytes to allow for
some UDP overhead.

    # ping -c5 -M do -s 548 elmer.acmecorp.org

    PING elmer.acmecorp.org (99.88.77.66) 548(576) bytes of data.
    556 bytes from 99.88.77.66: icmp_seq=1 ttl=48 time=206 ms
    556 bytes from 99.88.77.66: icmp_seq=2 ttl=48 time=224 ms
    556 bytes from 99.88.77.66: icmp_seq=3 ttl=48 time=206 ms
    556 bytes from 99.88.77.66: icmp_seq=4 ttl=48 time=207 ms
    556 bytes from 99.88.77.66: icmp_seq=5 ttl=48 time=208 ms

    --- myrelay.net ping statistics ---
    5 packets transmitted, 5 received, 0% packet loss, time 4001ms
    rtt min/avg/max/mdev = 206.027/210.603/224.158/6.832 ms

After some trial and error..., we discover that we need to fragment
packets on 548 bytes. In order to do this we specify this fragment size
in the configuration and instruct OpenVPN to fix the Maximum Segment
Size (MSS).

    /etc/openvpn/client.conf

    remote elmer.acmecorp.org 1194
    .
    .
    fragment 548
    mssfix
    .
    .
    user nobody
    group nobody
    .
    .
    ca /etc/openvpn/ca.crt
    cert /etc/openvpn/bugs.crt
    key /etc/openvpn/bugs.key
    .
    .
    tls-auth /etc/openvpn/ta.key 1

  

Note:This will add about 3min's to OpenVPN start time. It is advisable
to configure the fragment size unless your client is a laptop that will
be connecting over many different networks and the bottle neck is on the
client side.

You can also allow OpenVPN to do this for you by having OpenVPN do the
ping testing every time the client connects to the VPN.

    /etc/openvpn/client.conf

    remote elmer.acmecorp.org 1194
    .
    .
    mtu-test
    .
    .
    user nobody
    group nobody
    .
    .
    ca /etc/openvpn/ca.crt
    cert /etc/openvpn/bugs.crt
    key /etc/openvpn/bugs.key
    .
    .
    tls-auth /etc/openvpn/ta.key 1

Starting OpenVPN
----------------

> Manual startup

To troubleshoot a vpn connection, start the daemon manually with:
# openvpn /etc/openvpn/client.conf.

> Systemd service configuration

To start openvpn automatically at system boot, enable
openvpn@<configuration>.service.

For example, if the configuration file is /etc/openvpn/client.conf, the
service name is openvpn@client.service.

Advanced L3 IP routing
----------------------

> Prerequisites for routing a LAN

IPv4 forwarding

For a host to be able to forward IPv4 packets between the LAN and VPN,
it must be able to forward the packets between its NIC and its tun/tap
device.

Edit etc/sysctl.conf to permanently enable ipv4 packet forwarding (takes
effect at the next boot):

    /etc/sysctl.conf

    # Enable packet forwarding
    net.ipv4.ip_forward=1

To temporarily enable without rebooting:
# echo 1 > /proc/sys/net/ipv4/ip_forward

Promiscuous LAN interface

The forwarding host's NIC (eth0 in the following examples) must also be
able to accept packets for a different IP address than it is configured
for, something known as promiscious mode. To enable, add the following
to /etc/rc.local (takes effect at the next boot):

    /etc/rc.local

    ip link set dev eth0 promisc on

To temporarily enable without rebooting:
# ip link set dev eth0 promisc on

To set the eth0 in promiscuous mode using systemd use this service file
and enable it using:

     # systemctl enable promiscuous@eth0.service

Routing tables

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Investigate if a 
                           routing protocol like    
                           RIP, QUAGGA, BIRD, etc   
                           can be used (Discuss)    
  ------------------------ ------------------------ ------------------------

By default, all IP packets on a LAN addressed to a different subnet get
sent to the default gateway. If the LAN/VPN gateway is also the default
gateway, there is no problem and the packets get properly forwarded. If
not, the gateway has no way of knowing where to send the packets. There
are a couple of solutions to this problem.

-   Add a static route to the default gateway routing the VPN subnet to
    the LAN/VPN gateway's IP address.
-   Add a static route on each host on the LAN that needs to send IP
    packets back to the VPN.
-   Use iptables' NAT feature on the LAN/VPN gateway to masquerade the
    incoming VPN IP packets.

> Connect the server LAN to a client

The server is on a LAN using the 10.66.0.0/24 subnet. To inform the
client about the available subnet, add a push directive to the server
configuration file:

    /etc/openvpn/server.conf

    push "route 10.66.0.0 255.255.255.0"

Note:Remember to enable ipv4 forwarding and to make the LAN interface
promiscuous on the server. Make sure the server LAN knows how to reach
the VPN client.

Note:To route more LANs from the server to the client, add more push
directives to the server configuration file, but keep in mind that the
server side LANs will need to know how to route to the client.

> Connect the client LAN to a server

Prerequisites:

-   Any subnets used on the client side, must be unique and not in use
    on the server or by any other client. In this example we will use
    192.168.4.0/24 for the clients LAN.
-   Each client's certificate has a unique Common Name, in this case
    bugs.
-   The server may not use the duplicate-cn directive in its config
    file.

Create a client configuration directory on the server. It will be
searched for a file named the same as the client's common name, and the
directives will be applied to the client when it connects.

    # mkdir -p /etc/openvpn/ccd

Create a file in the client configuration directory called bugs,
containing the iroute 192.168.4.0 255.255.255.0 directive. It tells the
server what subnet should be routed to the client:

    /etc/openvpn/ccd/bugs

    iroute 192.168.4.0 255.255.255.0

Add the client-config-dir and the route 192.168.4.0 255.255.255.0
directive to the server configuration file. It tells the server what
subnet should be routed from the tun device to the server LAN:

    /etc/openvpn/server.conf

    client-config-dir ccd
    route 192.168.4.0 255.255.255.0

Note:Remember to enable ipv4 forwarding and to make the LAN interface
promiscuous on the client. Make sure the client LAN knows how to reach
the VPN server.

Note:To route more LANs from the client to the server, add more iroute
and route directives to the appropriate configuration files, but keep in
mind that the client side LANs will need to know how to route to the
server.

> Connect both the client and server LANs

Combine the two previous sections:

    /etc/openvpn/server.conf

    push "route 10.66.0.0 255.255.255.0"
    .
    .
    client-config-dir ccd
    route 192.168.4.0 255.255.255.0

  

    /etc/openvpn/ccd/bugs

    iroute 192.168.4.0 255.255.255.0

  

Note:Remember to enable ipv4 forwarding and to make the LAN interfaces
promiscuous on both the client and the server. Make sure that all the
LANs or the needed hosts can route to all the destinations.

> Connect clients and client LANs

By default clients will not see each other, to allow ip packets to flow
between clients and/or client LANs add a client-to-client directive to
the server configuration file:

    /etc/openvpn/server.conf

    client-to-client

In order for another client or client LAN to see a specific client LAN
you will need to add a push directive for each client subnet to the
server configuration file (this will make the server announce the
available subnet(s) to other clients):

    /etc/openvpn/server.conf

    client-to-client
    push "route 192.168.4.0 255.255.255.0"
    push "route 192.168.5.0 255.255.255.0"
    .
    .

Note:As always, make sure that the routing is properly configured.

L2 Ethernet bridging
--------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Please add a     
                           well thought out section 
                           on L2 bridging.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

For now see: OpenVPN Bridge

Contributions that do not yet fit into the main article
-------------------------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: Not quite sure   
                           where this fits into the 
                           main article yet         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Routing client traffic through the server

Append the following to your server's openvpn.conf configuration file:

    push "redirect-gateway def1"
    push "dhcp-option DNS 192.168.1.1"

Change "192.168.1.1" to your preferred DNS IP address.

If you have problems with non responsive DNS after connecting to server,
install BIND as simple DNS forwarder and push openvpn ip address of
server as DNS to clients.

Configure ufw for routing

Configure your ufw settings to enable routing traffic from clients
through server.

You must change default forward policy, edit /etc/sysctl.conf to
permanently enable ipv4 packet forwarding. Takes effect at the next
boot.

    /etc/sysctl.conf

    # Enable packet forwarding
    net.ipv4.ip_forward=1

And then configure ufw in /etc/default/ufw

    /etc/default/ufw

    DEFAULT_FORWARD_POLICY="ACCEPT"

Now change /etc/ufw/before.rules, and add the following code after the
header and before the "*filter" line. Don't forget to change the
IP/subnet mask to match the one in /etc/openvpn/server.conf.

    /etc/ufw/before.rules

    # NAT (Network Address Translation) table rules
    *nat
    :POSTROUTING ACCEPT [0:0]

    # Allow traffic from clients to eth0
    -A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE

    # don't delete the "COMMIT" line or the NAT table rules above won't be processed
    COMMIT

Open openvpn port 1194

    ufw allow 1194

Using iptables

Use an iptable for NAT forwarding:

    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

If running ArchLinux in a OpenVZ VPS environment [1]:

    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o venet0 -j SNAT --to (venet0 ip)

If all is well, make the changes permanent:

Edit /etc/conf.d/iptables and change IPTABLES_FORWARD=1

    /etc/rc.d/iptables save

  

> Configuring LDAP authorization

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: what does the    
                           following do, and is the 
                           package still supported? 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

You may also want to install openvpn-authldap-plugin, available in the
Arch User Repository.

> Deprecated older wiki content

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: See how this     
                           older content can be     
                           fitted into the new      
                           article (Discuss)        
  ------------------------ ------------------------ ------------------------

Using PAM and passwords to authenticate

    port 1194
    proto udp
    mtu-test
    dev tap
    ca /etc/openvpn/easy-rsa/keys/ca.crt
    cert /etc/openvpn/easy-rsa/keys/<MYSERVER>.crt
    key /etc/openvpn/easy-rsa/keys/<MYSERVER>.key
    dh /etc/openvpn/easy-rsa/keys/dh2048.pem
    server 192.168.56.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    ;learn-address ./script
    client-to-client
    ;duplicate-cn
    keepalive 10 120
    ;tls-auth ta.key 0
    comp-lzo
    ;max-clients 100
    ;user nobody
    ;group nobody
    persist-key
    persist-tun
    status /var/log/openvpn-status.log
    verb 3
    client-cert-not-required
    username-as-common-name
    plugin /usr/lib/openvpn/openvpn-auth-pam.so login

Using certs to authenticate

    port 1194
    proto tcp
    dev tun0

    ca /etc/openvpn/easy-rsa/keys/ca.crt
    cert /etc/openvpn/easy-rsa/keys/<MYSERVER>.crt
    key /etc/openvpn/easy-rsa/keys/<MYSERVER>.key
    dh /etc/openvpn/easy-rsa/keys/dh2048.pem

    server 10.8.0.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    keepalive 10 120
    comp-lzo
    user nobody
    group nobody
    persist-key
    persist-tun
    status /var/log/openvpn-status.log
    verb 3

    log-append /var/log/openvpn
    status /tmp/vpn.status 10

Routing traffic through the server

Append the following to your server's openvpn.conf configuration file:

    push "dhcp-option DNS 192.168.1.1"
    push "redirect-gateway def1"

Change "192.168.1.1" to your external DNS IP address.

Use an iptable for NAT forwarding:

    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

If running ArchLinux in a OpenVZ VPS environment [2]:

    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o venet0 -j SNAT --to (venet0 ip)

If all is well, make the changes permanent:

Edit /etc/conf.d/iptables and change IPTABLES_FORWARD=1

    /etc/rc.d/iptables save

Setting up the Client

The clientside .conf file

With password authentication

    client
    dev tap
    proto udp
    mtu-test
    remote <address> 1194
    resolv-retry infinite
    nobind
    persist-tun
    comp-lzo
    verb 3
    auth-user-pass passwd
    ca ca.crt

passwd file (referenced by auth-user-pass) must contain two lines:

-   first line - username
-   second - password

Certs authentication

    client
    remote <MYSERVER> 1194
    dev tun0
    proto tcp
    resolv-retry infinite
    nobind
    persist-key
    persist-tun
    verb 2
    ca ca.crt
    cert client1.crt
    key client1.key
    comp-lzo

Copy three files from server to remote computer.

    ca.crt
    client1.crt
    client1.key

Install the tunnel/tap module:

     # sudo modprobe tun

To have the tun module loaded automatically at boot time add it to the
Modules line in /etc/rc.conf

DNS

The DNS servers used by the system are defined in /etc/resolv.conf.
Traditionally, this file is the responsibility of whichever program
deals with connecting the system to the network (e.g. Wicd,
NetworkManager, etc...) However, OpenVPN will need to modify this file
if you want to be able to resolve names on the remote side. To achieve
this in a sensible way, install openresolv, which makes it possible for
more than one program to modify resolv.conf without stepping on
each-other's toes. Before continuing, test openresolv by restarting your
network connection and ensuring that resolv.conf states that it was
generated by "resolvconf", and that your DNS resolution still works as
before. You should not need to configure openresolv; it should be
automatically detected and used by your network system.

Next, save the following script at
/usr/share/openvpn/update-resolv-conf:

    #!/bin/bash
    #
    # Parses DHCP options from openvpn to update resolv.conf
    # To use set as 'up' and 'down' script in your openvpn *.conf:
    # up /etc/openvpn/update-resolv-conf
    # down /etc/openvpn/update-resolv-conf
    #
    # Used snippets of resolvconf script by Thomas Hood <jdthood@yahoo.co.uk>
    # and Chris Hanson
    # Licensed under the GNU GPL.  See /usr/share/common-licenses/GPL.
    #
    # 05/2006 chlauber@bnc.ch
    #
    # Example envs set from openvpn:
    # foreign_option_1='dhcp-option DNS 193.43.27.132'
    # foreign_option_2='dhcp-option DNS 193.43.27.133'
    # foreign_option_3='dhcp-option DOMAIN be.bnc.ch'

    [ -x /usr/sbin/resolvconf ] || exit 0

    case $script_type in

    up)
       for optionname in ${!foreign_option_*} ; do
          option="${!optionname}"
          echo $option
          part1=$(echo "$option" | cut -d " " -f 1)
          if [ "$part1" == "dhcp-option" ] ; then
             part2=$(echo "$option" | cut -d " " -f 2)
             part3=$(echo "$option" | cut -d " " -f 3)
             if [ "$part2" == "DNS" ] ; then
                IF_DNS_NAMESERVERS="$IF_DNS_NAMESERVERS $part3"
             fi
             if [ "$part2" == "DOMAIN" ] ; then
                IF_DNS_SEARCH="$IF_DNS_SEARCH $part3"
             fi
          fi
       done
       R=""
       if [ "$IF_DNS_SEARCH" ] ; then
               R="${R}search $IF_DNS_SEARCH
    "
       fi
       for NS in $IF_DNS_NAMESERVERS ; do
               R="${R}nameserver $NS
    "
       done
       echo -n "$R" | /usr/sbin/resolvconf -a "${dev}.inet"
       ;;
    down)
       /usr/sbin/resolvconf -d "${dev}.inet"
       ;;
    esac

Remember to make the file executable with:

     $ chmod +x /usr/share/openvpn/update-resolv-conf

Next, add the following lines to your OpenVPN client configuration file:

    script-security 2
    up /usr/share/openvpn/update-resolv-conf
    down /usr/share/openvpn/update-resolv-conf

Now, when your launch your OpenVPN connection, you should find that your
resolv.conf file is updated accordingly, and also returns to normal when
your close the connection.

Webmin

webmin-plugin-openvpn is available in the AUR.

Note:You must add "openvpn" to the end of /etc/webmin/webmin.acl.

Connecting to the Server

You need to start the service on the server

    /etc/rc.d/openvpn start

You can add it to rc.conf to make it permanent.

On the client, in the home directory create a folder that will hold your
OpenVPN client config files along with the .crt/.key files. Assuming
your OpenVPN config folder is called .openvpn and your client config
file is vpn1.conf, to connect to the server issue the following command:

    cd ~/.openvpn && sudo openvpn vpn1.conf

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenVPN&oldid=254660"

Category:

-   Virtual Private Network
