iptables
========

> Summary

Information regarding the setup and configuration of iptables.

> Related

Firewalls

Sysctl#TCP/IP stack hardening

Iptables is a powerful firewall built into the Linux kernel and is part
of the netfilter project. It can be configured directly, or by using one
of the many frontends and GUIs. iptables is used for IPv4 and ip6tables
is used for IPv6.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Basic concepts                                                     |
|     -   2.1 tables                                                       |
|     -   2.2 chains                                                       |
|     -   2.3 targets                                                      |
|     -   2.4 modules                                                      |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 From the command line                                        |
|     -   3.2 Configuration file                                           |
|     -   3.3 Guides                                                       |
|                                                                          |
| -   4 Logging                                                            |
|     -   4.1 Limiting log rate                                            |
|     -   4.2 syslog-ng                                                    |
|     -   4.3 ulogd                                                        |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Note:Your kernel needs to be compiled with iptables support. All stock
Arch Linux kernels have iptables support.

First, install the userland utilities, which are provided by the package
iptables in the official repositories.

Basic concepts
--------------

> tables

iptables contains four tables: raw, filter, nat and mangle.

> chains

Chains are used to specify rulesets. A packet begins at the top of a
chain and progresses downwards until it hits a rule. There are three
built-in chains: INPUT, OUTPUT and FORWARD. All outbound,
locally-generated traffic passes through the OUTPUT chain, all inbound
traffic addressed to the machine itself passes through the INPUT chain,
and all routed traffic which should not be delivered locally passes
through the FORWARD chain. The three built-in chains have default
targets which are used if no rules are hit. User-defined chains can be
added to make rulesets more efficient.

> targets

A "target" is the result that occurs when a packet hits a rule. Targets
are specified using "jump" (-j). The most common targets are ACCEPT,
DROP, REJECT and LOG.

> modules

There are many modules which can be used to extend iptables such as
connlimit, conntrack, limit and recent. These modules add extra
functionality to allow complex filtering rules.

Configuration
-------------

> From the command line

You can check the current ruleset and the number of hits per rule by
using the command:

    # iptables -nvL

    Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
     pkts bytes target     prot opt in     out     source               destination   
         
    Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
     pkts bytes target     prot opt in     out     source               destination    
        
    Chain OUTPUT (policy ACCEPT 0K packets, 0 bytes)
     pkts bytes target     prot opt in     out     source               destination

If the output looks like the above, then there are no rules. Nothing is
blocked.

You can flush and reset iptables to default using these commands:

    # iptables -P INPUT ACCEPT
    # iptables -P FORWARD ACCEPT
    # iptables -P OUTPUT ACCEPT
    # iptables -F
    # iptables -X

> Configuration file

The configuration file at /etc/conf.d/iptables points to the location of
the ruleset file. The ruleset is loaded when the daemon is started.

    /etc/conf.d/iptables

    # Configuration for iptables rules
    IPTABLES_CONF=/etc/iptables/iptables.rules
    IP6TABLES_CONF=/etc/iptables/ip6tables.rules

    # Enable IP forwarding (both IPv4 and IPv6)
    # NOTE: this is not the recommended way to do this, and is supported only for
    # backward compatibility. Instead, use /etc/sysctl.conf and set the following
    # options:
    # * net.ipv4.ip_forward=1
    # * net.ipv6.conf.default.forwarding=1
    # * net.ipv6.conf.all.forwarding=1
    #IPTABLES_FORWARD=0

After adding rules via command-line:

    # iptables-save > /etc/iptables/iptables.rules

Finally:

    # systemctl reload iptables

> Guides

-   Simple stateful firewall
-   Router

Logging
-------

The LOG target can be used to log packets that hit a rule. Unlike other
targets like ACCEPT or DROP, the packet will continue moving through the
chain after hitting a LOG target. This means that in order to enable
logging for all dropped packets, you would have to add a duplicate LOG
rule before each DROP rule. Since this reduces efficiency and makes
things less simple, a LOGDROP chain can be created instead.

    ## /etc/iptables/iptables.rules

    *filter
    :INPUT DROP [0:0]
    :FORWARD DROP [0:0]
    :OUTPUT ACCEPT [0:0]

    ... other user defined chains ..

    ## LOGDROP chain
    :LOGDROP - [0:0]

    -A LOGDROP -m limit --limit 5/m --limit-burst 10 -j LOG
    -A LOGDROP -j DROP

    ... rules ...

    ## log AND drop packets that hit this rule:
    -A INPUT -m state --state INVALID -j LOGDROP

    ... more rules ...

> Limiting log rate

The limit module should be used to prevent your iptables log from
growing too large or causing needless hard drive writes. Without
limiting, an attacker could fill your drive (or at least your /var
partition) by causing writes to the iptables log.

-m limit is used to call on the limit module. You can then use --limit
to set an average rate and --limit-burst to set an initial burst rate.
Example:

    -A LOGDROP -m limit --limit 5/m --limit-burst 10 -j LOG

This appends a rule to the LOGDROP chain which will log all packets that
pass through it. The first 10 packets will the be logged, and from then
on only 5 packets per minute will be logged. The "limit burst" is
restored by one every time the "limit rate" is not broken.

> syslog-ng

Assuming you are using syslog-ng, you can control where iptables' log
output goes this way:

    filter f_everything { level(debug..emerg) and not facility(auth, authpriv); };

to

    filter f_everything { level(debug..emerg) and not facility(auth, authpriv) and not filter(f_iptables); };

This will stop logging iptables output to /var/log/everything.log.

If you also want iptables to log to a different file than
/var/log/iptables.log, you can simply change the file value of
destination d_iptables here (still in syslog-ng.conf)

    destination d_iptables { file("/var/log/iptables.log"); };

> ulogd

ulogd is a specialized userspace packet logging daemon for netfilter
that can replace the default LOG target. The package ulogd is available
in the [community] reopository.

See also
--------

See the Wikipedia article on this subject for more information: iptables

-   Official iptables web site
-   iptables Tutorial 1.2.2 by Oskar Andreasson
-   iptables Debian Debian wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Iptables&oldid=255802"

Category:

-   Firewalls
