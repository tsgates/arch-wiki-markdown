Wake-on-LAN
===========

Wake-on-LAN, otherwise known as 'wol', is the ability to switch on a
computer that is connected to a network (be it the internet or
intranet). This article deals with what it is, how it can be used from
an Arch Linux computer, and its general uses.

It is important to note that Wake-on-LAN applies to the computers being
physically connected (ie, not wireless).

Contents
--------

-   1 Does my motherboard support Wake-on-LAN?
-   2 Ensure that Wake-on-LAN is enabled and survives a reboot
    -   2.1 With udev
    -   2.2 With cron
    -   2.3 With systemd
-   3 Wake-on-LAN in different situations
    -   3.1 Across your intranet/network (no router)
        -   3.1.1 For two computers connected to each other
        -   3.1.2 For computers connected to a non-firewalled router
    -   3.2 Across your intranet/network (router)
    -   3.3 Across the internet
-   4 Battery draining problem
-   5 Additional Notes
-   6 Example WOL script
-   7 Resources

Does my motherboard support Wake-on-LAN?
----------------------------------------

For Wake-on-LAN to work, the target computer motherboard must support
this feature. Generally speaking, the Wake-on-LAN (non)ability of the
target motherboard will be specified by the hardware manufacturer.
Sometimes, this ability is evident by browsing through said
motherboard's BIOS and looking for something like 'PCI Power up'. Most
modern motherboards should support Wake-on-LAN.

Ensure that Wake-on-LAN is enabled and survives a reboot
--------------------------------------------------------

A common problem with the Wake-on-LAN in computers running Linux is that
the network drivers have Wake-on-LAN switched off by default. To
manually switch on the Wake-on-LAN feature on your driver, you will need
to install ethtool.

Note:For the following commands substitute net0 with your network
device, e.g. eth0

First query the driver to see if it's defaulted to 'on' by using
ethtool:

    # ethtool net0 | grep Wake-on

            Supports Wake-on: pg
    	Wake-on: d

Note:We need a 'Wake-on' value of 'g' for WOL to work.

To enable the wol feature in the driver, simply run the following

    # ethtool -s net0 wol g

This command does not last beyond the next reboot. If using netctl, one
can make this setting persistent by adding the following to your netctl
profile:

    /etc/netctl/PROFILE

    ExecUpPost='/usr/bin/ethtool -s net0 wol g'

-   If for some reason, you find that after using the command to switch
    your network drivers Wake-on-LAN feature on, the computer shuts down
    normally but then starts again, experiment with combinations of
    [u/b/m]g
-   For some network cards, you may also need the following command:

    # echo enabled > /sys/class/net/net0/device/power/wakeup

> With udev

udev is capable of running any command you desire as soon as a device is
visible. We want udev to turn on wake on lan for our device. Put the
following in /etc/udev/rules.d/50-wol.rules, replacing N with the number
for your interface:

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="netN", RUN+="/usr/bin/ethtool -s %k wol g"

This tells udev to run "/usr/bin/ethtool -s netN wol g" as soon as the
device netN exists. To turn on wake on lan for all new devices, replace
the N with a '*':

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="net*", RUN+="/usr/bin/ethtool -s %k wol g"

> With cron

A command can be run each time the computer is (re)booted using
"@reboot" in a crontab. First, make sure cron is enabled, and then edit
a crontab for the root user that contains the following line:

    @reboot /usr/bin/ethtool -s [net-device] wol g

> With systemd

If for some reason udev fails or is not an option, systemd can be used
instead as a last resort. (In this editor's experience, systemd is
rather intermittent.) To use systemd, do not follow the udev
instructions. Instead, create a new service unit file
/etc/systemd/system/wol@.service:

    [Unit]
    Description=Wake-on-LAN for %i
    Requires=network.target
    After=network.target

    [Service]
    ExecStart=/usr/bin/ethtool -s %i wol g
    Type=oneshot

    [Install]
    WantedBy=multi-user.target

Or install wol-systemd package from the AUR

Then activate this new service for your network adapter:

    # systemctl enable wol@net0

and start it right now

    # systemctl start wol@net0

Wake-on-LAN in different situations
-----------------------------------

The computer that you want to use Wake-on-LAN on may be directly linked
to your computer through a network cable, connected to the same router
that you are using, or remotely, across the internet.

There are four essential things needed in order to use Wake-on-LAN on a
target PC:

1.  Some kind of Wake-on-LAN software on the host (your) PC
2.  A connection to the internet or intranet of the target PC
3.  The MAC address of the target PC
4.  The internal or external IP of the target PC

-   Firstly, install a Wake-on-LAN software. In this article, wol will
    be used. It can be installed from the [community] repository.

-   It is recommended that you read the documentation of wol

    man wol
    wol --help

-   wol requires several parameters, the most basic needed:

    wol MACADDRESS

-   But it is good practice to include the IP address or hostname,
    therefore this syntax should be the minimal used:

    # wol -i HOSTNAME_OR_IP MACADDRESS

-   The documentation of wol states that:

Each MAC-ADDRESS is written as x:x:x:x:x:x, where x is a hexadecimal
number between 0 and ff which represents one byte of the address, which
is in network byte order (big endian).

-   To obtain the MACADDRESS of the target computer:

    $ ip link

The port, IP or hostname of the target PC will be addressed in the
relevant following sections.

> Across your intranet/network (no router)

If you are connected directly to another computer through a network
cable, or have disabled your router firewall (not a good idea), then
using Wake-on-LAN should be very simple.

For two computers connected to each other

    wol MACADDRESS_OF_TARGET_PC

For computers connected to a non-firewalled router

    wol -i INTERNAL_IP_OF_TARGET_PC MACADDRESS_OF_TARGET_PC

-   To find the internal IP:

    ip addr | grep 'inet '

-   Since you are not firewalled, then there is no need to worry about
    port redirects.
-   If you intend to continue using Wake-on-LAN, it is recommended that
    you assign your computer's MACADDRESS to a specific IP on your
    router. Consult your router for details as to how to do this.

> Across your intranet/network (router)

The syntax used in this situation:

    wol -p PORT_FORWARDED_TO_INTERNAL_IP -i INTERNAL_IP MACADDRESS_OF_TARGET_PC

-   When you send the MagicPacket signal to the target computer via a
    specific port, the signal passes through your router. The router
    must be instructed to forward any signal heading for that specific
    port to the internal IP of the target PC.

-   It is recommended that for multiple computers connected to one
    computer, to assign a different port forward to each internal IP

-   For port forwarding help, please consult http://portforward.com/
    (though this website has some Windows specific content, it has a
    very large database of router web interfaces)

> Across the internet

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Request for      
                           OpenWRT instructions.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The syntax needed in this case:

    wol -p X -i HOSTNAME_OR_EXTERNAL_IP_OF_TARGET MACADDRESS

-   Assuming that you know the external IP of the target machine, and
    that the router ports on both sides have been forwarding correctly,
    then this should be exactly as the syntax states.

  
 Usually it is necessary to forward your wol port (typically UDP 9) to
the broadcast address on your network, not to a particular IP. Most
routers do not allow you to forward to broadcast, however if you can get
shell access to your router (through telnet, ssh, serial cable, etc) you
can implement this workaround:

    ip neighbor add 192.168.1.254 lladdr FF:FF:FF:FF:FF:FF dev net0

(The above command assumes your network is 192.168.1.0/24 and use net0
as network interface). Now, forward UDP port 9 to 192.168.1.254. This
has worked for me on a Linksys WRT54G running Tomato, and on the Verizon
FIOS ActionTec router.

For notes on how to do it on DD-WRT routers, see this tutorial.

Battery draining problem
------------------------

Some laptops have battery draining problem after shutdown [1]. This
might be caused by enabled Wake-on-LAN. To solve this problem, we can
disable it by using ethtool as mentioned above.

    # ethtool -s net0 wol d

We can also add this to the /etc/rc.local or /etc/rc.local.shutdown.

Additional Notes
----------------

-   A common problem is that some forget to switch on the Wake-on-LAN
    feature in their BIOS.

-   In some systems the BIOS option "Boot from PCI/PCI-E" needs to be
    Enabled.

Example WOL script
------------------

Here is a script you can use to automate wol to several different
machine. Modify as you see fit:

    #!/bin/bash

    # definition of MAC addresses
    monster=01:12:46:82:ab:4f
    chronic=00:3a:53:21:bc:30
    powerless=1a:32:41:02:29:92
    ghost=01:1a:d2:56:6b:e6

    while [ "$input1" != quit ]; do
    echo "Which PC to wake?"
    echo "p) powerless"
    echo "m) monster"
    echo "c) chronic"
    echo "g) ghost"
    echo "b) wake monster, wait 40sec, then wake chronic"
    echo "q) quit and take no action"
    read input1
      if [ $input1 == p ]; then
      /usr/bin/wol $powerless
      exit 1
    fi

    if [ $input1 == m ]; then
      /usr/bin/wol $monster
      exit 1
    fi

    if [ $input1 == c ]; then
      /usr/bin/wol $chronic
      exit 1
    fi

    # this line requires an IP address in /etc/hosts for ghost
    # and should use wol over the internet provided that port 9
    # is forwarded to ghost on ghost's router

    if [ $input1 == g ]; then
      /usr/bin/wol -v -h -p 9 ghost $ghost
      exit 1
    fi

    if [ $input1 == b ]; then
      /usr/bin/wol $monster
      echo "monster sent, now waiting for 40sec then waking chronic"
      sleep 40
      /usr/bin/wol $chronic
      exit 1
    fi

    if [ $input1 == Q ] || [ $input1 == q ]; then
    echo "later!"
    exit 1
    fi

    done
    echo  "this is the (quit) end!! c-ya!"

Resources
---------

Wake-On-Lan

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wake-on-LAN&oldid=303427"

Category:

-   Networking

-   This page was last modified on 7 March 2014, at 02:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
