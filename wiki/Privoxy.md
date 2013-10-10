Privoxy
=======

> Summary

This article explains how to install and configure Privoxy alongside the
Tor network.

Required software

Tor

Privoxy

> Related

Tor

Polipo

Privoxy is a filtering proxy for the HTTP protocol, frequently used in
combination with Tor. Privoxy is a web proxy with advanced filtering
capabilities for protecting privacy, filtering web page content,
managing cookies, controlling access, and removing ads, banners,
pop-ups, etc. It supports both stand-alone systems and multi-user
networks.

Using Privoxy is necessary when they use a SOCKS proxy directly because
browsers leak your DNS requests, which reduces your anonymity.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation and setup                                             |
| -   2 Ad Blocking with Privoxy                                           |
| -   3 Usage                                                              |
| -   4 Troubleshooting                                                    |
| -   5 External Links                                                     |
+--------------------------------------------------------------------------+

Installation and setup
----------------------

As root install the privoxy package from [community].

    # pacman -S privoxy

When Privoxy is used in conjunction with Tor the two applications need
to exchange information through a chain, which requires the
specification of forwarding rules.

Warning:If you do not want to use Tor or another proxy there is no need
to edit /etc/privoxy/config. In fact, chaining to an invalid target will
prevent your browser from opening any website.

Edit your /etc/privoxy/config file and add this line at the end (be sure
to include the . at the end and preserve the file owner and group
permissions as privoxy):

    forward-socks5 / localhost:9050 .

This example uses the default port used by Tor. If you changed the port
number modify the example accordingly. The same basic example is valid
for other targets. If you plan on chaining to another proxy specify the
method (here SOCKS5) and the port to suit your needs. Refer to section 5
of the manual inside /etc/privoxy/config for a complete list of options
and examples.

Additionally, make sure your /etc/hosts file is correctly set up by
comparing the hostname listed in /etc/hosts with /etc/rc.conf, which the
hostname is set. For further information see: Set the hostname.

The above will forward all browser traffic through Tor. To only forward
.onion sites through Tor, use this instead:

    forward-socks4a .onion localhost:9050 .

To forward .i2p sites through the I2P router, add the following to
/etc/privoxy/config:

    forward .i2p localhost:4444

Finally, if you plan to make Privoxy available to other computers in
your network, just add:

    listen-address [SERVER-IP]:[PORT]

For example:

    listen-address 192.168.1.1:8118

Ad Blocking with Privoxy
------------------------

Using an ad blocking extension in a web browser can increase page load
time. Additionally, extensions like AdBlock Plus are not supported by
all browsers. A useful alternative is to install system-wide ad blocking
by setting a proxy address in your preferred browser.

Once Privoxy has been installed download and install an AdBlock Plus
easylist importer from AUR (i.e. privoxy-blocklist). You can optionally
use an AUR Helper to do so.

To block tracking via embedded Facebook "Like" button, Twitter "follow",
and Google Plus "+1", edit /etc/privoxy/user.action and add these lines
to the end:

    {+block-as-image{Facebook "like" and similar tracking URLs.}}
    www.facebook.com/(extern|plugins)/(login_status|like(box)?|activity|fan)\.php
    platform.twitter.com/widgets/follow_button?
    plusone.google.com

Usage
-----

Start the Privoxy service:

    # rc.d start privoxy

Add privoxy to your DAEMONS array in /etc/rc.conf

    DAEMONS=(... privoxy ...)

Configure your program to use Privoxy. The default address is:

    localhost:8118

For Firefox, go to:

    Preferences > Advanced > Network > Settings

For Chromium you can use:

    $ chromium --proxy-server="localhost:8118"

Troubleshooting
---------------

If errors appear when accessing /var/log/privoxy/, user can add the
following after /bin/bash in /etc/rc.d/privoxy and then restart privoxy.

    if [ ! -d /var/log/privoxy ] then
       mkdir /var/log/privoxy
       touch /var/log/privoxy/errorfile
       touch /var/log/privoxy/logfile
       chown -R privoxy:adm /var/log/privoxy
    fi

External Links
--------------

-   Official Website
-   Blocking ads with Privoxy by Mike Stegeman

Retrieved from
"https://wiki.archlinux.org/index.php?title=Privoxy&oldid=243795"

Category:

-   Proxy servers
