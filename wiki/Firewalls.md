Firewalls
=========

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: convert to       
                           Template:App (Discuss)   
  ------------------------ ------------------------ ------------------------

A firewall is a system designed to prevent unauthorized access to or
from a private network (which could be just one machine). Firewalls can
be implemented in only hardware or software, or a combination of both.
Firewalls are frequently used to prevent unauthorized Internet users
from accessing private networks connected to the Internet, especially
intranets. All messages entering or leaving the intranet pass through
the firewall, which examines each message and allows, proxys, or denies
the traffic based on specified security criteria.

The firewalls listed in this article are overwhelmingly based on the
iptables program. Consider configuring the iptables process yourself
according to its wiki page (listed below) to keep to the The Arch Way.

There are many posts on the forums about different firewall apps and
scripts so here they all are condensed into one page - please add your
comments about each firewall, especially ease of use and a security
check at Shields Up.

Note:Checks at Shields Up are only a valid measure of your router should
you have one in the LAN. To accurately evaluate a software firewall, one
needs to directly connect the box to the cable modem.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Firewall Guides & Tutorials                                        |
|     -   1.1 External Firewall Tutorials                                  |
|                                                                          |
| -   2 iptables front-ends                                                |
|     -   2.1 iptables                                                     |
|     -   2.2 Arno's Firewall                                              |
|     -   2.3 ferm                                                         |
|     -   2.4 Firehol                                                      |
|     -   2.5 Firetable                                                    |
|     -   2.6 Shorewall                                                    |
|     -   2.7 ufw                                                          |
|     -   2.8 Vuurmuur                                                     |
|                                                                          |
| -   3 iptables GUIs                                                      |
|     -   3.1 Firestarter                                                  |
|     -   3.2 Guarddog                                                     |
|     -   3.3 Uncomplicated Firewall (ufw) Frontends                       |
|     -   3.4 KMyFirewall                                                  |
|     -   3.5 firewalld                                                    |
|                                                                          |
| -   4 Firewall Builder                                                   |
| -   5 Other                                                              |
| -   6 See Also                                                           |
+--------------------------------------------------------------------------+

Firewall Guides & Tutorials
---------------------------

-   Simple Stateful Firewall: Setting up a comprehensive firewall with
    iptables.

-   Uncomplicated Firewall, the wiki page for the simple iptables
    frontend, ufw, provides a nice tutorial for a basic configuration.

-   Router Setup Guide. A tutorial for turning a computer into an
    internet gateway/router. It focuses on security and configuring your
    gateway to have as few insecure holes to the internet as possible.

External Firewall Tutorials

-   http://www.frozentux.net/documents/iptables-tutorial/ A complete and
    simple tutorial to iptables

-   http://tldp.org/HOWTO/Masquerading-Simple-HOWTO/IP Masq is a form of
    Network Address Translation or NAT that allows internally networked
    computers that do not have one or more registered Internet IP
    addresses to have the ability to communicate to the Internet via
    your Linux boxes single Internet IP address.

-   http://tldp.org/HOWTO/Masquerading-Simple-HOWTO/ Masquerading,
    transparent proxying, port forwarding, and other forms of Network
    Address Translations with the 2.4 Linux Kernels.

iptables front-ends
-------------------

> iptables

-   Iptables — A powerful firewall built into the Linux kernel that is
    part of the Netfilter project. Most firewalls, as described in this
    section below, are usually just front-ends.

http://www.netfilter.org/projects/iptables/index.html || iptables

Also see the man pages: (man iptables) –
http://unixhelp.ed.ac.uk/CGI/man-cgi?iptables+8

> Arno's Firewall

Arno's IPTABLES Firewall Script is a secure firewall for both single and
multi-homed machines.

The script:

-   EASY to configure and highly customizable
-   daemon script included
-   a filter script that makes your firewall log more readable

Supports:

-   NAT and SNAT
-   port forwarding
-   ADSL ethernet modems with both static and dynamically assigned IPs
-   MAC address filtering
-   stealth port scan detection
-   DMZ and DMZ-2-LAN forwarding
-   protection against SYN/ICMP flooding
-   extensive user definable logging with rate limiting to prevent log
    flooding
-   all IP protocols and VPNs such as IPsec
-   plugin support to add extra features.

> ferm

ferm (which stands for "For Easy Rule Making") is a tool to maintain
complex firewalls, without having the trouble to rewrite the complex
rules over and over again. ferm allows the entire firewall rule set to
be stored in a separate file, and to be loaded with one command. The
firewall configuration resembles structured programming-like language,
which can contain levels and lists.

> Firehol

FireHOL is a language to express firewalling rules, not just a script
that produces some kind of a firewall. It makes building even
sophisticated firewalls easy - the way you want it. The result is
actually iptables rules.

firehol is available in the official repositories.

> Firetable

Firetable is an iptables-based firewall with "human readable" syntax.

firetable is available in the AUR.

> Shorewall

The Shoreline Firewall, more commonly known as "Shorewall", is
high-level tool for configuring Netfilter. You describe your
firewall/gateway requirements using entries in a set of configuration
files. See Shorewall page for how to install and configure it.

> ufw

ufw (uncomplicated firewall) is a simple front-end for iptables and is
available in the official repositories.

See Uncomplicated Firewall for more information.

> Vuurmuur

Vuurmuur Vuurmuur is a powerful firewall manager built on top of
iptables. It has a simple and easy to learn configuration that allows
both simple and complex configurations. The configuration can be fully
configured through an ncurses GUI, which allows secure remote
administration through SSH or on the console. Vuurmuur supports traffic
shaping, has powerful monitoring features, which allow the administrator
to look at the logs, connections and bandwidth usage in realtime.

Vuurmuur is available in the AUR.

iptables GUIs
-------------

> Firestarter

Firestarter is a good GUI for iptables writen on GTK2, it has the
ability to use both white and black lists for regulating traffic, it is
very simple and easy to use, with good documentation available on their
website.

Firestarter has GNOME dependencies and is available in the AUR.

> Guarddog

Guarddog is a really easy to use GUI for configuring iptables. After
setting up a basic desktop configuration it passes all Shields Up tests
perfectly.

Guarddog requires kdelibs3 and is available in the AUR repository.

To have the firewall settings applied at boot-up you must run
/etc/rc.firewall from inside /etc/rc.local or something similar.

> Uncomplicated Firewall (ufw) Frontends

Gufw, a GTK-based front-end to ufw which happens to be a CLI front-end
to iptables (gufw->ufw->iptables), is super easy and super simple to
use.

Note:Gufw is perhaps the simplest replacement for tcp_wrappers, which
was discontinued recently

kcm-ufw is a KDE alternative to Gufw.

See Uncomplicated Firewall for more info.

> KMyFirewall

KMyFirewall is KDE3 GUI for iptables.

Firewall editing capabilities are simple enough to use to be suitable
for beginners, but also allow for sophisticated tweaking of the firewall
settings.

KMyFirewall requires kdelibs3 and is available in the AUR.

> firewalld

firewalld provides a daemon and graphical interface for configuring
network and firewall zones as well as setting up and configuring
firewall rules.

firewalld is available in the official repositories.

Firewall Builder
----------------

Firewall Builder is "a GUI firewall configuration and management tool
that supports iptables (netfilter), ipfilter, pf, ipfw, Cisco PIX (FWSM,
ASA) and Cisco routers extended access lists. [...] The program runs on
Linux, FreeBSD, OpenBSD, Windows and Mac OS X and can manage both local
and remote firewalls." Source: http://www.fwbuilder.org/

fwbuilder is available in the official repositories.

Other
-----

-   EtherApe — A graphical network monitor for various OSI layers and
    protocols.

http://etherape.sourceforge.net/ || etherape

-   Fail2ban — Bans IPs after too many failed authentification attempts
    against common daemons.

http://www.fail2ban.org/ || fail2ban

See Also
--------

Debian Wiki's list of Firewalls: http://wiki.debian.org/Firewalls

Retrieved from
"https://wiki.archlinux.org/index.php?title=Firewalls&oldid=255759"

Category:

-   Firewalls
