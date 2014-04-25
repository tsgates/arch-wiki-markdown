HTTP Tunneling
==============

In networking, tunneling is using a protocol of higher level (in our
case HTTP) to transport a lower level protocol (in our case TCP).

Note:See also Tunneling SSH through HTTP proxies using HTTP Connect

Create the tunnel using httptunnel
----------------------------------

  httptunnel [available in extra] creates a bidirectional virtual data
  connection tunneled in HTTP requests. The HTTP requests can be sent
  via an HTTP proxy if so desired. This can be useful for users behind
  restrictive firewalls. If WWW access is allowed through a HTTP proxy,
  it's possible to use httptunnel and, say, telnet or PPP to connect to
  a computer outside the firewall.

If you already have a web server listening on port 80 you are probably
going to want to create a virtual host and tell your web server to proxy
request to the hts server. This is not covered here.

If you do not have any web server listening on port 80 you can do:

-   on the server:

    hts --forward-port localhost:22 80

-   on the client:

    htc --forward-port 8888 example.net:80
    ssh -ND user@localhost -p 8888

Note:As SSH thinks it is connecting to localhost it will not recognize
the fingerprint and display a warning.

You can now use localhost:8888 as a SOCKS proxy.

Using the tunnel
----------------

See Using a SOCKS proxy.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HTTP_Tunneling&oldid=237091"

Category:

-   Networking

-   This page was last modified on 28 November 2012, at 03:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
