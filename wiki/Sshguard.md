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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 In Arch Linux                                                |
|                                                                          |
| -   3 General Information                                                |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install sshguard from the official repositories.

Configuration
-------------

The main configuration required is creating a chain named "sshguard" in
the INPUT chain of iptables where sshguard automatically inserts rules
to drop packets coming from bad hosts:

    # iptables -N sshguard
    # iptables -A INPUT -j sshguard
    # /etc/rc.d/iptables save

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
ip6tabes-save to /etc/iptables/ip6tables.rules.

For more information on using iptables to create powerful firewalls, see
Simple Stateful Firewall.

Then, enable the service:

    # systemctl enable sshguard

> In Arch Linux

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: systemd          
                           sshguard.service relies  
                           on logging to systemd    
                           journal and ignores      
                           /var/log/auth.log        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

By default, sshguard does not have its own configuration file: all
options are supplied on the command line. However, Arch Linux uses the
/etc/conf.d/sshguard configuration file, allowing additional arguments
to be passed to the command line when sshguard is started. By default
sshguard will use its built-in log reader, called Log Sucker, to read
the logs:

    /usr/sbin/sshguard -l /var/log/auth.log -b /var/db/sshguard/blacklist.db

The -l switch tells sshguard which log to watch. Note also the -b option
is used, which makes some bans permanent. Records of permanent bans are
then kept in /var/db/sshguard/blacklist.db to be remembered between
restarts.

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

See also
--------

-   fail2ban

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sshguard&oldid=248371"

Category:

-   Secure Shell
