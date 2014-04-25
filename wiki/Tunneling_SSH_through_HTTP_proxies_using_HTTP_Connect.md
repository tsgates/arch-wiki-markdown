Tunneling SSH through HTTP proxies using HTTP Connect
=====================================================

  

Contents
--------

-   1 Introduction
-   2 Creating the tunnel
-   3 Using the tunnel
-   4 See Also

Introduction
============

To open the connection to the server running the SSH daemon we will use
the HTTP CONNECT method which allows a client to connect to a server
through a proxy by sending an HTTP CONNECT request to this proxy.

Tip:If your proxy does not support the HTTP Connect method, see HTTP
Tunneling

Creating the tunnel
===================

For this we will use corkscrew, available in [community], which is «a
tool for tunneling SSH through HTTP proxies».

Opening an SSH connection is pretty simple:

    ssh user@server -o "ProxyCommand corkscrew $proxy_ip_or_domain_name $proxy_port $destination_ip_or_domain_name $destination_port"

but that just opens a shell yet what we want is a tunnel, so we do this:

    ssh -ND $port user@server -o "ProxyCommand corkscrew $proxy_ip_or_domain_name $proxy_port $destination_ip_or_domain_name $destination_port"

which creates a SOCKS proxy on localhost:$port.

Using the tunnel
================

See Using a SOCKS proxy.

See Also
========

-   community/proxytunnel

     ProxyCommand /usr/bin/proxytunnel -p some-proxy:8080 -d www.muppetzone.com:443

-   community/httptunnel

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tunneling_SSH_through_HTTP_proxies_using_HTTP_Connect&oldid=239094"

Category:

-   Secure Shell

-   This page was last modified on 6 December 2012, at 01:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
