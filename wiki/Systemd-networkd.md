systemd-networkd
================

Related articles

-   systemd
-   systemd-nspawn
-   Network configuration
-   netctl
-   Bridge with netctl

As of version 210, systemd now includes support for basic network
configuration through udev and networkd.

systemd-networkd is a system daemon that manages network configuration.
It detects and configures network devices as they appear, as well as
creates virtual network devices. This service can run alongside your
usual network management tool like netctl or even replace it for some
configurations when it comes to virtualization. This service can
especially be very useful to setup basic or more complex network
settings (static IP, bridge,vlan...) for a container managed by
systemd-nspawn.

It is not intended to configure low-level settings of network interfaces
as this remains udev's job.

The primary functionality of the networkd daemon is to easily set up
network on containers or VM from your host machine

Note:this service is still under heavy development and documentation is
spare. The settings are not so straightforward and will ask a good
knowledge of basic networking notions.

Contents
--------

-   1 Installation
-   2 Configuration files
    -   2.1 network files
        -   2.1.1 [Match] section
        -   2.1.2 [Network] section
    -   2.2 netdev files
        -   2.2.1 [Match] section
        -   2.2.2 [Netdev] section
    -   2.3 link files
        -   2.3.1 [Match] section
        -   2.3.2 [Link] section
-   3 Usage
    -   3.1 Basic DHCP network
    -   3.2 DHCP with two distinct IP
        -   3.2.1 Bridge interface
        -   3.2.2 Bind Ethernet to Bridge
        -   3.2.3 Bridge network
        -   3.2.4 Add option to boot the container
        -   3.2.5 Result
        -   3.2.6 Notice
    -   3.3 Static IP network
-   4 See also

Installation
------------

The service is available with systemd >= 210. You will want to enable
and start the systemd-networkd.service on the host and container.

For debugging purposes, it is strongly advised to install the
bridge-utils, net-tools and iproute2 packages.

Depending on your networking set-up, you will need to modify the
systemd-nspawn@.service and append to the ExecStart line some boot
options. Please refer to systemd-nspawn(1) for an exhaustive list of
options.

Configuration files
-------------------

Configuration files will be read from /usr/lib/systemd/metwork, the
volatile runtime network directory /run/systemd/network and the local
administration network directory /etc/systemd/network. Files in
/etc/systemd/network have the highest priority.

There are three types of configuration files.

-   .network files. They will apply a network configuration for a
    matching device
-   .netdev files. They will create a virtual network device for a
    matching environment
-   .link files. When a network device appears, udev will look for the
    first matching .link file

They all follow the same rules:

-   if one of the entry of the [Match] section match a condition, then
    the configurations in the next sections will be applied
-   the [Match] section accepts more than one entry. In this case, each
    of the entries have to match the conditions for the profile to be
    activated
-   an empty [Match] section means the profile will apply in any case
    (can be compared to the * joker)
-   each entry is a key with the NAME=VALUE syntax
-   all configuration files are collectively sorted and processed in
    lexical order, regardless of the directory in which they live
-   files with identical name replace each other

> Tip:

-   to override a system-supplied file in /usr/lib/systemd/network in a
    permanent manner (i.e even after upgrade), place a file with same
    name in /etc/systemd/network and symlink it to /dev/null
-   the * joker can be used in VALUE (e.g en* will match any Ethernet
    device)
-   following this Arch-general thread, the best practice is to setup
    specific container network settings inside the container with
    networkd configuration files.

> network files

These files are aimed at setting network configuration variables,
especially for servers and containers.

Below is a basic structure of a MyProfile.network file:

    /etc/systemd/network/MyProfile.network

    [Match]
    a vertical list of keys

    [Network]
    a vertical list of keys

    [Address]
    a vertical list of keys

    [Route]
    a vertical list of keys

[Match] section

Most common keys are:

-   Name= the device name (e.g Br0, enp4s0)
-   Host= the machine hostname
-   Virtualization= a Boolean to check whether the system is executed in
    a virtualized environment or not. Thus a Virtualization=no key will
    only apply on your host machine, when Virtualization=yes apply to
    any container or VM.

[Network] section

Most common keys are:

-   DHCP= is a Boolean. When set to true it enables a basic DHCPv4
    support.
-   DNS= is a DNS server address. You can specify this option more than
    once
-   Bridge= is the name of the bridge to add the link to

Most common key in the [Address] section is:

-   Address= is a static IPv4 or IPv6 address and its prefix length,
    separated by a / character (e.g 192.168.1.90/24). This option is
    mandatory

Most common key in the [Route] section is:

-   Gateway= is the address of your machine gateway. This option is
    mandatory

For an exhaustive key list, please refer to systemd.network(5)

Tip:you can put the Address= and Gateway= keys in the [Network] section
as a short-hand if Address= contains only an Address key and Gateway=
section contains only a Gateway key

> netdev files

These files will create virtual network devices.

Below is a basic structure of a Mydevice.netdev file:

    /etc/systemd/network/MyDevice.netdev

    [Match]
    a vertical list of keys

    [Netdev]
    a vertical list of keys

[Match] section

Most common keys are Host= and Virtualization=

[Netdev] section

Most common keys are:

-   Name= is the interface name used when creating the netdev. This
    option is compulsory
-   Kind= is the netdev kind. Currently, bridge, bond, vlan and macvlan
    are supported. This option is compulsory

For an exhaustive key list, please refer to systemd.netdev(5)

> link files

These files are an alternative to custom udev rules and will be applied
by udev as the device appears.

Below is a basic structure of a Mydevice.link file:

    /etc/systemd/network/MyDevice.link

    [Match]
    a vertical list of keys

    [Link]
    a vertical list of keys

The [Match] section will determine if a given link file may be applied
to a given device, when the [Link] section specifies the device
configuration.

[Match] section

Most common keys are MACADRESS=, Host= and Virtualization=.

Type= is the device type (e.g. vlan)

[Link] section

Most common keys are:

MACAddressPolicy= is either persistent when the hardware has a
persistent MAC address (as most hardware should) or random , which
allows to give a random MAC address when the device appears.

MACAddress= shall be used when no MACAddressPoicy= is specified.

Note:the system /usr/lib/systemd/network/99-default.link is generally
sufficient for mots of the basic cases.

Usage
-----

Tip:before you start to configure your container network, it is useful
to:

-   disable all your netctl services. This will avoid any potential
    conflicts with systemd-networkd and make all your configurations
    easier to test. Furthermore, odds are high you will end with few or
    even no netctl activated profiles. The $ netctl list command will
    output a list of all your profiles, with the activated one being
    starred.
-   disable systemd-nspawn@.service and use the
    # systemd-nspawn -bD /path_to/your_container/ command with some more
    options to boot the container. To log off and shutdown, run inside
    the container # systemctl poweroff. Once your network setting met
    your requirements, enable and start systemd-nspawn@.service
-   disable dhcpcd.service if enabled on your system. This service apply
    dhcpcd on all interfaces
-   make sure you have no netctl profiles activated on your container,
    nor the systemd-networkd.service enabled and started
-   make sure you don't have any iptables rules which can block traffic
-   make sure packet forwarding is enabled if you plan to set up a
    private network on your container
-   after any configuration files, reload the networkd daemon when
    running # systemctl restart systemd-networkd

Note:For the set-up described below,

-   we will limit the output of the $ ip a command to the concerned
    interfaces
-   we assume the host is your main OS you are booting to and the
    container is your guest virtual machine
-   all interface names and IP adresses are only examples

> Basic DHCP network

This set up will enable a DHCP IP for host and container. In this case,
both systems will share the same IP as they share the same interfaces.

    /etc/systemd/network/MyDhcp.network

    [Match]
    Name=en*

    [Network]
    DHCP=yes

You can of course replace en* by the full name of your Ethernet device
given by the output of the $ ip link command.

-   on host and container:

    $ ip a

    2: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 14:da:e9:b5:7a:88 brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.72/24 brd 192.168.1.255 scope global enp7s0
           valid_lft forever preferred_lft forever
        inet6 fe80::16da:e9ff:feb5:7a88/64 scope link 
           valid_lft forever preferred_lft forever

> DHCP with two distinct IP

Bridge interface

Create a virtual bridge interface

    /etc/systemd/network/MyBridge.netdev

    [NetDev]
    Name=br0
    Kind=bridge

-   on host and container:

    $ ip a

    3: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default 
        link/ether ae:bd:35:ea:0c:c9 brd ff:ff:ff:ff:ff:ff

Note that the interface br0 is listed but is DOWN.

Bind Ethernet to Bridge

Modify the /etc/systemd/network/MyDhcp.network to remove the DHCP, as
the bridge requires an interface to bind to with no IP, and add a key to
bind this device to br0. Let's change its name to a more relevant one.

    /etc/systemd/network/MyEth.network

    [Match]
    Name=en*

    [Network]
    Bridge=br0

Bridge network

Create a network profile for the Bridge

    /etc/systemd/network/MyBridge.network

    [Match]
    Name=br0

    [Network]
    DHCP=yes

Add option to boot the container

As we want to give a separate IP for host and container, we need to
Disconnect networking of the container from the host. To do this, add
this option --network-bridge=br0 to your container boot command.

    # systemd-nspawn --network-bridge=br0 -bd /path_to/my_container

Result

-   on host

    $ ip a

    3: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
        link/ether 14:da:e9:b5:7a:88 brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.87/24 brd 192.168.1.255 scope global br0
           valid_lft forever preferred_lft forever
        inet6 fe80::16da:e9ff:feb5:7a88/64 scope link 
           valid_lft forever preferred_lft forever
    6: vb-MyContainer: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP group default qlen 1000
        link/ether d2:7c:97:97:37:25 brd ff:ff:ff:ff:ff:ff
        inet6 fe80::d07c:97ff:fe97:3725/64 scope link 
           valid_lft forever preferred_lft forever

-   on container

    $ ip a

    2: host0: <BROADCAST,MULTICAST,ALLMULTI,AUTOMEDIA,NOTRAILERS,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 5e:96:85:83:a8:5d brd ff:ff:ff:ff:ff:ff
        inet 192.168.1.73/24 brd 192.168.1.255 scope global host0
           valid_lft forever preferred_lft forever
        inet6 fe80::5c96:85ff:fe83:a85d/64 scope link 
           valid_lft forever preferred_lft forever

Notice

-   we have now one IP address for Br0 on the host, and one for host0 in
    the container
-   two new interfaces have appeared: vb-MyContainer in the host and
    host0 in the container. This comes as a result of the
    --network-bridge=br0 option. This option implies another option,
    --network-veth. This means a virtual Ethernet link has been created
    between host and container.
-   the DHCP address on host0 comes from the system
    /usr/lib/systemd/network/80-container-host0.network file.
-   on host

    $ brctl show

    bridge name	bridge id		STP enabled	interfaces
    br0		8000.14dae9b57a88	no		enp7s0
    							vb-MyContainer

the above command output confirms we have a bridge with two interfaces
binded to.

-   on host

    $ ip route

    default via 192.168.1.254 dev br0 
    192.168.1.0/24 dev br0  proto kernel  scope link  src 192.168.1.87

-   on container

    $ ip route

    default via 192.168.1.254 dev host0 
    192.168.1.0/24 dev host0  proto kernel  scope link  src 192.168.1.73

the above command outputs confirm we have activated br0 and host0
interfaces with an IP address and Gateway 192.168.1.254. The gateway
address has been automatically grabbed by systemd-networkd

    $ cat /run/systemd/network/resolv.conf

    nameserver 192.168.1.254

> Static IP network

Setting a static IP for each device can be helpful in case of deployed
web services (e.g FTP, http, SSH). Each device will keep the same MAC
address across reboots if your system
/usr/lib/systemd/network/99-default.link file has the
MACAdressPolicy=persistent option (it has by default). Thus, you will
easily route any service on your Gateway to the desired device. First,
we shall get rid of the system
/usr/lib/systemd/network/80-container-host0.network file. To do it in a
permanent way (e.g even after upgrades), do the following on both host
and container.

    # cp /usr/lib/systemd/network/80-container-host0.network /etc/systemd/network
    # ln -sf /dev/null /etc/systemd/network/80-container-host0.network

Then, enable and start systemd-networkd on your container.

The needed configuration files:

-   on host

    /etc/systemd/network/MyBridge.netdev
    /etc/systemd/network/MyEth.network

A modified MyBridge.network

    /etc/systemd/network/MyBridge.network

    [Match]
    Name=br0

    [Network]
    DNS=192.168.1.254
    Address=192.168.1.87/24
    Gateway=192.168.1.254

-   on container

    /etc/systemd/network/MyVeth.network

    [Match]
    Name=host0

    [Network]
    DNS=192.168.1.254
    Address=192.168.1.94/24
    Gateway=192.168.1.254

Et voila!

See also
--------

-   systemd.networkd man page
-   Tom Gundersen, main systemd-networkd developer, G+ home page
-   Tom Gundersen posts on Core OS blog

Retrieved from
"https://wiki.archlinux.org/index.php?title=Systemd-networkd&oldid=306182"

Categories:

-   Networking
-   Virtualization

-   This page was last modified on 20 March 2014, at 20:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
