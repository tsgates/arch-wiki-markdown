Uncomplicated Firewall
======================

Uncomplicated Firewall (ufw) is a simple frontend for iptables that is
designed to be easy to use.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Basic Configuration                                                |
| -   3 Adding Other Applications                                          |
| -   4 Deleting Applications                                              |
| -   5 Rate Limiting with ufw                                             |
| -   6 GUI frontends                                                      |
|     -   6.1 Gufw                                                         |
|     -   6.2 kcm-ufw                                                      |
|                                                                          |
| -   7 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

ufw can be installed from the official repositories.

Start ufw as systemd service:

    # systemctl start ufw

Make it available after boot:

    # systemctl enable ufw

Basic Configuration
-------------------

A very simplistic configuration which will deny all by default, allow
any protocol from inside a 192.168.0.1-192.168.0.255 LAN, and allow
incoming Deluge and SSH traffic from anywhere:

    # ufw default deny
    # ufw allow from 192.168.0.0/24
    # ufw allow Deluge
    # ufw allow SSH

The next line is only needed once the first time you install the
package. From there on out, enable ufw through systemctl:

    # ufw enable

Finally, query the rules being applied via the status command:

    # ufw status

    Status: active
    To                         Action      From
    --                         ------      ----
    Anywhere                   ALLOW       192.168.0.0/24
    Deluge                     ALLOW       Anywhere
    SSH                        ALLOW       Anywhere

The status report shows the rules added by the user. For most cases this
will be what is needed, but it is good to be aware that builtin-rules do
exist. These include filters to allow UPNP, AVAHI and DHCP replies. In
order to see all rules setup

    # ufw show raw 

may be used, as well as further reports listed in the manpage. Since
these reports also summarize traffic, they may be somewhat difficult to
read. Another way to check for accepted traffic:

    # iptables -S |grep ACCEPT

While this works just fine for reporting, keep in mind not to enable the
iptables service as long as you use ufw for managing it.

Note:If special network variables are set on the system in
/etc/sysctl.conf, it may be necessary to update /etc/ufw/sysctl.conf
accordingly since this configuration overrides the default settings.

Adding Other Applications
-------------------------

The PKG comes with some defaults based on the default ports of many
common daemons and programs. Inspect the options by looking in the
/etc/ufw/applications.d directory or by listing them in the program
itself:

    # ufw app list

If users are running any of the applications on a non-standard port, it
is recommended to simply make /etc/ufw/applications.d/custom containing
the needed data using the defaults as a guide.

Warning:If users modify any of the PKG provided rule sets, these will be
overwritten the first time the ufw package is updated. This is why
custom app definitions need to reside in a non-PKG file as recommended
above!

Example, deluge with custom tcp ports that range from 20202-20205:

    [Deluge-my]
    title=Deluge
    description=Deluge BitTorrent client
    ports=20202:20205/tcp

Should you require to define both tcp and udp ports for the same
application, simply separate them with a pipe as shown: this app opens
tcp ports 10000-10002 and udp port 10003

    ports=10000:10002/tcp|10003/udp

One can also use a comma to define ports if a range is not desired. This
example opens tcp ports 10000-10002 (inclusive) and udp ports 10003 and
10009

     ports=10000:10002/tcp|10003,10009/udp

Deleting Applications
---------------------

Drawing on the Deluge/Deluge-my example above, the following will remove
the standard Deluge rules and replace them with the Deluge-my rules from
the above example:

    # ufw delete allow Deluge
    # ufw allow Deluge-my

Query the result via the status command:

     # ufw status

    Status: active
    To                         Action      From
    --                         ------      ----
    Anywhere                   ALLOW       192.168.0.0/24
    SSH                        ALLOW       Anywhere
    Deluge-my                  ALLOW       Anywhere

Rate Limiting with ufw
----------------------

ufw has the ability to deny connections from an IP address that has
attempted to initiate 6 or more connections in the last 30 seconds.
Users should consider using this option for services such as sshd.

Using the above basic configuration, to enable rate limiting we would
simply replace the allow parameter with the limit parameter. The new
rule will then replace the previous.

    # ufw limit SSH
    Rule updated

     # ufw status

    Status: active
    To                         Action      From
    --                         ------      ----
    Anywhere                   ALLOW       192.168.0.0/24
    SSH                        LIMIT       Anywhere
    Deluge-my                  ALLOW       Anywhere

GUI frontends
-------------

> Gufw

Gufw is an easy to use Ubuntu / Linux firewall, powered by ufw.

Gufw is an easy, intuitive, way to manage your Linux firewall. It
supports common tasks such as allowing or blocking pre-configured,
common p2p, or individual ports port(s), and many others! Gufw is
powered by ufw, runs on Ubuntu, and anywhere else Python, GTK, and Ufw
are available.

> kcm-ufw

Warning:Since the release of ufw 0.31-1, kcm-ufw no longer works.

kcm-ufw is KDE4 control module for ufw. The following features are
supported:

-   Enable/disable firewall
-   Configure firewall default settings
-   Add, edit, and remove rules
-   Re-order rules via drag\'n\'drop
-   Import/export of rules
-   Setting of some IP tables modules

The module will appear under "Network and Connectivity" category.

See also
--------

-   Ubuntu UFW Documentation
-   UFW manual
-   ArchWiki Firewalls page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Uncomplicated_Firewall&oldid=255762"

Category:

-   Firewalls
