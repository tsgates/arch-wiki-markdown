Telnet
======

Telnet is the traditional protocol for making remote console connections
over TCP. Telnet is not secure and is mainly used to connect to legacy
equipment nowadays. For a secure alternative see SSH.

Follow these instructions to configure an Arch Linux machine as a telnet
server.

Installation
------------

To use telnet only to connect to other machines, install inetutils.

To configure a telnet server, install xinetd as well.

Configuration
-------------

To allow telnet connections in xinetd, edit /etc/xinetd.d/telnet, change
disable = yes to disable = no and restart xinetd service.

Enable systemd xinetd service if you wish to start it at boot time.

> Testing the setup

Try opening a telnet connection to your server:

    $ telnet localhost

Note that you can not login as root.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Telnet&oldid=260024"

Category:

-   Networking

-   This page was last modified on 1 June 2013, at 10:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
