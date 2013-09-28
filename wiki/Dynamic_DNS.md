Dynamic DNS
===========

  Summary
  ----------------------
  Updating Dynamic DNS

Dynamic DNS or DDNS is a method of updating, in real time, a DNS to
point to a changing IP address on the Internet. This is used to provide
a persistent domain name for a resource that may change location on the
network.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Router                                                             |
| -   2 Software Dynamic DNS                                               |
|     -   2.1 Afraid                                                       |
|         -   2.1.1 afraid-dyndns                                          |
|         -   2.1.2 ddclient                                               |
|         -   2.1.3 cron                                                   |
|                                                                          |
|     -   2.2 DynDNS                                                       |
+--------------------------------------------------------------------------+

Router
------

Many routers have built in DDNS Services but can be limited in the
services which they update. If the Router supports a the service, or you
are willing to pay or donate for a service, you should do this, it is
faster and more reliable. In that case, there is no need to use a
softwareside solution.

Software Dynamic DNS
--------------------

> Afraid

FreeDNS.afraid.org is a free Service which is easy and uncomplicated to
set up.

There are several options to enable automatic DDNS updating for this
provider:

afraid-dyndns

The package afraid-dyndns-uv is available in the AUR.

ddclient

The package ddclient is available in the AUR. It includes systemd
support. Unfortunately, it seems to generate broken update URLs for
freedns: http://ddclient.tisnix.be/ticket/58

An example config file looks like this:

    daemon=600
    cache=/tmp/ddclient.cache
    syslog=yes

    use=web, web=checkip.dyndns.com/, web-skip='IP Address'

    ssl=yes

    ## Configuration variables applicable to the 'freedns' protocol are:
    #  protocol=freedns             ##
    #  server=fqdn.of.service       ## defaults to freedns.afraid.org
    #  login=service-login          ## login name and password registered with the service
    #  password=service-password    ##
    #  fully.qualified.host         ## the host registered with the service.
    #
    protocol=freedns,                                             \
    login=my-freedns.afraid.org-login,                            \
    password=my-freedns.afraid.org-password                       \
    myhost.afraid.org

To enable the systemd service:

    systemctl enable ddclient

cron

Another option is to:

-   goto Dynamic DNS page on freedns.afraid.org
-   add A record and select your prefered domain name
-   copy link under Direct URL, it will be something like
    "http://freedns.afraid.org/dynamic/update.php?ZRRJZ...................bzo4Njc1M4DA"
-   use crontab -e to enter new schedulled command:

    */10 * * * * curl -ks http://freedns.afraid.org/dynamic/update.php?ZRRJZ...................bzo4Njc1M4DA > /dev/null

> DynDNS

DynDNS is another Dynamic DNS service.

DynDNS can be installed with the package dyndns, available in the AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dynamic_DNS&oldid=247559"

Category:

-   Domain Name System
