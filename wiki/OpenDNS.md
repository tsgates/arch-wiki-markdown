OpenDNS
=======

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           resolv.conf.             
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

OpenDNS is an alternative DNS service.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 DNS in Linux                                                       |
| -   2 Using OpenDNS                                                      |
| -   3 Protect /etc/resolv.conf                                           |
|     -   3.1 dhclient                                                     |
|     -   3.2 Pdnsd                                                        |
|                                                                          |
| -   4 Fixing problems with Google                                        |
| -   5 Resources                                                          |
+--------------------------------------------------------------------------+

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

Warning: The OpenDNS servers ALWAYS respond with an IP address for any
query, even if the domain or DNS record doesn't exist. This can cause
problems when debugging network issues.

Using OpenDNS
-------------

Edit /etc/resolv.conf and add the OpenDNS nameservers to the top of the
file so they are used first, optionally removing already listed servers
in order to only use OpenDNS:

    # OpenDNS nameservers
    nameserver 208.67.222.222
    nameserver 208.67.220.220

Several network management applications, such as wicd, have an option
for a third DNS server. You should not duplicate one of the first two
OpenDNS nameservers as it will resort back to 0.0.0.0. OpenDNS has two
servers which can be used for this third option:

    208.67.222.220
    208.67.220.222

Note: Changes made to /etc/resolv.conf take effect immediately.

Protect /etc/resolv.conf
------------------------

See Resolv.conf#Preserve_DNS_settings for how to preserve your settings
in resolv.conf.

> dhclient

If you use dhclient, you will need to add to (or create) to
/etc/dhclient.conf:

    prepend domain-name-servers 127.0.0.1;

> Pdnsd

See Pdnsd#OpenDNS.

Tip: You may also specify these IPs in your router's configuration
interface and merely point to your router's IP from /etc/resolv.conf.

Fixing problems with Google
---------------------------

OpenDNS hijacks Google-searches by routing all queries through their own
servers first. This can be annoying because Google searches may slow
down noticeably and it also breaks Google's FeelingLucky feature (e.g.,
entering digg in your adress bar will open www.digg.com). For the
latter, there is a Firefox-addon that brings back the original
behaviour. A more elegant solution is to redirect all queries for Google
exclusively to your ISP's DNS Server. This can be done with dnsmasq (see
Speeding up DNS with dnsmasq for more information).

Resources
---------

-   resolv.conf
-   Domain Name System (DNS)
-   OpenDNS.com
-   OpenNIC Alternative DNS Installer

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenDNS&oldid=250044"

Category:

-   Domain Name System
