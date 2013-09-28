Telnet
======

Telnet is the traditional protocol for making remote console connections
over TCP. Telnet is not secure and is mainly used to connect to legacy
equipment nowadays. For a secure alternative see SSH.

Follow these instructions to configure an Arch Linux machine as a telnet
server.

Installation
------------

To use telnet only to connect to other machines, install inetutils (if
not already installed):

    # pacman -S inetutils

To configure a telnet server, install xinetd as well:

    # pacman -S xinetd

Configuration
-------------

1. To allow telnet connections in xinetd, edit /etc/xinetd.d/telnet and
change 'disable = yes' to 'disable = no'

2. Add xinetd to the DAEMONS array of your rc.conf:

    DAEMONS=(... xinetd)

3. Reboot or restart xinetd:

    # /etc/rc.d/xinetd restart

> Testing the setup

Try opening a telnet connection to your server:

    $ telnet localhost

Note that you can not login as root.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Telnet&oldid=240585"

Category:

-   Networking
