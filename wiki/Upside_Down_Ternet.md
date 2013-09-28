Upside Down Ternet
==================

This article explains how to create a transparent Squid proxy server
using mogrify to flip the images upside down.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Router Setup                                                 |
|                                                                          |
| -   3 Starting                                                           |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the squid, apache and imagemagick packages from the official
repositories.

Configuration
-------------

Create flip.pl and place it in your /usr/local/bin folder

    /usr/local/bin/flip.pl

    #!/usr/bin/perl
    $|=1;
    $count = 0;
    $pid = $$;
    while (<>) {
           chomp $_;
           if ($_ =~ /(.*\.jpg)/i) {
                   $url = $1;
                   system("/usr/bin/wget", "-q", "-O","/srv/http/images/$pid-$count.jpg", "$url");
                   system("/usr/bin/mogrify", "-flip","/srv/http/images/$pid-$count.jpg");
                   print "http://127.0.0.1/images/$pid-$count.jpg\n";
           }
           elsif ($_ =~ /(.*\.gif)/i) {
                   $url = $1;
                   system("/usr/bin/wget", "-q", "-O","/srv/http/images/$pid-$count.gif", "$url");
                   system("/usr/bin/mogrify", "-flip","/srv/http/images/$pid-$count.gif");
                   print "http://127.0.0.1/images/$pid-$count.gif\n";
           }
           elsif ($_ =~ /(.*\.png)/i) {
                   $url = $1;
                   system("/usr/bin/wget", "-q", "-O","/srv/http/images/$pid-$count.png", "$url");
                   system("/usr/bin/mogrify", "-flip","/srv/http/images/$pid-$count.png");
                   print "http://127.0.0.1/images/$pid-$count.png\n";
           }
           else {
                   print "$_\n";;
           }
           $count++;
    }

Now we need to modify the permissions so that it's executable

    # chmod 755 /usr/local/bin/flip.pl

Next, while not necessary, does clean up the Squid config file a lot
making it easier on the eyes

    # sed -i "/^#/d;/^ *$/d" /etc/squid/squid.conf

Now, edit your squid.conf file and append this to the bottom

    squid.conf

    url_rewrite_program /usr/local/bin/flip.pl

Also find the line for http_port and make it now read

    squid.conf

    http_port 3128 transparent

Finally, we have to create the folders for the images to be flipped in
and set their permissions

The directory where the images are to be stored must be owned by the
proxy user.

    # mkdir /srv/http/images
    # chown proxy:proxy /srv/http/images
    # chmod 755 /srv/http/images

Finally, add the http user to the proxy group

    # usermod -aG proxy http

Verify that the http user is a member of the proxy group

    # groups proxy

or

    # id -Gn proxy

> Router Setup

You will need to edit iptables on your router or gateway to redirect
http traffic to your proxy.

If you have DD-WRT on your router, this is easily done by going to
Administration -> Commands and pasting the following into the box.

    #!/bin/sh
    PROXY_IP=192.168.1.
    PROXY_PORT=3128
    LAN_IP=`nvram get lan_ipaddr`
    LAN_NET=$LAN_IP/`nvram get lan_netmask`
    iptables -t nat -A PREROUTING -i br0 -s $LAN_NET -d $LAN_NET -p tcp --dport 80 -j ACCEPT
    iptables -t nat -A PREROUTING -i br0 -s ! $PROXY_IP -p tcp --dport 80 -j DNAT --to $PROXY_IP:$PROXY_PORT
    iptables -t nat -I POSTROUTING -o br0 -s $LAN_NET -d $PROXY_IP -p tcp -j SNAT --to $LAN_IP
    iptables -I FORWARD -i br0 -o br0 -s $LAN_NET -d $PROXY_IP -p tcp --dport $PROXY_PORT -j ACCEPT

Starting
--------

Configure httpd.service and squid.service to start on boot.

Read Daemons for more information.

See also
--------

-   Original Upside-Down-Ternet Link
-   Ubuntu HowTo
-   Transparent Proxy with DD-WRT
-   Upside-Down-Ternet XKCD

Retrieved from
"https://wiki.archlinux.org/index.php?title=Upside_Down_Ternet&oldid=241222"

Category:

-   Networking
