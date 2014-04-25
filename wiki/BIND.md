BIND
====

Berkeley Internet Name Daemon (BIND) is the reference implementation of
the Domain Name System (DNS) protocols.

Contents
--------

-   1 Installation
-   2 A configuration template for running a domain
    -   2.1 1. Creating a zonefile
    -   2.2 2. Configuring master server
-   3 BIND as simple DNS forwarder
-   4 Running BIND in a chrooted environment
-   5 Configuring BIND to serve DNSSEC signed zones
-   6 Automatically listen on new interfaces without chroot and root
    privileges
-   7 See also
-   8 BIND Resources

Installation
------------

These few steps show you how to install BIND and set it up as a local
caching-only server.

Install the bind package which can be found in the official
repositories.

Optionally edit /etc/named.conf and add this under the options section,
to only allow connections from the localhost:

    listen-on { 127.0.0.1; };

Edit /etc/resolv.conf to use the local DNS server:

    nameserver 127.0.0.1

Start the named daemon.

A configuration template for running a domain
---------------------------------------------

This is a simple tutorial in howto setup a simple home network
DNS-server with bind. In our example we use "domain.tld" as our domain.

For a more elaborate example see Two-in-one DNS server with BIND9.

> 1. Creating a zonefile

    # nano /var/named/domain.tld.zone

    $TTL 7200
    ; domain.tld
    @       IN      SOA     ns01.domain.tld. postmaster.domain.tld. (
                                            2007011601 ; Serial
                                            28800      ; Refresh
                                            1800       ; Retry
                                            604800     ; Expire - 1 week
                                            86400 )    ; Minimum
                    IN      NS      ns01
                    IN      NS      ns02
    ns01            IN      A       0.0.0.0
    ns02            IN      A       0.0.0.0
    localhost       IN      A       127.0.0.1
    @               IN      MX 10   mail
    imap            IN      CNAME   mail
    smtp            IN      CNAME   mail
    @               IN      A       0.0.0.0
    www             IN      A       0.0.0.0
    mail            IN      A       0.0.0.0
    @               IN      TXT     "v=spf1 mx"

$TTL defines the default time-to-live in seconds for all record types.
In this example it is 2 hours.

Serial must be incremented manually before restarting named every time
you change a resource record for the zone. If you forget to do it slaves
will not re-transfer the zone: they only do it if the serial is greater
than that of the last time they transferred the zone.

> 2. Configuring master server

Add your zone to /etc/named.conf:

    zone "domain.tld" IN {
            type master;
            file "domain.tld.zone";
            allow-update { none; };
            notify no;
    };

Restart the daemon and you are done.

BIND as simple DNS forwarder
----------------------------

If you have problems with, for example, VPN connections, they can
sometimes be solved by setting-up a forwarding DNS server. This is very
simple with BIND. Add these lines to /etc/named.conf, and change IP
address according to your setup.

    listen-on { 192.168.66.1; };
    forwarders { 8.8.8.8; 8.8.4.4; };

Don't forget to restart the service!

Running BIND in a chrooted environment
--------------------------------------

Running in a chroot environment is not required but improves security.
See BIND (chroot) for how to do this.

Configuring BIND to serve DNSSEC signed zones
---------------------------------------------

See DNSSEC#BIND (serving signed DNS zones)

Automatically listen on new interfaces without chroot and root privileges
-------------------------------------------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: initscripts have 
                           been replaced by systemd 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Add

     interface-interval <rescan-timeout-in-minutes>;

parameter into named.conf options. Then you should modify rc-script:

         stat_busy "Starting DNS"
    -    [ -z "$PID" ] && /usr/sbin/named ${NAMED_ARGS}
    +    setcap cap_net_bind_service=eip /usr/sbin/named
    +    NAMED_ARGS=`echo ${NAMED_ARGS} | sed 's#-u [[:alnum:]]*##'`
    +    [ -z "$PID" ] && sudo -u named /usr/sbin/named ${NAMED_ARGS}

So your /etc/rc.d/named should look like this:

         stat_busy "Starting DNS"
         setcap cap_net_bind_service=eip /usr/sbin/named
         NAMED_ARGS=`echo ${NAMED_ARGS} | sed 's#-u [[:alnum:]]*##'`
         [ -z "$PID" ] && sudo -u named /usr/sbin/named ${NAMED_ARGS}

Change user name in last line (with "... sudo -u named ...") if your
named user is not 'named'.

See also
--------

-   BIND (chroot)

BIND Resources
--------------

-   BIND 9 DNS Administration Reference Book
-   Pro DNS and BIND
-   Internet Systems Consortium, Inc. (ISC)
-   DNS Glossary

Retrieved from
"https://wiki.archlinux.org/index.php?title=BIND&oldid=305713"

Category:

-   Domain Name System

-   This page was last modified on 20 March 2014, at 01:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
