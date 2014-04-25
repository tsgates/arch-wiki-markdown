Unbound
=======

Unbound is a validating, recursive, and caching DNS resolver.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Access control
    -   2.2 Root hints
    -   2.3 Set /etc/resolv.conf to use the local DNS server
    -   2.4 Logging
    -   2.5 DNSSEC validation
    -   2.6 Forwarding queries
-   3 Usage
    -   3.1 Starting Unbound
    -   3.2 Remotely control Unbound
        -   3.2.1 Setting up unbound-control
        -   3.2.2 Using unbound-control
-   4 Adding an authoritative DNS server
-   5 WAN facing DNS
-   6 Issues concerning num-threads

Installation
------------

Install the unbound package from official repositories.

Additionally, expat is required for DNSSEC validation.

Configuration
-------------

unbound is easy to configure. There is a sample config file
/etc/unbound/unbound.conf.example, which can be copied to
/etc/unbound/unbound.conf and with the adjustments to the file for your
own needs it is enough to run on both IPv4 and IPv6 without access
restrictions.

> Access control

You can specify the interfaces to answer queries from by IP address. To
listen on localhost, use:

    interface: 127.0.0.1

To listen on all interfaces, use:

    interface: 0.0.0.0

Access can be further configured via the access-control option:

    access-control: subnet action

For example:

    access-control: 192.168.1.0/24 allow

action can be one of deny (drop message), refuse (polite error reply),
allow (recursive ok), or allow_snoop (recursive and nonrecursive ok). By
default everything is refused except for localhost.

> Root hints

For querying a host that is not cached as an address the resolver needs
to start at the top of the server tree and query the root servers to
know where to go for the top level domain for the address being queried.
Therefore it is necessary to put a root hints file into the unbound
config directory. The simplest way to do this is to run the command:

    # wget ftp://FTP.INTERNIC.NET/domain/named.cache -O /etc/unbound/root.hints

It is a good idea to run this every six months or so in order to make
sure the list of root servers is up to date. This can be done manually
or by setting up a cron job for the task.

Point unbound to the root.hints file:

    root-hints: "/etc/unbound/root.hints"

> Set /etc/resolv.conf to use the local DNS server

Edit /etc/resolv.conf (See also resolv.conf):

    nameserver 127.0.0.1

Also if you want to be able to use the hostname of local machine names
without the fully qualified domain names, then add a line with the local
domain such as:

    domain localdomain.com
    nameserver 127.0.0.1

That way you can refer to local hosts such as
mainmachine1.localdomain.com as simply mainmachine1 when using the ssh
command, but the drill command below still requires the fully qualified
domain names in order to perform lookups.

Testing the server before making it default can be done using the drill
command from the ldns package with examples from internal and external
forward and reverse addresses:

    $ drill @127.0.0.1 www.cnn.com
    $ drill @127.0.0.1 localmachine.localdomain.com
    $ drill @127.0.0.1 -x w.x.y.z 

where w.x.y.z can be a local or external IP address and the -x option
requests a reverse lookup. Once all is working, and you have
/etc/resolv.conf set to use 127.0.0.1 as the nameserver then you no
longer need the @127.0.0.1 in the drill command, and you can test again
that it uses the default DNS server - check that the server used as
listed at the bottom of the output from each of these commands shows it
is 127.0.0.1 being queried.

> Logging

If you will want logging for unbound, then create a log file which can
also be in the same directory, but you can choose any location. One way
is then to do as root:

    # touch /etc/unbound/unbound.log
    # chown unbound:unbound /etc/unbound/unbound.log

Then you can include the logging parameter when you set up the main
unbound.conf file as below.

> DNSSEC validation

You will need the root server trust key anchor file. It is provided by
the dnssec-anchors package (already installed as a dependency), however,
unbound needs read and write access to the file. You can follow an
example configuration below:

    # mkdir /etc/unbound/keys
    # cp /etc/trusted-key.key /etc/unbound/keys/dnssec-root-anchor.key
    # chown -R unbound:unbound /etc/unbound/keys

Then point unbound to the file:

    /etc/unbound/unbound.conf

    server:
      auto-trust-anchor-file: "/etc/unbound/keys/dnssec-root-anchor.key"
      ...

Also make sure that if a general forward to the Google servers had been
in place, then comment them out otherwise DNS queries will fail. DNSSEC
validation will be done if the DNS server being queried supports it.

Note:Including DNSSEC checking significantly increases DNS lookup times
for initial lookups. Once an address is cached locally, then the lookup
is virtually instantaneous.

> Forwarding queries

If you have a local network which you wish to have DNS queries for and
there is a local DNS server that you would like to forward queries to
then you should include this line:

    private-address: local_subnet/subnet_mask

for example:

    private-address: 10.0.0.0/24

To include a local DNS server for both forward and reverse local
addresses a set of lines similar to these below is necessary with a
forward and reverse lookup (choose the IP address of the server
providing DNS for the local network accordingly by changing 10.0.0.1 in
the lines below):

    local-zone: "10.in-addr.arpa." transparent

This line above is important to get the reverse lookup to work
correctly.

    forward-zone:
    name: "mynetwork.com."
    forward-addr: 10.0.0.1        # Home DNS

    forward-zone:
    name: "10.in-addr.arpa."
    forward-addr: 10.0.0.1

Note:There is a difference between forward zones and stub zones - stub
zones will only work when connected to an authoritative DNS server
directly. This would work for lookups from a bind DNS server if it is
providing authoritative DNS - but if you are referring queries to an
unbound server in which internal lookups are forwarded on to another DNS
server, then defining the referral as a stub zone in the machine here
will not work. In that case it is necessary to define a forward zone as
above, since forward zones can have daisy chain lookups onward to other
DNS servers. i.e. forward zones can refer queries to recursive DNS
servers. This distinction is important as you do not get any error
messages indicating what the problem is if you use a stub zone
inappropriately.

You can set up the localhost forward and reverse lookups with the
following lines:

    local-zone: "localhost." static
    local-data: "localhost. 10800 IN NS localhost."
    local-data: "localhost. 10800 IN SOA localhost. nobody.invalid. 1 3600 1200 604800 10800"
    local-data: "localhost. 10800 IN A 127.0.0.1"
    local-zone: "127.in-addr.arpa." static
    local-data: "127.in-addr.arpa. 10800 IN NS localhost."
    local-data: "127.in-addr.arpa. 10800 IN SOA localhost. nobody.invalid. 2 3600 1200 604800 10800"
    local-data: "1.0.0.127.in-addr.arpa. 10800 IN PTR localhost."

Then to use specific servers for default forward zones that are outside
of the local machine and outside of the local network (i.e. all other
queries will be forwarded to them, and then cached) add this to the
configuration file (and in this example the first two addresses are the
fast google DNS servers):

    forward-zone:
      name: "."
      forward-addr: 8.8.8.8
      forward-addr: 8.8.4.4
      forward-addr: 208.67.222.222
      forward-addr: 208.67.220.220

This will make unbound use Google and OpenDNS servers as the forward
zone for external lookups.

Note:OpenDNS strips DNSSEC records from responses. Do not use the above
forward zone if you want to enable DNSSEC validation (below).

Usage
-----

> Starting Unbound

The unbound package provides unbound.service, just start it. You may
want to enable it so that it starts at boot.

> Remotely control Unbound

unbound ships with the unbound-control utility which enables us to
remotely administer the unbound server. It is similar to the pdnsd-ctl
command of pdnsd.

Setting up unbound-control

Before you can start using it, the following steps need to be performed:

1) Firstly, you need to run the following command

    # unbound-control-setup

which will generate a self-signed certificate and private key for the
server, as well as the client. These files will be created in the
/etc/unbound directory.

2) After that, edit /etc/unbound/unbound.conf and put the following
contents in that. The control-enable: yes option is necessary, the rest
can be adjusted as required.

    remote-control:
        # Enable remote control with unbound-control(8) here.
        # set up the keys and certificates with unbound-control-setup.
        control-enable: yes
       
        # what interfaces are listened to for remote control.
        # give 0.0.0.0 and ::0 to listen to all interfaces.
        control-interface: 127.0.0.1
       
        # port number for remote control operations.
        control-port: 8953
       
        # unbound server key file.
        server-key-file: "/etc/unbound/unbound_server.key"
       
        # unbound server certificate file.
        server-cert-file: "/etc/unbound/unbound_server.pem"
       
        # unbound-control key file.
        control-key-file: "/etc/unbound/unbound_control.key"
       
        # unbound-control certificate file.
        control-cert-file: "/etc/unbound/unbound_control.pem"

Using unbound-control

Some of the commands that can be used with unbound-control are:

-   print statistics without resetting them

     # unbound-control stats_noreset

-   dump cache to stdout

     # unbound-control dump_cache

-   flush cache and reload configuration

     # unbound-control reload

Please refer to man 8 unbound-control for a detailed look at the
operations it supports.

Adding an authoritative DNS server
----------------------------------

For users who wish to run both a validating, recursive, caching DNS
server as well as an authoritative DNS server on a single machine then
it may be useful to refer to the wiki page nsd which gives an example of
a configuration for such a system. Having one server for authoritative
DNS queries and a separate DNS server for the validating, recursive,
caching DNS functions gives increased security over a single DNS server
providing all of these functions. Many users have used bind as a single
DNS server, and some help on migration from bind to the combination of
running nsd and bind is provided in the nsd wiki page.

WAN facing DNS
--------------

It is also possible to change the configuration files and interfaces on
which the server is listening so that DNS queries from machines outside
of the local network can access specific machines within the LAN. This
is useful for web and mail servers which are accessible from anywhere,
and the same techniques can be employed as has been achieved using bind
for many years, in combination with suitable port forwarding on firewall
machines to forward incoming requests to the right machine.

Issues concerning num-threads
-----------------------------

The man page for unbound.conf mentions:

         outgoing-range: <number>
                 Number of ports to open. This number of file  descriptors  can  be  opened  per thread.

and some sources suggest that the num-threads parameter should be set to
the number of cpu cores. The sample unbound.conf.example file merely
has:

           # number of threads to create. 1 disables threading.
           # num-threads: 1

However it is not possible to arbitrarily increase num-threads above 1
without causing unbound to start with warnings in the logs about
exceeding the number of file descriptors. In reality for most users
running on small networks or on a single machine it should be
unnecessary to seek performance enhancement by increasing num-threads
above 1. If you do wish to do so then refer to official documentation
and the following rule of thumb should work:

Set num-threads equal to the number of CPU cores on the system. E.g. for
4 CPUs with 2 cores each, use 8.

Set the outgoing-range to as large a value as possible, see the sections
in the referred web page above on how to overcome the limit of 1024 in
total. This services more clients at a time. With 1 core, try 950. With
2 cores, try 450. With 4 cores try 200. The num-queries-per-thread is
best set at half the number of the outgoing-range.

Because of the limit on outgoing-range thus also limits
num-queries-per-thread, it is better to compile with libevent, so that
there is no 1024 limit on outgoing-range. If you need to compile this
way for a heavy duty DNS server then you will need to compile the
programme from source instead of using the unbound package.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unbound&oldid=275350"

Category:

-   Domain Name System

-   This page was last modified on 13 September 2013, at 15:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
