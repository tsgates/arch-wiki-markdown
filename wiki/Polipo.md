Polipo
======

> Summary

Polipo is a light weight http proxy server for your small network.
Polipo caches web data.

> Related

Squid

From Polipo's site:

"Polipo is a small and fast caching web proxy (a web cache, an HTTP
proxy, a proxy server). While Polipo was designed to be used by one
person or a small group of people, there is nothing that prevents it
from being used by a larger group."

Unlike Squid, Polipo is very light on resources and simple to configure.
This makes it ideal for single user systems and other uncomplicated
setups. Do keep in mind; however, that this versatility comes at a cost;
Polipo will increase its space usage without restriction as it is not
aware of how big its disk cache grows. This perceived fault is by
design, since omitting these sanity checks drastically reduces Polipo's
memory usage and overall toll on the system. A practical way of
restricting disk usage is by making Polipo run as its own user and
employing disk quota.

The following covers installing and setting up Polipo.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Run polipo as different user (not nobody)                    |
|                                                                          |
| -   2 Starting the daemon                                                |
|     -   2.1 Multiple instances                                           |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Browser                                                      |
|     -   3.2 Tunneling                                                    |
|     -   3.3 Privoxy                                                      |
|     -   3.4 Tor                                                          |
|     -   3.5 DansGuardian                                                 |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 DNS Error                                                    |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install polipo, available in the Official Repositories.

Alternatively, install the newer development branch polipo-git from the
AUR instead.

> Run polipo as different user (not nobody)

Polipo should run as an unprivileged user. Such a user can either be
created or reused. Lets create the polipo cache folder first

    # mkdir /var/cache/polipo

Now we add the new polipo group

    # groupadd -r polipo

and we add the new polipo user afterwards to this group

    # useradd -d /var/cache/polipo -g polipo -r -s /bin/false polipo

then we need a new polipo logfile which is assigned to the upper user
and group

    # touch /var/log/polipo.log
    # chown -R polipo:polipo /var/log/polipo.log /var/cache/polipo

To change user running polipo daemon, we have to create another
polipo.service file

    # touch /etc/systemd/system/polipo.service

Copy the following code section to the new
/etc/systemd/system/polipo.service file

    .include /usr/lib/systemd/system/polipo.service
    [Service]
    User=polipo

To make sure all files and folders are created before you start Polipo
as a designated user. Restart Polipo and check its logfile.

    # systemctl restart polipo
    # tail /var/log/polipo.log

If everything went well you should read something like this

     Established listening socket on port 8123.

Also check, if polipo is running as polipo user:

    # ps aux | grep polipo

Stop the polipo daemon

    # systemctl stop polipo

Starting the daemon
-------------------

To start the polipo daemon:

    # systemctl start polipo

To start it automatically at boot:

    # systemctl enable polipo

> Multiple instances

Polipo can also run without super user privileges. To do so, first copy
/etc/polipo/config.sample to a suitable directory:

    $ cp /etc/polipo/config.sample ~/.poliporc

Edit it so that it points at a writable location, instead of
/var/cache/polipo:

    # Uncomment this if you want to put the on-disk cache in a
    # non-standard location:
    diskCacheRoot = "~/.polipo-cache/"

Create the cache directory:

    $ mkdir ~/.polipo-cache

Finally, launch Polipo with the new configuration:

    $ polipo -c ~/.poliporc

Configuration
-------------

Management is mostly performed in /etc/polipo/config. Most users can opt
for using the sample configuration file, which is sufficient for most
situations and well documented.

    # cd /etc/polipo; cp config.sample config

One element of configuration that warrants mentioning is polipo's
default behavior of blocking outbound connections by port. There are two
variables in polipo's config file that control allowed outbound ports.
allowedPorts specifies ports for outbound HTTP connections. It defaults
to 80-100 and 1024-65535. tunnelAllowedPorts specifies ports polipo will
allow tunnel traffic to as well as HTTPS traffic. By default it is much
more restricted: "It defaults to allowing ssh, HTTP, https, rsync, IMAP,
imaps, POP, pops, Jabber, CVS and Git traffic."

If you see a "403 Forbidden Port" error message from polipo when
attempting to browse to a host:port, you need to configure polipo to
accept traffic to more ports for either HTTP or HTTPS. To set them wide
open, add the following to /etc/polipo/config:

    allowedPorts = 1-65535
    tunnelAllowedPorts = 1-65535

Unlike other proxies, Polipo needs to be restarted after alterations.

> Browser

Set the browser so that it uses localhost:8123 for proxying. Be sure to
disable the browser's disk cache to avoid redundant IO operations and
bad performance.

> Tunneling

Note:According to the Polipo FAQ on "intercepting proxy" this is not
possible/supported!

Note:this requires to run Polipo as its own user.

Instead of manually configuring each browser or other utilities that
might benefit from Polipo's caching, one can also use iptables to route
traffic through polipo.

After installing iptables, add the appropiate rules to
/etc/iptables/iptables.rules:

    *nat
    :PREROUTING ACCEPT [0:0]
    :POSTROUTING ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner polipo -j ACCEPT
    -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 8123
    COMMIT

This routes HTTP traffic through Polipo. Remove all proxy settings from
browsers, if any, and restart iptables.

> Privoxy

Privoxy is a proxy useful for intercepting advertisement and other
undesirables.

According to Polipo's developer, in order to get the privacy
enhancements of Privoxy and much (but not all) of the performance of
Polipo, one should place Polipo upstream of Privoxy.

In other words:

-   point the browser at Privoxy: localhost:8118

-   and direct Privoxy traffic to Polipo: forward / localhost:8123 in
    the Privoxy configuration file.

> Tor

Tor is an anonymizing proxy network.

To use Polipo with Tor, uncomment or include the following in
/etc/polipo/config:

    socksParentProxy = localhost:9050
    socksProxyType = socks5

> DansGuardian

DansGuardian is a web content filter. The only difference to using
DansGuardian with Polipo (rather than squid or tinyproxy) is that in
dansguardian.conf the proxyport needs to be set to polipo's 8123:

    # the port DansGuardian connects to proxy on
    proxyport = 8123

Troubleshooting
---------------

> DNS Error

If the network is started in background there could be a error like this
(in the polipo log file):

    Couldn't send DNS query: Connection refused
    Falling back on gethostbyname.
    Getaddrinfo failed: Temporary name server failure
    Host ***.com lookup failed: Getaddrinfo failed: Temporary name server failure (131072).

This error occurs because in background mode the network hasn't
initialised before Polipo wants to connect to the DNS server (especially
using DHCP). Solving this error is possible on three ways:

-   Do not start the net-profiles in background mode (probably not
    wanted).
-   Set dnsNameServer manually on the wanted DNS server.
-   Or add sleep 10 (or more, it depends) near the beginning of the
    Polipo daemon script /etc/rc.d/polipo in the start section. This
    will Polipo start after the network has initialised.

See this thread for more information on this topic.

See also
--------

-   Polipo FAQ
-   The Polipo Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=Polipo&oldid=255851"

Category:

-   Proxy servers
