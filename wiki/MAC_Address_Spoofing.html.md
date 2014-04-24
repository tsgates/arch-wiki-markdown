MAC Address Spoofing
====================

This article gives several methods to spoof a Media Access Control (MAC)
address.

Note:In the examples below is assumed the ethernet device is enp1s0. Use
ip link to check your actual device name, and adjust the examples as
necessary

Contents
--------

-   1 Manually
    -   1.1 Method 1: iproute2
    -   1.2 Method 2: macchanger
-   2 Automatically
    -   2.1 Systemd unit
    -   2.2 Systemd unit using random address
-   3 See also

Manually
--------

There are two methods for spoofing a MAC address using either iproute2
(installed by default) or macchanger (available on the official
repositories).

Both of them are outlined below.

> Method 1: iproute2

First, you can check your current MAC address with the command

    # ip link show interface

where interface is the name of your network interface.

The section that interests us at the moment is the one that has
"link/ether" followed by a 6-byte number. It will probably look
something like this:

    link/ether 00:1d:98:5a:d1:3a

The first step to spoofing the MAC address is to bring the network
interface down. It can be accomplished with the command:

    # ip link set dev interface down

Next, we actually spoof our MAC. Any hexadecimal value will do, but some
networks may be configured to refuse to assign IP addresses to a client
whose MAC does not match up with a vendor. Therefore, unless you control
the network(s) you are connecting to, it is a good idea to test this out
with a known good MAC rather than randomizing it right away.

To change the MAC, we need to run the command:

    # ip link set dev interface address XX:XX:XX:XX:XX:XX

Where any 6-byte value will suffice for 'XX:XX:XX:XX:XX:XX'.

The final step is to bring the network interface back up. This can be
accomplished by running the command:

    # ip link set dev interface up

If you want to verify that your MAC has been spoofed, simply run
ip link show interface again and check the value for 'link/ether'. If it
worked, 'link/ether' should be whatever address you decided to change it
to.

> Method 2: macchanger

Another method uses macchanger (a.k.a., the GNU MAC Changer). It
provides a variety of features such as changing the address to match a
certain vendor or completely randomizing it.

Install the package macchanger from the official repositories.

The spoofing is done on per-interface basis, specify network interface
name as interface in each of the following commands.

The MAC address can be spoofed with a fully random address:

    # macchanger -r interface

To randomize all of the address except for the vendor bytes (that is, so
that if the MAC address was checked it would still register as being
from the same vendor), you would run the command:

    # macchanger -e interface

To change the MAC address to a specific value, you would run:

    # macchanger --mac=XX:XX:XX:XX:XX:XX interface

Where XX:XX:XX:XX:XX:XX is the MAC you wish to change to.

Finally, to return the MAC address to its original, permanent hardware
value:

    # macchanger -p interface

Note:A device cannot be in use (connected in any way or with its
interface up) while the MAC address is being changed.

Automatically
-------------

> Systemd unit

This example uses #Method 1: iproute2.

    /etc/systemd/system/macspoof@.service

    [Unit]
    Description=MAC address change %I
    Before=dhcpcd@%i.service

    [Service]
    Type=oneshot
    ExecStart=/usr/bin/ip link set dev %i address 36:aa:88:c8:75:3a
    ExecStart=/usr/bin/ip link set dev %i up

    [Install]
    WantedBy=network.target

You may have to edit this file if you do not use dhcpcd.

> Systemd unit using random address

This example uses #Method 2: macchanger, so make sure that macchanger is
installed.

    /etc/systemd/system/macchanger@.service

    [Unit]
    Description=Macchanger service for %I
    Documentation=man:macchanger(1)

    [Service]
    ExecStart=/usr/bin/macchanger -e %I
    Type=oneshot

    [Install]
    WantedBy=multi-user.target

See also
--------

-   Macchanger GitHub page
-   Article on DebianAdmin with more macchanger options

Retrieved from
"https://wiki.archlinux.org/index.php?title=MAC_Address_Spoofing&oldid=297727"

Categories:

-   Networking
-   Security

-   This page was last modified on 15 February 2014, at 12:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
