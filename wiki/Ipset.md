Ipset
=====

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Summary help replacing me

Information regarding the setup and configuration of ipset.

> Related

Firewalls

Iptables

ipset is a companion application for the iptables Linux firewall. It
allows you to setup rules to quickly and easily block a set of IP
addresses, among other things.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Blocking a list of addresses
-   3 Other Commands

Installation
------------

Install ipset from the official repositories.

Configuration
-------------

> Blocking a list of addresses

Start by creating a new "set" of network addresses. This creates a new
"hash" set of "net" network addresses named "myset".

    # ipset create myset hash:net

Add any IP address that you'd like to block to the set.

    # ipset add myset 14.144.0.0/12
    # ipset add myset 27.8.0.0/13
    # ipset add myset 58.16.0.0/15

Finally, configure iptables to block any address in that set. This
command will add a rule to the "INPUT" chain to "-m" match the set named
"myset" from ipset (--match-set) when it's a "src" packet and "DROP", or
block, it.

    # iptables -I INPUT -m set --match-set myset src -j DROP

Other Commands
--------------

To view the sets:

    # ipset list

To delete a set named "myset":

    # ipset destroy myset

To delete all sets:

    # ipset destroy

Please see the man page for ipset for further information.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ipset&oldid=301782"

Category:

-   Firewalls

-   This page was last modified on 24 February 2014, at 15:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
