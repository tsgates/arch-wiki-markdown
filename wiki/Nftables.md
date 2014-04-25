nftables
========

Related articles

-   Firewalls
-   iptables

nftables is a netfilter project that aims to replace the existing ip-,
ip6-, arp-, and ebtables framework. It provides a new packet filtering
framework, a new user-space utility (nft), and a compatibility layer for
ip- and ip6tables. It uses the existing hooks, connection tracking
system, user-space queueing component, and logging subsystem of
netfilter.

The first release is available in Linux 3.13, which is in the core
repository (linux), and nftables (the user-space components) is
available in the community repository (nftables), and on the AUR in
package nftables-git.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: nftables is an   
                           entirely new utility,    
                           and lacks sufficient     
                           documentation on this    
                           wiki, as well as         
                           elsewhere. (Discuss)     
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Overview
-   2 nft
-   3 Tables
    -   3.1 Listing
    -   3.2 Creation
    -   3.3 Deletion
-   4 Chains
    -   4.1 Listing
    -   4.2 Creation
        -   4.2.1 Properties
            -   4.2.1.1 Types
            -   4.2.1.2 Hooks
            -   4.2.1.3 Priorities
    -   4.3 Deletion
-   5 Rules
    -   5.1 Listing
    -   5.2 Creation
        -   5.2.1 Matches
        -   5.2.2 Jumps
    -   5.3 Insertion
    -   5.4 Deletion
-   6 File Definitions
-   7 Getting Started
-   8 Samples
    -   8.1 Simple IP/IPv6 Firewall
    -   8.2 Limit rate and tcp flags IP/IPv6 Firewall
    -   8.3 Priority-based Atomic Fix
    -   8.4 Rules Script with Atomic Fix
-   9 Systemd
-   10 See also

Overview
--------

nftables consists of three main components: a kernel implementation, the
libnl netlink communication and the nftables user-space front-end. The
kernel provides a netlink configuration interface, as well as run-time
rule-set evaluation using a small classification language interpreter.
libnl contains the low-level functions for communicating with the
kernel; the nftables front-end is what the user interacts with.

nft
---

nftables' user-space utility nft now performs most of the rule-set
evaluation before handing rule-sets to the kernel. Because of this,
nftables provides no default tables or chains; although, a user can
emulate an iptables-like setup.

It works in a fashion similar to ifconfig or iproute2. The commands are
a long, structured sequence rather than using argument switches like in
iptables. For example:

    nft add rule ip6 filter input ip saddr ::1 accept

add is the command. rule is a subcommand of add. ip6 is an argument of
rule, telling it to use the ip6 family. filter and input are arguments
of rule specifying the table and chain to use, respectively. The rest
that follows is a rule definition, which includes matches (ip), their
parameters (saddr), parameter arguments (::1), and jumps (accept).

The following is an incomplete list of the commands available in nft:

    list
      tables [family]
      table [family] <name>
      chain [family] <table> <name>

    add
      table [family] <name>
      chain [family] <table> <name> [chain definitions]
      rule [family] <table> <chain> <rule definition>

    table [family] <name> (shortcut for `add table`)

    insert
      rule [family] <table> <chain> <rule definition>

    delete
      table [family] <name>
      chain [family] <table> <name>
      rule [family] <table> <handle>

    flush
      table [family] <name>
      chain [family] <table> <name>

family is optional, but it will default to ip.

Tables
------

The purpose of tables is to hold chains. Unlike tables in iptables,
there are no built-in tables in nftables. Tables can have one of four
families specified, which unifies the various iptables utilities into
one:

-   ip (iptables)
-   ip6 (ip6tables)
-   arp (arptables)
-   bridge (ebtables)

ip is the default family. A fifth family is scheduled for Linux 3.15
that allows for the unification of the ip and ip6 families to make
defining rules for both easier.

> Listing

You can list the current tables in a family with the nft list command.

    # nft list tables
    # nft list tables ip6

You can list a full table definition by specifying a table name:

    # nft list table foo
    # nft list table ip6 foo

> Creation

Tables can be added via two commands — one just being a shortcut for the
other. Here is an example of how to add an ip table called foo and an
ip6 table called foo:

    # nft add table foo
    # nft table ip6 foo

You can have two tables with the same name as long as they are in
different families.

> Deletion

Tables can only be deleted if there are no chains in them.

    # nft delete table foo
    # nft delete table ip6 foo

Chains
------

The purpose of chains is to hold rules. Unlike chains in iptables, there
are no built-in chains in nftables. This means that if no chain uses any
types or hooks in the netfilter framework, packets that would flow
through those chains will not be touched by nftables, unlike iptables.

> Listing

You can list the current chains in a chain with the nft list command,
using the same method as listing a table. You can also list rules from
an individual chain.

    # nft list chain foo bar
    # nft list chain ip6 foo bar

These commands will list the bar chains in the ip and ip6 foo tables.

> Creation

Chains can be added when a table is created in a file definition or one
at time via the nfc add chain command.

    # nft add chain foo bar
    # nft add chain ip6 foo bar

These commands will add a chain called bar to the ip and ip6 foo tables.

Properties

Because nftables has no built-in chains, it allows chains to access
certain features of the netfilter framework.

    # nft add chain filter input { type filter hook input priority 0; }

This command tells nftables to add a chain called input to the filter
table and defines its type, hook, and priority. These properties
essentially replace the built-in tables and chains in iptables.

Types

There are three types a chain can have and they correspond to the tables
used in iptables:

-   filter
-   nat
-   route (mangle)

Hooks

There are five hooks a chain can use and they correspond to the chains
used in iptables:

-   input
-   output
-   forward
-   prerouting
-   postrouting

Priorities

Note:Priorities do not currently appear to have any effect on which
chain sees packets first.

Note:Since the priority seems to be an unsigned integer, negative
priorities will be converted into very high priorities.

Priorities tell nftables which chains packets should pass through first.
They are integers, and the higher the integer, the higher the priority.

> Deletion

Chains can only be deleted if there are no rules in them.

    # nft delete chain foo bar
    # nft delete chain ip6 foo bar

These commands delete the bar chains from the ip and ip6 foo tables.

Rules
-----

The purpose of rules is to identify packets (match) and carry out tasks
(jump). Like in iptables, there are various matches and jumps available,
though not all of them are feature-complete in nftables.

> Listing

You can list the current rules in a table with the nft list command,
using the same method as listing a table. You can also list rules from
an individual chain.

    # nft list chain foo bar
    # nft list chain ip6 foo bar

These commands will list the rules in the bar chains in the ip and ip6
foo tables.

> Creation

Rules can be added when a table is created in a file definition or one
at time via the nfc add rule command.

    # nft add rule foo bar ip saddr 127.0.0.1 accept
    # nft add rule ip6 foo bar ip saddr ::1 accept

These commands will add a rule to the bar chains in the ip and ip6 foo
tables that matches an ip packet when its saddr (source address) is
127.0.0.1 (IPv4) or ::1 (IPv6) and accepts those packets.

Matches

There are various matches available in nftables and, for the most part,
coincide with their iptables counterparts. The most noticeable
difference is that there are no generic or implicit matches anymore. A
generic match was one that was always available, such as --protocol or
--source. Implicit matches were protocol-specific, such as --sport when
a packet was determined to be TCP.

The following is an incomplete list of the matches available:

-   meta (meta properties, e.g. interfaces)
-   icmp (ICMP protocol)
-   icmpv6 (ICMPv6 protocol)
-   ip (IP protocol)
-   ip6 (IPv6 protocol)
-   tcp (TCP protocol)
-   udp (UDP protocol)
-   sctp (SCTP protocol)
-   ct (connection tracking)

The following is an incomplete list of match arguments:

    meta:
      oif <output interface INDEX>
      iif <input interface INDEX>
      oifname <output interface NAME>
      iifname <input interface NAME>

      (oif and iif accept string arguments and are converted to interface indexes)
      (oifname and iifname are more dynamic, but slower because of string matching)

    icmp:
      type <icmp type>

    icmpv6:
      type <icmpv6 type>

    ip:
      protocol <protocol>
      daddr <destination address>
      saddr <source address>

    ip6:
      daddr <destination address>
      saddr <source address>

    tcp:
      dport <destination port>
      sport <source port>

    udp:
      dport <destination port>
      sport <source port>

    sctp:
      dport <destination port>
      sport <source port>

    ct:
      state <new | established | related | invalid>

Jumps

Jumps work the same as they do in iptables, except multiple jumps can
now be used in one rule.

    # nft add rule filter input tcp dport 22 log accept

The following is an incomplete list of jumps:

-   accept (accept a packet)
-   reject (reject a packet)
-   drop (drop a packet)
-   snat (perform source NAT on a packet)
-   dnat (perform destination NAT on a packet)
-   log (log a packet)
-   counter (keep a counter on a packet; counters are optional in
    nftables)
-   return (stop traversing the chain)

> Insertion

Rules can be prepended to chains with the nft insert rule command.

    # nft insert rule filter input ct state established,related accept

> Deletion

Individual rules can only be deleted by their handles. The
nft --handle list command must be used to determine rule handles. Note
the --handle switch, which tells nft to list handles in its output.

The following determines the handle for a rule and then deletes it. The
--number argument is useful for viewing some numeric output, like
unresolved IP addresses.

    # nft --handle --numeric list chain filter input

    table ip filter {
         chain input {
              type filter hook input priority 0;
              ip saddr 127.0.0.1 accept # handle 10
         }
    }

    # nft delete rule filter input handle 10

All the chains in a table can be flushed with the nft flush table
command. Individual chains can be flushed using either the
nft flush chain or nft delete rule commands.

    # nft flush table foo
    # nft flush chain foo bar
    # nft delete rule ip6 foo bar

The first command flushes all of the chains in the ip foo table. The
second flushes the bar chain in the ip foo table. The third deletes all
of the rules in bar chain in the ip6 foo table.

File Definitions
----------------

Warning:The nft -f command, despite what the netfilter wiki says, is NOT
atomic. This means you will have a small window between deleting the old
tables and when the new ruleset is loaded where all packets will be
accepted.

Note:You must delete all conflicting tables before using the nft -f
command.

File definitions can be used by the nft -f command, which acts like the
iptables-restore command.

    /etc/nftables/filter.rules

    table ip filter {
         chain input {
              type filter hook input priority 0;
              ct state established,related accept
              ip saddr 127.0.0.1 accept
              tcp dport 22 log accept
              reject
         }
    }

Getting Started
---------------

To get an iptables-like chain set up, you will first need to use the
provided IPv4 filter file:

    # nft -f /etc/nftables/ipv4-filter

To list the resulting chain:

    # nft list table filter

Drop output to a destination:

    # nft add rule ip filter output ip daddr 1.2.3.4 drop

Drop packets destined for local port 80:

    # nft add rule ip filter input tcp dport 80 drop

Delete all rules in a chain:

    # nft delete rule filter output

Samples
-------

> Simple IP/IPv6 Firewall

    firewall.rules

    # A simple firewall

    table firewall {
      chain incoming {
        type filter hook input priority 0;

        # established/related connections
        ct state {established, related} accept

        # invalid connections
        ct state invalid drop

        # loopback interface
        iifname lo accept

        # icmp
        ip protocol icmp accept

        # open tcp ports: sshd (22), httpd (80)
        tcp dport {ssh, http} accept

        # everything else
        reject
      }
    }

    table ip6 firewall {
      chain incoming {
        type filter hook input priority 0;

        # established/related connections
        ct state {established, related} accept

        # invalid connections
        ct state invalid drop

        # loopback interface
        iifname lo accept

        # icmp
        ip6 nexthdr icmpv6 accept

        # open tcp ports: sshd (22), httpd (80)
        tcp dport {ssh, http} accept

        # everything else
        reject
      }
    }

> Limit rate and tcp flags IP/IPv6 Firewall

    firewall.2.rules

    table firewall {
        chain incoming {
            type filter hook input priority 0;

            # bad tcp -> avoid network scanning:
            tcp flags & (fin|syn) == (fin|syn)			drop
            tcp flags & (syn|rst) == (syn|rst)			drop
            tcp flags & (fin|syn|rst|psh|ack|urg) < (fin)		drop # == 0 would be better, not supported yet.
            tcp flags & (fin|syn|rst|psh|ack|urg) == (fin|psh|urg)	drop

            # no ping floods:
            ip protocol icmp limit rate 10/second accept
            ip protocol icmp drop

            ct state {established, related} accept
            ct state invalid drop

            iifname lo accept

    	# avoid brute force on ssh:
            tcp dport {ssh} limit rate 15/minute accept

            reject
        }
    }

    table ip6 firewall {
        chain incoming {
            type filter hook input priority 0;

            # bad tcp:
            tcp flags & (fin|syn) == (fin|syn)			drop
            tcp flags & (syn|rst) == (syn|rst)			drop
            tcp flags & (fin|syn|rst|psh|ack|urg) < (fin)		drop # == 0 would be better, not supported yet.
            tcp flags & (fin|syn|rst|psh|ack|urg) == (fin|psh|urg)	drop

            # no ping floods:
            ip6 nexthdr icmpv6 limit rate 10/second accept
            ip6 nexthdr icmpv6 drop

            ct state {established, related} accept
            ct state invalid drop

            # loopback interface
            iifname lo accept

    	# avoid brute force on ssh:
            tcp dport {ssh} limit rate 15/minute accept

            reject
        }
    }

> Priority-based Atomic Fix

If priorities ever actually take effect, this may be a workaround for
nft -f's lack of true atomicness (being able to replace all the current
rules with new ones in one go):

    atomic.rules

    table atomic {
      chain incoming {
        type filter hook input priority 0;
        ct state new reject
      }
    }

    table ip6 atomic {
      chain incoming {
        type filter hook input priority 0;
        ct state new reject
      }
    }

Set the priority of other chains that hook input to higher than 0. This
should block new connections while no other input chains are loaded.

> Rules Script with Atomic Fix

Because using nft -f to reload rulesets is time consuming, it's far
easier to script it. This will include an atomic fix not based on
priorities. It uses the two rules files from above.

    firewall.sh

    #!/bin/sh

    # Load atomic rules first
    nft -f atomic.rules

    # New incoming traffic should now be stopped

    # Get rid of both the ip and ip6 firewall tables

    nft flush table firewall 2>/dev/null
    nft delete chain firewall incoming 2>/dev/null
    nft delete table firewall 2>/dev/null

    nft flush table ip6 firewall 2>/dev/null
    nft delete chain ip6 firewall incoming 2>/dev/null
    nft delete table ip6 firewall 2>/dev/null

    # Reload the firewall rules
    nft -f firewall.rules

    # Get rid of both the ip and ip6 atomic tables

    nft flush table atomic 2>/dev/null
    nft delete chain atomic incoming 2>/dev/null
    nft delete table atomic 2>/dev/null

    # New incoming IP traffic should be working

    nft flush table ip6 atomic 2>/dev/null
    nft delete chain ip6 atomic incoming 2>/dev/null
    nft delete table ip6 atomic 2>/dev/null

    # New incoming IPv6 traffic should be working

This should take anywhere from 100ms to 400ms, which is clearly
unacceptable, but the only apparent solution.

Systemd
-------

To automatically load rules on system boot, nftables-systemd-git from
AUR can be used. Further install instruction can be found on the
corresponding github page

See also
--------

-   netfilter nftables wiki
-   First release of nftables
-   nftables quick howto
-   The return of nftables

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nftables&oldid=303708"

Category:

-   Firewalls

-   This page was last modified on 9 March 2014, at 05:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
