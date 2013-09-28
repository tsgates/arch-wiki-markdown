Bridge with netcfg
==================

A bridge is a piece of software used to unite two or more network
segments. A bridge behaves like a virtual network switch, working
transparently (the other machines don't need to know or care about its
existance). Real devices (like eth ones) and virtual devices (like tap
ones) can be connected to it.

This article explains how to create a bridge that contains at least a
ethernet device. This is useful for things like the bridge mode of qemu,
setting a software based access point, etc.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Tips and Tricks                                                    |
|     -   3.1 Manually adding/removing network devices                     |
+--------------------------------------------------------------------------+

Installation
------------

Install the netcfg package from the official repositories.

Configuration
-------------

-   Load the bridge kernel module and configure it to be loaded at boot.

Read Kernel modules for more information.

-   Install the bridge-utils package from the official repositories.

-   Create a bridge called br0 to have, at least, your real Ethernet
    adapter (assuming eth0):

    /etc/network.d/bridge

    INTERFACE="br0"
    CONNECTION="bridge"
    DESCRIPTION="Bridge"
    IP='dhcp'

    #Uncomment this fields as necessary if you are using a static ip instead
    #IP='static'
    #ADDR='10.0.0.1'
    #GATEWAY='10.0.0.1'
    #DNS=('8.8.8.8')

    # Add your network adapter(s) here, separated by spaces.
    BRIDGE_INTERFACES="eth0"

If you are using an static ip, also edit /etc/resolv.conf as necessary.

-   If eth0 had dhcpcd enabled, disable and stop the dhcpcd@eth0.service
    daemon.
-   Finally, enable and start your netcfg@bridge.service.

Tips and Tricks
---------------

> Manually adding/removing network devices

Install the bridge-utils package from the official repositories.

It provides brctl, to manipulate bridges. You can use it to add a
device, like this:

    # brctl addif br0 eth1

Read the manual for more info: man brctl

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bridge_with_netcfg&oldid=252197"

Category:

-   Networking
