Honeyd
======

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 More Resources                                                     |
+--------------------------------------------------------------------------+

Introduction
------------

Honeyd is an open source computer program that allows a user to set up
and run multiple virtual hosts on a computer network. These virtual
hosts can be configured to mimic several different types of servers,
allowing the user to simulate an infinite number of computer network
configurations. Honeyd is primarily used in the field of computer
security by professionals and hobbyists alike.

This page goes over how to get a simple setup up and running. My server
uses IP address 192.168.1.10. My honeyd daemon will listen at 10.0.0.1.

Installation
------------

Install the honeyd package from the AUR.

Configuration
-------------

Create these files:

    /root/default.conf

    create host
    set host default tcp action reset
    add host tcp port 23 "/tmp/hello.sh"

    bind 10.0.0.1 host

    /tmp/hello.sh

    #!/bin/sh
    echo "Led Zeppelin, great band or greatest band?"
    while read data
    do
            echo "$data"
    done

On your firewall, add the following route:

    Destination IP 	Netmask 	Gateway
    10.0.0.0	        255.0.0.0	192.168.1.10

Open up 2 shells on your server. In the first shell, start the honeyd
program. In the second shell, use nc to connect to honeyd. The output
should be as follows:

    $ honeyd -d -p /usr/share/honeyd/nmap.prints -f default.conf 10.0.0.0/8

    Honeyd V1.5c Copyright (c) 2002-2007 Niels Provos
    honeyd[3985]: started with -d -p /usr/share/honeyd/nmap.prints -f default.conf 10.0.0.0/8
    Warning: Impossible SI range in Class fingerprint "IBM OS/400 V4R2M0"
    Warning: Impossible SI range in Class fingerprint "Microsoft Windows NT 4.0 SP3"
    honeyd[3985]: listening promiscuously on eth0: (arp or ip proto 47 or (udp and src port 67 and dst port 68) or (ip and (net 10.0.0.0/8))) and not ether src MAC_ADDY_HERE
    honeyd[3985]: Demoting process privileges to uid 99, gid 99
    honeyd[3985]: Connection request: tcp (192.168.1.10:60109 - 10.0.0.1:23)
    honeyd[3985]: Connection established: tcp (192.168.1.10:60109 - 10.0.0.1:23) <-> /tmp/hello.sh
    honeyd[3985]: Connection dropped by reset: tcp (192.168.1.10:60109 - 10.0.0.1:23)
    ^Choneyd[3985]: exiting on signal 2

    $ nc 10.0.0.1 23

    Led Zeppelin, great band or greatest band?
    greatest
    greatest

    ^C

There, you have a simple, basic, set up of honeyd. To kill honeyd, issue
the command

    killall honeyd

You can read "Virtual Honeypots: From Botnet Tracking to Intrusion
Detection" by Niels Provos for more information.

More Resources
--------------

http://www.honeyd.org/faq.php

Wikipedia:Honeyd

http://ulissesaraujo.wordpress.com/2008/12/08/deploying-honeypots-with-honeyd/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Honeyd&oldid=212529"

Categories:

-   Networking
-   Security
