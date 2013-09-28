Simple IP Failover with Heartbeat
=================================

This article illustrates a method of implementing VERY simple
active/passive IP failover using heartbeat. You are reccomended to
familiarize yourself with the concepts of High Availability Clustering
in Linux before proceeding to implement these instructions in a
live/production environment.(SEE: Linux-HA)

Methods
-------

For the purposes of this article we will not be configuring pacemaker,
we will be using the older style haresources file/method to define our
Highly Available Services with heartbeat.

We will NOT be using a load balancer, or any external resource agents
with heartbeat; because of this, this setup will only allow for a 2 node
ACTIVE/PASSIVE cluster, and we will be using two PHYSICAL machines. You
may however try this on two virtual machines/hosts to test first, I see
no reason why this setup wouldn't work in a virtual machine/environment.

We will have two machines, and at-least 3 IP addresses, for my setup I
have 3 publically accessible/WAN IP Adresses, but this may also be done
using two internal/LAN IP's & a single(1) Public/WAN IP address.

The IP/Hostnames/DNS we will be using are as follows:

-   ha1.example.com: 100.200.230.1 (WAN)(Virtual IP, not a physical
    node)
-   node1.example.com 100.200.230.2 (WAN OR LAN)(Physical Node/Machine
    1)
-   node2.example.com 100.200.230.3 (WAN OR LAN)(Physical Node/Machine
    2)

*100.200.230.2 & 100.200.230.3 (the IP's our two heartbeat nodes will be
using to communicate with eachother over our Local Area Network, these
may be public(WAN) or private(LAN) addresses. Each of these two nodes
should preferably be on the same subnet but all that is needed is that
each node is able to communicate with the other/vice versa.)

*100.200.230.1 (our VIRTUAL IP Address that the two node's will "share"
& monitor/bring alive if one node should stop communicating)-- This IP
Address may be on ANY subnet. This IP Address should be reachable from
the public internet(WAN) IF(IF) you plan for your Highly Available
services to be reachable from outside of your private Local Area Network
(we will be using this ip address to connect to our Highly Available
Services on the 'currently' active node...Alternatively this COULD be a
private LAN IP address, where your router has your PUBLIC/WAN IP address
assigned to it, and you could forward the ports your Highly Available
services will use to the 'lan' IP you choose for this, in your router.

*It is NOT neccesary to have a genuine registered domain name (FQDN) or
a DNS server for the purposes of these instructions, heartbeat will use
our /etc/hosts file for all heartbeat related hostname/domain name
lookups locally(Irregardless of what /etc/host.conf tells it to use.);
but, if you would like to reach your highly available services via a
domain name from outside your Local Area Network, you will have to
register a domain and fix it up with the proper zone/ns/mx/A
record/CNAME definitions, and, optionally install/run ICS Bind with the
proper/relevant zone definitions & replicate those definitions in
/etc/hosts.

Installation
------------

Available in AUR:

    $ yaourt -S ha-glue ha-heartbeat ha-pacemaker ha-resourceagent inetutils net-tools

Configuration
-------------

Edit the main configuration file for heartbeat /etc/ha.d/ha.cf and make
it look like this

    deadtime 5
    warntime 10
    initdead 15
    bcast eth0
    auto_failback on
    node node1
    node node2
    use_logd yes

Note: 'auto_failback on' will tell heartbeat to prefer node1. If node1
should go down, node2 will take over our Virtual IP Address and start
our Highly Available services. When/if node1 comes back alive node2 will
transfer(automatically failback) our Virtual IP and Highly Available
services back to node1 and stop our H.A services on node 2. If
auto_failback off is used, in the previous scenario, node2 would not
give our virtual IP and services back to node1 when node1 comes back
alive--node1 would remain inactive and node2 would continue to serve our
virtual IP/HA services until node2 eventually fails and node1 takes over
for it...auto_failback on provides for more session
disconnects/connection drops from a user perspective but this may be a
neccesary option for you if you do not have shared storage(E.G For user
email, NFS/shared storage, etc)... For example, you want to also serve
Highly Available NFS exports(data) using your VIRTUAL IP and all of your
data is on node1--if auto_failback off is used and node1 fails, users
will browse to their NFS share and not see any of the data that exists
on node1's NFS shares!

Note: if you want to use auto_failback off & still share NFS exports/etc
this can be overcome by using something like rsync, fam & ssh/scp to
frequently copy over (only the new data/see FAM) and keep the two nodes
in sync, one could also use DRBD on both nodes to mirror two partitions
over ethernet--essentially raid1 over ethernet. DRBD(Avail. in AUR) is
the most commonly used tool to solve this problem, if you choose to use
drbd for this please note that you want to set your two drbd partitions
secondary/secondary(initially) and have heartbeat/haresources file mount
your drbd partition as primary on the 'currently' active node ONLY, I'd
also HIGHLY reccomend using a cluster friendly FileSystem like GFS2 or
OCFS2 for a shared drbd device/partition! Another possible solution is
to use pNFS(if you choose to use NFS to share data that will be
simultaneously accessed/written to/altered on/by both nodes at the same
time to prevent file corruption, or at the least, prevent any drastic
issues with .lock files...

Note:using 'bcast eth0' tells heartbeat to send out the
'beats/heartbeats/ack/alive queries' using broadcast using the interface
eth0. You may also use unicast if you want, like so: 'ucast eth0
put.the.other.nodes.ip.address.here', or serial using two lines 'baud
9200' & '/dev/ttyS0' if you use serial to communicate you will need a
null modem/crossover serial cable. It is also possible to use a second
network interface in each node and connect them using a RJ45/cat5e
crossover cable, in a crossover cable setup you would likely want to use
unicast but broadcast will work also. For a two node active/passive
heartbeat cluster I prefer to use a null modem/crossover serial cable to
connect the two heartbeat nodes as it is far simpler and less likely to
have issues, it also doesnt require the installation of any extra NIC
cards in our nodes, but for the purposes of this article we will use
broadcast on the very same interface(eth0) our two heartbeat nodes are
already using to connect to our router/switch on, with no extra
heartbeat specific NIC card/no extra hardware of any kind(Because of
this, any router/switch failures in our
node1<==(?switch/router)?==>node2 signal path will throw our cluster
offline & bring down our H.A Services on BOTH nodes, this is why I
prefer a null modem/serial crossover cable setup! generally you would
want the signal path the 'heartbeats' will be sent on/e.g the path the
two heartbeat 'nodes' will communicate with to be as simple, direct, &
reliable as possible!)

Note: If you should choose to use unicast in your /etc/ha.d/haresources
file, for say, a dedicated heartbeat connection with a cat5e crossover
cable & extra NICS in our two nodes, the /etc/ha.d/haresources file on
each node should represent the other nodes IP Address, for example, the
unicast line in node1's haresources file would look like this 'ucast
eth0 node2.ip.address.here', and the unicast line in haresources on
node2 would be the opposite like such 'ucast eth0
node1.ip.address.here', in ALL other scenarios, our haresources file
should be 100% identical on both nodes.

  
 03. Edit/create the file /etc/ha.d/haresources as follows:

    node1 IPaddr::100.200.230.1/100.200.230.6 named httpd mysqld

Note: this file should be EXACTLY the same on both nodes!!!
...explanation: node1 is the hostname of our first/primary node(see
above), IPaddr::100.200.230.3/100.200.230.6 is the virtual IP address,
and the gateway/device we are expecting to assign this 'virtual' WAN IP
address to us. In most circumstances the gateway definition will not be
neccesary(EG. remove '/100.200.230.6 so it reads IPaddr::100.200.230.3'
but for my purposes, because of some funky behaviour of my att 2wire
u-verse gateway and how it assigns it's static IP addresses, heartbeat
would fail to bring up the virtual IP address/eth0:0 alias without this
specifically defined in the haresources file. Please remove 'named httpd
mysqld' from haresources if you will not be running BIND, Apache/other
web server, MySQL Server, otherwise heartbeat will try to start bind,
apache, and mysql server and COMPLETELY FAIL to start if you do not have
startup scripts for these in /etc/rc.d/(heartbeat looks for startup
scripts/resource agents in BOTH: /etc/rc.d/* & /etc/ha.d/resource.d, the
resource agent 'IPaddr is in /etc/ha.d/resource.d for example)

Note: You MAY define more then one(as many as you like) VIRTUAL IP
Adresses, this is desirable in MOST scenarios, for example, you dns
registrar requires that you have two name servers and you would like to
host your own dns zone. For this our haresources file would look like:
'node1 IPaddr::100.200.230.1/100.200.230.6
IPaddr::100.200.230.0/100.200.230.6 named httpd mysqld' where we have
two highly available IP's 100.200.230.0 & 100.200.230.1

04. at the end of the line 'node1 IPaddr::100.200.230.1/100.200.230.6'
our /etc/ha.d/haresources file append(on the same line) the name of the
startup scripts/resource agents for whatever service you would like
heartbeat to make highly available. In the example above in step 03. We
have told heartbeat to manage named(BIND) httpd(APACHE) mysqld(MYSQL
Server), see here:

    IPaddr::100.200.230.1/100.200.230.6 IPaddr::100.200.230.0/100.200.230.6 named httpd mysqld

Note: any services you define in your /etc/ha.d/haresources file MUST
NOT be defined in your /etc/rc.conf daemons array, or heartbeat will
fail when trying to start the service(it will already be running). It is
not reccomended to tell heartbeat to manage services like sshd(SSH) eg.
if we tell heartbeat to manage sshd(SSH), we will only be able to ssh
into whatever node is currently active as our master node, and not the
slave node.

  
 05. Edit /etc/rc.conf and place heartbeat at the END of your daemons
array...

That's it! Fire up both nodes, pull the plug on your primary node/node1,
and check node two to see that it has taken over your H.A Services &
Virtual IP Address. E.G. 'ip addr show','ps aux'...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Simple_IP_Failover_with_Heartbeat&oldid=198732"

Categories:

-   Networking
-   System recovery
