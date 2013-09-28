Port Knocking
=============

Warning:Port knocking should be used as part of a security strategy, not
as the only protection. That would be a fragile security through
obscurity. In case of SSH protection, see SSH Keys for a strong method
that can be used along with port knocking.

Port knocking is a stealth method to externally open ports that, by
default, the firewall keep closed. It works by requiring connection
attempts to a series of predefined closed ports. When the correct
sequence of port "knocks" (connection attempts) is received, the
firewall opens certain port(s).

The benefit is that, for a regular port scan, it may appear as the
service of the port is just not available.

A session with port knocking may look like this:

    $ ssh username@hostname # No response (Ctrl+c to exit)
    ^C
    $ nmap -PN --host_timeout 201 --max-retries 0  -p 1111 hostname #knockig port 1111
    $ nmap -PN --host_timeout 201 --max-retries 0  -p 2222 hostname #knockig port 2222
    $ ssh username@hostname # Now logins are allowed
    username@hostname's password:

Note:Instead of following this guide, you can use a daemon to do all the
work for you. Read Simple_stateful_firewall#Port_Knocking for a method
for that.

The purpose of this article is to teach how to use port knocking without
using external daemons, by using iptables only.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Port knocking script                                         |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the iptables package from the official repositories.

Read iptables for more details about iptables.

Configuration
-------------

The module recent in iptables is used to dynamically create list of ip
addresses based on their (successful or unsuccessful) port connections.

Using recent we can find out if a certain IP address has knocked the
correct ports, and if that is the case, open certain port(s).

The following represents the contents of an iptables.rules file. In this
example, the port to be open by port knocking is 22 (default for SSH)
The example has comments that explain how it works.

    /etc/iptables/iptables.rules

    *filter
    :INPUT ACCEPT [0:0]
    :FORWARD ACCEPT [0:0]
    :OUTPUT ACCEPT [0:0]
    :TRAFFIC - [0:0]
    :SSH-INPUT - [0:0]
    :SSH-INPUTTWO - [0:0]
    -A INPUT -j TRAFFIC
    -A FORWARD -j TRAFFIC

    # Accepted connections by default

    -A TRAFFIC -i lo -j ACCEPT
    -A TRAFFIC -s 192.168.0.0/24 -j ACCEPT
    -A TRAFFIC -p icmp --icmp-type any -j ACCEPT
    -A TRAFFIC -m state --state ESTABLISHED,RELATED -j ACCEPT
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT

    # Port Knocking -- the correct port sequence is 8881 -> 7777 -> 9991; any other sequence will close the port 22

    # If the ip is on the list SSH2, the port 22 is going to be open for 30 seconds, 
    # after that is closed again (but only for new connections, established ones are not closed)
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 22 -m recent --rcheck --seconds 30 --name SSH2 -j ACCEPT

    # Now we delete the ip from the list SSH2 (if present)
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH2 --remove -j DROP

    # This will call SSH-INPUTTWO if the ip is present on the list SSH1 and the port knocked is 9991
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 9991 -m recent --rcheck --name SSH1 -j SSH-INPUTTWO

    # Now we delete the ip from the list SSH1 (if present)
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH1 --remove -j DROP

    # This will call SSH-INPUT if the ip is present on the list SSH0 and the port knocked is 7777
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 7777 -m recent --rcheck --name SSH0 -j SSH-INPUT

    # Now we delete the ip from the list SSH0 (if present)
    -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH0 --remove -j DROP

    # This will add the ip to the list SSH0 if the port knocked is 8881
    -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 8881 -m recent --name SSH0 --set -j DROP

    # SSH-INPUT add the ip to the list SSH1 
    -A SSH-INPUT -m recent --name SSH1 --set -j DROP

    # SSH-INPUTTWO add the ip to the list SSH2
    -A SSH-INPUTTWO -m recent --name SSH2 --set -j DROP 

    # Any other traffic is dropped
    -A TRAFFIC -j DROP
    COMMIT
    # you can add nat rules, etc here

Note:For security reasons, the 8881, 7777 and 9991 ports used in the
above example should be changed. Please use a unique set of port
numbers.

Next, start the iptables.service, and configure it to have it load your
settings on boot. Read Daemons for more information.

> Port knocking script

Now we can use a simple shell script (knock.sh) to do the knocking:

    knock.sh

    #!/bin/bash
    HOST=$1
    shift
    for ARG in "$@"
    do
            nmap -PN --host_timeout 201 --max-retries 0 -p $ARG $HOST
    done

Here is how the script would work:

    $ ssh username@hostname # No response (Ctrl+c to exit)
    ^C
    $ sh knock.sh hostname 8881 7777 9991
    $ history -r
    $ ssh username@hostname # Now logins are allowed
    username@hostname's password:

Warning:Security gained from using the above information cannot be
guaranteed. This is only a way to mask the existence of a service at a
certain port. Other security measures should be used. If you use the
above information for any purpose, you do so at your own risk.

See also
--------

-   Port knocking homepage
-   Port knocking by using a daemon

Retrieved from
"https://wiki.archlinux.org/index.php?title=Port_Knocking&oldid=243472"

Categories:

-   Security
-   Networking
