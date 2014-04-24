Dynamic DNS
===========

  Summary help replacing me
  ---------------------------
  Updating Dynamic DNS

Dynamic DNS or DDNS is a method of updating, in real time, a DNS to
point to a changing IP address on the Internet. This is used to provide
a persistent domain name for a resource that may change location on the
network.

Contents
--------

-   1 Router
-   2 Software Dynamic DNS
    -   2.1 Afraid
        -   2.1.1 afraid-dyndns
        -   2.1.2 ddclient
        -   2.1.3 cron
        -   2.1.4 Netctl
    -   2.2 DynDNS
    -   2.3 DNSdynamic
    -   2.4 System-NS
        -   2.4.1 cron

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

The package ddclient is available in the community repository. It
includes systemd support. Unfortunately, it seems to generate broken
update URLs for freedns: http://ddclient.tisnix.be/ticket/58

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

Netctl

To add the record of your IP to freedns.afraid.org along with a network
connection through the use with Netctl. You can append the following
line to your netctl profile.

    ExecUpPost='curl -ks http://freedns.afraid.org/dynamic/update.php?ZRRJZ...................bzo4Njc1M4DA'

> DynDNS

DynDNS is another Dynamic DNS service.

DynDNS can be updated with ddclient or the dyndns package in the AUR.

> DNSdynamic

DNSdynamic "will always be absolutely free" and works with ddclient

> System-NS

System-NS free DNS service.

cron

Make directory and script file in it.

    $ cd ~
    $ mkdir systemns
    $ cd systemns
    $ vi systemns.sh

Put this text in systemns.sh. You should change domain and token
parameters.

    #!/bin/bash
    wget -q -O- --post-data "type=dynamic&domain=mydomain.system-ns.net&command=set&token=880078764367979fe765c0fa3f4efff1" http://system-ns.com/api | grep -v '"code":0' | awk '{print d, $0}' "d=$(date)" >> ~/systemns/systemns.log

Make the systemns.sh file executable.

    $ chmod +x systemns.sh

Open crontab.

    $ crontab -e

Put this text in the crontab (run every 5 minutes)

    */5 * * * * ~/systemns/systemns.sh

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dynamic_DNS&oldid=282631"

Category:

-   Domain Name System

-   This page was last modified on 13 November 2013, at 12:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
