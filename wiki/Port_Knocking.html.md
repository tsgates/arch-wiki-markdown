Port Knocking
=============

Port knocking is a stealth method to externally open ports that, by
default, the firewall keeps closed. It works by requiring connection
attempts to a series of predefined closed ports. When the correct
sequence of port "knocks" (connection attempts) is received, the
firewall opens certain port(s) to allow a connection.

The benefit is that, for a regular port scan, it may appear as the
service of the port is just not available. This article shows how to use
port knocking with either a daemon or with iptables only.

Contents
--------

-   1 Introduction
-   2 Port Knocking with a daemon helper
-   3 Port Knocking with iptables only
-   4 Port knocking script
-   5 See also

Introduction
------------

iptables is a pre-requisite to install and configure before the content
of this article. Read iptables for more details about iptables.

The module recent in iptables is used to dynamically create list of IP
addresses based on their (successful or unsuccessful) port connections.
Using recent the firewall can find out if a certain IP address has
knocked the correct ports, and if that is the case, open certain
port(s).

A session with port knocking may look like this:

    $ ssh username@hostname # No response (Ctrl+c to exit)
    ^C
    $ nmap -Pn --host_timeout 201 --max-retries 0  -p 1111 host #knocking port 1111
    $ nmap -Pn --host_timeout 201 --max-retries 0  -p 2222 host #knocking port 2222
    $ ssh user@host # Now logins are allowed
    user@host's password:

Warning:Port knocking should be used as part of a security strategy, not
as the only protection. That would be a fragile security through
obscurity. In case of SSH protection, see SSH Keys for a strong method
that can be used along with port knocking. Further, do not use the port
sequence used in this example for live configurations permanently.

Note:There are additions to iptables in current development that have
commands for port knocking in a single rule. They also offer many other
advanced options, but are not in the standard kernel yet (August 2013).
If interested: xtables-addons

It is wise to randomly select the ports that you use for the knock
sequence. random.org can help you generate a selection of ports between
1 and 65535. To check that you have not inadvertantly selected commonly
used ports, use this port database, and/or your /etc/services file.

Port Knocking with a daemon helper
----------------------------------

A specialised daemon can be used to handle port knocking. Besides easing
the setup of rules these helper programs may also offer advanced
features.

knockd is such a port knocking daemon that can provide an added layer of
security to your network. The knockd wiki provides three example port
knocking configurations. These configs can be easily altered to
integrate properly with an iptables firewall. If you followed Simple
stateful firewall, you should substitute the INPUT chain specification,
with the custom open chain used in the firewall.

For example:

    [options]
            logfile = /var/log/knockd.log
    [opencloseSSH]
            sequence      = 8881:tcp,7777:tcp,9991:tcp
            seq_timeout   = 15
            tcpflags      = syn,ack
            start_command = /usr/bin/iptables -A TCP -s %IP% -p tcp --dport 22 -j ACCEPT
            cmd_timeout   = 10
            stop_command  = /usr/bin/iptables -D TCP -s %IP% -p tcp --dport 22 -j ACCEPT

Port Knocking with iptables only
--------------------------------

In the following we construct an /etc/iptables/iptables.rules file to
handle port knocking for SSH. The rules are setup to open the standard
SSH port 22 after a series of single knocks to the ports 8881, 7777 and
9991 in that order.

First we define the default filter policies and chains for this sample
script. The OUTPUT ACCEPT is necessary in this example, because
otherwise the SSH port could be opened, but traffic would be dropped -
which defeats the purpose. The last three chains we require for the port
knocking in the following rules.

    # Filter definition

    *filter
    :INPUT DROP [0:0]
    :FORWARD DROP [0:0]
    :OUTPUT ACCEPT [0:0]
    :TRAFFIC - [0:0]
    :SSH-INPUT - [0:0]
    :SSH-INPUTTWO - [0:0]

Now we add the rules for the main chain, TRAFFIC. The concept of port
knocking is based on sending singular connect requests to the right
ports in a sequence. We need ICMP for some network traffic control and
to allow an established connection, e.g. to SSH.

    # INPUT definition

    -A INPUT -j TRAFFIC
    -A TRAFFIC -m state --state ESTABLISHED,RELATED -j ACCEPT
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 22 -m recent --rcheck --seconds 30 --name SSH2 -j ACCEPT

The last of the above rules is the one to open the port 22 for 30
seconds, if the connecting IP is on the list SSH2. It can be on top of
the chain, because it will only apply if this condition is met. It also
introduces the first of the lists of connection attempts, which are used
to track the port knocking sequence in the following. In this example,
the port will be closed again after 30 seconds, but nothing else is
triggered. So, a new port knocking attempt could be done from the same
source IP.

If the last rule did not accept the traffic (e.g. no connection attempt
in 30 seconds) but the connecting IP is on the correct list to allow
SSH2, it is removed from that to knock again from the beginning. The
removal directly after the check for the respective list is important
for the correct handling of the sequence.

    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH2 --remove -j DROP

Now that the end of the sequence has been handled first, the following
rules now do the checking of the port sequence. For each of the ports to
knock one rule checks for the correct port in sequence. If the sequence
is met, a jump occurs to where the IP is added to the list for the next
knock in sequence. If no jump to SSH-INPUT or SSH-INPUTTWO occured, it
can only mean that the wrong port was knocked or (more likely) that it
is some other traffic. Hence, the second rule removes the IP from the
list and drops the traffic, same as the rule for SSH2 before.

    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 9991 -m recent --rcheck --name SSH1 -j SSH-INPUTTWO
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH1 --remove -j DROP

The same procedure is followed for the next port to be knocked. The
ordering of the sequence in the TRAFFIC chain can be any way, as long as
the rules corresponding to the same list are kept together and in the
right order.

    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 7777 -m recent --rcheck --name SSH0 -j SSH-INPUT
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH0 --remove -j DROP

In the final block of rules, the magic of setting the connection attempt
for the IP to the respective recent list of allowed IPs for the next
step of the knocking sequence is done.

The first is the one for the first knock in sequence, which is checked
as part of the main chain TRAFFIC since any new connection attempt may
be the start of a port knocking. On success (correct port) it sets the
knock to the first list, SSH0. This in turn one can see in the last
block of rules to be checked against, where the rule for checking the
second knock (7777) requires a recent knock on the first port and only
then may set the next recent list (SSH1). This switch brings the
sequencing of the lists.

    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 8881 -m recent --name SSH0 --set -j DROP
    -A SSH-INPUT -m recent --name SSH1 --set -j DROP
    -A SSH-INPUTTWO -m recent --name SSH2 --set -j DROP 
    -A TRAFFIC -j DROP
    COMMIT

Note that the traffic is dropped in the last rules too, although a
correct port is knocked. This DROP disguises that the connection attempt
was a successful knock for any of them.

Now that the rules are complete, the iptables.service can be started
with with the rules.

    # systemctl daemon-reload 
    # systemctl restart iptables

Example of iptables.rules file after running all the commands from
above:

    *filter
    :INPUT DROP [0:0]
    :FORWARD DROP [0:0]
    :OUTPUT ACCEPT [0:0]
    :TRAFFIC - [0:0]
    :SSH-INPUT - [0:0]
    :SSH-INPUTTWO - [0:0]
    # TRAFFIC chain for Port Knocking. The correct port sequence in this example is  8881 -> 7777 -> 9991; any other sequence will drop the traffic 
    -A INPUT -j TRAFFIC
    -A TRAFFIC -p icmp --icmp-type any -j ACCEPT
    -A TRAFFIC -m state --state ESTABLISHED,RELATED -j ACCEPT
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 22 -m recent --rcheck --seconds 30 --name SSH2 -j ACCEPT
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH2 --remove -j DROP
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 9991 -m recent --rcheck --name SSH1 -j SSH-INPUTTWO
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH1 --remove -j DROP
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 7777 -m recent --rcheck --name SSH0 -j SSH-INPUT
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH0 --remove -j DROP
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 8881 -m recent --name SSH0 --set -j DROP
    -A SSH-INPUT -m recent --name SSH1 --set -j DROP
    -A SSH-INPUTTWO -m recent --name SSH2 --set -j DROP 
    -A TRAFFIC -j DROP
    COMMIT
    # END or further rules 

Port knocking script
--------------------

Now that configuration is done, to do the port knocking you will need a
tool. nmap is used here. A simple shell script (knock.sh) automates the
port knocking:

    knock.sh

    #!/bin/bash
    HOST=$1
    shift
    for ARG in "$@"
    do
            nmap -Pn --host_timeout 100 --max-retries 0 -p $ARG $HOST
    done

In the following we use the script. In order not to have adverse effects
from other ongoing networking, this test has been done on localhost.

First, the IP for SSHD to listen to is setup, after pulling the network
cable:

    [user@host ~]# ip link set up dev enp8s0
    [user@host ~]# ip address add 192.168.1.1/24 dev enp8s0 
    [user@host ~]# ip route add default via 192.168.1.1 
    [user@host ~]# systemctl status sshd |grep listening
    Aug 21 14:36:53 host sshd[3572]: Server listening on 192.168.1.1 port 22

Second, it is checked if SSHD accepts connections and then the script is
executed, followed by a successful SSH login:

    $ ssh user@host # No response (Ctrl+c to exit)
    ^C
    $ sh knock.sh host 8881 7777 9991
    $ history -r
    $ ssh user@host           # Now logins are allowed
    user@host's password:
    Last login: Tue Aug 20 23:00:27 2013 from host

The first connection attempt has to be stopped, because the DROP of the
connection sends no reply. For testing purposes one can change the last
rules' DROP to REJECT, which will return a $ connection refused instead.
Finally, right after the successful login, one can see the successful
knocks in the kernel's recent lists:

    [user@host ~]$ cat /proc/net/xt_recent/SSH*
    src=192.168.1.1 ttl: 64 last_seen: 296851 oldest_pkt: 1 296851
    src=192.168.1.1 ttl: 64 last_seen: 297173 oldest_pkt: 1 297173
    src=192.168.1.1 ttl: 64 last_seen: 297496 oldest_pkt: 1 297496
    [user@host ~]$ exit
    logout
    Connection to 192.168.1.1 closed.

Warning:Security gained from using the above information cannot be
guaranteed. This is only a way to mask the existence of a service at a
certain port. Other security measures should be used. If you use the
above information for any purpose, you do so at your own risk.

See also
--------

-   Port knocking homepage
-   Wikipedia on Port knocking

Retrieved from
"https://wiki.archlinux.org/index.php?title=Port_Knocking&oldid=305927"

Category:

-   Firewalls

-   This page was last modified on 20 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
