Network configuration
=====================

Related articles

-   Jumbo Frames
-   Firewalls
-   Wireless network configuration
-   List of Applications#Network Managers

This page explains how to set up a wired connection to a network. If you
need to set up wireless networking see the Wireless network
configuration page.

Contents
--------

-   1 Check the connection
-   2 Set the hostname
-   3 Device Driver
    -   3.1 Check the driver status
    -   3.2 Load the device module
-   4 Network Interfaces
    -   4.1 Device names
        -   4.1.1 Change device name
    -   4.2 Set device MTU and queue Length
    -   4.3 Get current device names
    -   4.4 Enabling and disabling network interfaces
-   5 Configure the IP address
    -   5.1 Dynamic IP address
        -   5.1.1 dhcpcd
        -   5.1.2 systemd-networkd
    -   5.2 Static IP address
        -   5.2.1 Manual assignment
        -   5.2.2 Persistent configuration on boot using systemd and
            udev rules
        -   5.2.3 Persistent configuration on boot using
            systemd-networkd
        -   5.2.4 Calculating addresses
-   6 Load configuration
-   7 Additional settings
    -   7.1 ifplugd for laptops
    -   7.2 Bonding or LAG
    -   7.3 IP address aliasing
        -   7.3.1 Example
    -   7.4 Change MAC/hardware address
    -   7.5 Internet Sharing
    -   7.6 Router Configuration
    -   7.7 Local network hostname resolution
-   8 Troubleshooting
    -   8.1 Swapping computers on the cable modem
    -   8.2 The TCP window scaling problem
        -   8.2.1 How to diagnose the problem
        -   8.2.2 How to fix it (The bad way)
        -   8.2.3 How to fix it (The good way)
        -   8.2.4 How to fix it (The best way)
        -   8.2.5 More about it
    -   8.3 Realtek no link / WOL problem
        -   8.3.1 Method 1 - Enable the NIC directly in Linux
        -   8.3.2 Method 2 - Rollback/change Windows driver
        -   8.3.3 Method 3 - Enable WOL in Windows driver
        -   8.3.4 Method 4 - Newer Realtek Linux driver
        -   8.3.5 Method 5 - Enable LAN Boot ROM in BIOS/CMOS
    -   8.4 No eth0 with Atheros AR9485
    -   8.5 Broadcom BCM57780

Check the connection
--------------------

Note:If you receive an error like
ping: icmp open socket: Operation not permitted when executing ping, try
to re-install the iputils package.

Many times, the basic installation procedure has created a working
network configuration. To check if this is so, use the following
command:

Note:The -c 3 option calls it three times. See man ping for more
information.

    $ ping -c 3 www.google.com

    PING www.l.google.com (74.125.224.146) 56(84) bytes of data.
    64 bytes from 74.125.224.146: icmp_req=1 ttl=50 time=437 ms
    64 bytes from 74.125.224.146: icmp_req=2 ttl=50 time=385 ms
    64 bytes from 74.125.224.146: icmp_req=3 ttl=50 time=298 ms

    --- www.l.google.com ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 1999ms
    rtt min/avg/max/mdev = 298.107/373.642/437.202/57.415 ms

If it works, then you may only wish to personalize your settings from
the options below.

If the previous command complains about unknown hosts, it means that
your machine was unable to resolve this domain name. It might be related
to your service provider or your router/gateway. You can try pinging a
static IP address to prove that your machine has access to the Internet.

    $ ping -c 3 8.8.8.8

    PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
    64 bytes from 8.8.8.8: icmp_req=1 ttl=53 time=52.9 ms
    64 bytes from 8.8.8.8: icmp_req=2 ttl=53 time=72.5 ms
    64 bytes from 8.8.8.8: icmp_req=3 ttl=53 time=70.6 ms

    --- 8.8.8.8 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2002ms
    rtt min/avg/max/mdev = 52.975/65.375/72.543/8.803 ms

Note:8.8.8.8 is a static address that is easy to remember. It is the
address of Google's primary DNS server, therefore it can be considered
reliable, and is generally not blocked by content filtering systems and
proxies.

If you are able to ping 8.8.8.8 but not www.google.com, check your DNS
configuration. See resolv.conf for details.

Set the hostname
----------------

A hostname is a unique name created to identify a machine on a network:
it is configured in /etc/hostname. The file can contain the system's
domain name, if any. To set the hostname, do:

    # hostnamectl set-hostname myhostname

This will put myhostname into /etc/hostname.

See man 5 hostname and man 1 hostnamectl for details.

> Note:

-   hostnamectl supports FQDNs
-   You no longer need to edit /etc/hosts, systemd will provide host
    name resolution, and is installed on all systems by default. It
    might be necessary if you experience network slow downs.

To set the hostname temporarily (until a reboot), use hostname from
inetutils:

    # hostname myhostname

Device Driver
-------------

> Check the driver status

udev should detect your network interface card (NIC) and automatically
load the necessary module at start up. Check the "Ethernet controller"
entry (or similar) from the lspci -v output. It should tell you which
kernel module contains the driver for your network device. For example:

    $ lspci -v

    02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit Ethernet Adapter (rev b0)
     	...
     	Kernel driver in use: atl1
     	Kernel modules: atl1

Next, check that the driver was loaded via dmesg | grep module_name. For
example:

    $ dmesg | grep atl1
        ...
        atl1 0000:02:00.0: eth0 link is up 100 Mbps full duplex

Skip the next section if the driver was loaded successfully. Otherwise,
you will need to know which module is needed for your particular model.

> Load the device module

Google for the right module/driver for the chipset. Some common modules
are 8139too for cards with a Realtek chipset, or sis900 for cards with a
SiS chipset. Once you know which module to use, try to load it manually.
If you get an error saying that the module was not found, it's possible
that the driver is not included in Arch kernel. You may search the AUR
for the module name.

If udev is not detecting and loading the proper module automatically
during bootup, see Kernel modules#Loading.

Network Interfaces
------------------

> Device names

For computers with multiple NICs, it is important to have fixed device
name. Many configuration problems are caused by interface name changing.

udev is responsible for which device gets which name. Systemd v197
introduced Predictable Network Interface Names, which automatically
assigns static names to network devices. Interfaces are now prefixed
with en (ethernet), wl (WLAN), or ww (WWAN) followed by an automatically
generated identifier, creating an entry such as enp0s25.

This behavior may be disabled by adding a symlink:

    # ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

Users upgrading from an earlier systemd version will have a blank rules
file created automatically. So if you want to use persistent device
names, just delete the file.

Tip:You can run ip link or ls /sys/class/net to list all available
interfaces.

Note:When changing the interface naming scheme, do not forget to update
all network-related configuration files and custom systemd unit files to
reflect the change. Specifically, if you have netctl static profiles
enabled, run netctl reenable profile to update the generated service
file.

Change device name

You can change the device name by defining the name manually with an
udev-rule. For example:

    /etc/udev/rules.d/10-network.rules

    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="net1"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="ff:ee:dd:cc:bb:aa", NAME="net0"

A couple things to note:

-   To get the MAC address of each card, use this command:
    cat /sys/class/net/device_name/address
-   Make sure to use the lower-case hex values in your udev rules. It
    doesn't like upper-case.

If the network card has a dynamic MAC, you can use DEVPATH, for example:

    /etc/udev/rules.d/10-network.rules

    SUBSYSTEM=="net", DEVPATH=="/devices/platform/wemac.*", NAME="int"

Note:When choosing the static names it should be avoided to use names in
the format of "ethX" and "wlanX", because this may lead to race
conditions between the kernel and udev during boot. Instead, it is
better to use interface names that are not used by the kernel as
default, e.g.: net0, net1, wifi0, wifi1. For further details please see
the systemd documentation.

> Set device MTU and queue Length

You can change the device MTU and queue length by defining manually with
an udev-rule. For example:

    /etc/udev/rules.d/10-network.rules

    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", ATTR{mtu}="1480", ATTR{tx_queue_len}="2000"

> Get current device names

Current NIC names can be found via sysfs

    $ ls /sys/class/net

    lo eth0 eth1 firewire0

> Enabling and disabling network interfaces

You can activate or deactivate network interfaces using:

    # ip link set eth0 up
    # ip link set eth0 down

To check the result:

    $ ip link show dev eth0

    2: eth0: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP mode DEFAULT qlen 1000
    ...

Configure the IP address
------------------------

You have two options: a dynamically assigned address using DHCP, or an
unchanging "static" address.

> Dynamic IP address

dhcpcd

The easiest is to use dhcpcd, which is included in the base group.
Either use the provided service file dhcpcd@.service, passing the
interface name as an argument, or start it manually by running
dhcpcd interface.

systemd-networkd

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           systemd-networkd.        
                           Notes: Since a separate  
                           page exists, there       
                           should be only quick     
                           introduction + link (as  
                           for #dhcpcd above).      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

With systemd version >= 209, it's possible to manage network connections
with Systemd-networkd. With this approach, only a single configuration
file per interface is needed, for example:

    /etc/systemd/network/20-dhcp.network

    [Match]
    Name=*

    [Network]
    DHCP=yes

Name = * matches all available network interfaces, and e.g. Name = en*
would only match ethernet interfaces. See Network configuration#Device
names for the naming scheme and ip link for a list of available
interfaces.

Then start/enable systemd-networkd.service.

systemd doesn't update /etc/resolv.conf - instead it updates
/run/systemd/network/resolv.conf. A quick fix is to symlink the two, ie:

    # ln -sf /run/systemd/network/resolv.conf /etc/resolv.conf

Worth noting: systemd-networkd (as of version 210) does not have the
ability to send the system's hostname to the DHCP server when requesting
an IP address (dhcpcd does this by default).

  
 Further examples: https://coreos.com/blog/intro-to-systemd-networkd/

> Static IP address

There are various reasons why you may wish to assign static IP addresses
on your network. For instance, one may gain a certain degree of
predictability with unchanging addresses, or you may not have a DHCP
server available.

Note:If you share your Internet connection from a Windows machine
without a router, be sure to use static IP addresses on both computers
to avoid LAN problems.

You need:

-   Static IP address
-   Subnet mask
-   Broadcast address
-   Gateway's IP address

If you are running a private network, it is safe to use IP addresses in
192.168.*.* for your IP addresses, with a subnet mask of 255.255.255.0
and a broadcast address of 192.168.*.255. The gateway is usually
192.168.*.1 or 192.168.*.254.

Tip:You may need to manually set the DNS servers, see resolv.conf for
details.

Manual assignment

You can assign a static IP address in the console:

    # ip addr add IP_address/subnet_mask broadcast broadcast_address dev interface

For example:

    # ip addr add 192.168.1.2/24 broadcast 192.168.1.255 dev eth0

Note:The subnet mask was specified using CIDR notation.

For more options, see man ip.

Add your gateway IP address like so:

    # ip route add default via default_gateway

For example:

    # ip route add default via 192.168.1.1

If you the get the error "No such process", it means you have to run
ip link set dev eth0 up as root.

Persistent configuration on boot using systemd and udev rules

First create a configuration file for the systemd service, replace
interface with the proper network interface name:

    /etc/conf.d/network@interface

    address=192.168.0.15
    netmask=24
    broadcast=192.168.0.255
    gateway=192.168.0.1

Create a systemd unit file:

    /etc/systemd/system/network@.service

    [Unit]
    Description=Network connectivity (%i)
    Wants=network.target
    Before=network.target
    BindsTo=sys-subsystem-net-devices-%i.device
    After=sys-subsystem-net-devices-%i.device

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    EnvironmentFile=/etc/conf.d/network@%i

    ExecStart=/usr/bin/ip link set dev %i up
    ExecStart=/usr/bin/ip addr add ${address}/${netmask} broadcast ${broadcast} dev %i
    ExecStart=/usr/bin/sh -c 'test -n ${gateway} && /usr/bin/ip route add default via ${gateway}'

    ExecStop=/usr/bin/ip addr flush dev %i
    ExecStop=/usr/bin/ip link set dev %i down

    [Install]
    WantedBy=multi-user.target

Enable the unit and start it, passing the name of the interface:

    # systemctl enable network@interface.service
    # systemctl start network@interface.service

Persistent configuration on boot using systemd-networkd

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           systemd-networkd.        
                           Notes: Since a separate  
                           page exists, there       
                           should be only quick     
                           introduction + link (as  
                           for #dhcpcd above).      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

With systemd version >= 209, it's possible to manage network connections
with the integrated systemd-networkd service (which is disabled by
default with version 210). With this approach, only a single
configuration file per interface is needed, for example:

    /etc/systemd/network/10-static-ethernet.network

    [Match]
    Name=enp0s25

    [Network]
    Address=192.168.0.15/24
    Gateway=192.168.0.1

Name has to be the name of the interface you want to configure, see
ip link for the names of available interfaces.

Then start/enable systemd-networkd.service.

Further examples: https://coreos.com/blog/intro-to-systemd-networkd/ and
in the Systemd-networkd Arch wiki

Calculating addresses

You can use ipcalc provided by the ipcalc package to calculate IP
broadcast, network, netmask, and host ranges for more advanced
configurations. For example, I use ethernet over firewire to connect a
windows machine to arch. For security and network organization, I placed
them on their own network and configured the netmask and broadcast so
that they are the only 2 machines on it. To figure out the netmask and
broadcast addresses for this, I used ipcalc, providing it with the IP of
the arch firewire nic 10.66.66.1, and specifying ipcalc should create a
network of only 2 hosts.

    $ ipcalc -nb 10.66.66.1 -s 1

    Address:   10.66.66.1

    Netmask:   255.255.255.252 = 30
    Network:   10.66.66.0/30
    HostMin:   10.66.66.1
    HostMax:   10.66.66.2
    Broadcast: 10.66.66.3
    Hosts/Net: 2                     Class A, Private Internet

Load configuration
------------------

To test your settings either reboot the computer or reload the relevant
systemd services. Then try pinging your gateway, DNS server, ISP
provider and other Internet sites, in that order, to detect any
connection problems along the way, as in this example:

    $ ping -c 3 www.google.com

Additional settings
-------------------

> ifplugd for laptops

Tip:dhcpcd provides the same feature out of the box.

ifplugd in official repositories is a daemon which will automatically
configure your Ethernet device when a cable is plugged in and
automatically unconfigure it if the cable is pulled. This is useful on
laptops with onboard network adapters, since it will only configure the
interface when a cable is really connected. Another use is when you just
need to restart the network but do not want to restart the computer or
do it from the shell.

By default it is configured to work for the eth0 device. This and other
settings like delays can be configured in /etc/ifplugd/ifplugd.conf.

Note:Netctl package includes netctl-ifplugd@.service, otherwise you can
use ifplugd@.service from ifplugd package. Use for example
systemctl enable ifplugd@eth0.service.

> Bonding or LAG

See netctl#Bonding.

> IP address aliasing

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Manual method    
                           using ip should be       
                           added; then move current 
                           example using netctl     
                           into netctl. (Discuss)   
  ------------------------ ------------------------ ------------------------

IP aliasing is the process of adding more than one IP address to a
network interface. With this, one node on a network can have multiple
connections to a network, each serving a different purpose. Typical uses
are virtual hosting of Web and FTP servers, or reorganizing servers
without having to update any other machines (this is especially useful
for nameservers).

Example

You will need netctl from the official repositories.

Prepare the configuration:

    /etc/netctl/mynetwork

    Connection='ethernet'
    Description='Five different addresses on the same NIC.'
    Interface='eth0'
    IP='static'
    Address=('192.168.1.10' '192.168.178.11' '192.168.1.12' '192.168.1.13' '192.168.1.14' '192.168.1.15')
    Gateway='192.168.1.1'
    DNS=('192.168.1.1')

Then simply execute:

    $ netctl start mynetwork

> Change MAC/hardware address

See MAC Address Spoofing.

> Internet Sharing

See Internet sharing.

> Router Configuration

See Router.

> Local network hostname resolution

The pre-requisite is to #Set the hostname after which hostname
resolution works on the local system itself

    $ ping hostname

    PING hostname (192.168.1.2) 56(84) bytes of data.
    64 bytes from hostname (192.168.1.2): icmp_seq=1 ttl=64 time=0.043 ms

To enable other machines to address the host by name, either a manual
configuration of the respective /etc/hosts files or a service to
propagate/resolve the name is required.

When setting up a DNS server such as BIND or Unbound is overkill,
manually editing your /etc/hosts is too cumbersome, or when you want
more flexibility with dynamic leaving and joining of hosts to the
network, it is possible to handle hostname resolution on your local
network using zero-configuration networking. There are two options
available:

-   Samba provides hostname resolution via Microsoft's NetBIOS. It only
    requires installation of samba and enabling of the nmbd.service
    service. Computers running Windows, OS X, or Linux with nmbd
    running, will be able to find your machine.

-   Avahi provides hostname resolution via zeroconf, also known as Avahi
    or Bonjour. It requires slightly more complex configuration than
    Samba: see Avahi#Hostname resolution for details. Computers running
    OS X, or Linux with an Avahi daemon running, will be able to find
    your machine. Windows does not have an built-in Avahi client or
    daemon.

Troubleshooting
---------------

> Swapping computers on the cable modem

Some cable ISPs (videotron for example) have the cable modem configured
to recognize only one client PC, by the MAC address of its network
interface. Once the cable modem has learned the MAC address of the first
PC or equipment that talks to it, it will not respond to another MAC
address in any way. Thus if you swap one PC for another (or for a
router), the new PC (or router) will not work with the cable modem,
because the new PC (or router) has a MAC address different from the old
one. To reset the cable modem so that it will recognise the new PC, you
must power the cable modem off and on again. Once the cable modem has
rebooted and gone fully online again (indicator lights settled down),
reboot the newly connected PC so that it makes a DHCP request, or
manually make it request a new DHCP lease.

If this method does not work, you will need to clone the MAC address of
the original machine. See also Change MAC/hardware address.

> The TCP window scaling problem

TCP packets contain a "window" value in their headers indicating how
much data the other host may send in return. This value is represented
with only 16 bits, hence the window size is at most 64Kb. TCP packets
are cached for a while (they have to be reordered), and as memory is (or
used to be) limited, one host could easily run out of it.

Back in 1992, as more and more memory became available, RFC 1323 was
written to improve the situation: Window Scaling. The "window" value,
provided in all packets, will be modified by a Scale Factor defined
once, at the very beginning of the connection.

That 8-bit Scale Factor allows the Window to be up to 32 times higher
than the initial 64Kb.

It appears that some broken routers and firewalls on the Internet are
rewriting the Scale Factor to 0 which causes misunderstandings between
hosts.

The Linux kernel 2.6.17 introduced a new calculation scheme generating
higher Scale Factors, virtually making the aftermaths of the broken
routers and firewalls more visible.

The resulting connection is at best very slow or broken.

How to diagnose the problem

First of all, let's make it clear: this problem is odd. In some cases,
you will not be able to use TCP connections (HTTP, FTP, ...) at all and
in others, you will be able to communicate with some hosts (very few).

When you have this problem, the dmesg's output is OK, logs are clean and
ip addr will report normal status... and actually everything appears
normal.

If you cannot browse any website, but you can ping some random hosts,
chances are great that you're experiencing this problem: ping uses ICMP
and is not affected by TCP problems.

You can try to use Wireshark. You might see successful UDP and ICMP
communications but unsuccessful TCP communications (only to foreign
hosts).

How to fix it (The bad way)

To fix it the bad way, you can change the tcp_rmem value, on which Scale
Factor calculation is based. Although it should work for most hosts, it
is not guaranteed, especially for very distant ones.

    # echo "4096 87380 174760" > /proc/sys/net/ipv4/tcp_rmem

How to fix it (The good way)

Simply disable Window Scaling. Since Window Scaling is a nice TCP
feature, it may be uncomfortable to disable it, especially if you cannot
fix the broken router. There are several ways to disable Window Scaling,
and it seems that the most bulletproof way (which will work with most
kernels) is to add the following line to
/etc/sysctl.d/99-disable_window_scaling.conf (see also sysctl)

    net.ipv4.tcp_window_scaling = 0

How to fix it (The best way)

This problem is caused by broken routers/firewalls, so let's change
them. Some users have reported that the broken router was their very own
DSL router.

More about it

This section is based on the LWN article TCP window scaling and broken
routers and a Kernel Trap article: Window Scaling on the Internet.

There are also several relevant threads on the LKML.

> Realtek no link / WOL problem

Users with Realtek 8168 8169 8101 8111(C) based NICs (cards / and
on-board) may notice a problem where the NIC seems to be disabled on
boot and has no Link light. This can usually be found on a dual boot
system where Windows is also installed. It seems that using the offical
Realtek drivers (dated anything after May 2007) under Windows is the
cause. These newer drivers disable the Wake-On-LAN feature by disabling
the NIC at Windows shutdown time, where it will remain disabled until
the next time Windows boots. You will be able to notice if this problem
is affecting you if the Link light remains off until Windows boots up;
during Windows shutdown the Link light will switch off. Normal operation
should be that the link light is always on as long as the system is on,
even during POST. This problem will also affect other operative systems
without newer drivers (eg. Live CDs). Here are a few fixes for this
problem:

Method 1 - Enable the NIC directly in Linux

Get the ethernet NIC name from the output of

    $ ip a

Bring up the device as root using the NIC name:

    # ip link set dev <NIC_name> up

For ex, if <NIC_name> is enp7s0

    # ip link set dev enp7s0 up

If it worked and the card is powered on, a new interface should appear
in the output of ifconfig

Method 2 - Rollback/change Windows driver

You can roll back your Windows NIC driver to the Microsoft provided one
(if available), or roll back/install an official Realtek driver
pre-dating May 2007 (may be on the CD that came with your hardware).

Method 3 - Enable WOL in Windows driver

Probably the best and the fastest fix is to change this setting in the
Windows driver. This way it should be fixed system-wide and not only
under Arch (eg. live CDs, other operative systems). In Windows, under
Device Manager, find your Realtek network adapter and double-click it.
Under the Advanced tab, change "Wake-on-LAN after shutdown" to Enable.

    In Windows XP (example)
    Right click my computer
    --> Hardware tab
      --> Device Manager
        --> Network Adapters
          --> "double click" Realtek ...
            --> Advanced tab
              --> Wake-On-Lan After Shutdown
                --> Enable

Note:Newer Realtek Windows drivers (tested with Realtek 8111/8169 LAN
Driver v5.708.1030.2008, dated 2009/01/22, available from GIGABYTE) may
refer to this option slightly differently, like Shutdown Wake-On-LAN -->
Enable. It seems that switching it to Disable has no effect (you will
notice the Link light still turns off upon Windows shutdown). One rather
dirty workaround is to boot to Windows and just reset the system
(perform an ungraceful restart/shutdown) thus not giving the Windows
driver a chance to disable LAN. The Link light will remain on and the
LAN adapter will remain accessible after POST - that is until you boot
back to Windows and shut it down properly again.

Method 4 - Newer Realtek Linux driver

Any newer driver for these Realtek cards can be found for Linux on the
realtek site. (untested but believed to also solve the problem).

Method 5 - Enable LAN Boot ROM in BIOS/CMOS

It appears that setting Integrated Peripherals --> Onboard LAN Boot ROM
--> Enabled in BIOS/CMOS reactivates the Realtek LAN chip on system
boot-up, despite the Windows driver disabling it on OS shutdown.

Note:This was tested successfully multiple times with GIGABYTE system
board GA-G31M-ES2L with BIOS version F8 released on 2009/02/05. YMMV.

> No eth0 with Atheros AR9485

The ethernet (eth0) for Atheros AR9485 are not working out-of-the-box
(with installation media of February 2014). The working solution for
this is to install the package backports-patched from AUR.

> Broadcom BCM57780

This Broadcom chipset sometimes does not behave well unless you specify
the order of the modules to be loaded. The modules are broadcom and tg3,
the former needing to be loaded first.

These steps should help if your computer has this chipset:

    $ lspci | grep Ethernet
    02:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57780 Gigabit Ethernet PCIe (rev 01)

If your wired networking is not functioning in some way or another, try
unplugging your cable then doing the following (as root):

    # modprobe -r tg3
    # modprobe broadcom
    # modprobe tg3

Now plug you network cable in. If this solves your problems you can make
this permanent by adding broadcom and tg3 (in this order) to the MODULES
array in /etc/mkinitcpio.conf:

    MODULES=".. broadcom tg3 .."

Then rebuild the initramfs:

    # mkinitcpio -p linux

Note:These methods may work for other chipsets, such as BCM57760.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Network_configuration&oldid=305503"

Categories:

-   Networking
-   Getting and installing Arch

-   This page was last modified on 18 March 2014, at 17:50.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
