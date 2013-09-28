Unbound
=======

Unbound is a validating, recursive, and caching DNS resolver.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Pre-configuration                                                  |
| -   3 Basic configuration                                                |
|     -   3.1 Unbound configuration                                        |
|     -   3.2 Adding unbound to boot process                               |
|     -   3.3 Set /etc/resolv.conf to use the local DNS server             |
|                                                                          |
| -   4 Configuring Unbound to Validate DNSSEC                             |
| -   5 Adding an authoritative dns server                                 |
| -   6 WAN facing dns                                                     |
| -   7 Issues concerning num_threads                                      |
+--------------------------------------------------------------------------+

Installation
------------

Install unbound, and expat which is dependency for DNSSEC:

    pacman -S unbound expat

Pre-configuration
-----------------

For querying a host that is not cached as an address the resolver needs
to start at the top of the server tree and query the root servers to
know where to go for the top level domain for the address being queried.
Therefore it is necessary to put a "root hints" file into the unbound
config directory. The simplest way to do this is to run the command:

wget ftp://FTP.INTERNIC.NET/domain/named.cache -O /etc/unbound/root.hints

It is a good idea to run this every six months or so in order to make
sure the list of root servers is up to date. This can be done manually
or by setting up a cron job for the task.

If you are going to use DNSSEC then you will need the root server trust
key anchor in the file root.key which you can place in a directory owned
by user unbound.

    mkdir /etc/unbound/keys
    chown unbound:unbound /etc/unbound/keys

Then create the file root.key and place it in this directory
[/etc/unbound/keys/] and make sure the file root.key is owned by user
unbound as below.

The line below is the 2010 trust anchor for the root zone, and this line
is the only line in the file root.key. You can independently verify the
root zone anchor by going to the IANA.org Index of /root-anchors.

    . IN DS 19036 8 2 49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5

Once the file is created make unbound the owner:

# chown unbound:unbound /etc/unbound/keys/root.key

  
 If you will want logging for unbound then create a log file which can
also be in the same directory, but you can choose any location. One way
is then to do as root:

    # touch /etc/unbound/unbound.log
    # chown unbound:unbound /etc/unbound/unbound.log

Then you can include the logging parameter when you set up the main
unbound.conf file as below.

Basic configuration
-------------------

> Unbound configuration

Unbound is easy to configure. In the directory /etc/unbound/ there is a
sample config file [unbound.conf.example] which can be copied to
/etc/unbound/unbound.conf and with the adjustments to the file for your
own needs it is enough to run on both IPv4 and IPv6 without access
restrictions. Once copied to unbound.conf and then uncomment lines or
add in lines as needed.

For the case where you want the unbound server to listen to requests
from the machine that it is running on then make sure that the line
defining which address it is going to listen on is included:

    interface: 127.0.0.1

It is also important to include a line to point to the root.hints file
that was prepared before editing the unbound.conf file:

    root-hints: "/etc/unbound/root.hints"

If you have a local network which you wish to have dns queries for and
there is a local dns server that you would like to forward queries to
then you should include the line: private-address for say the 10. or
192.168. networks as:

private-address: 10.0.0.0/24

or

private-address: 192.168.0.0/16

To include a local dns server for both forward and reverse local
addresses a set of lines similar to these below is necessary with a
forward and reverse lookup (choose the ip address of the server
providing dns for the local network accordingly by changing 10.0.0.1 in
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

Note that there is a difference between forward zones and stub zones -
stub zones will only work when connected to an authoritative dns server
directly. This would work for lookups from a bind dns server if it is
providing authoritative dns - but if you are referring queries to an
unbound server in which internal lookups are forwarded on to another dns
server, then defining the referral as a stub zone in the machine here
won't work. In that case it is necessary to define a forward zone as
above, since forward zones can have daisy chain lookups onward to other
dns servers. i.e. forward zones can refer queries to recursive dns
servers. This distinction is important as you don't get any error
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
fast google dns servers):

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

> Adding unbound to boot process

Start the service:

    systemctl start unbound

Then enable it so that it starts at boot once you have tested that it
works.

    systemctl enable unbound

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

    drill @127.0.0.1 www.cnn.com
    drill @127.0.0.1 localmachine.localdomain.com
    drill @127.0.0.1 -x w.x.y.z 

where w.x.y.z can be a local or external ip address and the -x option
requests a reverse lookup. Once all is working, and you have
/etc/resolv.conf set to use 127.0.0.1 as the nameserver then you no
longer need the @127.0.0.1 in the drill command, and you can test again
that it uses the default dns server - check that the server used as
listed at the bottom of the output from each of these commands shows it
is 127.0.0.1 being queried.

Configuring Unbound to Validate DNSSEC
--------------------------------------

Make sure that the root anchor key file exists as described earlier in
the page:

Edit unbound.conf, adding the following line to the server: block:

       auto-trust-anchor-file: "/etc/unbound/keys/root.key"

Also make sure that if a general forward to the google servers had been
in place, then comment them out otherwise dns queries will fail.

Restart unbound:

    systemctl restart unbound

Now dnssec validation will be done if the dns server being queried
supports it. Note that including dnssec checking siginificantly
increases dns lookup times for initial lookups. Once an address is
cached then the lookup is virtually instantaneous.

Adding an authoritative dns server
----------------------------------

For users who wish to run both a validating, recursive, caching dns
server as well as an authoritative dns server on a single machine then
it may be useful to refer to the wiki page nsd which gives an example of
a configuration for such a system. Having one server for authoritative
dns queries and a separate dns server for the validating, recursive,
caching dns functions gives increased security over a single dns server
providing all of these functions. Many users have used bind as a single
dns server, and some help on migration from bind to the combination of
running nsd and bind is provided in the nsd wiki page.

WAN facing dns
--------------

It is also possible to change the configuration files and interfaces on
which the server is listening so that dns queries from machines outside
of the local network can access specific machines within the LAN. This
is useful for web and mail servers which are accessible from anywhere,
and the same techniques can be employed as has been achieved using bind
for many years, in combination with suitable port forwarding on firewall
machines to forward incoming requests to the right machine.

Issues concerning num_threads
-----------------------------

The man page for unbound.conf mentions:

         outgoing-range: <number>
                 Number of ports to open. This number of file  descriptors  can  be  opened  per thread.

and some sources suggest that the num-threads parameter should be set to
the number of cpu cores. The sample unbound.conf file merely has:

           # number of threads to create. 1 disables threading.
           # num-threads: 1

However it is not possible to arbitrarily increase num-threads above 1
without causing unbound to start with warnings in the logs about
exceeding the number of file descriptors. In reality for most users
running on small networks or on a single machine it should be
unnecessary to seek performance enhancement by increasing num-threads
above 1. If you do wish to do so then refer to
http://www.unbound.net/documentation/howto_optimise.html and the
following rule of thumb should work:

Set num-threads equal to the number of CPU cores on the system. E.g. for
4 CPUs with 2 cores each, use 8.

Set the outgoing-range to as large a value as possible, see the sections
in the referred web page above on how to overcome the limit of 1024 in
total. This services more clients at a time. With 1 core, try 950. With
2 cores, try 450. With 4 cores try 200. The num-queries-per-thread is
best set at half the number of the outgoing-range.

Because of the limit on outgoing-range thus also limits
num-queries-per-thread, it is better to compile with libevent, so that
there is no more 1024 limit on outgoing-range. If you need to compile
this way for a heavy duty dns server then you will need to compile the
programme from source instead of using the arch package.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unbound&oldid=251235"

Category:

-   Domain Name System
