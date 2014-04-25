DNSCrypt
========

DNSCrypt is a piece of software that encrypts DNS traffic between the
user and a DNS resolver, preventing spying, spoofing or
man-in-the-middle attacks.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Starting
-   4 Tips and tricks
    -   4.1 Using DNSCrypt in combination with Unbound
    -   4.2 Enable EDNS0
        -   4.2.1 Test EDNS0
-   5 See also

Installation
------------

Install dnscrypt-proxy from the official repositories.

Configuration
-------------

By default dnscrypt-proxy is pre-configured in
/etc/conf.d/dnscrypt-proxy (read by dnscrypt-proxy.service) to accept
incoming requests on 127.0.0.1 to an OpenDNS resolver. See the list of
resolvers for alternatives.

With this setup, it will be necessary to alter your resolv.conf file and
replace your current set of resolver addresses with localhost:

    nameserver 127.0.0.1

You might need to prevent other programs from overwriting it, see
resolv.conf#Preserve DNS settings for details.

Starting
--------

Available as a systemd service: dnscrypt-proxy.service

Tips and tricks
---------------

Using DNSCrypt in combination with Unbound

It is recommended to run DNSCrypt as a forwarder for a local DNS cache,
otherwise every single query will make a round-trip to the upstream
resolver.

Install unbound from the official repositories and add the following
lines to the end of the server section in /etc/unbound/unbound.conf:

    do-not-query-localhost: no
    forward-zone:
      name: "."
      forward-addr: 127.0.0.1@40

Note:Port 40 is given as an example as unbound by default listens to 53,
these must be different.

Start the systemd service unbound.service. Then configure DNScrypt to
match Unbound's new forward-zone IP and port in
/etc/config.d/dnscrypt-proxy:

    DNSCRYPT_LOCALIP=127.0.0.1
    DNSCRYPT_LOCALPORT=40

Note:dnscrypt-proxy needs to start before unbound, so include
unbound.service on a Before= line in the [Unit] section of
dnscrypt.service.

Restart dnscrypt-proxy.service to reread the changes.

Enable EDNS0

Extension Mechanisms for DNS that, among other things, allows a client
to specify how large a reply over UDP can be.

Add the following line to your /etc/resolv.conf:

    options edns0

You may also wish to add the following argument to dnscrypt-proxy:

    --edns-payload-size=<bytes>

The default size being 1252 bytes, with values up to 4096 bytes being
purportedly safe. A value below or equal to 512 bytes will disable this
mechanism, unless a client sends a packet with an OPT section providing
a payload size.

Test EDNS0

Make use of the DNS Reply Size Test Server, use the dig command line
tool available with dnsutils from the official repositories to issue a
TXT query for the name rs.dns-oarc.net:

    $ dig +short rs.dns-oarc.net txt

With EDNS0 supported, the output should look similar to this:

    rst.x3827.rs.dns-oarc.net.
    rst.x4049.x3827.rs.dns-oarc.net.
    rst.x4055.x4049.x3827.rs.dns-oarc.net.
    "2a00:d880:3:1::a6c1:2e89 DNS reply size limit is at least 4055 bytes"
    "2a00:d880:3:1::a6c1:2e89 sent EDNS buffer size 4096"

See also
--------

-   resolv.conf
-   Unbound - a validating, recursive, and caching DNS resolver.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DNSCrypt&oldid=301008"

Categories:

-   Domain Name System
-   Security

-   This page was last modified on 23 February 2014, at 21:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
