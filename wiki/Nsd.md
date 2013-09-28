Nsd
===

Nsd is an authoritative DNS resolver.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Migration to nsd for bind users                                    |
| -   3 Initial Setup                                                      |
| -   4 Starting and running nsd                                           |
| -   5 Testing nsd                                                        |
| -   6 WAN facing dns                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install nsd:

    pacman -S nsd

Migration to nsd for bind users
-------------------------------

Once the package is installed there are useful migration notes for users
who currently run bind as their dns server in the file:

    /usr/share/doc/nsd/NSD-FOR-BIND-USERS

Many users will wish to run nsd as their authoritative dns server
concurrently with unbound as the validating, recursive, caching dns
server on a single machine. It may be useful to refer to the wiki page
for unbound at:

    unbound

Initial Setup
-------------

More often than not nsd will be running concurrently with a recursive,
caching dns server such as unbound. Usually dns servers will be
listening on port 53 but the two services would conflict if they were
listening to the same port. Hence if unbound was the main server
answering dns queries on port 53 then it is sensible for added security
to select a high private port number for nsd to listen on. Also if the
only direct access to nsd will be from queries forwarded from unbound,
then nsd can be configured to listen only to the localhost machine on
the private port chosen, and is not then directly accessible from
outside. This gives added security to the authoritative server. In the
examples of configuration files here port 53530 is chosen as the
listening port number for nsd.

If any firewall running on the machine blocks private port 53530 then
this adds to security. The only port that then needs to be open for dns
queries coming from external machines (or other machines on the same
local network) is port 53.

It is perfectly possible to put the nsd.conf file as well as any zone
files into /etc/nsd/ but it is also possible to place the zone files in
a separate directory. So for the purpose of this wiki page assume that
the zone files are in /etc/nsd3/ and if you have already been running
bind previously then copying the zone files that worked with bind into
/etc/nsd3/ should work without adjustment. There are sample
configuration files in the web page at https://calomel.org/nsd_dns.html
but the example here is for a single master zone only.

Note that nsd is not designed to do logging, despite the existence of a
logging line in the nsd.conf example file. Attempting to uncomment the
logging line will result in being unable to start nsd.

A sample nsd.conf is given here where the forward and reverse zone files
are presumed to be in /etc/nsd3/ and named myhomenet.com.zone and
0.0.10.in-addr.arpa.zone:

    ## NSD authoritative only DNS
    ## nsd.conf .:. https://calomel.org
    ## Primary or "Master" NSD server
    #
    # The directives "notify" and "provide-xfr" are only needed if you are also going to setup 
    # a secondary NSD server. Uncomment out these lines to use them.
    server:
     # uncomment to specify specific interfaces to bind (default all).
       ip-address: 127.0.0.1
     # port to answer queries on. default is 53.
    #    port: 53
       port: 53530
     # Number of NSD servers to fork.
       server-count: 1
     # listen only on IPv4 connections
       ip4-only: yes
     # don't answer VERSION.BIND and VERSION.SERVER CHAOS class queries
       hide-version: yes
     # identify the server (CH TXT ID.SERVER entry).
       identity: "Home network authoritative DNS"
     # The directory for zonefile: files.
       zonesdir: "/etc/nsd3"
    key:
      name: "sec_key"
      algorithm: hmac-md5
      secret: "6KM6qiKfwfEpamEq72HQdA=="
    zone:
       name: myhomenet.com
       zonefile: myhomenet.com.zone
     # notify: 10.0.0.222@53 sec_key
     # provide-xfr: 10.0.0.222 sec_key
    zone:
       name: 0.0.10.in-addr.arpa
       zonefile: 0.0.10.in-addr.arpa.zone
     # notify: 10.0.0.222@53 sec_key
     # provide-xfr: 10.0.0.222 sec_key
    # Logging
    #logfile: "/etc/nsd/nsd.log"
    # Do not uncomment these lines as logging in nsd is not currently implemented
    #
    ## NSD authoritative only DNS
    ## nsd.conf .:. https://calomel.org
    ## Primary or "Master" NSD server

Starting and running nsd
------------------------

Before starting up nsd you can check the zone files using the
nsd-checkconf command with the zone file name as a parameter.

In order to build the zone database that makes nsd run exceptionally
quickly the database file must be rebuilt each time a zone or config
file is changed, and the following command is executed as the nsd user
(the daemon runs as nsd and that user must be able to read
/var/db/nsd/nsd.db):

    nsdc rebuild

In order to start nsd then type as root:

    systemctl start nsd

Once nsd has been tested then make nsd start at boot by typing:

    systemctl enable nsd

If you were already running bind listening on port 53 and are moving
over to unbound, then it is important to stop bind before starting
unbound to avoid conflicts:

    systemctl stop named
    systemctl start unbound

and to make the correct services start at boot:

    systemctl disable named
    systemctl enable unbound

Testing nsd
-----------

nsd can be run concurrently with bind during the testing phase. You can
check forward and reverse local lookups on the port at 53530 using:

    drill @127.0.0.1 -p 53530 mylocalmachine1.myhomenet.com
    drill @127.0.0.1 -p 53530 -x w.x.y.z

where w.x.y.z is a local address within the LAN.

Once this is working then if you are running unbound as the caching
recursive server then you can switch the unbound config to forward
queries from local machines on the same network to query nsd by using
the following structure in unbound.conf (and see unbound), where it is
assumed that nsd is listening to port 53530:

    local-zone: "10.in-addr.arpa." nodefault

    stub-zone:
           name: "mdylocalnet.com"
           stub-addr: 127.0.0.1@53530

    stub-zone:
           name: "10.in-addr.arpa"
           stub-addr: 127.0.0.1@53530

Once the unbound.conf contains the above then restart unbound and check
that local queries for the nsd zone entries works. Once it is all tested
then you can switch unbound to listen on both 127.0.0.1 as well as on
the external interface for the local network by having the lines in
unbound.conf including:

       interface: 127.0.0.1
       interface: 10.0.0.1

where 10.0.0.1 is the ip address of the dns server running both nsd and
unbound and providing local dns for other machines on the 10.x.x.x
network.

The examples here all assume that only ipv4 is being used. Corresponding
configurations for ipv6 should be included where necessary, and further
details on the parameters for that can be found in the man files for the
two packages as well as examples that can be found with web searches.

WAN facing dns
--------------

It is also possible to change the configuration files and interfaces on
which the server is listening so that dns queries from machines outside
of the local network can access specific machines within the LAN. This
is useful for web and mail servers which are accessible from anywhere,
and the same techniques can be employed as has been achieved using bind
for many years, in combination with appropriate port forwarding in the
network firewall machines, to allow incoming requests to access the
correct machine.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nsd&oldid=254263"

Category:

-   Domain Name System
