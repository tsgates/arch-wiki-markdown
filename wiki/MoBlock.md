MoBlock
=======

Warning:MoBlock's development has been stopped in favor of Phoenix Labs'
official PeerGuardian Linux (pgl). Parts of its code have been merged in
pgl.

MoBlock is a IP blocking daemon that uses iptables. MoBlock is also
unofficial PeerGuardian Linux client that is very useful in filtering
malicous peers on P2P networks.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Setting up                                                         |
|     -   2.1 Configuration                                                |
|     -   2.2 Starting up                                                  |
|     -   2.3 MSN                                                          |
+--------------------------------------------------------------------------+

Installation
============

First you need moblock package from AUR. If you want GUI, install the
blockcontrol (dependency for GUI) and mobloquer (moblock GUI written
using Qt).

Setting up
==========

Configuration
-------------

Open the /etc/moblock/config file with your favourite editor.

I recommend disabling filtering HTTP connections, so find
WHITE_TCP_OUT="" and add http https to it. It will looks like: ]
WHITE_TCP_OUT="http https"

In this file you can also customize what lists MoBlock will use for
filtering, but is best to keep the defaults (MoBlock will filter about
99% bad connections, but will not be too paranoid).

If you are behind NAT, add this to config:

WHITE_IP_IN="192.168.0.0/24" WHITE_IP_OUT="192.168.0.0/24"

That will whitelist everything from 192.168.0.0 to 192.168.0.255.

Now run moblock-update to update the lists.

Note: If you get an error like this when doing a /etc/rc.d/moblock
start:

 iptables v1.4.8: iprange: Bad value for "--dst-range" option: "10.0.1.0/24" Try `iptables -h' or 'iptables --help' for more information.

Try using a range instead, so WHITE_IP_IN="10.0.1.0-10.0.1.255"

Starting up
-----------

After configuration just run

# /etc/rc.d/moblock start

This is it! If you decide that moblock must run everytime you boot up,
just add word moblock to your DAEMONS array in /etc/rc.conf

MSN
---

If you use MSN for instant messaging, you'll need to add port 1863 to
the whitelist:

WHITE_TCP_OUT="http https 1863"

Retrieved from
"https://wiki.archlinux.org/index.php?title=MoBlock&oldid=198649"

Categories:

-   Networking
-   Security
