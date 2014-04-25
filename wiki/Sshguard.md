Sshguard
========

Warning:Using an IP blacklist will stop trivial attacks but it relies on
an additional daemon and successful logging (the partition containing
/var can become full, especially if an attacker is pounding on the
server). Additionally, if the attacker knows your IP address, they can
send packets with a spoofed source header and get you locked out of the
server. SSH keys provide an elegant solution to the problem of brute
forcing without these problems.

sshguard is a daemon that protects SSH and other services against
brute-force attacts, similar to fail2ban.

sshguard is different from the other two in that it is written in C, is
lighter and simpler to use with fewer features while performing its core
function equally well.

sshguard is not vulnerable to most (or maybe any) of the log analysis
vulnerabilities that have caused problems for similar tools.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Usage
    -   3.1 With systemd
    -   3.2 With syslog-ng
-   4 General Information
-   5 How to Unban
-   6 See also

Installation
------------

Install sshguard from the official repositories.

Configuration
-------------

The main configuration required is creating a chain named "sshguard" in
the INPUT chain of iptables where sshguard automatically inserts rules
to drop packets coming from bad hosts:

    # iptables -N sshguard
    # iptables -A INPUT -p tcp --dport 22 -j sshguard
    # iptables-save > /etc/iptables/iptables.rules

If you use IPv6:

    # ip6tables -N sshguard
    # ip6tables -A INPUT -p tcp --dport 22 -j sshguard
    # ip6tables-save > /etc/iptables/ip6tables.rules

If you don't use IPv6, create and empty file "ip6tables.rules" with:

    # touch /etc/iptables/ip6tables.rules

Finally:

    # systemctl reload iptables

  
 If you do not currently use iptables and just want to get sshguard up
and running without any further impact on your system, these commands
will create and save an iptables configuration that does absolutely
nothing except allowing sshguard to work:

    # iptables -F
    # iptables -X
    # iptables -P INPUT ACCEPT
    # iptables -P FORWARD ACCEPT
    # iptables -P OUTPUT ACCEPT
    # iptables -N sshguard
    # iptables -A INPUT -j sshguard 
    # iptables-save > /etc/iptables/iptables.rules    

To finish saving your iptables configuration. Repeat above steps with
ip6tables to configure the firewall rules for IPv6 and save them with
ip6tables-save to /etc/iptables/ip6tables.rules.

For more information on using iptables to create powerful firewalls, see
Simple stateful firewall.

Usage
-----

sshguard does not have its own configuration file. All options are
supplied as arguments when sshguard is started. See man sshguard.

> With systemd

Enable and start the service:

    # systemctl enable sshguard
    # systemctl start sshguard 

Add optional sshguard arguments between the quotation marks in the file,
/usr/lib/systemd/system/sshguard.service.

> With syslog-ng

If you have syslog-ng installed, you may start sshguard directly from
the command line instead.

    /usr/sbin/sshguard -l /var/log/auth.log -b /var/db/sshguard/blacklist.db

General Information
-------------------

sshguard works by watching /var/log/auth.log for changes to see if
someone is failing to log in too many times. It can also be configured
to get this information straight from syslog-ng. After too many login
failures (default 4) the offending host is banned from further
communication for a limited amount of time. The amount of time the
offender is banned starts at 7 minutes and doubles each time he is
banned again. By default in the archlinux package, at one point
offenders become permanently banned.

Bans are done by adding an entry into the "sshguard" chain in iptables
that drops all packets from the offender. To make the ban only affect
port 22, simply do not send packets going to other ports through the
"sshguard" chain.

When sshguard bans someone, the ban is logged to syslog and ends up in
/var/log/auth.log.

How to Unban
------------

If you get banned, you can wait to get unbanned automatically or use
iptables to unban yourself. First check if your ip is banned by
sshguard:

    # iptables -L sshguard --line-numbers

Then use the following command to unban, with the line-number as
identified in the former command:

    # iptables -D sshguard <line-number>

See also
--------

-   fail2ban

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sshguard&oldid=302038"

Category:

-   Secure Shell

-   This page was last modified on 25 February 2014, at 13:05.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
