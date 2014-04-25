Resolv.conf
===========

The configuration file for DNS resolvers is /etc/resolv.conf. From its
man page:

"The resolver is a set of routines in the C library that provide access
to the Internet Domain Name System (DNS). The resolver configuration
file contains information that is read by the resolver routines the
first time they are invoked by a process. The file is designed to be
human readable and contains a list of keywords with values that provide
various types of resolver information.

"On a normally configured system this file should not be necessary. The
only name server to be queried will be on the local machine; the domain
name is determined from the host name and the domain search path is
constructed from the domain name."

Contents
--------

-   1 DNS in Linux
-   2 Alternative DNS servers
    -   2.1 OpenDNS
        -   2.1.1 Fixing problems with Google
    -   2.2 Google
    -   2.3 Comodo
-   3 Preserve DNS settings
    -   3.1 Using openresolv
    -   3.2 Modify the dhcpcd config
    -   3.3 Write-protect /etc/resolv.conf
    -   3.4 Use timeout option to reduce hostname lookup time
-   4 See also

DNS in Linux
------------

Your ISP (usually) provides working DNS servers, and a router may also
add an extra DNS server in case you have your own cache server.
Switching between DNS servers does not represent a problem for Windows
users, because if a DNS server is slow or does not work it will
immediately switch to a better one. However, Linux usually takes longer
to timeout, which could be the reason why you are getting a delay.

Use dig (provided by package dnsutils) before any changes, repeat after
making the adjustments in the section below and compare the query
time(s):

    $ dig www5.yahoo.com

You can also specify a nameserver:

    $ dig @ip.of.name.server www5.yahoo.com

Alternative DNS servers
-----------------------

To use alternative DNS servers, edit /etc/resolv.conf and add them to
the top of the file so they are used first, optionally removing or
commenting out already listed servers.

> Note:

-   Changes made to /etc/resolv.conf take effect immediately.
-   Bracket notation must be used for IPv6 addresses in
    /etc/resolv.conf.

> OpenDNS

OpenDNS provides free alternative nameservers:

    # OpenDNS nameservers
    nameserver 208.67.222.222
    nameserver 208.67.220.220

There are also IPv6 servers available:

    nameserver [2620:0:ccc::2]
    nameserver [2620:0:ccd::2]

Warning:The OpenDNS servers ALWAYS respond with an IP address for any
query, even if the domain or DNS record doesn't exist. This can cause
problems when debugging network issues.

Fixing problems with Google

OpenDNS hijacks Google-searches by routing all queries through their own
servers first. This can be annoying because Google searches may slow
down noticeably and it also breaks Google's FeelingLucky feature (e.g.,
entering digg in your adress bar will open www.digg.com). For the
latter, there is a Firefox-addon that brings back the original
behaviour. A more elegant solution is to redirect all queries for Google
exclusively to your ISP's DNS Server. This can be done with dnsmasq (see
Speeding up DNS with dnsmasq for more information).

> Google

Google's nameservers can be used as an alternative:

    # Google nameservers
    nameserver 8.8.8.8
    nameserver 8.8.4.4

There are also IPv6 servers available:

    nameserver [2001:4860:4860::8888]
    nameserver [2001:4860:4860::8844]

> Comodo

Comodo provides another IPv4 set, with optional (non-free)
web-filtering. Implied in this feature is that the service hijacks the
queries like OpenDNS does.

    # Comodo nameservers 
    nameserver 8.26.56.26 
    nameserver 8.20.247.20

Preserve DNS settings
---------------------

dhcpcd, netctl, NetworkManager, and various other processes can
overwrite /etc/resolv.conf. This is usually desirable behavior, but
sometimes DNS settings need to be set manually (e.g. when using a static
IP address). There are several ways to accomplish this.

-   If you are using dhcpcd, see #Modify the dhcpcd config below.
-   If you are using NetworkManager, see this thread on how to prevent
    it from overriding your /etc/resolv.conf.
-   If you are using netctl and static IP address assignment, do not use
    the DNS* options in your profile, otherwise resolvconf is called and
    /etc/resolv.conf overwritten.

> Using openresolv

openresolv provides a utility resolvconf, which is a framework for
managing multiple DNS configurations. See man 8 resolvconf and
man 5 resolvconf.conf for more information.

The configuration is done in /etc/resolvconf.conf and running
resolvconf -u will generate /etc/resolv.conf.

> Modify the dhcpcd config

dhcpcd's configuration file may be edited to prevent the dhcpcd daemon
from overwriting /etc/resolv.conf. To do this, add the following to the
last section of /etc/dhcpcd.conf:

    nohook resolv.conf

Alternatively, you can create a file called /etc/resolv.conf.head
containing your DNS servers. dhcpcd will prepend this file to the
beginning of /etc/resolv.conf.

> Write-protect /etc/resolv.conf

Another way to protect your /etc/resolv.conf from being modified by
anything is setting the immutable (write-protection) attribute:

    # chattr +i /etc/resolv.conf

> Use timeout option to reduce hostname lookup time

If you are confronted with a very long hostname lookup (may it be in
pacman or while browsing), it often helps to define a small timeout
after which an alternative nameserver is used. To do so, put the
following in /etc/resolv.conf.

    options timeout:1

See also
--------

-   OpenNIC Alternative DNS Installer

Retrieved from
"https://wiki.archlinux.org/index.php?title=Resolv.conf&oldid=302367"

Category:

-   Domain Name System

-   This page was last modified on 28 February 2014, at 06:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
